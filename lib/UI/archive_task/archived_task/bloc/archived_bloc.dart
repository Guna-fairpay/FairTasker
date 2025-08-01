import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'archived_event.dart';
part 'archived_state.dart';

class ArchivedBloc extends Bloc<ArchivedEvent, ArchivedState>{

  APiRepository apiRepository = APiRepository();

  TextEditingController searchController = TextEditingController();

  DateRange? selectedDateRange = DateRange(DateTime.now(), DateTime.now());

  bool isSelectAll = false;
  bool isTaskAll = false;

  List<dynamic> selectedIds = [];
  List<dynamic> archivedList = [];
  List<dynamic> filteredList = [];
  List<dynamic> _filteredList = [];
  List<dynamic> taskFilterList = [];
  List<dynamic> taskData = [];
  List<dynamic> taskNameList = [];

  Future<Map<String, dynamic>?> _archive({dynamic from, dynamic to}) async => await apiRepository.getArchive(from: from, to: to, archiveStatus: 1);
  Future<Map<String, dynamic>?> _updateArchive({dynamic body}) async => await apiRepository.updateArchive(body: body);
  Future<List<Map<String, dynamic>>> _getTaskData() async => await getIt<CommonService>().getTaskCategoryGroupList();

  ArchivedBloc() : super(LoadingState()){
    on<InitEvent>(_onInitEvent);
    on<DateRangePickerEvent>(_onDateRangePickerEvent);
    on<SelectAllEvent>(_onSelectAllEvent);
    on<ArchiveStatusEvent>(_onArchiveStatusEvent);
    on<UnArchiveEvent>(_onUnArchiveEvent);
    on<SearchEvent>(_onSearchEvent);
    on<TaskFilterEvent>(_onTaskFilterEvent);
  }

  Future<void> _onInitEvent(InitEvent event, Emitter<ArchivedState> emit) async{
    try{
      emit(LoadingState());
      await fetchData();
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }
  Future<void> _onDateRangePickerEvent(DateRangePickerEvent event, Emitter<ArchivedState> emit) async{
    try{
      emit(LoadingState());
      selectedDateRange = event.selectedDateRange;
      await fetchData();
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onSelectAllEvent(SelectAllEvent event, Emitter<ArchivedState> emit){
    isSelectAll = !isSelectAll;
    if(isSelectAll){
      selectedIds = filteredList.map((e) => e['id']).toList();
    }else{
      selectedIds = [];
    }
    Console.of.log(selectedIds);
    emit(CommonState());
  }

  void _onArchiveStatusEvent(ArchiveStatusEvent event, Emitter<ArchivedState> emit){
    try {
      var model = event.model;
      if(selectedIds.contains(model['id'])){
        selectedIds.remove(model['id']);
      }else{
        selectedIds.add(model['id']);
      }
      isSelectAll = filteredList.isNotEmpty && selectedIds.length == filteredList.length;
      Console.of.log(selectedIds);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onUnArchiveEvent(UnArchiveEvent event, Emitter<ArchivedState> emit) async {
    try{
      emit(LoadingState());
      var body = {
        'archive_status': 0,
        'todoList': selectedIds,
      };
      var response = await _updateArchive(body: body);
      if(response?['status'] == 200){
        await fetchData();
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onTaskFilterEvent(TaskFilterEvent event, Emitter<ArchivedState> emit){
    try{
      taskFilterList = List.from(event.data);
      _search();
      taskFilter();
      emit(CommonState());
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onSearchEvent(SearchEvent event, Emitter<ArchivedState> emit){
    try{
      _search();
      taskFilter();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<dynamic> filteredData = [];
    if (query.trim().isNotNullOrEmpty) {
      filteredData = archivedList.where((element) {
        return [
          element?['title'],
          getIt<CommonService>().findVehicle(vin: element?['vin'],vehicleLis: List.from(element?['vehicles'] ?? []),
            vehicleGroupId: element['vehicle_group_id'],),
          element?['notes'],
          getIt<CommonService>().findLeadName(leadId: element?['lead_id'], channelId: element?['channel_id'])
        ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    } else {
      filteredData = archivedList;
    }
    _filteredList = filteredData;
    filteredList = _filteredList;
  }

  void _onError(dynamic error, Emitter<ArchivedState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }

  Future<void> fetchData()async {
    var response = await _archive(from: selectedDateRange?.start.toFormat(), to: selectedDateRange?.end.toFormat());
    archivedList = response?['data'] ?? [];
    taskData = await _getTaskData();
    _filteredList = archivedList;
    filteredList = _filteredList;
    selectedIds = [];
    isSelectAll = false;
    _processedMap();
  }

  void _processedMap() {
    Map<String, dynamic> mapData = {};
    List<Map<String, dynamic>> listMapData = [];
    var addedTitles = <dynamic>{};
    var todosNames = archivedList.map((element) =>  (element['title']).toString().toLowerCase()).toSet().toList();
    for (var element in taskData) {
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
      var id = taskData.firstWhereOrNull((e) => e['name'] == key)?['id'] ?? -1;
      var tasks = archivedList.where((e) => value.contains(e['title'].toString().toLowerCase())).map((e) => e['title'].toString()).toList();
      var map = {
        "id" : id,
        "name" : key,
        "related_sub_names": tasks,
        "task_count" : tasks.length,
        "isChecked" : 0,
        "tasks" : value.map((e) => {
          "task_name" : archivedList.firstWhereOrNull((task) => task['title'].toString().toLowerCase() == e)?['title'],
          "count" : archivedList.where((task) => task['title'].toString().toLowerCase() == e).length,
          "isChecked" : 0,
        }).toList()
      };
      listMapData.add(map);
    }
    taskFilterList = listMapData;
  }

  void taskFilter(){
    isTaskAll = taskFilterList.any((e) => e['isChecked'] == 0) ? false : true;
    taskNameList = taskFilterList
        .expand((group) => List.from(group['tasks'] ?? []))
        .where((task) => task['isChecked'] == 1)
        .map((task) => task['task_name'].toString())
        .toList();
    if(taskNameList.isNotEmpty){
      filteredList = _filteredList.where((element)=> taskNameList.contains(element['title'])).toList();
    }else{
      filteredList = _filteredList;
    }
    selectedIds.removeWhere((element) => !filteredList.any((e) => e['id'] == element));
    isSelectAll = filteredList.isNotEmpty && selectedIds.length == filteredList.length;
  }

}