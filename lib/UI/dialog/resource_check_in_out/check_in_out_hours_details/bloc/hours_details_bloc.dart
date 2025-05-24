import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hours_details_event.dart';
part 'hours_details_state.dart';

class HourDetailsBloc extends Bloc<HourDetailsEvent, HourDetailsState> {
  Map<String, dynamic>? model;
  DateRange? dateRange;
  final APiRepository _aPiRepository = APiRepository();
  List<Map<String, dynamic>>? _taskCounts = [];
  List<Map<String, dynamic>>? tasks = [];
  HourDetailsBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
  }

  Future<Map<String, dynamic>?> _getEmployeeTaskCount() async => await _aPiRepository.employeeTaskCount(userId: model?['user_id'], from: dateRange?.start, to: dateRange?.end);

  void _onInitialEvent(InitialEvent event, Emitter<HourDetailsState> emit) async {
    try {
      emit(LoadingState());
      model = event.model;
      dateRange = event.dateRange;
      var response = await _getEmployeeTaskCount();
      _taskCounts = List<Map<String, dynamic>>.from(response?['history'] ?? []);
      tasks = List<Map<String, dynamic>>.from(jsonDecode(jsonEncode(model?['list'] ?? "")));
      tasks = tasks?.map((e) => e..['task_count'] = (_taskCounts?.firstWhereOrNull((element) => element['todo_date'] == e['date'])?['task_count'])).toList();
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }
}