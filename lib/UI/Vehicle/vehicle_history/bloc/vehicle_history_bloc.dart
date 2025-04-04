import 'dart:convert';
import 'dart:developer';

import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Response/user_group_response.dart';
import 'package:fairpytasker/Response/vehicle_history_response.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/repository/vehicle_history_repository.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../event/vehicle_history_event.dart';
import '../state/vehicle_history_state.dart';

class VehicleHistoryBloc
    extends Bloc<VehicleHistoryEvent, VehicleHistoryState> {
  final TextEditingController searchController = TextEditingController();
  final VehicleHistoryRepository vehicleHistoryRepository =
      VehicleHistoryRepository();
  dynamic vinNumber;
  dynamic vehicleGroupId;
  dynamic vinName;
  int itemsPerPage = 10;
  List<Map<String, dynamic>> resources = [];
  List<Map<String, dynamic>> userGroups = [];

  bool get _isAdminRole => getIt<CommonService>().isAdmin;
  bool get isAdmin => (Session.of.getString(Str.userIdPrefText) == "3") || _isAdminRole;

  VehicleHistoryBloc()
      : super(const VehicleHistoryState(
          vin: '',
          selectedTask: {},
          vehicleName: '',
          apiResponse: [],
          vehicleDataList: {},
          resourceList: [],
          userGroupList: [],
          isLoading: false,
          totalPage: 1,
          currentPage: 1,
          hasMoreData: false,
          isSameTaskSelected: false,
        )) {
    on<VehicleInitialEvent>((event, emit) async {
      vinNumber = event.vin;
      vehicleGroupId = event.groupId;
      vinName = event.vehicleName;
      try {
        emit(state.copyWith(isLoading: true));
        var response = await Future.wait([
          _getVehicleHistory(currentPage: state.currentPage, search: searchController.text),
          _getResourcesList(),
          _getGroupPersonList(),
        ]);
        VehicleHistoryResponse? apiResponse = (response[0] is VehicleHistoryResponse) ? (response[0] as VehicleHistoryResponse) : null;
        AssignedToResponse? resourceList = (response[1] is AssignedToResponse) ? (response[1] as AssignedToResponse) : null;
        UserGroupResponse? userGroupList = (response[2] is UserGroupResponse) ? (response[2] as UserGroupResponse) : null;
        resources = resourceList?.resource ?? [];
        userGroups = userGroupList?.data ?? [];
        var vehicleDataList = _convertData(apiResponse?.data);
        emit(state.copyWith(
          isLoading: false,
          resourceList: resourceList?.resource,
          userGroupList: userGroupList?.data,
          currentPage: apiResponse?.currentPage,
          hasMoreData: apiResponse?.hasMoreData,
          totalPage: apiResponse?.total,
          vin: vinNumber,
          vehicleName: vinName,
          apiResponse: apiResponse?.data,
          vehicleDataList: vehicleDataList,
        ));
      } catch (e) {
        log('${vinNumber} Exception: $e', name: "VEHICLE_HISTORY_BLOC");
        Toaster.showError("Something went wrong");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<VehicleHistoryPageEvent>((event, emit) async {
      var pageCount = event.page;
      try{
          emit(state.copyWith(isLoading: true, vehicleDataList: {}));
          var response = await _getVehicleHistory(currentPage: pageCount, search: searchController.text);
          var vehicleDataList = _convertData(response?.data);
          emit(state.copyWith(
              isLoading: false,
              vehicleDataList: vehicleDataList,
              currentPage: response?.currentPage,
              hasMoreData: response?.hasMoreData,
              totalPage: response?.total));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<VehicleHistorySearchEvent>((event, emit) async {
      var pageCount = 1;
      try{
        emit(state.copyWith(isLoading: true, vehicleDataList: {}));
        var response = await _getVehicleHistory(currentPage: pageCount, search: event.searchText);
        var vehicleDataList = _convertData(response?.data);
        emit(state.copyWith(
            isLoading: false,
            vehicleDataList: vehicleDataList,
            currentPage: response?.currentPage,
            hasMoreData: response?.hasMoreData,
            totalPage: response?.total));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<VehicleHistoryCompleteEvent>((event, emit) async {
      try{
        emit(state.copyWith(isLoading: true));
        var response = await _completeTodo(event.todoId, event.status);
        if (response?.status == 200) {
          emit(state.copyWith(vehicleDataList: {}));
          var pageCount = state.currentPage;
          var response = await _getVehicleHistory(currentPage: pageCount, search: searchController.text);
          var vehicleDataList = _convertData(response?.data);
          var selectedTask = state.selectedTask;
          if (selectedTask != null) {
            selectedTask = response?.data?.where((element) => element['id'] == selectedTask['id']).lastOrNull;
          }
          emit(state.copyWith(
              isLoading: false,
              vehicleDataList: vehicleDataList,
              selectedTask: selectedTask,
              currentPage: response?.currentPage,
              hasMoreData: response?.hasMoreData));
        } else {
          Toaster.showError(response?.message);
          emit(state.copyWith(isLoading: false));
        }
      } catch (e) {
        Toaster.showError(e.toString());
        emit(state.copyWith(isLoading: false));
      }
    });

    on<VehicleHistoryDeleteEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        var response = await _deleteTodo(event.todoId, event.reason);
        if (response?.status == 200) {
          emit(state.copyWith(vehicleDataList: {}));
          var pageCount = state.currentPage;
          var response = await _getVehicleHistory(currentPage: pageCount, search: searchController.text);
          var vehicleDataList = _convertData(response?.data);
          emit(state.copyWith(
              isLoading: false,
              vehicleDataList: vehicleDataList,
              currentPage: response?.currentPage,
              totalPage: response?.total,
              hasMoreData: response?.hasMoreData));
        } else {
          Toaster.showError(response?.message);
        }
      } catch (e) {
        Toaster.showError(e.toString());
        emit(state.copyWith(isLoading: false));
      }
    });

    on<VehicleHistorySameTaskEvent>((event, emit) async{
      if (event.isChecked && (event.title.toString().isNotEmpty)) {
        searchController.text = event.title;
      } else {
        searchController.clear();
      }
      var pageCount = 1;
      try{
        emit(state.copyWith(isLoading: true, vehicleDataList: {}, isSameTaskSelected: event.isChecked));
        var response = await _getVehicleHistory(currentPage: pageCount, search: searchController.text);
        var vehicleDataList = _convertData(response?.data);
        emit(state.copyWith(
            isLoading: false,
            vehicleDataList: vehicleDataList,
            currentPage: response?.currentPage,
            hasMoreData: response?.hasMoreData,
            totalPage: response?.total));
      } catch (e) {
        emit(state.copyWith(isLoading: false, isSameTaskSelected: event.isChecked));
      }
    });

    on<VehicleHistoryViewEvent>((event, emit) async {
      emit(state.copyWith(selectedTask: event.task));
    });

  }

  Map<DateTime, List<dynamic>> _convertData(List<Map<String, dynamic>>? data) {
    Map<DateTime, List<dynamic>> map = {};
    if (data != null) {
      for (var item in data) {
        int? groupId = item['user_group_id'];
        if ((groupId != null) && (groupId != 0)) {
          String userIdString = userGroups.firstWhere((element) => element['id'] == groupId)['userId'] ?? "";
          List<int> userIds = List.from(jsonDecode(userIdString));
          var users = resources.where((element) => userIds.contains(element['id'])).toList();
          item['userIds'] = userIds;
          item['users'] = (item['users'] != null) ? [...[item['users']], ...users] : users;
        } else {
          item['users'] = [item['users']];
        }
      }
      for (var item in data) {
        var inputDate = item['todo_date'].toString();
        DateTime? date = inputDate.toDateTime();
        if (date != null) {
          if (map.containsKey(date)) {
            map[date]?.add(item);
          } else {
            map[date] = [item];
          }
        }
      }
    }
      return map;
  }

  Future<VehicleHistoryResponse?> _getVehicleHistory({int? currentPage, String? search}) async =>
      await vehicleHistoryRepository.getVehicleHistoryList(vin: vinNumber, groupId: vehicleGroupId,
          currentPage: currentPage, search: search, itemsPerPage: itemsPerPage);

  Future<AssignedToResponse?> _getResourcesList() async => await vehicleHistoryRepository.getResourcesList();

  Future<UserGroupResponse?> _getGroupPersonList() async => await vehicleHistoryRepository.getGroupPersonList();

  Future<GeneralResponse?> _completeTodo(dynamic todoId, bool status) async => await vehicleHistoryRepository.completeToDo(todoId, status: status);

  Future<GeneralResponse?> _deleteTodo(dynamic todoId, dynamic reason) async => await vehicleHistoryRepository.deleteToDo(todoId, reason);

}
