import 'dart:async';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_config.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
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
  List<Map<String, dynamic>> miscellaneousVehicles = [];
  Map<String, dynamic>? selectedCategory;
  List<Map<String, dynamic>> tripStatusCategories =
      VehicleStatusConfig.tripStatusCategories;
  Map<String, dynamic> selectedTripCategory =
      VehicleStatusConfig.tripStatusCategories.first;
  bool showSearcher = false;
  bool showRentalCategories = true;
  bool showMiscellaneous = false;
  Map<String, dynamic> filterData = {};
  List<Map<String, dynamic>> tripApiResponse = [];
  List<Map<String, dynamic>> filteredTrips = [];
  List<Map<String, dynamic>> filterBys = [];
  final FBroadcast _fBroadcast = FBroadcast.instance();

  VehicleStatusBloc() : super(VehicleStatusLoadingState()) {
    _fBroadcast.register("vehicleStatus", (value, callback) => add(VehicleStatusInitialEvent()));
    on<VehicleStatusInitialEvent>(_onInitialEvent);
    on<VehicleStatusShowHideSearcherEvent>(_onShowHideSearcher);
    on<VehicleStatusCohortChangeEvent>(_onCohortChange);
    on<VehicleStatusCategoryChangeEvent>(_onCategoryChange);
    on<VehicleStatusOnChangeTripCategory>(_onChangeTripCategory);
    on<VehicleStatusDisplayRentalCategories>(_onChangeTripCategoryVisibility);
    on<VehicleStatusOnTapEvent>(_onVehicleStatusTap);
    on<VehicleStatusSearchQueryEvent>(_onSearchQuery);
    on<VehicleStatusRefreshEvent>(_onRefresh);
    on<VehicleStatusMiscEvent>(_onMiscEvent);
    on<VehicleStatusShowDatePickEvent>(_onDatePick);
    on<VehicleStatusSaveDateEvent>(_onSaveDate);
    on<VehicleOnCompleteEvent>(_onComplete);
    on<VehicleOnPreviousEvent>(_onPrevious);
    on<VehicleStatusShowSortingEvent>(_onShowSortingEvent);
    on<VehicleStatusSortEvent>(_onSortEvent);
  }

  void _onInitialEvent(event, emit) async {
    try {
      emit(VehicleStatusLoadingState());
      var response = await Future.wait([
        _getVehicleStatusCategories(),
        _getVehicleStatus(statusId: 1),
        _getCohorts(),
        _getFilter(1)
      ]);
      var categories = response[0];
      var status = response[1];
      var cohorts = response[2];
      var filter = response[3];
      vehicleStatusCategories =
          List<Map<String, dynamic>>.from(categories?['data'] ?? []);
      vehicleStatus = List<Map<String, dynamic>>.from(status?['data'] ?? []);
      var vehiclesCount =
          List<Map<String, dynamic>>.from(status?['vehiclesCount'] ?? []);
      cohortsData =
          List<Map<String, dynamic>>.from(cohorts?['cohortsData'] ?? []);
      cohortsData.insert(0, {'cohort': 'All', 'id': 0});
      vehicleStatusCategories = vehicleStatusCategories
          .map((e) => e
            ..['count'] = vehiclesCount.firstWhereOrNull(
                    (element) => element['id'] == e['id'])?['vehicle_count'] ??
                0)
          .toList();
      filterData = filter?['data'] ?? {};
      selectedCategory = vehicleStatusCategories.firstOrNull;
      _prepareFilter();
      filteredVehicleStatus = vehicleStatus;
      selectedCohort = cohortsData[0];
      emit(VehicleStatusLoadedState());
    } catch (e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  } // INITIAL EVENT FETCHING

  void _onShowHideSearcher(VehicleStatusShowHideSearcherEvent event,
      Emitter<VehicleStatusState> emit) async {
    showSearcher = !showSearcher;
    emit(showSearcher
        ? VehicleStatusShowSearcherState()
        : VehicleStatusHideSearcherState());
  }

  void _onCohortChange(VehicleStatusCohortChangeEvent event, emit) async {
    selectedCohort = event.cohort;
    filteredVehicleStatus = [];
    vehicleStatus = [];
    showMiscellaneous = false;
    try {
      emit(VehicleStatusLoadingState());
      var response = await _getVehicleStatus(
          statusId: selectedCategory?['id'], cohortId: selectedCohort?['id']);
      vehicleStatus = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      var vehiclesCount =
          List<Map<String, dynamic>>.from(response?['vehiclesCount'] ?? []);
      filteredVehicleStatus = vehicleStatus
          .where((element) => element['vehicle_name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
      vehicleStatusCategories = vehicleStatusCategories
          .map((e) => e
            ..['count'] = vehiclesCount.firstWhereOrNull(
                    (element) => element['id'] == e['id'])?['vehicle_count'] ??
                0)
          .toList();
      selectedCategory = vehicleStatusCategories.firstOrNull;
      emit(VehicleStatusChangedState());
    } catch (e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  }

  void _prepareFilter() {
    var sortByDate = {
      "id": filterData['id'] ?? 1,
      "name": "Followup Date",
      "showSort": true,
      "asc": (filterData['filter_data'].toString() == "dateAsc"),
      "type": filterData['filter_data'], // "dateDesc" | "dateAsc"
      "modType": filterData['filter_data']
          .toString()
          .replaceAll("Asc", "")
          .replaceAll("Desc", ""),
      "model": (selectedCategory?['id'] == 3)
          ? "vehicle_status_rental_list"
          : "vehicle_status_list",
      "order": 1
    };
    var sortByDays = {
      "id": filterData['id'] ?? 1,
      "name": "Days",
      "showSort": true,
      "asc": (filterData['filter_data'].toString() == "daysAsc"),
      "type": filterData['filter_data'], // "daysDesc" | "daysAsc"
      "modType": filterData['filter_data']
          .toString()
          .replaceAll("Asc", "")
          .replaceAll("Desc", ""),
      "model": (selectedCategory?['id'] == 3)
          ? "vehicle_status_rental_list"
          : "vehicle_status_list",
      "order": 2
    };
    filterBys = [sortByDate, sortByDays];
    if ([3, 7, 1].contains(selectedCategory?['id'])) filterBys.removeLast();
  }

  void _onCategoryChange(VehicleStatusCategoryChangeEvent event, emit) async {
    selectedCategory = event.category;
    try {
      showMiscellaneous = false;
      filteredVehicleStatus = [];
      vehicleStatus = [];
      miscellaneousVehicles = [];
      emit(VehicleStatusLoadingState());
      var response = await Future.wait([
        _getFilter(selectedCategory?['id']),
        _getVehicleStatus(
            statusId: selectedCategory?['id'], cohortId: selectedCohort?['id'])
      ]);
      var filter = response[0];
      var status = response[1];
      vehicleStatus = List<Map<String, dynamic>>.from(status?['data'] ?? []);
      filterData = filter?['data'] ?? {};
      _prepareFilter();
      filteredVehicleStatus = vehicleStatus;
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
    filteredTrips = _findByTripCategory(selectedTripCategory['id'] ?? 1);
    emit(VehicleStatusChangedState());
  }

  void _onChangeTripCategoryVisibility(
      VehicleStatusDisplayRentalCategories event, emit) async {
    showRentalCategories = !showRentalCategories;
    if (!showRentalCategories) {
      try {
        if (tripApiResponse.isEmpty) {
          emit(VehicleStatusLoadingState());
          var response = await _getTuroVehiclesList();
          tripApiResponse =
              List<Map<String, dynamic>>.from(response?['data'] ?? []);
          Console.of.log(tripApiResponse);
          tripStatusCategories = tripStatusCategories
              .map((e) => e
            ..['count'] = _findByTripCategory(e['id'] ?? 1).length
          )
              .toList();
          selectedTripCategory = tripStatusCategories.first;
          filteredTrips = _findByTripCategory(selectedTripCategory['id'] ?? 1);
          emit(VehicleStatusLoadedState());
        }
      } catch (e) {
        Console.of.log(e.toString());
        emit(VehicleStatusErrorState(e.toString()));
      }
    }
    emit(VehicleStatusChangedState());
  }

  List<Map<String, dynamic>> _findByTripCategory(int id) {
    var nextDate =
        DateTime.now().add(const Duration(days: 1)).toFormat(format: "MMM dd");
    switch (id) {
      case 1: // ON A TRIP
        return tripApiResponse
            .where((element) =>
                element['trip_status'].toString().toLowerCase() == 'on a trip')
            .toList();
      case 2: // EXCEPT ON A TRIP
        return tripApiResponse
            .whereNot((element) =>
                element['trip_status'].toString().toLowerCase() == 'on a trip')
            .toList();
      case 3: // NEXT TRIP
        return tripApiResponse
            .where((element) =>
                [
                  'next trip',
                  'on a trip'
                ].contains(element['trip_status'].toString().toLowerCase()) &&
                (element['vehicle_status'].toString().toLowerCase() !=
                    'unlisted') &&
                (element['ratings'].toString().isNotEmpty))
            .toList();
      case 4: // EXCEPT NEXT TRIP
        return tripApiResponse
            .whereNot((element) =>
                [
                  'next trip',
                  'on a trip'
                ].contains(element['trip_status'].toString().toLowerCase()) &&
                (element['vehicle_status'].toString().toLowerCase() !=
                    'unlisted') &&
                (element['ratings'].toString().isNotEmpty))
            .toList();
      case 5: // NEXT DAY
        return tripApiResponse
            .where((element) =>
                (element['trip_status'].toString().toLowerCase() ==
                    'next trip') &&
                (element['trip_date']
                    .toString()
                    .split(" - ")
                    .contains(nextDate)))
            .toList();
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
  Future<Map<String, dynamic>?> _getVehicleStatusCategories() async =>
      await _aPiRepository.getVehicleCategories();

  Future<Map<String, dynamic>?> _getVehicleStatus(
          {dynamic statusId, dynamic cohortId}) async =>
      await _aPiRepository.getVehicleStatus(statusId, cohortId: cohortId);

  Future<Map<String, dynamic>?> _getCohorts() async =>
      await _aPiRepository.getCohorts();

  Future<Map<String, dynamic>?> _getTuroVehiclesList() async =>
      await _aPiRepository.getTuroVehiclesList();

  Future<Map<String, dynamic>?> _getMiscellaneousVehicles() async =>
      await _aPiRepository.getMiscellaneousVehicles();

  Future<Map<String, dynamic>?> _saveDate(dynamic vin, DateTime? date) async =>
      await _aPiRepository.saveNote(vin: vin, date: date);

  Future<Map<String, dynamic>?> _completeToDo(
          Map<String, dynamic> todo) async =>
      await _aPiRepository.createStatusToDo(body: todo);

  Future<Map<String, dynamic>?> _previousToDo(
          Map<String, dynamic> todo) async =>
      await _aPiRepository.updateStatusToDo(body: todo);

  Future<Map<String, dynamic>?> _getFilter(dynamic selectedCategoryId) async =>
      await _aPiRepository.getFilter(
          filterName: selectedCategoryId,
          model: (selectedCategoryId == 3)
              ? "vehicle_status_rental_list"
              : "vehicle_status_list");

  Future<Map<String, dynamic>?> _saveFilter(
          {required dynamic filterId,
          required dynamic filterModel,
          required dynamic filterData}) async =>
      await _aPiRepository.saveFilter(
          filterName: filterId, model: filterModel, filterData: filterData);

// API CALLS : ENDS HERE

  void _onVehicleStatusTap(
      VehicleStatusOnTapEvent event, Emitter<VehicleStatusState> emit) {
    emit(VehicleStatusOnPressedState(
        event.model, event.type, selectedCategory?['id']));
  }

  void _onSearchQuery(
      VehicleStatusSearchQueryEvent event, Emitter<VehicleStatusState> emit) {
    if (event.query.trim().isEmpty) {
      filteredVehicleStatus = vehicleStatus;
      filteredTrips = _findByTripCategory(selectedTripCategory['id'] ?? 1);
    } else {
      filteredVehicleStatus = vehicleStatus
          .where((element) => element['vehicle_name']
              .toString()
              .toLowerCase()
              .contains(event.query.toLowerCase()))
          .toList();
      filteredTrips = _findByTripCategory(selectedTripCategory['id'] ?? 1)
          .where((element) => element['vehicle_name']
              .toString()
              .toLowerCase()
              .contains(event.query.toLowerCase()))
          .toList();
    }
    emit(VehicleStatusChangedState());
  }

  void _onRefresh(
      VehicleStatusRefreshEvent event, Emitter<VehicleStatusState> emit) async {
    try {
      emit(VehicleStatusLoadingState());
      var response = await _getVehicleStatus(statusId: 1);
      vehicleStatus = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      var vehiclesCount =
          List<Map<String, dynamic>>.from(response?['vehiclesCount'] ?? []);
      filteredVehicleStatus = vehicleStatus;
      vehicleStatusCategories = vehicleStatusCategories
          .map((e) => e
            ..['count'] = vehiclesCount.firstWhereOrNull(
                    (element) => element['id'] == e['id'])?['vehicle_count'] ??
                0)
          .toList();
      selectedCategory = vehicleStatusCategories.firstOrNull;
      selectedCohort = cohortsData[0];
      searchController.clear();
      showMiscellaneous = false;
      miscellaneousVehicles = [];
      emit(VehicleStatusLoadedState());
    } catch (e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  }

  void _onMiscEvent(
      VehicleStatusMiscEvent event, Emitter<VehicleStatusState> emit) async {
    if (showMiscellaneous) return;
    try {
      showMiscellaneous = true;
      selectedCategory = null;
      selectedTripCategory.clear();
      showRentalCategories = true;
      showSearcher = false;
      emit(VehicleStatusLoadingState());
      var response = await _getMiscellaneousVehicles();
      var vehicles =
          List<Map<String, dynamic>>.from(response?['vehicles'] ?? []);
      miscellaneousVehicles = vehicles;
      filteredVehicleStatus = [];
      vehicleStatus = [];
      emit(VehicleStatusLoadedState());
    } catch (e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  }

  void _onDatePick(VehicleStatusShowDatePickEvent event,
      Emitter<VehicleStatusState> emit) async {
    emit(VehicleStatusShowDatePickerState(event.model));
  }

  void _onSaveDate(VehicleStatusSaveDateEvent event,
      Emitter<VehicleStatusState> emit) async {
    try {
      var vin = event.model?['vin'] ?? "";
      if (vin.toString().isNullOrEmpty) return;
      emit(VehicleStatusLoadingState());
      var response = await _saveDate(vin, event.date);
      if (response?['status'] == 1) {
        vehicleStatus = vehicleStatus.map((e) {
          if (e == event.model) {
            return e..['followup_date'] = response?['data']?['followup_date'];
          } else {
            return e;
          }
        }).toList();
        filteredVehicleStatus = vehicleStatus;
        emit(VehicleStatusSuccessState(response?['message']));
      } else {
        emit(VehicleStatusErrorState(response?['message']));
      }
    } catch (e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  }

  Map<String, dynamic> toModel(Map<String, dynamic>? model) {
    return {
      "category_id": selectedCategory?['id'],
      "cohort_id": model?['cohort_id'] ?? "",
      "cohort_name": model?['cohort'] ?? "",
      "user_id": getIt<CommonService>().getUserId,
      "vehicle_image": List<Map<String, dynamic>>.from(model?['images'])
              .firstOrNull?['path'] ??
          "",
      "vehicle_name": model?['vehicle_name'] ?? "",
      "vin": model?['vin'] ?? ""
    };
  }

  void _onComplete(
      VehicleOnCompleteEvent event, Emitter<VehicleStatusState> emit) async {
    try {
      var model = event.model;
      var mapBody = toModel(model);
      emit(VehicleStatusLoadingState());
      var response = await _completeToDo(mapBody);
      if (response?['status'] == 200) {
        emit(VehicleStatusSuccessState("Status updated Successfully"));
      } else {
        emit(VehicleStatusErrorState("Something went wrong"));
      }
    } catch (e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  }

  void _onPrevious(
      VehicleOnPreviousEvent event, Emitter<VehicleStatusState> emit) async {
    try {
      var model = event.model;
      var mapBody = toModel(model);
      emit(VehicleStatusLoadingState());
      var response = await _previousToDo(mapBody);
      if (response?['status'] == 200) {
        emit(VehicleStatusSuccessState("Status updated Successfully"));
      } else {
        emit(VehicleStatusErrorState("Something went wrong"));
      }
    } catch (e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  }

  void _onShowSortingEvent(
      VehicleStatusShowSortingEvent event, Emitter<VehicleStatusState> emit) {
    emit(VehicleStatusShowSortingState(event.details));
  }

  void _onSortEvent(
      VehicleStatusSortEvent event, Emitter<VehicleStatusState> emit) async {
    try {
      var model = event.model;
      var filterId = model?['id'];
      var filterModel = model?['model'];
      var sortStatus = !(model?['asc'] as bool);
      var order = (model?['order'] as int);
      var filterData = model?['modType'] + (sortStatus ? "Asc" : "Desc");
      model?['asc'] = sortStatus;
      emit(VehicleStatusLoadingState());
      var response = await _saveFilter(
          filterId: filterId, filterModel: filterModel, filterData: filterData);
      if ((response != null) && (response['data'] != null)) {
        log("$model", name: "MODEL_PICKED");
        log("$response", name: "MODEL_SAVED");
        if (order == 1) {
          vehicleStatus.sort((a, b) =>
          (((sortStatus ? a : b)['followup_date'].toString().toDateTime() ?? DateTime.now())
              .compareTo(((sortStatus ? b : a)['followup_date']
              .toString()
              .toDateTime() ?? DateTime.now()))));
        } else {
          vehicleStatus.sort((a, b) => ((sortStatus ? a : b)['count_days'].toString().getOnlyNumeric).compareTo(((sortStatus ? b : a)['count_days'].toString().getOnlyNumeric)));
        }
        filteredVehicleStatus = vehicleStatus;
      }
      emit(VehicleStatusChangedState());
    } catch (e) {
      emit(VehicleStatusErrorState(e.toString()));
    }
  }
}
