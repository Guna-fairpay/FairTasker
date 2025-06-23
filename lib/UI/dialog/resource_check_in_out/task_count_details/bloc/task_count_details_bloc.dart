import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;

part 'task_count_details_event.dart';
part 'task_count_details_state.dart';

class TaskCountDetailsBloc extends Bloc<TaskCountDetailsEvent, TaskCountDetailsState>{
  DateRange? _dateRange;
  Map<String, dynamic>? _model;
  List<Map<String, dynamic>>? list = [];
  final APiRepository _aPiRepository = APiRepository();

  TaskCountDetailsBloc() : super(LoadingState()) {
    on<InitialEvent>(_initialEvent);
    on<ViewNotesCommentsEvent>(_viewNotesCommentsEvent);
  }

  Future<List<Map<String, dynamic>>?> _getEditComments() async => List<Map<String, dynamic>>.from((await _aPiRepository.editComments(hrmId: _model?['id'], from: _dateRange?.start, to: _dateRange?.end))?['comments'] ?? []);


  void _initialEvent(InitialEvent event, Emitter<TaskCountDetailsState> emit) async {
    try {
      _model = event.model;
      _dateRange = event.dateRange;
      emit(LoadingState());
      list = List<Map<String, dynamic>>.from(_model?['list'] ?? []);
      if (list?.isNotEmpty ?? false) {
        var response = await _getEditComments();
        list = list?.map((e) {
          var data = response?.firstWhereOrNull((element) => element['date'] == e['date']);
          return e..['comments'] = (data?['comments'] ?? "")..['reason'] = (data?['reason'] ?? "");
        }).toList();
      }
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _viewNotesCommentsEvent(ViewNotesCommentsEvent event, Emitter<TaskCountDetailsState> emit) {
    try {
      emit(ViewNotesCommentsState(event.model));
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }
}