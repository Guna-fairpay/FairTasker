import 'package:fairpytasker/UI/dialog/tasker_move_previous_dialog_bloc/tasker_move_previous_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_move_previous_dialog_bloc/tasker_move_previous_dialog_states.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TMPDBloc extends Bloc<TMPDEvents, TMPDStates> {
  Map<String, dynamic>? model;
  List<Map<String, dynamic>>? models;
  List<Map<String, dynamic>>? filteredModels;
  List<Map<String, dynamic>>? selectedModels;
  int selectedIndex = 0;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool hasByVehicle = false;
  bool? isAllSelected = false;
  TMPDBloc() : super(TMPDLoadingState()) {
    on<TMPDInitialEvent>(_onInitialEvent);
    on<TMPDSelectDateEvent>(_onSelectDateEvent);
    on<TMPDSelectTimeEvent>(_onSelectTimeEvent);
    on<TMPDSelectVehicleEvent>(_onSelectVehicleEvent);
    on<TMPDSelectDayEvent>(_onSelectDayEvent);
    on<TMPDSelectTaskEvent>(_onSelectTaskEvent);
    on<TMPDSelectAllTaskEvent>(_onSelectAllTaskEvent);
  }


  void _onInitialEvent(TMPDInitialEvent event, Emitter<TMPDStates> emit) {
    model = event.model;
    models = event.models;
    selectedModels = [(model ?? {})];
    hasByVehicle = (model?['display']?['vehicle_name'].toString().isNotNullOrEmpty ?? false);
    selectedIndex = (hasByVehicle) ? 0 : 1;
    selectedDate = (model?['todo_date'].toString().toDateTime() ?? DateTime.now()).add(const Duration(days: 1));
    selectedTime = model?['todo_time'].toString().toTimeOfDay(inputFormat: "HH:mm:ss") ?? TimeOfDay.now();
    _filterDatas();
    _checkAllSelected();
    emit(TMPDCommonState());
  }

  void _onSelectDateEvent(TMPDSelectDateEvent event, Emitter<TMPDStates> emit) {
    selectedDate = event.selected ?? DateTime.now();
    emit(TMPDCommonState());
  }

  void _onSelectTimeEvent(TMPDSelectTimeEvent event, Emitter<TMPDStates> emit) {
    selectedTime = event.selected ?? TimeOfDay.now();
    emit(TMPDCommonState());
  }

  void _onSelectVehicleEvent(TMPDSelectVehicleEvent event, Emitter<TMPDStates> emit) {
    selectedIndex = 0;
    _filterDatas();
    emit(TMPDCommonState());
  }

  void _onSelectDayEvent(TMPDSelectDayEvent event, Emitter<TMPDStates> emit) {
    selectedIndex = 1;
    _filterDatas();
    emit(TMPDCommonState());
  }

  void _onSelectTaskEvent(TMPDSelectTaskEvent event, Emitter<TMPDStates> emit) {
    if (event.selected ?? false) {
      selectedModels?.add(event.model ?? {});
    } else {
      selectedModels?.removeWhere((element) => element == event.model);
    }
    _checkAllSelected();
    emit(TMPDCommonState());
  }

  void _onSelectAllTaskEvent(TMPDSelectAllTaskEvent event, Emitter<TMPDStates> emit) {
    isAllSelected = event.selected ?? !(isAllSelected ?? false);
    selectedModels = (isAllSelected ?? false) ? filteredModels : [];
    emit(TMPDCommonState());
  }

  void _checkAllSelected() {
    if (filteredModels?.length == selectedModels?.length) {
      isAllSelected = true;
    } else {
      isAllSelected = (selectedModels?.isNotEmpty ?? false) ? null : false;
    }
  }

  void _filterDatas() {
    filteredModels = models;
    if (selectedIndex == 0) {
      filteredModels = models?.where((element) => List.from(element['display']?['vins']).isNotEmpty).where((element) => (model?['display']?['vins'].toSet().containsAll(element['display']?['vins']))).toList();
    }
  }
}