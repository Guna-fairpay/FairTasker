import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart' show Durations, TextEditingController;
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Todo/pre_checks/bloc/precheck_event.dart';
import 'package:fairpytasker/UI/Todo/pre_checks/bloc/precheck_state.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';

class PreCheckBloc extends Bloc<PreCheckEvent, PreCheckState> {
  final APiRepository _aPiRepository = APiRepository();
  List<Map<String, dynamic>> _todos = [];
  List<Map<String, dynamic>> checkLists = [];
  Map<String, dynamic>? _editToDoModel;
  int get _userId => getIt<CommonService>().userId;
  PreCheckBloc(): super(PreCheckLoadingState()) {
    on<PreCheckInitialEvent>(_onInitialEvent);
    on<PreCheckCheckEvent>(_onCheckEvent);
    on<PreCheckSubmitEvent>(_onSubmitEvent);
    on<PreCheckCompleteEvent>(_onCompleteEvent);
    on<PreCheckDeleteEvent>(_onDeleteEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchCheckList() async => await getIt<CommonService>().getCheckList();
  Future<List<Map<String, dynamic>>?> _fetchToDo() async => await _aPiRepository.todo();
  Future<Map<String, dynamic>?> _updateToDo(Map<String, dynamic> body, dynamic toDoId) async => await _aPiRepository.updateToDo(body: body, toDoId: toDoId);
  Future<Map<String, dynamic>?> _addToDo(Map<String, dynamic> body) async => await _aPiRepository.addToDo(body: body);
  Future<Map<String, dynamic>?> _completeToDo(Map<String, dynamic> body, dynamic toDoId) async => await _aPiRepository.completeTodo(body: body, todoId: toDoId);
  Future<Map<String, dynamic>?> _deleteToDo(dynamic toDoId, dynamic reason) async => await _aPiRepository.deleteTodo(id: toDoId, reason: reason);

  void _onInitialEvent(PreCheckInitialEvent event, Emitter<PreCheckState> emit) async {
    try {
      _editToDoModel = event.model;
      emit(PreCheckLoadingState());
      var response = await Future.wait([
        _fetchCheckList(),
        _fetchToDo()
      ]);
      checkLists = response[0] ?? [];
      _todos = response[1] ?? [];
      _processData();
      emit(PreCheckCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(PreCheckErrorState(e));
    }
  }

  void _processData() {
    try {
      var fixTasks = (_editToDoModel?['fix_tasks'].toString().isNullOrEmpty ?? false) ? null :  jsonDecode(_editToDoModel?['fix_tasks'] ?? "");
      Console.of.log("${fixTasks is String}", name: "FIX_TASKS");
      Map<dynamic, dynamic> fixTaskId = (fixTasks != null) ? ((fixTasks is String) ? Map.from(jsonDecode(fixTasks)) : fixTasks) : {};
      Console.of.log("$fixTaskId", name: "FIX_TASKS");
      // BASIC CHECK ALL THE FIELDS INSIDE CHILDREN
      for (var element in checkLists) {
        var taskId = fixTaskId[element['id'].toString()];
        var todo = _findToDo(taskId: taskId);
        element['fix_task_id'] = taskId;
        element['fix_task'] = todo;
        element['checked'] = (todo == null);
        element['notes'] = TextEditingController(text: parse(_fetchComments(taskId: taskId)).body?.text);
      }
    } catch (e) {
      rethrow;
    }
  }

  String _fetchComments({dynamic taskId}) => (_todos.where((element) => element['status'].toString() == "In Progress").firstWhereOrNull((element) => element['id'] == taskId)?['notes'] ?? "").toString().split("-").lastOrNull ?? "";

  Map<String, dynamic>? _findToDo({required dynamic taskId}) {
    var todo = _todos.where((element) => element['status'].toString() == "In Progress").firstWhereOrNull((element) => element['id'] == taskId);
    var vinList = (List.from(todo?['vehicles'] ?? []).map((e) => e['vin'])).toList();
    vinList.add((todo?['vin'] ?? ""));
    vinList.removeWhere((element) => element.toString().isNullOrEmpty);
    vinList = vinList.distinct((element) => element);
    todo?.putIfAbsent("display", () => {
      "vins" : vinList
    });
    return todo;
  }

  int? _identifierId({required dynamic modelId}) => switch(modelId){
    1 => 30,
    7 => 35,
    _ => null,
  };

  dynamic _title({required dynamic modelId}) => switch(modelId){
    1 => "Clean Car",
    7 => "Oil Change Check",
    8 => "Refuel Car",
    _ => "Fix"
  };

  Future<void> _updateBody({dynamic responseId, dynamic modelId}) async {
    try {
      var oldIds = checkLists
          .where((element) =>
      element['fix_task_id']
          .toString()
          .isNotNullOrEmpty)
          .map((e) => <String, dynamic>{"${e['id']}": e['fix_task_id']}).toList();
      Map<String, dynamic> fixTaskBody = { for (var element in oldIds) ...element };
      fixTaskBody["$modelId"] = responseId;
      var updateBody = { "fix_tasks" : fixTaskBody, "type" : "inline" };
      Console.of.log(jsonEncode(updateBody));
      await _updateToDo(updateBody, _editToDoModel?['id']);
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }

  void _onCheckEvent(PreCheckCheckEvent event, Emitter<PreCheckState> emit) {
    if ((event.model['fix_task'] != null) && (event.model['checked'] == false)) {
      emit(PreCheckPopupState(model: event.model));
      return;
    }
    event.model['checked'] = event.isChecked;
    Console.of.log("${event.model['name']}");
    emit(PreCheckCommonState());
  }

  void _onSubmitEvent(PreCheckSubmitEvent event, Emitter<PreCheckState> emit) async {
    try {
      emit(PreCheckLoadingState());
      var labels = (event.model?['title'] ?? "");
      var comments = (event.model?['notes'] as TextEditingController).text;
      var taskId = (event.model?['fix_task']?['id'] ?? 0);
      var modelId = event.model?['id'] ?? 0;
      var identifierId = _identifierId(modelId: modelId);
      var title = _title(modelId: modelId);
      Map<String, String> body = {
        "notes" : ["${labels ?? ""}", (comments.isNullOrEmpty ? "" : comments)].join(" - "),
      };
      if (taskId == 0) {
        // INSERT
        body['address'] = "${_editToDoModel?['address'] ?? ""}";
        body['branch_id'] = "${_editToDoModel?['branch_id'] ?? ""}";
        body['cohort_id'] = "${_editToDoModel?['cohort_id'] ?? ""}";
        body['identifier_id'] = "${identifierId ?? ""}";
        body['location'] = "${_editToDoModel?['location'] ?? ""}";
        body['location_id'] = "${_editToDoModel?['location_id'] ?? ""}";
        body['start_at'] = "${_editToDoModel?['todo_date'] ?? ""}";
        body['time_sensitive'] = "${_editToDoModel?['time_sensitive'] ?? ""}";
        body['title'] = title;
        body['todo_time'] = DateTime.now().toFormat(format: "HH:mm:ss") ?? "";
        body['todo_user_type'] = "${_editToDoModel?['todo_user_type'] ?? ""}";
        body['user_group_id'] = "${_editToDoModel?['user_group_id'] ?? ""}";
        body['user_id'] = "$_userId";
        body['vehicle_name'] = List.from(_editToDoModel?['vehicles'] ?? []).firstOrNull?['vehicle_name'] ?? "";
        body['vehicles'] = "${List.from(_editToDoModel?['vehicles'] ?? []).map((e) => jsonEncode(e)).toList()}";
        body['vendor_id'] = _editToDoModel?['vendor_id'] ?? "";
        body['vendor_name'] = "${_editToDoModel?['vendor_name'] ?? ""}";
        body['vin'] = "${_editToDoModel?['vin'] ?? ""}";
      }
      var response = await ((taskId > 0) ? _updateToDo(body, taskId) : _addToDo(body));
      if (response != null) {
        if (taskId == 0) await _updateBody(responseId: List.from(response['todo']).firstOrNull?['id'], modelId: event.model['id']);
        Console.of.log("$response", name: "RESPONSE");
        TaskerHelper.instance.refresh();
        emit(PreCheckCompleteState());
      } else {
        emit(PreCheckCommonState());
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(PreCheckErrorState(e));
    }
  }

  void _onCompleteEvent(PreCheckCompleteEvent event, Emitter<PreCheckState> emit) async {
    try {
      Map<String, dynamic> model = event.model;
      var fixTask = model['fix_task'];
      var taskId = fixTask?['id'];
      var identifierId = fixTask?['identifier_id'];
      if (identifierId == 35) { // OILCHANGE CHECK
        emit(PreCheckCompleteState());
        await Future.delayed(Durations.short1);
        FBroadcast.instance().broadcast("show_completed_popup", value: fixTask);
        return;
      }
      emit(PreCheckLoadingState());
      var mapData = {
        "complete_time_approved" : fixTask?['complete_time_approved'] ?? 1,
        "complete_time_taken" : (fixTask?['complete_time_taken']) ?? "00:15",
        "status" : true,
      };
      var response = await _completeToDo(mapData, taskId);
      if (response != null) {
        Console.of.log("$response", name: "RESPONSE");
        TaskerHelper.instance.refresh();
        emit(PreCheckCompleteState());
      } else {
        emit(PreCheckCommonState());
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(PreCheckErrorState(e));
    }
  }

  void _onDeleteEvent(PreCheckDeleteEvent event, Emitter<PreCheckState> emit) async {
    if (event.reason.isNullOrEmpty) {
      emit(PreCheckDeleteDialogState(model: event.model));
      return;
    }
    try {
      emit(PreCheckLoadingState());
      Map<String, dynamic> model = event.model;
      var fixTask = model['fix_task'];
      var taskId = fixTask?['id'];
      await _deleteToDo(taskId, event.reason);
      TaskerHelper.instance.refresh();
      emit(PreCheckCompleteState());
    } catch(e) {
      Console.of.error("Error", error: e);
      emit(PreCheckErrorState(e));
    }
  }
}