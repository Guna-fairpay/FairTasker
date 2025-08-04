import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';

part 'tasker_filter_tasks_dialog_events.dart';
part 'tasker_filter_tasks_dialog_states.dart';
class TFTDBloc extends Bloc<TFTDEvents, TFTDStates> {
  List<Map<String, dynamic>>? toDos;
  List<dynamic> selected = [];
  List<Map<String, dynamic>>? taskCategoryGroup;
  List<Map<String, dynamic>>? mainCategories;
  List<Map<String, dynamic>>? subCategories;

  List<Map<String, dynamic>> processedCategories = [];
  List<dynamic> allRelateds = [];

  bool isSelectedAll = false;
  bool isTimeSensitive = false;

  TFTDBloc() : super(TFTDLoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<SelectAllEvent>(_onAllSelectEvent);
    on<TFTDSingleSelectEvent>(_onSingleSelectEvent);
    on<TFTDMultiSelectEvent>(_onMultiSelectEvent);
    on<TimeSensitiveEvent>(_onTimeSensitiveEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchTaskCategoryGroup() async => await getIt<CommonService>().getTaskCategoryGroupList();
  List<Map<String, dynamic>> get _taskCategoryGroup => [...getIt<CommonService>().taskCategoryGroupList];

  void _onInitialEvent(InitialEvent event, Emitter<TFTDStates> emit) async {
    try {
      toDos = event.toDos;
      selected = event.selected ?? [];
      isTimeSensitive = event.isTimeSensitive;
      emit(TFTDLoadingState());
      await _fetchTaskCategoryGroup();
      taskCategoryGroup = _taskCategoryGroup;
      processedCategories = _processedMapMod();
      for (var element in processedCategories) {
        element['related_sub_names'].forEach((e)=> allRelateds.add(e));
      }
      _checkisAllChecked();
      emit(TFTDCommonState());
    } catch (e) {
      emit(TFTDErrorState(e.toString()));
    }
  }

  void _checkisAllChecked() {
    isSelectedAll = (selected.isEmpty) ? false : (selected.length == allRelateds.length);
  }

  Future<List<Map<String, dynamic>>> _processMap() async {
    Map<String, dynamic> value = {
      "todos" : (toDos ?? []).map((e) => jsonEncode(e)).toList(),
      "taskCategoryGroup" : (taskCategoryGroup ?? []).map((e) => jsonEncode(e)).toList(),
      "isTimeSensitive" : isTimeSensitive ? 1 : 0
    };
    return await compute(_processCallback, jsonEncode(value));
  }

  Future<List<Map<String, dynamic>>> _processCallback(dynamic value) async {
    Map<String, dynamic> input = jsonDecode(value);
    List<Map<String, dynamic>> todos = input['todos'];
    List<Map<String, dynamic>> taskCategoryGroup = input['taskCategoryGroup'];
    int isTimeSensitive = input['isTimeSensitive'];
    Map<String, dynamic> mapData = {};
    List<Map<String, dynamic>> listMapData = [];
    var addedTitles = <dynamic>{};
    var todosNames = todos.where((element) => [isTimeSensitive, 1].contains(element['time_sensitive'])).map((e) => e['title'].toString().toLowerCase()).toSet().toList();
    for (var element in taskCategoryGroup) {
      final parentName = element['name'].toString().toLowerCase();
      mapData[element['name']] = [];
      if (element['subcategories'] is List) {
        element['subcategories'].forEach((e) {
          final subName = e['name'].toString().toLowerCase();
          for (var lowercaseTile in todosNames) {
            if (lowercaseTile == subName && !addedTitles.contains(lowercaseTile)) {
              mapData[element['name']].add(lowercaseTile);
              addedTitles.add(lowercaseTile);
            }
          }
        });
      }
      for (var lowercaseTile in todosNames) {
        if (lowercaseTile == parentName && !addedTitles.contains(lowercaseTile)) {
          mapData[element['name']].add(lowercaseTile);
          addedTitles.add(lowercaseTile);
        }
      }
    }
    mapData.removeWhere((key, value) => (value as List).isEmpty);
    for (var element in todosNames) {
      if (!addedTitles.contains(element) && !(['check out', 'check in'].contains(element))) {
        if (!mapData.containsKey("Others")) mapData['Others'] = [];
        mapData['Others'].add(element);
      }
    }
    for (var element in mapData.entries) {
      var key = element.key;
      var value = List.from(element.value ?? []);
      var id = taskCategoryGroup.firstWhereOrNull((e) => e['name'] == key)?['id'] ?? -1;
      var tasks = todos.where((e) => value.contains(e['title'].toString().toLowerCase())).map((e) => e['title'].toString()).toList();
      var map = {
        "id" : id,
        "name" : key,
        "related_sub_names": tasks,
        "task_count" : tasks.length,
        "tasks" : value.map((e) => {
          "task_name" : toDos?.firstWhereOrNull((task) => task['title'].toString().toLowerCase() == e)?['title'],
          "count" : toDos?.where((task) => task['title'].toString().toLowerCase() == e).length ?? 0
        }).toList()
      };
      listMapData.add(map);
    }
    return listMapData;
  }

  List<Map<String, dynamic>> _processedMapMod() {
    Map<String, dynamic> mapData = {};
    List<Map<String, dynamic>> listMapData = [];
    var addedTitles = <dynamic>{};
    var todosNames = toDos?.where((element) => [(isTimeSensitive ? 1 : 0), 1].contains(element['time_sensitive'])).map((e) => e['title'].toString().toLowerCase()).toSet().toList();
    taskCategoryGroup?.forEach((element) {
      final parentName = element['name'].toString().toLowerCase();
      mapData[element['name']] = [];
      if (element['subcategories'] is List) {
        element['subcategories'].forEach((e) {
          final subName = e['name'].toString().toLowerCase();
          todosNames?.forEach((lowercaseTile){
            if (lowercaseTile == subName && !addedTitles.contains(lowercaseTile)) {
              mapData[element['name']].add(lowercaseTile);
              addedTitles.add(lowercaseTile);
            }
          });
          });
      }
      todosNames?.forEach((lowercaseTile){
        if (lowercaseTile == parentName && !addedTitles.contains(lowercaseTile)) {
          mapData[element['name']].add(lowercaseTile);
          addedTitles.add(lowercaseTile);
        }
      });
    });
    mapData.removeWhere((key, value) => (value as List).isEmpty);
    todosNames?.forEach((element) {
      if (!addedTitles.contains(element) && !(['check out', 'check in'].contains(element))) {
        if (!mapData.containsKey("Others")) mapData['Others'] = [];
        mapData['Others'].add(element);
      }
    });
    for (var element in mapData.entries) {
      var key = element.key;
      var value = List.from(element.value ?? []);
      var id = taskCategoryGroup?.firstWhereOrNull((e) => e['name'] == key)?['id'] ?? -1;
      var tasks = toDos?.where((e) => value.contains(e['title'].toString().toLowerCase())).map((e) => e['title'].toString()).toList() ?? [];
      var map = {
        "id" : id,
        "name" : key,
        "related_sub_names": tasks,
        "task_count" : tasks.length,
        "tasks" : value.map((e) => {
          "task_name" : toDos?.firstWhereOrNull((task) => task['title'].toString().toLowerCase() == e)?['title'],
          "count" : toDos?.where((task) => task['title'].toString().toLowerCase() == e).length ?? 0
        }).toList()
      };
      listMapData.add(map);
    }
    return listMapData;
  }

  void _onAllSelectEvent(SelectAllEvent event, Emitter<TFTDStates> emit) {
    if (selected.length == allRelateds.length) {
      selected.clear();
    } else {
      selected = List.from(allRelateds);
    }
    _checkisAllChecked();
    emit(TFTDTriggerSelectedState(selected));
  }

  void _onSingleSelectEvent(TFTDSingleSelectEvent event, Emitter<TFTDStates> emit) {
    if (selected.contains(event.name)) {
      selected.remove(event.name);
    } else {
      selected.add(event.name);
    }
    _checkisAllChecked();
    emit(TFTDTriggerSelectedState(selected));
  }

  void _onMultiSelectEvent(TFTDMultiSelectEvent event, Emitter<TFTDStates> emit) {
    if (event.names.every((element) => selected.contains(element))) {
      selected.removeWhere((element) => event.names.contains(element));
    } else {
      selected.removeWhere((element) => event.names.contains(element));
      selected.addAll(event.names);
    }
    _checkisAllChecked();
    emit(TFTDTriggerSelectedState(selected));
  }

  void _onTimeSensitiveEvent(TimeSensitiveEvent event, Emitter<TFTDStates> emit) async {
    isTimeSensitive = event.value ?? false;
    processedCategories = _processedMapMod();
    emit(TimeSensitiveState(isTimeSensitive));
  }
}