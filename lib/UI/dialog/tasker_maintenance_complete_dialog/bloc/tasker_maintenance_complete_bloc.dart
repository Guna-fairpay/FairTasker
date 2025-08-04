import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/tasker_maintenance_complete_dialog/bloc/tasker_maintenance_complete_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_maintenance_complete_dialog/bloc/tasker_maintenance_complete_state.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskerMaintenanceBloc extends Bloc<TaskerMaintenanceCompleteEvent, TaskerMaintenanceCompleteState> {
  Map<String, dynamic>? _model;
  List<Map<String, dynamic>>? _tasks;
  dynamic _parentId, _childId, _subChildId;
  Map<String, dynamic>? _selectedParent, _selectedChild, selectedTask, _fixTaskIds;
  final APiRepository _apiRepository = APiRepository();
  TaskerMaintenanceBloc() : super(TaskerMaintenanceLoadingState()) {
    on<TaskerMaintenanceInitialEvent>(_onInitialEvent);
    on<TaskerMaintenanceSelectEvent>(_onSelectEvent);
    on<TaskerMaintenanceUpdateEvent>(_onUpdateEvent);
  }

  Future<Map<String, dynamic>?> _updateToDo(Map<String, dynamic> model, dynamic toDoId) async => await _apiRepository.updateToDo(body: model, toDoId: toDoId);
  Future<Map<String, dynamic>?> _completeToDo({required Map<String, dynamic> body, required dynamic todoId}) async => await _apiRepository.completeTodo(todoId: todoId, body: body);

  List<Map<String, dynamic>> get tasks {
    var list = (List<Map<String, dynamic>>.from(_selectedChild?['children'] ?? []));
    if (list.isEmpty) return [];
    (_parentId != 5)
    ? (list..add({
      "id": 99,
      "name": "Other",
      "order": 4194,
      "description": null,
      "deleted_at": null,
      "created_at": null,
      "updated_at": null,
      "children": []
    })) : list;
    list = list.distinct((element) => element['id']);
    return list;
  }

  List<String> _getLabels(List<dynamic> ids) {
    List<String> labels = [];
    for (var element in (_tasks ?? [])) {
      if (ids.contains(element['id'])) {
        labels.add(element['name'].toString().removeNextLines);
        for (var child in element['children']) {
          if (ids.contains(child['id'])) {
            labels.add(child['name'].toString().removeNextLines);
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
    if (labels.length == 2) labels.add("Other");
    return labels;
  }

  Future<Map<String, dynamic>?> _onCompleteToDo(Map<String, dynamic>? model) async {
    Map<String, dynamic> body = {
      "complete_time_approved" : model?['complete_time_approved'],
      "complete_time_taken" : (model?['display']?['completed_time'] ?? model?['complete_time_taken']),
      "status" : true
    };
    return await _completeToDo(body : body, todoId: model?['id']);
  }

  bool get showButton => (selectedTask?['name'].toString().toLowerCase() != "good");

  Future<List<Map<String, dynamic>>> _getTasks() async => getIt<CommonService>().getMaintenanceCheckList();

  void _onInitialEvent(TaskerMaintenanceInitialEvent event, Emitter<TaskerMaintenanceCompleteState> emit) async {
    try {
      _model = event.model;
      emit(TaskerMaintenanceLoadingState());
      _tasks = await _getTasks();
      var existingTaskIds = _model?['maintenance_task_id'].toString().split(" - ");
      _parentId = int.tryParse("${existingTaskIds?[0]}");
      _childId = int.tryParse("${existingTaskIds?[1]}");
      _subChildId = int.tryParse("${existingTaskIds?[2]}");
      _selectedParent = _tasks?.firstWhereOrNull((element) => element['id'] == _parentId);
      _selectedChild = List.from(_selectedParent?['children']).firstWhereOrNull((element) => element['id'] == _childId);
      selectedTask = tasks.firstWhereOrNull((element) => element['id'] == _subChildId);
      var fixTasks = (_model?['fix_tasks'].toString().isNullOrEmpty ?? false) ? null :  jsonDecode(_model?['fix_tasks'] ?? "");
      _fixTaskIds = (fixTasks != null) ? ((fixTasks is String) ? Map.from(jsonDecode(fixTasks)) : fixTasks) : {};
      Console.of.log(_fixTaskIds);
      emit(TaskerMaintenanceCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(TaskerMaintenanceErrorState(e));
    }
  }

  void _onSelectEvent(TaskerMaintenanceSelectEvent event, Emitter<TaskerMaintenanceCompleteState> emit) async {
    try {
      selectedTask = event.model;
      if (selectedTask?['name'].toString().toLowerCase() == "good") {
        // API CALL AND UPDATE THE STATE
        emit(TaskerMaintenanceLoadingState());
        Map<String, dynamic> body = {
          "fix_tasks" : {
            (selectedTask?['id'].toString()) : _fixTaskIds?.values.firstOrNull
          },
        };
        var response = await _updateToDo(body, _fixTaskIds?.values.firstOrNull);
        if ((response != null) && (response['status'] == 200)) {
          TaskerHelper.instance.refresh();
          emit(TaskerMaintenanceCompletedState());
        }
        Console.of.log(body);
      }
      emit(TaskerMaintenanceCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(TaskerMaintenanceErrorState(e));
    }
  }

  void _onUpdateEvent(TaskerMaintenanceUpdateEvent event, Emitter<TaskerMaintenanceCompleteState> emit) async {
    var taskIds = [_parentId, _childId, selectedTask?['id']];
    emit(TaskerMaintenanceLoadingState());
    Map<String, dynamic> body = { "maintenance_task_id": taskIds.join(" - "), "notes" : _getLabels(taskIds).join(" - ") };
    var response = await _updateToDo(body, _model?['id']);
    await _onCompleteToDo(_model);
    if ((response != null) && (response['status'] == 200)) {
      TaskerHelper.instance.refresh();
      emit(TaskerMaintenanceCompletedState());
    }
    Console.of.log(body);
  }
}