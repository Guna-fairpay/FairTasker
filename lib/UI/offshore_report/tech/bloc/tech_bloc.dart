import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'tech_event.dart';
part 'tech_state.dart';

class TechBloc extends Bloc<TechEvent, TechState> {

  final APiRepository _aPiRepository = APiRepository();

  TextEditingController searchController = TextEditingController();

  List<dynamic>? apiData;
  List<dynamic>? filteredData;
  List<dynamic> _filteredData = [];
  List<Map<String, dynamic>>? projectList;

  String? startDate;
  String? endDate;

  DateRange selectedDateRange = DateRange(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
    DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
  );

  int currentPage = 1;
  int itemsPerPage = 10;
  int totalCount = 0;

  TechBloc() : super(LoadingState()){
    on<TechInitialEvent>(_onTechInitialEvent);
    on<DateRangeSelectedEvent>(_onDateRangeSelectedEvent);
    on<SearchEvent>(_onSearchEvent);
    on<PaginationEvent>(_onPaginationEvent);
    on<ProjectFilterEvent>(_onProjectFilterEvent);
    on<ProjectBasedFilterEvent>(_onProjectBasedFilterEvent);
  }

  Future<Map<String, dynamic>?> _getTaskHistory() async => await _aPiRepository.getFairTechTaskHistory(startDate: selectedDateRange.start, endDate: selectedDateRange.end, page: currentPage, itemsPerPage: itemsPerPage);
  Future<List<Map<String, dynamic>>?> _getProjectList() async => await getIt<CommonService>().getTechProjects();

  Future<void> _onProjectBasedFilterEvent(ProjectBasedFilterEvent event, Emitter<TechState> emit) async {
    try {
      projectList = List.from(event.projects);
      var projectIds = projectList?.where((e) => e['checked'] == true).map((e) => e['id']).toList();
      _filteredData = (apiData ?? []).where((element) {
        final projectId = element['todo']?['project']?['id'];
        return (projectList ?? []).any((project) =>
        project['checked'] == true && project['id'] == projectId);
      }).toList();
      filteredData = _filteredData;
      _search();
      Console.of.log(projectIds);
      emit(CommonState());
    }catch (e){
      error(e, emit);
    }
  }

  Future<void> _onTechInitialEvent(TechInitialEvent event, Emitter<TechState> emit) async {
    try {
      emit(LoadingState());
      projectList = await _getProjectList();
      projectList?.forEach((e) => e['checked'] = true,);
      await fitchData();
      emit(CommonState());
    } catch (e) {
      error(e, emit);
    }
  }

  Future<void> _onDateRangeSelectedEvent(DateRangeSelectedEvent event, Emitter<TechState> emit) async {
    try {
      emit(LoadingState());
      selectedDateRange = event.selectedDateRange;
      startDate = selectedDateRange.start.toFormat(format: 'yyyy-MM-dd');
      endDate = selectedDateRange.end.toFormat(format: 'yyyy-MM-dd');
      await fitchData();
      emit(CommonState());
    } catch (e) {
      error(e, emit);
    }
  }

  Future<void> _onSearchEvent(SearchEvent event, Emitter<TechState> emit) async {
    try {
      _search();
      emit(CommonState());
    }catch(e){
      error(e, emit);
    }
  }

  void _onPaginationEvent(PaginationEvent event, Emitter<TechState> emit) async {
    try {
      emit(LoadingState());
      currentPage = event.page;
      await fitchData();
      emit(CommonState());
    } catch (e) {
      error(e, emit);
    }
  }

  Future<void> _onProjectFilterEvent(ProjectFilterEvent event, Emitter<TechState> emit) async {
    try {
      emit(ProjectFilterState(projectList));
    } catch (e) {
      error(e, emit);
    }
  }

  Future<void> fitchData () async {
    var response = await _getTaskHistory();
    apiData = response?['data']?['data']?['data'] ?? [];
    apiData?.forEach((e) => e['todo']?['project']?['checked'] = true,);
    _filteredData = (apiData ?? []).where((element) {
      final projectId = element['todo']?['project']?['id'];
      return (projectList ?? []).any((project) =>
      project['checked'] == true && project['id'] == projectId);
    }).toList();
    totalCount = response?['data']?['data']?['total'] ?? 0;
    filteredData = _filteredData;
    paginateList(data: _filteredData, currentPage: currentPage, itemsPerPage: itemsPerPage);
    _search();
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    if (query.trim().isNotNullOrEmpty) {
      filteredData = (_filteredData).where((element) {
        return [
          element['todo']?['title'],
          element['todo']?['project']?['name'],
          element['today_activity'],
          element['task_completed_today'],
          "${element['user']?['first_name']} ${element['user']?['last_name']}",
        ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    } else {
      filteredData = _filteredData;
    }
  }

  void error(dynamic e,Emitter<TechState> emit){
    Console.of.error(e);
    emit(ErrorState(e));
  }

}