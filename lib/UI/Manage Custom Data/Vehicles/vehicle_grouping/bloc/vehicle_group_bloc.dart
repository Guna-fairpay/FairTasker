import 'dart:async';
import 'dart:convert';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping/bloc/vehicle_group_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping/bloc/vehicle_group_states.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleGroupBloc extends Bloc<VehicleGroupEvent, VehicleGroupState> {
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  AutovalidateMode? autoValidateMode;
  List<Map<String, dynamic>> _apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  List<Map<String, dynamic>> apiResponseVehicles = [];
  List<Map<String, dynamic>> selectedVehicles = [];
  int _totalCount = 0;
  int currentPage = 1;
  int itemsPerPage = 10;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Map<String, dynamic>? selectedModel;
  VehicleGroupBloc() : super(VehicleGroupLoadingState()) {
   on<VehicleGroupInitialEvent>(_onInitialEvent);
   on<VehicleGroupPaginationEvent>(_onPaginationEvent);
   on<VehicleGroupSearchEvent>(_onSearchEvent);
   on<VehicleGroupEditEvent>(_onEditEvent);
   on<VehicleGroupDeleteVehicleEvent>(_onDeleteEvent);
   on<VehicleGroupSelectVehicleEvent>(_onSelectVehicleEvent);
   on<VehicleGroupCancelEvent>(_onCancelEvent);
   on<VehicleGroupDeleteTapVehicleEvent>(_onDeleteTapVehicleEvent);
   on<VehicleGroupSaveEvent>(_onSaveEvent);
  }

  int get totalPages => (_totalCount / itemsPerPage).ceil();

  Future<List<Map<String, dynamic>>> _fetchGroupVehicles() async => await getIt<CommonService>().groupVehicles(reset: true);
  Future<Map<String, dynamic>?> _updateGroupVehicles(Map<String, dynamic> body) async => await _apiRepository.updateGroupVehicle(groupId: selectedModel?['id'], body: body);
  Future<Map<String, dynamic>?> _saveGroupVehicles(Map<String, dynamic> body) async => await _apiRepository.saveGroupVehicle(body: body);
  Future<Map<String, dynamic>?> _deleteGroupVehicles(dynamic id) async => await _apiRepository.deleteGroupVehicle(groupId: id);
  Future<List<Map<String, dynamic>>?> _fetchActiveVehicles() async => await getIt<CommonService>().getActiveVehicles();

  void _onInitialEvent(VehicleGroupInitialEvent event, Emitter<VehicleGroupState> emit) async {
    try {
      var vids = event.selectedModels;
      Console.of.log("SELECTED_VIDS $vids");
      emit(VehicleGroupLoadingState());
      var response = await Future.wait([
        _fetchGroupVehicles(),
        _fetchActiveVehicles(),
      ]);
      _apiResponse = response[0] ?? [];
      apiResponseVehicles = response[1] ?? [];
      selectedVehicles = apiResponseVehicles.where((element) => vids.contains(element['id'])).toList();
      Console.of.log("API Response $_apiResponse");
      _totalCount = _apiResponse.length;
      filteredResponse = paginateList(data: _apiResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
      emit(VehicleGroupCommonState());
    } catch (e) {
      Console.of.error("Error Occurred", error: e);
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
    formKey.currentState?.reset();
    selectedModel = event.model;
    var vins = (selectedModel?['vin'].toString().isNullOrEmpty ?? false) ? [] : List<String>.from(jsonDecode(selectedModel?['vin'] ?? ""));
    Console.of.log("VINS ${vins}");
    groupNameController.text = (selectedModel?['name'] ?? "");
    selectedVehicles = apiResponseVehicles.where((element) => vins.contains(element['vin'])).toList();
    emit(VehicleGroupCommonState());
  }

  void _onDeleteEvent(VehicleGroupDeleteVehicleEvent event, Emitter<VehicleGroupState> emit) async {
    try {
      emit(VehicleGroupLoadingState());
      var response = await _deleteGroupVehicles(event.selectedModel['id']);
      if (response != null) {
        _apiResponse.removeWhere((element) => element['id'] == event.selectedModel['id']);
      }
      _totalCount = _apiResponse.length;
      filteredResponse = paginateList(data: _apiResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
      if (selectedModel == event.selectedModel) _clearControllers();
      emit(VehicleGroupCommonState());
    } catch (e) {
      emit(VehicleGroupErrorState(e));
    }
  }

  void _onSelectVehicleEvent(VehicleGroupSelectVehicleEvent event, Emitter<VehicleGroupState> emit) {
    if (event.isChecked) {
      selectedVehicles.add(event.selectedModel);
    } else {
      selectedVehicles.removeWhere((element) => element['id'] == event.selectedModel['id']);
    }
    selectedVehicles = selectedVehicles.unique((element) => element['id']);
    emit(VehicleGroupCommonState());
  }

  void _onCancelEvent(VehicleGroupCancelEvent event, Emitter<VehicleGroupState> emit) {
    formKey.currentState?.reset();
    selectedVehicles.clear();
    groupNameController.clear();
    selectedModel = null;
    emit(VehicleGroupCommonState());
  }

  void _onDeleteTapVehicleEvent(VehicleGroupDeleteTapVehicleEvent event, Emitter<VehicleGroupState> emit) {
    Console.of.log("Delete tapping");
    emit(VehicleGroupDeleteTapVehicleState(event.selectedModel));
  }

  void _onSaveEvent(VehicleGroupSaveEvent event, Emitter<VehicleGroupState> emit) async {
    try {
      autoValidateMode = AutovalidateMode.onUserInteraction;
      if ((formKey.currentState?.validate() == false) || (selectedVehicles.isEmpty)) return emit(VehicleGroupCommonState());
      autoValidateMode = null;
      emit(VehicleGroupLoadingState());
      if (selectedModel == null) {
        var response = await _saveGroupVehicles({
          "name": groupNameController.text,
          "vin": selectedVehicles.map((e) => e['vin']).toList(),
        });
        if ((response != null) && (response['data'] != null)) {
          _apiResponse.add(Map<String, dynamic>.from(response['data']));
        }
      } else {
        // UPDATE
        var response = await _updateGroupVehicles({
          "name": groupNameController.text,
          "vin": selectedVehicles.map((e) => e['vin']).toList(),
        });
        Console.of.log("Response $response");
        if ((response != null) && (response['data'] != null)) {
          _apiResponse[_apiResponse.indexWhere((element) => element['id'] == selectedModel?['id'])] = Map<String, dynamic>.from(response['data']);
        }
      }
      _totalCount = _apiResponse.length;
      filteredResponse = paginateList(data: _apiResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
      _clearControllers();
      emit(VehicleGroupCommonState());
    } catch (e) {
      Console.of.error("Error occurred", error: e);
      emit(VehicleGroupErrorState(e));
    }
  }

  void _clearControllers() {
    groupNameController.clear();
    vehicleController.clear();
    selectedVehicles.clear();
    selectedModel = null;
  }
}