import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/config/todo_config.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'meeting_change_state.dart';

class MeetingChangeBloc extends Cubit<MeetingState> {
  Map<String, dynamic> selectedMeetingMode = ToDoConfig.defaultMeetingMode, _model = {};
  MeetingChangeBloc() : super(CommonState());
  bool get _isNewValue => (_model['meeting_mode'].toString().toLowerCase() != selectedMeetingMode['name'].toString().toLowerCase());
  void initialize({Map<String, dynamic>? model}) async {
    try {
      if (model != null) {
        _model = model;
        selectedMeetingMode = ToDoConfig.meetingMode.firstWhere((element) => element['name'].toString().toLowerCase() == _model['meeting_mode'].toString().toLowerCase());
      }
    } catch (e) {
      _error(e);
    }
  }

  void _error(dynamic e) {
    Console.of.error("Error", error: e, name: "MeetingChangeBloc");
    emit(ErrorState(e));
  }

  void onChanged(Map<String, dynamic>? model) {
    selectedMeetingMode = model ?? {};
    emit(CommonState());
  }

  void onSave() {
    var state = (_isNewValue) ? CompleteState(selectedMeetingMode) : CloseState();
    return emit(state);
  }
}