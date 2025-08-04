import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part '../Event/location_data_event.dart';
part '../State/location_data_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final FBroadcast _broadcast = FBroadcast.instance();
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> addressesList = [];
  List<Map<String, dynamic>> location = [];
  List<Map<String, dynamic>> tempLocation = [];
  List<Map<String, dynamic>> filterPage = [];
  List<Map<String, dynamic>> _filteredResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  Map<String, dynamic>? selectedModel;
  Map<String, dynamic>? _selectedAddress;
  int itemsPerPage = 10;
  int currentPage = 1;
  int totalCount = 0;
  int? selectedAddressIndex;
  int? locationId;

  List<Map<String, dynamic>> get _apiResponse => List.from(getIt<CommonService>().locationsList)..sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
  bool get isEditAddress => ((_selectedAddress != null) && (_selectedAddress?.isNotEmpty ?? false));
  bool get isEditMode => ((selectedModel != null) && (selectedModel?.isNotEmpty ?? false));
  int get totalPages => ((_filteredResponse.length) / itemsPerPage).ceil();

  LocationBloc() : super(LoadingState())
  {
    on<LocationInitialEvent>(_onInitialEvent);

    on<PaginationEvent>(_onPaginationEvent);

    on<SubmitEvent>(_onSubmitEvent);

    on<DeleteLocationEvent>(_onDeleteLocationEvent);

    on<SearchQueryEvent>(_onSearchQueryEvent);

    on<StoreAddressEvent>(_onStoreAddressEvent);

    on<DeleteAddressEvent>(_onDeleteAddressEvent);

    on<EnterEditModeEvent>(_onEnterEditModeEvent);

    on<ExitEditModeEvent>(_onExitEditModeEvent);

    on<EditAddressEvent>(_onEditAddressEvent);

    on<RefreshEvent>(_onRefreshEvent);
  }

  Future<Map<String, dynamic>?> _fetchLocation(dynamic id) async => await _apiRepository.getLocation(id);
  Future<List<Map<String, dynamic>>> _fetchLocations() async => await getIt<CommonService>().getLocationsList(reset: true);
  Future<Map<String, dynamic>?> _saveLocation(Map<String, dynamic>? body) async => await _apiRepository.saveLocation(body);
  Future<Map<String, dynamic>?> _saveLocationAddress(Map<String, dynamic>? body) async => await _apiRepository.saveLocationAddress(body: body);
  Future<Map<String, dynamic>?> _updateLocation(dynamic id, Map<String, dynamic>? body) async => await _apiRepository.updateLocation(id, body: body);
  Future<Map<String, dynamic>?> _updateLocationAddress(dynamic id, Map<String, dynamic>? body) async => await _apiRepository.updateLocationAddress(id, body: body);
  Future<Map<String, dynamic>?> _deleteAddress(dynamic id) async => await _apiRepository.deleteAddress(id);
  Future<Map<String, dynamic>?> _deleteLocation(dynamic id) async => await _apiRepository.deleteLocation(id);

  void _broadCasting() {
    _broadcast.broadcast(Str.addToDoRefresh);
    _broadcast.broadcast(Str.editToDoRefresh);
    _broadcast.broadcast(Str.refetchVendorLocation);
  }

  void _sort() => _apiResponse.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));

  void _search() {
    var query = searchController.text.toLowerCase();
    if (query.trim().isNotNullOrEmpty) {
      // FILTER BY QUERY
      _filteredResponse = _apiResponse.where((element) => element['name'].toString().toLowerCase().contains(query)).toList();
    } else {
      // SET ALL THE VALUES IN IT
      _filteredResponse = _apiResponse;
    }
    _paginate();
  }

  void _paginate() => filteredResponse = paginateList(data: _filteredResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);

  void _error(e, Emitter<LocationState> emit) {
    Console.of.error("Error", error: e);
    emit(ErrorState(e));
  }

  void _clearControllers() {
    formKey.currentState?.reset();
    selectedModel = null;
    _selectedAddress = null;
    locationId = null;
    selectedAddressIndex = null;
    locationController.clear();
    addressController.clear();
    addressesList.clear();
    tempLocation.clear();
  }

  void _onInitialEvent(LocationInitialEvent event, Emitter<LocationState> emit) async {
    try {
      if(event.title != null) locationController.text = event.title ?? "";
      emit(LoadingState());
      await _fetchLocations();
      _sort();
      _search();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onPaginationEvent(PaginationEvent event, Emitter<LocationState> emit) {
    currentPage = event.page;
    _paginate();
    emit(CommonState());
  }

  void _onExitEditModeEvent(ExitEditModeEvent event, Emitter<LocationState> emit) {
    _clearControllers();
    emit(CommonState());
  }

  void _onEditAddressEvent(EditAddressEvent event, Emitter<LocationState> emit) {
    _selectedAddress = event.model;
    addressController.text = _selectedAddress?['address'];
    emit(CommonState());
  }

  void _onDeleteAddressEvent(DeleteAddressEvent event, Emitter<LocationState> emit) async {
    try {
      var model = event.model;
      var isLocal = (model?['location_id'] == -1);
      if (isLocal) {
        Console.of.log("LOCAL_DELETED");
        addressesList.remove(model);
        return emit(CommonState());
      } else { // API CALL REQUIRED
        emit(LoadingState());
        var response = await _deleteAddress(model?['id']);
        if (response != null) {
          addressesList.remove(model);
          selectedModel?['addresses'].removeWhere((element) => element['id'] == model?['id']);
          emit(CommonState());
        } else {
          emit(ErrorState("Something went wrong"));
        }
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onSearchQueryEvent(SearchQueryEvent event, Emitter<LocationState> emit) async {
    try {
      currentPage = 1;
      _search();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onStoreAddressEvent(StoreAddressEvent event, Emitter<LocationState> emit) {
    try {
      var address = addressController.text;
      if (address.trim().isNullOrEmpty) return;
      if (_selectedAddress == null) {
        addressesList.add({'address': address, 'id': -1});
      } else {
        for (var element in addressesList) {
          if (element['id'] == _selectedAddress?['id']) {
            element['address'] = address;
            break;
          }
        }
        _selectedAddress = null;
      }
      addressController.clear();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onSubmitEvent(SubmitEvent event, Emitter<LocationState> emit) async {
    try {
      if (formKey.currentState?.validate() == false) return emit(ErrorState("Please enter location name"));
      var hasAddresses = addressesList.where((element) => element['id'] == -1).isNotEmpty;
      var addressControl = addressController.text.isNotNullOrEmpty;
      Console.of.log("HasAddresses:\t $hasAddresses , AddressControl:	 $addressControl ${selectedModel == null}");
      Map<String, dynamic> body = {
        "name" : locationController.text,
        "status" : "1",
        "platform" : "taskerApp"
      };
      var addresses = addressesList.where((element) => element['id'] == -1).map((e) => e['address'] ?? "").toList();
      addresses.add(addressController.text);
      addresses.removeWhere((element) => element.toString().trim().isNullOrEmpty);
      if (selectedModel == null) {
        // INSERT AS NEW
        emit(LoadingState());
        body['address'] = addresses;
        var response = await _saveLocation(body);
        if (response != null) {
          _clearControllers();
          add(RefreshEvent());
        } else {
          emit(ErrorState("Something went wrong"));
        }
      } else {
        // UPDATE
        emit(LoadingState());
        var model = _apiResponse.firstWhereOrNull((element) => element['id'] == selectedModel?['id']);
        var existingAddress = List.from((model?['addresses'] ?? []));
        var modifiedAddress = addressesList.where((element) => element['id'] != -1).where((element) => !existingAddress.map((e) => e['address']).contains(element['address'])).toList();
        dynamic response;
        if (modifiedAddress.isNotEmpty) {
          var addressBody = modifiedAddress.map((e) => {"id" : e['id'], "body" : {"address": e['address'], "location_id" : e['location_id'], "platform" : "taskerApp"}}).toList();
          response = await Future.wait(addressBody.map((e) => _updateLocationAddress(e['id'], e['body'])));
        }
        if (addresses.isNotEmpty) {
          // NEW ADDRESSES
          Map<String, dynamic> locationBody = {};
          locationBody['location_id'] = selectedModel?['id'];
          locationBody['address'] = addresses;
          locationBody['platform'] = "taskerApp";
          response = await _saveLocationAddress(locationBody);
        }
        if (selectedModel?['name'] != body['name']) response = await _updateLocation(selectedModel?['id'], body);
        if (response != null) {
          _clearControllers(); add(RefreshEvent());
        } else {
          emit(ErrorState("Something went wrong"));
        }
      }
      _broadCasting();
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onEnterEditModeEvent(EnterEditModeEvent event, Emitter<LocationState> emit) async {
    try {
      emit(LoadingState());
      var response = await _fetchLocation(event.location?['id']);
      selectedModel = response?['location'];
      locationController.text = selectedModel?['name'] ?? "";
      addressesList.clear();
      addressesList.addAll(List.from(selectedModel?['addresses'] ?? []));
      addressController.clear();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onRefreshEvent(RefreshEvent event, Emitter<LocationState> emit) async {
    try {
      emit(LoadingState());
      currentPage = 1;
      await _fetchLocations();
      _sort();
      _search();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onDeleteLocationEvent(DeleteLocationEvent event, Emitter<LocationState> emit) async {
    try {
      var model = event.model;
      emit(LoadingState());
      var response = await _deleteLocation(model?['id']);
      if (response != null) {
        if (selectedModel?['id'] == model?['id']) _clearControllers();
        _apiResponse.removeWhere((element) => element['id'] == model?['id']);
        _search();
        emit(CommonState());
        _broadCasting();
      } else {
        emit(ErrorState("Something went wrong"));
      }
    } catch (e) {
      _error(e, emit);
    }
  }
}
