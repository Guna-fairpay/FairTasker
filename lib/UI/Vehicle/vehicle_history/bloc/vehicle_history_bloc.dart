import 'dart:async';
import 'dart:convert';

import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Response/vehicle_history_response.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/repository/vehicle_history_repository.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
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

  int currentPage = 1;
  int totalPage = 0;
  bool hasMoreData = false;
  bool isSameTaskSelected = false;
  VehicleHistoryResponse? apiResponse;
  List<Map<String, dynamic>> listData = [];

  // int get totalPage => (_totalCount ~/ itemsPerPage).ceil();

  VehicleHistoryBloc() : super(VehicleHistoryLoadingState()) {
    on<VehicleInitialEvent>(_initialEvent);

    on<VehicleHistoryPageEvent>(_paginationEvent);

    on<VehicleHistorySearchEvent>(_onSearchEvent);

    on<VehicleHistoryCompleteEvent>(_onCompleteEvent);

    on<VehicleHistoryDeleteEvent>(_onDeleteEvent);

    on<VehicleHistorySameTaskEvent>(_onSameTaskEvent);

    on<VehicleHistoryViewEvent>((event, emit) => emit(VehicleHistorySelectTaskState(event.task)));

    on<VehicleHistoryDeleteInitEvent>((event, emit) => emit(VehicleHistoryDeleteInitState(event.task)));

    on<VehicleHistoryShowPartsEvent>((event, emit) => emit(VehicleHistoryShowPartsState(event.model)));

    on<VehicleHistoryShowSuppliesEvent>((event, emit) => emit(VehicleHistoryShowSuppliesState(event.model)));

    on<VehicleHistoryShowUsersEvent>(_onUsersEvent);

    on<VehicleHistoryViewCustomLinkEvent>(_onViewCustomLinkEvent);
  }

  List<Map<String, dynamic>> _convertData(List<Map<String, dynamic>>? data) {
    for (var item in (data ?? [])) {
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
    return data ?? [];
  }

  Future<VehicleHistoryResponse?> _getVehicleHistory({int? currentPage, String? search}) async =>
      await vehicleHistoryRepository.getVehicleHistoryList(vin: vinNumber, groupId: vehicleGroupId,
          currentPage: currentPage, search: search, itemsPerPage: itemsPerPage);

  Future<List<Map<String, dynamic>>> _getResourcesList() async => await getIt<CommonService>().getResources();

  Future<List<Map<String, dynamic>>> _getGroupPersonList() async => await getIt<CommonService>().getGroupPersons();

  Future<GeneralResponse?> _completeTodo(dynamic todoId, bool status) async => await vehicleHistoryRepository.completeToDo(todoId, status: status);

  Future<GeneralResponse?> _deleteTodo(dynamic todoId, dynamic reason) async => await vehicleHistoryRepository.deleteToDo(todoId, reason);

  void _initialEvent(VehicleInitialEvent event, Emitter<VehicleHistoryState> emit) async {
    vinNumber = event.vin;
    vehicleGroupId = event.groupId;
    vinName = event.vehicleName;
    itemsPerPage = event.itemPerPage;
    if (vinName.toString().isNullOrEmpty && vehicleGroupId.toString().isNullOrEmpty && vinName.toString().isNullOrEmpty) return;
    try {
      emit(VehicleHistoryLoadingState());
      var response = await Future.wait([
        _getResourcesList(),
        _getGroupPersonList(),
      ]);
      apiResponse = await _getVehicleHistory(currentPage: currentPage, search: searchController.text);
      resources = response[0];
      userGroups = response[1];
      var vehicleDataList = _convertData(apiResponse?.data);
      listData = vehicleDataList;
      currentPage = apiResponse?.currentPage ?? 1;
      hasMoreData = apiResponse?.hasMoreData ?? false;
      totalPage = apiResponse?.total ?? 0;
      emit(VehicleHistoryCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(VehicleHistoryErrorState(e));
    }
  }

  void _paginationEvent(VehicleHistoryPageEvent event, Emitter<VehicleHistoryState> emit) async {
    var pageCount = event.page;
    try{
      listData = [];
      emit(VehicleHistoryLoadingState());
      var response = await _getVehicleHistory(currentPage: pageCount, search: searchController.text);
      listData = _convertData(response?.data);
      currentPage = response?.currentPage ?? 1;
      hasMoreData = response?.hasMoreData ?? false;
      totalPage = response?.total ?? 0;
      emit(VehicleHistoryCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(VehicleHistoryErrorState(e));
    }
  }

  void _onSearchEvent(VehicleHistorySearchEvent event, Emitter<VehicleHistoryState> emit) async {
    var pageCount = 1;
    try{
      listData = [];
      emit(VehicleHistoryLoadingState());
      var response = await _getVehicleHistory(currentPage: pageCount, search: event.searchText);
      listData = _convertData(response?.data);
      currentPage = response?.currentPage ?? 1;
      hasMoreData = response?.hasMoreData ?? false;
      totalPage = response?.total ?? 0;
      emit(VehicleHistoryCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(VehicleHistoryErrorState(e));
    }
  }

  void _onCompleteEvent(VehicleHistoryCompleteEvent event, Emitter<VehicleHistoryState> emit) async {
    try{
      emit(VehicleHistorySubLoadingState());
      var response = await _completeTodo(event.todoId, event.status);
      for (var element in listData) {
        if (element['id'] == event.todoId) {
          element['status'] = (event.status ? "Completed" : "In Progress");
        }
      }
      if (response?.status != 200) Toaster.showError(response?.message);
      emit(VehicleHistoryCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(VehicleHistoryErrorState(e));
    }
  }

  void _onDeleteEvent(VehicleHistoryDeleteEvent event, Emitter<VehicleHistoryState> emit) async {
    try {
      emit(VehicleHistorySubLoadingState());
      var response = await _deleteTodo(event.todoId, event.reason);
      if (response?.status == 200) {
        listData.removeWhere((element) => element['id'] == event.todoId);
      } else {
        Toaster.showError(response?.message);
      }
      emit(VehicleHistoryCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(VehicleHistoryErrorState(e));
    }
  }

  void _onSameTaskEvent(VehicleHistorySameTaskEvent event, Emitter<VehicleHistoryState> emit) async {
    isSameTaskSelected = event.isChecked;
    if (event.isChecked && (event.title.toString().isNotEmpty)) {
      searchController.text = event.title;
    } else {
      searchController.clear();
    }
    var pageCount = 1;
    try{
      totalPage = 0;
      listData = [];
      emit(VehicleHistorySubLoadingState());
      var response = await _getVehicleHistory(currentPage: pageCount, search: searchController.text);
      listData = _convertData(response?.data);
      currentPage = response?.currentPage ?? 1;
      hasMoreData = response?.hasMoreData ?? false;
      totalPage = response?.total ?? 0;
      emit(VehicleHistoryCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(VehicleHistoryErrorState(e));
    }
  }

  void _onViewCustomLinkEvent(VehicleHistoryViewCustomLinkEvent event, Emitter<VehicleHistoryState> emit) {
    var link = event.customLink;
    switch (event.customId) {
      case 2:
        link = link.toTuroReserveUrl;
        break;
      case 3:
        link = link.toGetAroundReserveUrl;
        break;
    }
    Utils.openURL(link);
  }

  void _onUsersEvent(VehicleHistoryShowUsersEvent event, Emitter<VehicleHistoryState> emit) {
    if (event.model.length <= 1) return;
    emit(VehicleHistoryShowUsersState(event.model));
  }
}
