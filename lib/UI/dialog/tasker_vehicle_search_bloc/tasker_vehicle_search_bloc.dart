import 'dart:async';

import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_bloc/tasker_vehicle_search_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_bloc/tasker_vehicle_search_states.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSBloc extends Bloc<TVSEvents, TVSStates> {
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> filterVehicleList = [];
  Map<String, dynamic>? selectedModel;
  int pageIndex = 0;
  final TextEditingController searchController = TextEditingController();
  TVSBloc() : super(TVSLoadingState()) {
    on<TVSInitialEvent>(_onInitialEvent);
    on<TVSSelectedEvent>(_onSelectedEvent);
    on<TVSSelectPageEvent>(_onSelectPageEvent);
    on<SearchEvent>(_onSearchEvent);
  }


  void _onInitialEvent(TVSInitialEvent event, Emitter<TVSStates> emit) async {
    try {
      emit(TVSLoadingState());
      vehicleList = await getIt<CommonService>().getActiveVehicles();
      vehicleList = vehicleList.where((element) => element['branch_code'] == Session.of.getInt(Str.branchIdPrefText)).toList();
      filterVehicleList = vehicleList;
      emit(TVSUpdatedState());
    } catch (e) {
      emit(TVSUpdatedState());
    }
  }

  void _onSelectedEvent(TVSSelectedEvent event, Emitter<TVSStates> emit) async {
    if (selectedModel != null) selectedModel = null;
    await Future.delayed(Durations.short1);
    selectedModel = event.model;
    pageIndex = 0;
    emit(TVSUpdatedState());
  }

  void _onSelectPageEvent(TVSSelectPageEvent event, Emitter<TVSStates> emit) {
    pageIndex = event.page;
    emit(TVSUpdatedState());
  }

  void _onSearchEvent(SearchEvent event, Emitter<TVSStates> emit) {
    if (event.query.trim().isNotNullOrEmpty) {
      filterVehicleList = vehicleList.where((element) {
        return [
          element['vehicle_name'],
        ].any((value) => value?.toString().toLowerCase().contains(event.query) ?? false);
      }).toList();
    } else {
      filterVehicleList = vehicleList;
    }
    emit(TVSUpdatedState());
  }
}