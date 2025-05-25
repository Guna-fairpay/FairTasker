import 'dart:async';
import 'dart:convert';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:math';

part 'task_details_event.dart';
part 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  Map<String, dynamic>? _model;
  DateRange? dateRange;
  List<Map<String, dynamic>>? _taskCategoryGroup;
  List<Map<String, dynamic>>? tasks = [];
  final APiRepository _apiRepository = APiRepository();
  TaskDetailsBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<ViewFilterEvent>(_onViewFilterEvent);
  }

  Future<List<Map<String, dynamic>>?> _getTaskCategoryGroup() async => List<Map<String, dynamic>>.from((await _apiRepository.getTaskCategoryGroup())?['data'] ?? []);

  void _onInitialEvent(InitialEvent event, Emitter<TaskDetailsState> emit) async {
    try {
      _model = event.model;
      dateRange = event.dateRange;
      emit(LoadingState());
      _taskCategoryGroup = await _getTaskCategoryGroup();
      var mainCategories = _taskCategoryGroup?.where((element) => element['parent_id'].toString().isNullOrEmpty).toList();
      var subCategories = _taskCategoryGroup?.where((element) => !element['parent_id'].toString().isNullOrEmpty).toList();

      tasks = mainCategories;
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onViewFilterEvent(ViewFilterEvent event, Emitter<TaskDetailsState> emit) async {
    emit(ViewFilterState());
  }
}