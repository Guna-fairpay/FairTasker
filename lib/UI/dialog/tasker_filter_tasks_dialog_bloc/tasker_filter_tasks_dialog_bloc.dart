import 'dart:async';
import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_tasks_dialog_bloc/tasker_filter_tasks_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_tasks_dialog_bloc/tasker_filter_tasks_dialog_states.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TFTDBloc extends Bloc<TFTDEvents, TFTDStates> {
  List<Map<String, dynamic>>? toDos;
  List<dynamic> selected = [];
  List<Map<String, dynamic>>? taskCategoryGroup;
  List<Map<String, dynamic>>? mainCategories;
  List<Map<String, dynamic>>? subCategories;

  List<Map<String, dynamic>> processedCategories = [];
  List<dynamic> allRelateds = [];

  bool isSelectedAll = false;
  TFTDBloc() : super(TFTDLoadingState()) {
    on<TFTDInitialEvent>(_onInitialEvent);
    on<TFTDAllSelectEvent>(_onAllSelectEvent);
    on<TFTDSingleSelectEvent>(_onSingleSelectEvent);
    on<TFTDMultiSelectEvent>(_onMultiSelectEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchTaskCategoryGroup() async => await getIt<CommonService>().getTaskCategoryGroupList();

  void _onInitialEvent(TFTDInitialEvent event, Emitter<TFTDStates> emit) async {
    try {
      toDos = event.toDos;
      selected = event.selected ?? [];
      emit(TFTDLoadingState());
      taskCategoryGroup = await _fetchTaskCategoryGroup();
      mainCategories = taskCategoryGroup?.where((element) => element['parent_id'].toString().isNullOrEmpty || element['subcategories'].toString().isNotNullOrEmpty).toList();
      subCategories = taskCategoryGroup?.where((element) => element['parent_id'].toString().isNotNullOrEmpty && (List.from(element['subcategories'] ?? []).isEmpty)).toList();
      subCategories = [
        ...(subCategories ?? []),
        ...(mainCategories?.where((element) => element['subsubcategories'].toString().isNotNullOrEmpty).map((e) => e['subsubcategories'] ?? []).toList() ?? [])
      ];
      processedCategories = _processedMap() ?? [];
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

  List<Map<String, dynamic>>? _processedMap() {
    var subNames = subCategories?.map((e) => e['name'].toString().toLowerCase()).toSet().toList();
    var todosNames = toDos?.map((e) => e['title'].toString().toLowerCase()).toSet().toList();
    var selectedGroups = subCategories?.where((element) => todosNames?.contains(element['name'].toString().toLowerCase()) ?? false).toList().unique((element) => element['name']);
    var subIds = selectedGroups?.map((e) => e['parent_id']).toSet().toList();
    var mainIds = mainCategories?.where((element) => subIds?.contains(element['id']) ?? false).map((e) => e['id']).toSet().toList();
    var mapData = mainIds?.map((e) => {
      "id" : e,
      "name" : mainCategories?.firstWhereOrNull((element) => element['id'] == e)?['name'],
      "related_sub_names" : subCategories?.where((element) => (element['parent_id'] == e) && (todosNames?.contains(element['name'].toString().toLowerCase()) ?? false)).map((e1) => e1['name']).toList(),
      "task_count" : toDos?.where((element) =>  (subCategories?.where((element) => (element['parent_id'] == e) && (todosNames?.contains(element['name'].toString().toLowerCase()) ?? false)).map((e1) => e1['name'].toString().toLowerCase()).toList())?.contains(element['title'].toString().toLowerCase()) ?? false).length,
      "tasks" : subCategories?.where((element) => (element['parent_id'] == e) && (todosNames?.contains(element['name'].toString().toLowerCase()) ?? false)).map((e1) => {
        "task_name" : e1['name'],
        "count" : toDos?.where((element) => element['title'].toString().toLowerCase() == e1['name'].toString().toLowerCase()).length
      }).toList()
    }).toList();
    var unfoundedTasks = todosNames?.where((element) => !(subNames?.contains(element) ?? false)).toList();
    var todoName = toDos?.where((element) => unfoundedTasks?.contains(element['title'].toString().toLowerCase()) ?? false).map((e) => e['title'] ?? "").toSet().toList();
    if ((todoName != null) && (todoName.isNotEmpty)) {
      mapData?.add({
        "id" : -1,
        "name" : "Others",
        "related_sub_names" : todoName,
        "task_count" : toDos?.where((element) => todoName.contains(element)).length,
        "tasks" : todoName.map((e) => {
          "task_name" : e,
          "count" : toDos?.where((element) => element['title'] == e).length
        }).toList()
      });
    }
    return mapData;
  }

  void _onAllSelectEvent(TFTDAllSelectEvent event, Emitter<TFTDStates> emit) {
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
}