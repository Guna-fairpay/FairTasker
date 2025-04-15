import 'dart:async';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_event.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState>{
  final FBroadcast _broadcast = FBroadcast.instance();
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredResponse = [];
  List<Map<String, dynamic>> apiResponse = [];
  Map<String, dynamic>? selectedVehicle;
  Map<int, bool> selectedVehicles = {};
  List<int> selectedIds = [];
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  int selectedTab = 0;

  VehicleBloc() : super(VehicleLoadingState()){
    _registerBroadcast();
    on<VehicleInitialEvent>(_onInitialEvent);
    on<SearchVehicleEvent>(_onSearchEvent);
    on<SelectedVehicleEvent>(_onSelectedEvent);
    on<VehicleDeleteEvent>(_onDeleteEvent);
    on<MoveToPrivateRentalEvent>(_onMoveToPrivateRentalEvent);
    on<AddVehicleEvent>((event, emit) => emit(AddVehicleState()));
    on<EditVehicleTabEvent>(_onEditVehicleTabEvent);
    on<VehiclePaginationEvent>(_onPaginationEvent);
    on<VehicleResetEvent>(_onResetEvent);
    on<VehicleTabChangeEvent>(_onTabChangeEvent);
    on<VehicleClearEditEvent>(_onClearEditEvent);
    on<VehicleGroupingTapEvent>(_onGroupingTapEvent);
  }
  Future<List<Map<String, dynamic>>?> _getVehicle() async => await getIt<CommonService>().getActiveVehicles(reset: true);
  void _registerBroadcast() => _broadcast.register("vehicle_refresh", (value, callback) => add(VehicleInitialEvent()));
  void _onPaginationEvent(VehiclePaginationEvent event, Emitter<VehicleState> emit) {
    currentIndex = event.page;
    filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
    emit(VehicleCommonState());
  }
  void _onInitialEvent(VehicleInitialEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoadingState());
    var response= await _getVehicle();
    response?.sort((a, b) => b['created_at'].compareTo(a['created_at']));
    apiResponse = response ?? [];
    filteredResponse.clear();
    if (event.vin.toString().isNotNullOrEmpty) selectedVehicle = apiResponse.firstWhereOrNull((element) => element['vin'] == event.vin);
    filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
    totalCount = apiResponse.length;
    emit(VehicleCommonState());
  }
  void _onSearchEvent(SearchVehicleEvent event, Emitter<VehicleState> emit) {
    var searchQuery = event.query;
    List<Map<String, dynamic>> result = [];
    if (searchQuery?.trim().isNotNullOrEmpty ?? false) {
      var response = apiResponse.where((element) =>
          element['vehicle_name'].toString().toLowerCase().contains(
              searchQuery.toString().toLowerCase())).toList();
      result = response;
      filteredResponse = result.take(itemsPerPage).toList();
    } else {
      result = apiResponse;
      filteredResponse = result.take(itemsPerPage).toList();
    }
    totalCount = result.length;
    currentIndex = 1;
    emit(VehicleCommonState());
  }
  void _onSelectedEvent(SelectedVehicleEvent event, Emitter<VehicleState> emit) {
    final updatedSelectedVehicles = Map<int, bool>.from(selectedVehicles);
    final updatedSelectedIds = List<int>.from(selectedIds);
    updatedSelectedVehicles[event.vehicleId] = event.isSelected;
    if (event.isSelected) {
      if (!updatedSelectedIds.contains(event.vehicleId)) {
        updatedSelectedIds.add(event.vehicleId);
      }
    } else {
      updatedSelectedIds.remove(event.vehicleId);
    }
    selectedVehicles = updatedSelectedVehicles;
    selectedIds = updatedSelectedIds;
    emit(VehicleCommonState());
  }
  void _onDeleteEvent(VehicleDeleteEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoadingState());
    var response = await _apiRepository.deleteActiveVehicle(event.vehicleId);
    if (response?['success'] != null) {
      apiResponse.removeWhere((element) => element['id'].toString() == event.vehicleId);
      filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      Toaster.showSuccess(response?['success']??'');
    } else{
      Toaster.showError(response?['error']??'');
    }
    emit(VehicleCommonState());
  }
  void _onMoveToPrivateRentalEvent(MoveToPrivateRentalEvent event, Emitter<VehicleState> emit) async {
    try {
      emit(VehicleLoadingState());
      var response = await _apiRepository.moveVehicleToPrivateRental(
          rentalData: event.vehicleData);
      log(response.toString(), name: "VehicleBloc");
      if (response?['data'] != null) {
        var existResponse = apiResponse.map((e) {
          if (e['id'] == event.vehicleData['id']) {
            return e
              ..['rental_status'] = (int.tryParse(
                  "${response?['data']['rental_status']}") ?? 0);
          } else {
            return e;
          }
        }).toList();
        filteredResponse = paginateList(data: existResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
        Toaster.showSuccess(response?['message']??'');
        emit(VehicleCommonState());
      }else{
        Toaster.showError(response?['message']??'');
      }
      emit(VehicleCommonState());
    } catch (e) {
      emit(VehicleCommonState());
      log("$e", name: "VehicleBloc");
    }
  }
  void _onEditVehicleTabEvent(EditVehicleTabEvent event, Emitter<VehicleState> emit) {
    selectedVehicle = event.vehicleData;
    emit(VehicleCommonState());
  }
  void _onResetEvent(VehicleResetEvent event, Emitter<VehicleState> emit) {
    selectedVehicle = null;
    emit(VehicleCommonState());
  }
  void _onTabChangeEvent(VehicleTabChangeEvent event, Emitter<VehicleState> emit) {
    selectedTab = event.tabIndex;
    emit(VehicleCommonState());
  }
  void _onClearEditEvent(VehicleClearEditEvent event, Emitter<VehicleState> emit) {
    selectedVehicle = null;
    emit(VehicleCommonState());
  }

  void _onGroupingTapEvent(VehicleGroupingTapEvent event, Emitter<VehicleState> emit) {
    var selectedVids = selectedVehicles.keys.toSet();
    emit(VehicleGroupingTapState(vehiclesData: selectedVids));
  }
}
