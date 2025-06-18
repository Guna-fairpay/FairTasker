import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

part 'vendor_event.dart';
part 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FBroadcast _broadcast = FBroadcast.instance();
  AutovalidateMode? autoValidateMode;
  TextEditingController searchController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController vendorTypeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController expertiseController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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

  dynamic latitude;
  dynamic longitude;

  bool isEdit = false;
  bool isLatLong = false;

  Future<List<Map<String, dynamic>>> _getVendors() async => await getIt<CommonService>().getVendorsList(reset: true);
  Future<List<Map<String, dynamic>>> _getVendorType() async => await getIt<CommonService>().getVendorTypeList(reset: true);

  // Future<List<Map<String, dynamic>>?> _getVendorType() async => await _apiRepository.getVendorType();
  // Future<Map<String, dynamic>?> _getVendors() async => await _apiRepository.getVendors();
  Future<Map<String, dynamic>?> _getEditVendors({dynamic id}) async => await _apiRepository.getEditVendors(id);
  Future<Map<String, dynamic>?> _addOrUpdateVendors({dynamic id, dynamic body, dynamic files}) async => await _apiRepository.addOrUpdateVendor(infusedFiles: files, id: id, body: body);
  Future<Map<String, dynamic>?> _deleteVendors({dynamic id,}) async => await _apiRepository.deleteVendor(id,);

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
    on<RefreshEvent>(_onRefreshEvent);
    _broadcast.register('refresh_vendor_type', (value, callback) => add(RefreshEvent()));
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<VendorState> emit) async {
    try {
      var response = await _getVendorType();
      vendorType = List.from(response ?? []);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<VendorState> emit) async {
    try {
      if(event.title != null) nameController.text = event.title;
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
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if(formKey.currentState?.validate() == false) return emit(CommonState());
    try {
      emit(LoadingState());
      autoValidateMode = null;
      List<Map<String, String?>> infusedFiles = businessCardImage.whereType<File>().map((e) => {"images" : e.path }).toList();
      var response = await _addOrUpdateVendors(
          id: isEdit ? model['id'] : null,
          body: saveData(),
          files: infusedFiles
      );
     if(response?['data'] != null){
       await fetchVendor();
       _broadcast.broadcast(Str.addToDoRefresh);
       _broadcast.broadcast(Str.editToDoRefresh);
       _broadcast.broadcast(Str.refetchVendorLocation);
       emit(SuccessState(response?['message']));
       clearAll();
      }else{
       emit(ErrorState(response?['message']));       }
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<VendorState> emit) async {
    try {
      emit(LoadingState());
      var response = await _deleteVendors(id: event.data['id']);
      if(response != null){
        await fetchVendor();
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        _broadcast.broadcast(Str.refetchVendorLocation);
        emit(SuccessState(response['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onEditEvent(EditEvent event, Emitter<VendorState> emit) async {
    try {
      emit(LoadingState());
      var response = await _getEditVendors(id: event.data?['id']);
      if(response != null){
        model = response;
        isEdit = true;
        formKey.currentState?.reset();
        clearAll();
        nameController.text = model?['name'] ?? '';
        addressController.text = model?['address'] ?? '';
        phoneController.text = model?['phone'] ?? '';
        websiteController.text = model?['website'] ?? '';
        expertiseController.text = model?['expertise'] ?? '';
        descriptionController.text = model?['description'] ?? '';
        selectedVendorType = vendorType.firstWhereOrNull((element) => element['id'].toString() == model?['type_id'].toString());
        vendorTypeController.text = selectedVendorType?['name'] ?? '';
        businessCardImage = model?['images']
            ?.map((element) => element['path'].toString().toStorageURL)
            .toList();
        latitude = model?['latitude'];
        longitude = model?['longitude'];
        if(latitude != null && longitude != null){
          isLatLong = true;
        }
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onCancelEvent(CancelEvent event, Emitter<VendorState> emit) async {
    try {
      clearAll();
      isEdit = false;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSelectVendorTypeEvent(SelectVendorTypeEvent event, Emitter<VendorState> emit) async {
    try {
      selectedVendorType = event.data;
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
        emit(LoadingState());
        var attachmentId = List.from(model['images'] ?? []).firstWhere((e) => e['path'] == event.data.toString().removeStorageUrl, orElse: () => null,)?['id'];
        await _apiRepository.deleteVendorImages(attachmentId);
          for (var element in apiResponse) {
            if (element['id'].toString() == model['id'].toString()) {
              for (var image in (element['images'] ?? [])) {
                if (image['id'].toString() == attachmentId.toString()) {
                  element['images']?.remove(image);
                  break;
                }
              }
              break;
            }
          }
          _unFilteredResponse = apiResponse;
          filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
          businessCardImage.remove(event.data);
      }
      emit(CommonState());
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
    vendorType = List.from(response);
    var response1 = await _getVendors();
     apiResponse = response1;
    // apiResponse = List.from(response1?['data'] ?? []);
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

  Map<String, dynamic> saveData(){
    Map<String, dynamic> data = {};
    data['name'] = nameController.text;
    data['address'] = addressController.text;
    data['status'] = '1';
    data['phone'] = phoneController.text;
    data['expertise'] = expertiseController.text;
    data['description'] = descriptionController.text;
    data['website'] = websiteController.text;
    data['type_id'] = selectedVendorType?['id'];
    data['platform'] = 'tasker-app';
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }

  void clearAll(){
    autoValidateMode = null;
    nameController.clear();
    vendorTypeController.clear();
    addressController.clear();
    phoneController.clear();
    websiteController.clear();
    expertiseController.clear();
    descriptionController.clear();
    businessCardImage.clear();
    latitude = null;
    longitude = null;
    isLatLong = false;

  }


}