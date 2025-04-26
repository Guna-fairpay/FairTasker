import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_events.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_states.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaintenanceCheckBloc extends Bloc<MaintenanceCheckEvent, MaintenanceCheckState> {
  Map<String, dynamic>? _editToDoModel;
  List<Map<String, dynamic>> maintenanceCheckList = [];
  List<Map<String, dynamic>> _todos = [];
  final APiRepository _apiRepository = APiRepository();
  int get _userId => getIt<CommonService>().userId;
  MaintenanceCheckBloc(): super(MaintenanceCheckLoadingState()) {
    on<MaintenanceCheckInitialEvent>(_onInitialEvent);
    on<MaintenanceCheckAllCheckEvent>(_onAllCheckEvent);
    on<MaintenanceCheckItemCheckEvent>(_onItemCheckEvent);
    on<MaintenanceChangeStatusEvent>(_onChangeStatusEvent);
    on<MaintenanceCreateTaskEvent>(_onCreateTaskEvent);
    on<MaintenanceDeleteTaskEvent>(_onDeleteTaskEvent);
    on<MaintenanceCompleteTaskEvent>(_onCompleteTaskEvent);
    on<MaintenanceUpdateTaskEvent>(_onUpdateTaskEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchMaintenanceCheckList() async => await getIt<CommonService>().getMaintenanceCheckList();
  Future<List<Map<String, dynamic>>?> _fetchToDo() async => await _apiRepository.todo();
  Future<Map<String, dynamic>?> _updateToDo(Map<String, dynamic> body, dynamic toDoId) async => await _apiRepository.updateToDo(body: body, toDoId: toDoId);
  Future<Map<String, dynamic>?> _addToDo(Map<String, dynamic> body) async => await _apiRepository.addToDo(body: body);

  bool get isMandatory => ((_editToDoModel?['mandatory'] ?? 0) == 0);

  void _onInitialEvent(MaintenanceCheckInitialEvent event, Emitter<MaintenanceCheckState> emit) async {
    try {
      _editToDoModel = event.todoItem;
      emit(MaintenanceCheckLoadingState());
      var response = await Future.wait([
        _fetchMaintenanceCheckList(),
        _fetchToDo()
      ]);
      maintenanceCheckList = List.from(response[0] ?? []);
      _todos = List.from(response[1] ?? []);
      _processData();
      emit(MaintenanceCheckCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(MaintenanceCheckErrorState(e));
    }
  }

  List<String> _getLabels(List<dynamic> ids) {
    List<String> labels = [];
    for (var element in maintenanceCheckList) {
      if (ids.contains(element['id'])) {
        labels.add(element['name']);
        for (var child in element['children']) {
          if (ids.contains(child['id'])) {
            labels.add(child['name']);
            if (List.from(child['children']).isEmpty) {
              labels.add("");
            } else {
              for (var subChild in child['children']) {
                if (ids.contains(subChild['id'])) {
                  labels.add(subChild['name'] ?? "");
                }
              }
            }
          }
        }
      }
    }
    return labels;
  }

  void _processData() {
    try {
      var fixTasks = (_editToDoModel?['fix_tasks'].toString().isNullOrEmpty ?? false) ? null :  jsonDecode(_editToDoModel?['fix_tasks'] ?? "");
      Console.of.log("${fixTasks is String}", name: "FIX_TASKS");
      Map<dynamic, dynamic> fixTaskId = (fixTasks != null) ? ((fixTasks is String) ? Map.from(jsonDecode(fixTasks)) : fixTasks) : {};
      Console.of.log("$fixTaskId", name: "FIX_TASKS");
      // BASIC CHECK ALL THE FIELDS INSIDE CHILDREN
      for (var element in maintenanceCheckList) {
        for (var child in element['children']) {
          var taskId = fixTaskId[child['id'].toString()];
          child['fix_task_id'] = taskId;
          if (child['parent_id'] != 5) {
            child['children'].add({
              "id": 99,
              "name": "Other",
              "order": 4194,
              "description": null,
              "deleted_at": null,
              "created_at": null,
              "updated_at": null,
              "children": []
            });
          }
          child['children'] = List.from(child['children']).distinct((element) => element['id']);
          child['selectedValue'] = _findSelectedValue(taskId: taskId, children: List.from(child['children']));
          child['fix_task'] = _findToDo(taskId: taskId);
          child['checked'] = (child['selectedValue']?['name'].toString().toLowerCase() == "good") || (taskId.toString().isNullOrEmpty);
          child['comments'] = TextEditingController(text: _fetchComments(taskId: taskId));
        }
      }
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }

  Map<String, dynamic>? _findSelectedValue({dynamic taskId, List<Map<String, dynamic>>? children}) {
    var maintenanceTaskId = _todos.where((element) => element['status'].toString() == "In Progress").firstWhereOrNull((element) => element['id'] == taskId)?['maintenance_task_id'];
    var lastTaskId = maintenanceTaskId.toString().trim().split("-").lastOrNull;
    if ((maintenanceTaskId == null) || (lastTaskId.isNullOrEmpty)) return children?.firstWhereOrNull((element) => element['name'].toString().toLowerCase() == "good");
    var result = children?.firstWhereOrNull((element) => element['id'].toString().toNumeric == lastTaskId.toNumeric);
    Console.of.log("$lastTaskId $result ${children?.map((e) => e['id'])}", name: "LAST_TASK_ID");
    return result;
  }

  String _fetchComments({dynamic taskId}) => _todos.where((element) => element['status'].toString() == "In Progress").firstWhereOrNull((element) => element['id'] == taskId)?['comments'] ?? "";

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

  void _onAllCheckEvent(MaintenanceCheckAllCheckEvent event, Emitter<MaintenanceCheckState> emit) async {
    try {
      emit(MaintenanceCheckLoadingState());
      var body = { "mandatory" : (event.value ?? false) ? 1 : 0, "type" : "inline" };
      var response = await _updateToDo(body, _editToDoModel?['id']);
      if (response != null) emit(MaintenanceCheckCompleteState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(MaintenanceCheckErrorState(e));
    }
  }

  void _onItemCheckEvent(MaintenanceCheckItemCheckEvent event, Emitter<MaintenanceCheckState> emit) {
    event.model['checked'] = event.value;
    if (event.value) {
      event.model['selectedValue'] = List.from(event.model['children']).firstWhereOrNull((element) => element['name'].toString().toLowerCase() == "good");
    } else {
      event.model['selectedValue'] = null;
    }
    Console.of.log("${event.model['name']}");
    emit(MaintenanceCheckCommonState());
  }

  void _onChangeStatusEvent(MaintenanceChangeStatusEvent event, Emitter<MaintenanceCheckState> emit) {
    if ((event.model['fix_task'] != null) && (event.value['id'] != 99)) {
      emit(MaintenanceTaskExistDialogState(event.model));
      return;
    }
    event.model['selectedValue'] = event.value;
    event.model['checked'] = (event.value['name'].toString().toLowerCase() == "good");
    emit(MaintenanceCheckCommonState());
  }

  void _onCreateTaskEvent(MaintenanceCreateTaskEvent event, Emitter<MaintenanceCheckState> emit) async {
    try {
      emit(MaintenanceCheckLoadingState());
      var maintenanceTaskIds = [event.model?['parent_id'], event.model?['id'], (event.model?['selectedValue']?['id'] ?? 0)];
      var labels = _getLabels(maintenanceTaskIds);
      var comments = (event.model?['comments'] as TextEditingController).text;
      var taskId = (event.model?['fix_task']?['id'] ?? 0);
      var identifierId = (event.model?['id'] == 64) ? 126 : null;
      var title = (event.model?['id'] == 64) ? "Oil Change" : "Fix";
      Map<String, String> body = {
        "comments" : comments,
        "maintenance_task_id": maintenanceTaskIds.join(" - "),
        "notes" : labels.join(" - "),
      };
      if (taskId == 0) {
        // INSERT
        body['address'] = "${_editToDoModel?['address'] ?? ""}";
        body['branch_id'] = "${_editToDoModel?['branch_id'] ?? ""}";
        body['cohort_id'] = "${_editToDoModel?['cohort_id'] ?? ""}";
        body['identifier_id'] = "${identifierId ?? ""}";
        body['location'] = "${_editToDoModel?['location'] ?? ""}";
        body['location_id'] = "${_editToDoModel?['location_id'] ?? ""}";
        body['start_at'] = DateTime.now().toFormat() ?? "";
        body['time_sensitive'] = "${_editToDoModel?['time_sensitive'] ?? ""}";
        body['title'] = title;
        body['todo_time'] = DateTime.now().toFormat(format: "HH:mm:ss") ?? "";
        body['todo_user_type'] = "${_editToDoModel?['todo_user_type'] ?? ""}";
        body['user_group_id'] = "${_editToDoModel?['user_group_id'] ?? ""}";
        body['user_id'] = "$_userId";
        body['vehicle_name'] = List.from(_editToDoModel?['vehicles'] ?? []).firstOrNull?['vehicle_name'] ?? "";
        body['vehicles'] = "${_editToDoModel?['vehicles'] ?? ""}";
        body['vendor_id'] = _editToDoModel?['vendor_id'] ?? "";
        body['vendor_name'] = "${_editToDoModel?['vendor_name'] ?? ""}";
        body['vin'] = "${_editToDoModel?['vin'] ?? ""}";
      }
      var response = await ((taskId > 0) ? _updateToDo(body, taskId) : _addToDo(body));
      if (response != null) {
        if (taskId == 0) await _updateBody(responseId: List.from(response['todo']).firstOrNull?['id'], modelId: event.model['id']);
        Console.of.log("$response", name: "RESPONSE");
        FBroadcast.instance().broadcast("todo_view");
        emit(MaintenanceCheckCompleteState());
      } else {
        emit(MaintenanceCheckCommonState());
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(MaintenanceCheckErrorState(e));
    }
  }

  Future<void> _updateBody({dynamic responseId, dynamic modelId}) async {
    try {
      var oldIds = maintenanceCheckList
          .map((e) => List.from(e['children']))
          .expand((element) => element)
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

  void _onDeleteTaskEvent(MaintenanceDeleteTaskEvent event, Emitter<MaintenanceCheckState> emit) async {
    if (event.reason.isNullOrEmpty) {
      emit(MaintenanceTaskDeleteDialogState(event.model));
      return;
    }
    try {
      emit(MaintenanceCheckLoadingState());
      var taskId = event.model?['fix_task_id'];
      await _apiRepository.deleteToDo(taskId, event.reason);
      FBroadcast.instance().broadcast("todo_view");
      emit(MaintenanceCheckCompleteState());
    } catch(e) {
      Console.of.error("Error", error: e);
      emit(MaintenanceCheckErrorState(e));
    }
  }

  void _onCompleteTaskEvent(MaintenanceCompleteTaskEvent event, Emitter<MaintenanceCheckState> emit) async {
    emit(MaintenanceCheckCompleteState());
    await Future.delayed(Durations.short1);
    FBroadcast.instance().broadcast("show_completed_popup", value: event.model['fix_task']);
  }

  void _onUpdateTaskEvent(MaintenanceUpdateTaskEvent event, Emitter<MaintenanceCheckState> emit) async {
    var taskId = event.model?['fix_task_id'];
    var fixTask = event.model?['fix_task'];
    var ids = [(event.model?['parent_id'] ?? 0), (event.model?['id'] ?? 0), (event.selectedModel?['id'] ?? 0)];
    var labels = _getLabels(ids);
    Map<String, String> body = {
      "maintenance_task_id": ids.join(" - "),
      "notes" : labels.join(" - "),
      "type": "inline"
    };
    var completeBody = {
      "complete_time_approved" : fixTask?['complete_time_approved'] ?? 0,
      "complete_time_taken" : fixTask?['complete_time_taken'] ?? "00:15",
      "status" : true
    };
    Console.of.log("$taskId $ids, $labels $body, $completeBody", name: "UPDATE_TASK_EVENT");
    await _updateToDo(body, taskId);
    await _apiRepository.completeTodo(todoId: taskId, body: completeBody);
    FBroadcast.instance().broadcast("todo_view");
    emit(MaintenanceCheckCompleteState());
  }
}