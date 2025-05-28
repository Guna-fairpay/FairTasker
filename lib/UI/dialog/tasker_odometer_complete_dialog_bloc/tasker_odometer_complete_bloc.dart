import 'dart:async';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/tasker_odometer_complete_dialog_bloc/tasker_odometer_complete_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_odometer_complete_dialog_bloc/tasker_odometer_complete_states.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TOCDBloc extends Bloc<TOCDEvents, TOCDStates> {
  Map<String, dynamic>? _model;
  Map<String, dynamic>? previousOdometerResponse;
  Map<String, dynamic>? toDoOdometerResponse;
  final TextEditingController nextMilesCheckController = TextEditingController(text: 5000.toString());
  final TextEditingController oilChangeController = TextEditingController();
  final TextEditingController nextOdometerController = TextEditingController(text: 5000.toString());
  final APiRepository _aPiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey();
  TOCDBloc() : super(TOCDLoadingState()) {
    nextMilesCheckController.addListener(_autoCalculateValues);
    oilChangeController.addListener(_autoCalculateValues);
   on<TOCDInitialEvents>(_onInitialEvents);
   on<TOCDSubmitEvent>(_onSubmitEvent);
  }

  /// API CALLS : BEGIN HERE
  Future<Map<String, dynamic>?> _getPreviousOdometer({required String date, required String vin, required dynamic identifierId}) async => await _aPiRepository.getPreviousOdometer(date: date, vin: vin, identifierId: identifierId);
  Future<Map<String, dynamic>?> _getToDoOdometer({required dynamic todoId}) async => await _aPiRepository.getTodoOdometer(toDoId: todoId);
  /// API CALLS : ENDS HERE

  void _onInitialEvents(TOCDInitialEvents event, Emitter<TOCDStates> emit) async {
    try {
      _model = event.model;
      emit(TOCDLoadingState());
      var hasVins = List.from(_model?['display']?['vins']).firstOrNull.toString().isNotNullOrEmpty ?? false;
      previousOdometerResponse = hasVins ? await _getPreviousOdometer(date: _model?['todo_date'], vin: List.from(_model?['display']?['vins']).firstOrNull, identifierId: _model?['identifier_id']) : null;
      toDoOdometerResponse = await _getToDoOdometer(todoId: _model?['id']);
      if (toDoOdometerResponse?['data'] != null) {
        oilChangeController.text = "${toDoOdometerResponse?['data']['current_odometer']}";
        nextMilesCheckController.text = "${toDoOdometerResponse?['data']['next_miles_check']}";
        nextOdometerController.text = "${toDoOdometerResponse?['data']['next_odometer']}";
      }
      emit(TOCDCommonState());
    } catch (e) {
      emit(TOCDErrorState(e.toString()));
    }
  }

  void _autoCalculateValues() {
    var nextMiles = num.tryParse(nextMilesCheckController.text);
    var oilChange = num.tryParse(oilChangeController.text);
    nextOdometerController.text = ((nextMiles ?? 0) + (oilChange ?? 0)).toString();
  }

  void _onSubmitEvent(TOCDSubmitEvent event, Emitter<TOCDStates> emit) {
    if (formKey.currentState?.validate() == false) return;
    var currentOdometer = num.tryParse(oilChangeController.text);
    var nextMileCheck = num.tryParse(nextMilesCheckController.text);
    var nextOdometer = num.tryParse(nextOdometerController.text);
    if (event.isOverride) {
      return emit(TOCDCompleteState(currentOdometer, nextMileCheck, nextOdometer));
    } else {
      if ((currentOdometer ?? 0) < (previousOdometerResponse?['data'] ?? 0)) return emit(TOCDOdometerWarningState());
      return emit(TOCDCompleteState(currentOdometer, nextMileCheck, nextOdometer));
    }
  }
}