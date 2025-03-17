import 'dart:async';

import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_bloc/tasker_vehicle_search_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_bloc/tasker_vehicle_search_states.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSBloc extends Bloc<TVSEvents, TVSStates> {
  List<Map<String, dynamic>> vehicleList = [];
  Map<String, dynamic>? selectedModel;
  int pageIndex = 0;
  final TextEditingController searchController = TextEditingController();
  TVSBloc() : super(TVSLoadingState()) {
    on<TVSInitialEvent>(_onInitialEvent);
    on<TVSSelectedEvent>(_onSelectedEvent);
    on<TVSSelectPageEvent>(_onSelectPageEvent);
  }


  void _onInitialEvent(TVSInitialEvent event, Emitter<TVSStates> emit) async {
    try {
      emit(TVSLoadingState());
      vehicleList = await getIt<CommonService>().getActiveVehicles();
      emit(TVSUpdatedState());
    } catch (e) {
      emit(TVSUpdatedState());
    }
  }

  void _onSelectedEvent(TVSSelectedEvent event, Emitter<TVSStates> emit) {
    selectedModel = event.model;
    pageIndex = 0;
    emit(TVSUpdatedState());
  }

  void _onSelectPageEvent(TVSSelectPageEvent event, Emitter<TVSStates> emit) {
    pageIndex = event.page;
    emit(TVSUpdatedState());
  }
}