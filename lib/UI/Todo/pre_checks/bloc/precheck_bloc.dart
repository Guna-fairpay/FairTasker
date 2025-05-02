import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:flutter/material.dart' show TextEditingController;
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
  PreCheckBloc(): super(PreCheckLoadingState()) {
    on<PreCheckInitialEvent>(_onInitialEvent);
    on<PreCheckCheckEvent>(_onCheckEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchCheckList() async => await getIt<CommonService>().getCheckList();
  Future<List<Map<String, dynamic>>?> _fetchToDo() async => await _aPiRepository.todo();
  Future<Map<String, dynamic>?> _updateToDo(Map<String, dynamic> body, dynamic toDoId) async => await _aPiRepository.updateToDo(body: body, toDoId: toDoId);
  Future<Map<String, dynamic>?> _addToDo(Map<String, dynamic> body) async => await _aPiRepository.addToDo(body: body);

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

  void _onCheckEvent(PreCheckCheckEvent event, Emitter<PreCheckState> emit) {
    if ((event.model['fix_task'] != null) && (event.model['checked'] == false)) {
      emit(PreCheckPopupState(model: event.model));
      return;
    }
    event.model['checked'] = event.isChecked;
    Console.of.log("${event.model['name']}");
    emit(PreCheckCommonState());
  }
}