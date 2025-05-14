import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_states.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleLogBloc extends Bloc<VehicleLogEvent, VehicleLogState> {
  dynamic vin;
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>>? expenseLogs = [], unfilteredExpenseLogs = [];
  List<Map<String, dynamic>>? users = [];
  final FBroadcast _broadcast = FBroadcast.instance();

  VehicleLogBloc() : super(VehicleLogLoadingState()) {
    _broadcast.register("vehicle_log", (value, callback) => _refresh());
    on<VehicleLogInitialEvent>(_onInitialEvent);
    on<AddVehicleLogEvent>(_onAddVehicleLogEvent);
    on<VehicleLogSearchEvent>(_onSearchEvent);
    on<VehicleLogViewAttachmentEvent>(_onViewAttachmentEvent);
    on<VehicleLogDeleteEvent>(_onDeleteEvent);
    on<VehicleLogDeleteTapEvent>(_onDeleteTapEvent);
    on<VehicleLogNotesTapEvent>(_onNotesTapEvent);
    on<VehicleLogNotesUpdateEvent>(_onNotesUpdateEvent);
  }

  Future<Map<String, dynamic>?> _deleteExpenseLog({required int? id}) async =>
      await _aPiRepository.deleteExpenseLog(logId: id);

  Future<List<Map<String, dynamic>>?> _fetchExpenseLogs() async =>
      await _aPiRepository.expenseLogs(vin: vin);

  Future<List<Map<String, dynamic>>?> _fetchUsers() async =>
      await getIt<CommonService>().getResources();

  void _onInitialEvent(
      VehicleLogInitialEvent event, Emitter<VehicleLogState> emit) async {
    vin = event.vin;
    _refresh();
  }

  void _refresh() async {
    try {
      if (!isClosed) emit(VehicleLogLoadingState());
      expenseLogs = await _fetchExpenseLogs();
      users = await _fetchUsers();
      expenseLogs = expenseLogs
          ?.map((e) => e
            ..['hasAttachments'] = _hasAttachment(e)
            ..['attachmentLabel'] = _attachmentLabel(e)
            ..['user'] = users?.firstWhereOrNull((element) =>
                element['id'].toString() == e['user_id'].toString()))
          .toList();
      unfilteredExpenseLogs = expenseLogs;
      if (!isClosed) emit(VehicleLogCommonState());
    } catch (e) {
      if (!isClosed) emit(VehicleLogErrorState(e));
    }
  }

  String? _attachmentLabel(Map<String, dynamic>? model) {
    return ([
      ((model?['audio'].toString().isNotNullOrEmpty ?? false) ? "Audio" : ""),
      ((model?['video'].toString().isNotNullOrEmpty ?? false) ? "Video" : ""),
      ((model?['image'].toString().isNotNullOrEmpty ?? false) ? "Image" : "")
    ]..removeWhere((element) => element.isNullOrEmpty))
        .join(",");
  }

  bool _hasAttachment(Map<String, dynamic>? model) {
    return _attachmentLabel(model).isNotNullOrEmpty;
  }

  void _onAddVehicleLogEvent(
      AddVehicleLogEvent event, Emitter<VehicleLogState> emit) {
    emit(VehicleLogAddState(vin));
  }

  void _onSearchEvent(
      VehicleLogSearchEvent event, Emitter<VehicleLogState> emit) {
    var searchQuery = event.searchQuery.toLowerCase();
    if (searchQuery.trim().isNotNullOrEmpty) {
      // SEARCH
      expenseLogs = unfilteredExpenseLogs
          ?.where((element) =>
              element['title'].toString().toLowerCase().contains(searchQuery) ||
              element['notes'].toString().toLowerCase().contains(searchQuery))
          .toList();
    } else {
      // DEFAULT
      expenseLogs = unfilteredExpenseLogs;
    }
    emit(VehicleLogCommonState());
  }

  void _onViewAttachmentEvent(
      VehicleLogViewAttachmentEvent event, Emitter<VehicleLogState> emit) {
    emit(VehicleLogViewAttachmentState(event.model));
  }

  void _onDeleteTapEvent(
      VehicleLogDeleteTapEvent event, Emitter<VehicleLogState> emit) {
    emit(VehicleLogDeleteTapState(event.model));
  }

  void _onDeleteEvent(
      VehicleLogDeleteEvent event, Emitter<VehicleLogState> emit) async {
    try {
      if (!isClosed) emit(VehicleLogLoadingState());
      var response = await _deleteExpenseLog(id: event.model?['id']);
      if (response != null) _refresh();
    } catch (e) {
      if (!isClosed) emit(VehicleLogErrorState(e));
    }
  }

  void _onNotesTapEvent(VehicleLogNotesTapEvent event, Emitter<VehicleLogState> emit) {
    emit(VehicleLogNotesTapState(event.model));
  }

  void _onNotesUpdateEvent(VehicleLogNotesUpdateEvent event, Emitter<VehicleLogState> emit) async {
    try {
      emit(VehicleLogLoadingState());
      var body = {"user_id": getIt<CommonService>().userId ,"notes":event.notes ?? "","vin":"${event.model?['vin'] ?? ""}"};
      var response = await _aPiRepository.updateExpenseLogs(logId: event.model?['id'], body: body);
      if (response != null) _refresh();
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(VehicleLogErrorState(e));
    }
  }
}
