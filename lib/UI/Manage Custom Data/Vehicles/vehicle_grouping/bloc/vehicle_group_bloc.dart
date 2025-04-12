import 'dart:async';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping/bloc/vehicle_group_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping/bloc/vehicle_group_states.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleGroupBloc extends Bloc<VehicleGroupEvent, VehicleGroupState> {
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> _apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  List<Map<String, dynamic>> apiResponseVehicles = [];
  List<Map<String, dynamic>> selectedVehicles = [];
  int _totalCount = 0;
  int currentPage = 1;
  int itemsPerPage = 10;

  Map<String, dynamic>? selectedModel;
  VehicleGroupBloc() : super(VehicleGroupLoadingState()) {
   on<VehicleGroupInitialEvent>(_onInitialEvent);
   on<VehicleGroupPaginationEvent>(_onPaginationEvent);
   on<VehicleGroupSearchEvent>(_onSearchEvent);
   on<VehicleGroupEditEvent>(_onEditEvent);
   on<VehicleGroupDeleteVehicleEvent>(_onDeleteEvent);
   on<VehicleGroupSelectVehicleEvent>(_onSelectVehicleEvent);
   on<VehicleGroupCancelEvent>(_onCancelEvent);
  }

  int get totalPages => (_totalCount / itemsPerPage).ceil();

  Future<List<Map<String, dynamic>>> _fetchGroupVehicles() async => await getIt<CommonService>().groupVehicles(reset: true);

  Future<List<Map<String, dynamic>>?> _fetchActiveVehicles() async => await getIt<CommonService>().getActiveVehicles();

  void _onInitialEvent(VehicleGroupInitialEvent event, Emitter<VehicleGroupState> emit) async {
    try {
      emit(VehicleGroupLoadingState());
      var response = await Future.wait([
        _fetchGroupVehicles(),
        _fetchActiveVehicles(),
      ]);
      _apiResponse = response[0] ?? [];
      apiResponseVehicles = response[1] ?? [];
      _totalCount = _apiResponse.length;
      filteredResponse = paginateList(data: _apiResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
      emit(VehicleGroupCommonState());
    } catch (e) {
      emit(VehicleGroupErrorState(e));
    }
  }

  void _onPaginationEvent(VehicleGroupPaginationEvent event, Emitter<VehicleGroupState> emit) {
    currentPage = event.page;
    filteredResponse = paginateList(data: _apiResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
    emit(VehicleGroupCommonState());
  }

  void _onSearchEvent(VehicleGroupSearchEvent event, Emitter<VehicleGroupState> emit) {
    var query = event.query?.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];
    if (query != null && query.trim().isNotEmpty) {
      filteredData = _apiResponse.where((element) => element['name'].toString().toLowerCase().contains(query)).toList();
    } else {
      filteredData = _apiResponse;
    }
    currentPage = 1;
    _totalCount = filteredData.length;
    filteredResponse = paginateList(data: filteredData, currentPage: currentPage, itemsPerPage: itemsPerPage);
    emit(VehicleGroupCommonState());
  }

  void _onEditEvent(VehicleGroupEditEvent event, Emitter<VehicleGroupState> emit) {
    selectedModel = event.model;
    groupNameController.text = (selectedModel?['name'] ?? "");
    selectedVehicles = selectedModel?['vehicles'] ?? [];
    emit(VehicleGroupCommonState());
  }

  void _onDeleteEvent(VehicleGroupDeleteVehicleEvent event, Emitter<VehicleGroupState> emit) {
    selectedVehicles.removeWhere((element) => element['id'] == event.selectedModel['id']);
    emit(VehicleGroupCommonState());
  }

  void _onSelectVehicleEvent(VehicleGroupSelectVehicleEvent event, Emitter<VehicleGroupState> emit) {
    selectedVehicles.add(event.selectedModel);
    emit(VehicleGroupCommonState());
  }

  void _onCancelEvent(VehicleGroupCancelEvent event, Emitter<VehicleGroupState> emit) {
    selectedVehicles.clear();
    groupNameController.clear();
    selectedModel = null;
    emit(VehicleGroupCommonState());
  }
}