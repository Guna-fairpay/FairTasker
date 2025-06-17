import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

part 'vendor_event.dart';
part 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final APiRepository _apiRepository = APiRepository();
  TextEditingController searchController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController vendorTypeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController expertiseController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  AutovalidateMode? autoValidate;

  List<Map<String, dynamic>> vendorType = [];
  Map<String, dynamic>? selectedVendorType;

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> _unFilteredResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];

  List<dynamic> businessCardImage = [];

  dynamic model;

  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  double? latitude;
  double? longitude;

  bool isEdit = false;
  bool isLatLong = false;

  Future<List<Map<String, dynamic>>?> _getVendorType() async => await _apiRepository.getVendorType();
  Future<Map<String, dynamic>?> _getVendors() async => await _apiRepository.getVendors();


  VendorBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<VendorTypeEvent>(_onVendorTypeEvent);
    on<AddressEvent>(_onAddressEvent);
    on<PickImageEvent>(_onPickImageEvent);
    on<RemoveImageEvent>(_onRemoveImageEvent);
    on<SearchEvent>(_onSearchEvent);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<EditEvent>(_onEditEvent);
    on<CancelEvent>(_onCancelEvent);
    on<SelectVendorTypeEvent>(_onSelectVendorTypeEvent);
    on<PaginationEvent>(_onPaginationEvent);
    on<GetDirectionEvent>(_getDirectionEvent);
    on<ClearLatLongEvent>(_onClearLatLongEvent);
    on<NavigationEvent>(_onNavigationEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<VendorState> emit) async {
    try {
      emit(LoadingState());
      await fetchVendor();
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onVendorTypeEvent(VendorTypeEvent event, Emitter<VendorState> emit) {
    emit(VendorTypeState(event.title));
  }

  Future<void> _onAddressEvent(AddressEvent event, Emitter<VendorState> emit) async {
    try {
      emit(LoadingState());
      var response = await getIt<CommonService>().getCurrentLocation();
      if(response != null){
        isLatLong = true;
        latitude = response['latitude'];
        longitude = response['longitude'];
      }
      Console.of.log(response);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onClearLatLongEvent(ClearLatLongEvent event, Emitter<VendorState> emit) {
    try{
      isLatLong = false;
      latitude = null;
      longitude = null;
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onSearchEvent(SearchEvent event, Emitter<VendorState> emit) async {
    try{
      _search();
      emit(CommonState());
    }catch(e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSaveEvent(SaveEvent event, Emitter<VendorState> emit) async {
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<VendorState> emit) async {
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onEditEvent(EditEvent event, Emitter<VendorState> emit) async {
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onCancelEvent(CancelEvent event, Emitter<VendorState> emit) async {
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSelectVendorTypeEvent(SelectVendorTypeEvent event, Emitter<VendorState> emit) async {
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onPaginationEvent(PaginationEvent event, Emitter<VendorState> emit) async {
    try{
      currentIndex = event.page;
      filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage,);
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _getDirectionEvent(GetDirectionEvent event, Emitter<VendorState> emit) async {
    try {
      emit(LoadingState());
      getDirection(latitude: event.data?['latitude'], longitude: event.data?['longitude']);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onNavigationEvent(NavigationEvent event, Emitter<VendorState> emit) async {
    try {
      emit(LoadingState());
      getDirection(latitude: latitude, longitude: longitude);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onPickImageEvent(PickImageEvent event, Emitter<VendorState> emit) async {
    try{
      var result = await _pickFiles();
      if (result.isNotEmpty) {
        var attachments = List.from(businessCardImage);
        var existingAttachments = List.from(businessCardImage)
            .whereType<File>()
            .map((e) => (e.path))
            .toList();
        for (var element in result) {
          if (!existingAttachments.contains(element.path)) {
            attachments.add(element);
          }
        }
        Console.of.log("$attachments", name: "PickImageEvent");
        businessCardImage = attachments;
      }
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onRemoveImageEvent(RemoveImageEvent event, Emitter<VendorState> emit) async {
    try {
      if (event.data == null) return;
      if (event.data is File) {
        businessCardImage.remove(event.data);
      } else if (event.data is String) {
        // REMOTE SELECTION REMOVE
        emit(LoadingState());
        var data = businessCardImage.firstWhereOrNull((element) => element == event.data.toString());
        var attachmentId = model['images'].firstWhere((e) => e['path'] == data.toString().removeAttachmentURL, orElse: () => null,)?['id'];
        var response = await _apiRepository.deleteBillImage(id: attachmentId);
        if(response != null){
          emit(SuccessState(response['message']));
          final item = apiResponse.firstWhereOrNull((e) => e['id'].toString() == response['bill_id'].toString(),);
          item?['billimages']?.removeWhere((img) => img['id'].toString() == attachmentId.toString(),);
          businessCardImage.remove(event.data);
        }else{
          emit(ErrorState('Something Went Wrong'));
        }
      }
    }catch(e){
      _onError(e, emit);
    }
  }


  void _onError(dynamic error, Emitter<VendorState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];
    if (query.trim().isNotNullOrEmpty) {
      filteredData = apiResponse.where((element) {
        return [
          element['name'],
        ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    } else {
      filteredData = apiResponse;
    }
    _unFilteredResponse = filteredData;
    currentIndex=1;
    totalCount = filteredData.length;
    filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage,);
  }

  Future<void> fetchVendor() async {
    var response = await _getVendorType();
    vendorType = List.from(response ?? []);
    var response1 = await _getVendors();
    apiResponse = List.from(response1?['data'] ?? []);
    apiResponse.sort((b, a) => a['created_at'].compareTo(b['created_at']));
    _unFilteredResponse = apiResponse;
    filteredResponse = paginateList(
        data: _unFilteredResponse,
        currentPage: currentIndex,
        itemsPerPage: itemsPerPage);
    totalCount = _unFilteredResponse.length;
  }



  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png',]);
    return result?.paths
        .where((element) => (element?.isNotEmpty ?? false))
        .map((e) => File(e!))
        .toList() ??
        [];
  }

  void getDirection({dynamic latitude, dynamic longitude}) async {
    final Uri mapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/$latitude,$longitude',
      queryParameters: {
        'q': '$longitude,$longitude'
      },
    );
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri,
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }


}