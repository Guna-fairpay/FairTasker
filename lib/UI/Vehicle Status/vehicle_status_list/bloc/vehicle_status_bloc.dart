import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_config.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_events.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_states.dart';

class VehicleStatusBloc extends Bloc<VehicleStatusEvent, VehicleStatusState> {
  final TextEditingController searchController = TextEditingController();
  final APiRepository _aPiRepository = APiRepository();
  List<Map<String, dynamic>> vehicleStatusCategories = [];
  List<Map<String, dynamic>> vehicleStatus = [];
  List<Map<String, dynamic>> cohortsData = [];
  Map<String, dynamic>? selectedCohort;
  List<Map<String, dynamic>> filteredVehicleStatus = [];
  Map<String, dynamic>? selectedCategory;
  List<Map<String, dynamic>> tripStatusCategories = VehicleStatusConfig.tripStatusCategories;
  Map<String, dynamic> selectedTripCategory = VehicleStatusConfig.tripStatusCategories.first;
  bool showSearcher = false;
  bool showRentalCategories = true;
  List<Map<String, dynamic>> tripApiResponse = [];
  List<Map<String, dynamic>> filteredTrips = [];
  VehicleStatusBloc() : super(VehicleStatusLoadingState()) {
    on<VehicleStatusInitialEvent>(_onInitialEvent);
    on<VehicleStatusShowHideSearcherEvent>(_onShowHideSearcher);
    on<VehicleStatusCohortChangeEvent>(_onCohortChange);
    on<VehicleStatusCategoryChangeEvent>(_onCategoryChange);
    on<VehicleStatusOnChangeTripCategory>(_onChangeTripCategory);
    on<VehicleStatusDisplayRentalCategories>(_onChangeTripCategoryVisibility);
    on<VehicleStatusOnTapEvent>(_onVehicleStatusTap);
  }

  void _onInitialEvent(event, emit) async {
    try {
      emit(VehicleStatusLoadingState());
      var response = await Future.wait([
        _getVehicleStatusCategories(),
        _getVehicleStatus(statusId: 1),
        _getCohorts()
        ]);
      var categories = response[0];
      var status = response[1];
      var cohorts = response[2];
      vehicleStatusCategories = List<Map<String,dynamic>>.from(categories?['data'] ?? []);
      vehicleStatus = List<Map<String,dynamic>>.from(status?['data'] ?? []);
      var vehiclesCount = List<Map<String,dynamic>>.from(status?['vehiclesCount'] ?? []);
      cohortsData = List<Map<String,dynamic>>.from(cohorts?['cohortsData'] ?? []);
      cohortsData.insert(0, {'cohort': 'All', 'id': 0});
      vehicleStatusCategories = vehicleStatusCategories.map((e) => e..['count'] = vehiclesCount.firstWhereOrNull((element) => element['id'] == e['id'])?['vehicle_count'] ?? 0).toList();
      selectedCategory = vehicleStatusCategories.firstOrNull;
      filteredVehicleStatus = vehicleStatus;
      selectedCohort = cohortsData[0];
      emit(VehicleStatusLoadedState());
    } catch(e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  } // INITIAL EVENT FETCHING

  void _onShowHideSearcher(VehicleStatusShowHideSearcherEvent event, Emitter<VehicleStatusState> emit) async {
    showSearcher = !showSearcher;
    emit(showSearcher ? VehicleStatusShowSearcherState() : VehicleStatusHideSearcherState());
  }

  void _onCohortChange(VehicleStatusCohortChangeEvent event, emit) {
    selectedCohort = event.cohort;
    emit(VehicleStatusChangedState());
  }

  void _onCategoryChange(VehicleStatusCategoryChangeEvent event,  emit) async {
    selectedCategory = event.category;
    try {
      filteredVehicleStatus = [];
      emit(VehicleStatusLoadingState());
      var response = await _getVehicleStatus(statusId: selectedCategory?['id']);
      filteredVehicleStatus = List<Map<String,dynamic>>.from(response?['data'] ?? []);
      if (tripApiResponse.isNotEmpty) {
        filteredTrips.clear();
        showRentalCategories = true;
        selectedTripCategory = tripStatusCategories.first;
        tripApiResponse.clear();
      }
      emit(VehicleStatusLoadedState());
    } catch (e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  }

  void _onChangeTripCategory(VehicleStatusOnChangeTripCategory event, emit) {
    selectedTripCategory = event.tripCategory ?? {};
    filteredTrips = _findByTripCategory(selectedTripCategory['id']);
    emit(VehicleStatusChangedState());
  }

  void _onChangeTripCategoryVisibility(VehicleStatusDisplayRentalCategories event, emit) async {
    showRentalCategories = !showRentalCategories;
    if (!showRentalCategories) {
      try {
        if (tripApiResponse.isEmpty) {
          emit(VehicleStatusLoadingState());
          var response = await _getTuroVehiclesList();
          tripApiResponse = List<Map<String, dynamic>>.from(response?['data'] ?? []);
          tripStatusCategories = tripStatusCategories.map((e) => e..['count'] = _findByTripCategory(e['id']).length).toList();
          selectedTripCategory = tripStatusCategories.first;
          filteredTrips = _findByTripCategory(selectedTripCategory['id']);
          emit(VehicleStatusLoadedState());
        }
      } catch(e) {
        emit(VehicleStatusErrorState(e.toString()));
      }
    }
    emit(VehicleStatusChangedState());
  }

  List<Map<String, dynamic>> _findByTripCategory(int id) {
    var nextDate = DateTime.now().add(const Duration(days: 1)).toFormat(format: "MMM dd");
    switch (id) {
      case 1: // ON A TRIP
        return tripApiResponse.where((element) => element['trip_status'].toString().toLowerCase() == 'on a trip').toList();
      case 2: // EXCEPT ON A TRIP
        return tripApiResponse.whereNot((element) => element['trip_status'].toString().toLowerCase() == 'on a trip').toList();
      case 3: // NEXT TRIP
        return tripApiResponse.where((element) => ['next trip', 'on a trip'].contains(element['trip_status'].toString().toLowerCase()) && (element['vehicle_status'].toString().toLowerCase() != 'unlisted') && (element['ratings'].toString().isNotEmpty)).toList();
      case 4: // EXCEPT NEXT TRIP
        return tripApiResponse.whereNot((element) => ['next trip', 'on a trip'].contains(element['trip_status'].toString().toLowerCase()) && (element['vehicle_status'].toString().toLowerCase() != 'unlisted') && (element['ratings'].toString().isNotEmpty)).toList();
      case 5: // NEXT DAY
        return tripApiResponse.where((element) => (element['trip_status'].toString().toLowerCase() == 'next trip') && (element['trip_date'].toString().split(" - ").contains(nextDate))).toList();
      default:
        return [];
    }
  }

  Color vehicleStatusColor(String status) {
    switch (status) {
      case 'Listed':
        return AppC.green;
      case "Unlisted":
        return AppC.red;
      case "Snoozed":
        return AppC.orange;
      default:
        return AppC.fieldBase;
    }
  }

  // API CALLS : BEGINS HERE
  Future<Map<String, dynamic>?> _getVehicleStatusCategories() async => await _aPiRepository.getVehicleCategories();
  Future<Map<String, dynamic>?> _getVehicleStatus({dynamic statusId}) async => await _aPiRepository.getVehicleStatus(statusId);
  Future<Map<String, dynamic>?> _getCohorts() async => await _aPiRepository.getCohorts();
  Future<Map<String, dynamic>?> _getTuroVehiclesList() async => await _aPiRepository.getTuroVehiclesList();
// API CALLS : ENDS HERE

  void _onVehicleStatusTap(VehicleStatusOnTapEvent event, Emitter<VehicleStatusState> emit) {
    emit(VehicleStatusOnPressedState(event.model, event.type, selectedCategory?['id']));
  }
}