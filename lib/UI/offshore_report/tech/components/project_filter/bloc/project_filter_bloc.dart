import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'project_filter_event.dart';
part 'project_filter_state.dart';

class ProjectFilterBloc extends Bloc<ProjectFilterEvent, ProjectFilterState>{

  bool isAll = false;
  List<Map<String, dynamic>>? popupFilterData;
  List<Map<String, dynamic>>? popupData;
  TextEditingController searchController = TextEditingController();


  ProjectFilterBloc() : super(CommonState()) {
    on<InitialEvent>(_onInitialEvent);
    on<ProjectSearchEvent>(_onProjectSearchEvent);
    on<SelectAllEvent>(_onSelectAllEvent);
    on<SelectProjectEvent>(_onSelectProjectEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<ProjectFilterState> emit) async{
    try {
      popupData = event.model;
      popupFilterData = event.model;
      isAll = (popupFilterData ?? []).every((e) => e['checked'] == true);
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
    }

  Future<void> _onProjectSearchEvent(ProjectSearchEvent event, Emitter<ProjectFilterState> emit) async{
    try {
      var query = searchController.text.toLowerCase();
      if (query.trim().isNotNullOrEmpty) {
        popupFilterData = (popupData ?? []).where((element) {
          return [
            element['name'],
          ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
        }).toList();
      } else {
        popupFilterData = popupData;
      }
      emit(CommonState());
    } catch (e) {
      emit(CommonState());
      _error(e, emit);
    }
  }

  Future<void> _onSelectAllEvent(SelectAllEvent event, Emitter<ProjectFilterState> emit) async{
    try {
      popupFilterData = (popupFilterData ?? []).map((e) {
        e['checked'] = !isAll;
        return e;
      }).toList();
      isAll = !isAll;
      emit(OnChangeState(value: popupFilterData ?? []));
    } catch (e) {
      emit(CommonState());
      _error(e, emit);
    }
  }

    Future<void> _onSelectProjectEvent(SelectProjectEvent event, Emitter<ProjectFilterState> emit) async {
      try {
        var model = event.model;
        popupFilterData = (popupFilterData ?? []).map((e) {
          if (e['id'] == model['id']) {
            e['checked'] = !e['checked'];
          }
          return e;}).toList();
        isAll = (popupFilterData ?? []).every((e) => e['checked'] == true);
        emit(OnChangeState(value: popupFilterData ?? []));
      } catch (e) {
        emit(CommonState());
        _error(e, emit);
      }
    }

    void _error(dynamic error, Emitter<ProjectFilterState> emit ){
    Console.of.log(error.toString());
    emit(CommonState());
  }

}
