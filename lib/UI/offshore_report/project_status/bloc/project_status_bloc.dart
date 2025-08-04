import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'project_status_events.dart';
part 'project_status_states.dart';

class ProjectStatusBloc extends Bloc<ProjectStatusEvents, ProjectStatusStates> {
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> _todos = [];
  List<Map<String, dynamic>> todosFiltered = [];
  int selectedSegment = 0;
  ProjectStatusBloc() : super(LoadingState()) {
   on<InitialEvent>(_onInitialEvent);
   on<MilestoneEvent>(_onMilestoneEvent);
   on<BackLogEvent>(_onBacklogEvent);
   on<RoadMapEvent>(_onRoadMapEvent);
   on<FilterEvent>(_onFilterEvent);
   on<SearchEvent>(_onSearchEvent);
  }

  Future<Map<String, dynamic>?> _getProjectStatus() async => await _aPiRepository.getProjectStatus();

  void _onInitialEvent(InitialEvent event, Emitter<ProjectStatusStates> emit) async {
    try {
      emit(LoadingState());
      var response = await _getProjectStatus();
      _todos = List<Map<String, dynamic>>.from(response?['data']?['todos'] ?? []).where((element) => ["Milestone", "Backlog", "Roadmap"].contains(element['title'])).toList();
      todosFiltered = _todos.where((element) => element['title'] == "Milestone").toList();
      emit(CommonState());
    } catch (e) {
      _error(e);
    }
  }

  void _error(e) {
    Console.of.error('Error', error: e);
    emit(ErrorState(e));
  }

  void _onMilestoneEvent(MilestoneEvent event, Emitter<ProjectStatusStates> emit) {
    selectedSegment = 0;
    todosFiltered = _todos.where((element) => element['title'] == "Milestone").toList();
    emit(CommonState());
  }

  void _onBacklogEvent(BackLogEvent event, Emitter<ProjectStatusStates> emit) {
    selectedSegment = 1;
    todosFiltered = _todos.where((element) => element['title'] == "Backlog").toList();
    emit(CommonState());
  }

  void _onRoadMapEvent(RoadMapEvent event, Emitter<ProjectStatusStates> emit) {
    selectedSegment = 2;
    todosFiltered = _todos.where((element) => element['title'] == "Roadmap").toList();
    emit(CommonState());
  }

  void _onFilterEvent(FilterEvent event, Emitter<ProjectStatusStates> emit) {
    var filtered = switch(selectedSegment) {
      0 => _todos.where((element) => element['title'] == "Milestone").toList(),
      1 => _todos.where((element) => element['title'] == "Backlog").toList(),
      2 => _todos.where((element) => element['title'] == "Roadmap").toList(),
      _ => _todos
    };
    todosFiltered = switch(event.filter.toLowerCase()) {
      "all" => filtered,
      _ => filtered.where((element) => element['priority'].toString() == event.filter.toLowerCase()).toList(),
    };
    emit(CommonState());
  }

  void _onSearchEvent(SearchEvent event, Emitter<ProjectStatusStates> emit) {
    todosFiltered = _todos.where((element) =>
        element['title'].toString().toLowerCase().contains(event.search.toLowerCase()) ||
            element['todo_date'].toString().toLowerCase().contains(event.search.toLowerCase()) ||
            element['comments'].toString().toLowerCase().contains(event.search.toLowerCase()) ||
            element['completed_at'].toString().toLowerCase().contains(event.search.toLowerCase()) ||
            (element['project']?['name'].toString().toLowerCase().contains(event.search.toLowerCase()) ?? false)
    ).toList();
    emit(CommonState());

  }
}