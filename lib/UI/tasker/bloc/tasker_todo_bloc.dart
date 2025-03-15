import 'dart:async';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_events.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_states.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/core/app/helper/tasker_todo_data_processor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoTaskerBloc extends Bloc<ToDoTaskerEvent, ToDoTaskerState> {
  bool isFilterSelected = false;
  bool isUserSelected = false;
  bool isCompleted = false;
  DateTime selectedDate = DateTime.now();
  final APiRepository _aPiRepository = APiRepository();

  String? get _userId => Session.of.getString(Str.userIdPrefText);
  List<Map<String, dynamic>> toDos = [];
  final ToDoProcessor _toDoProcessor = ToDoProcessor();

  ToDoTaskerBloc() : super(ToDoTaskerLoadingState()) {
    on<ToDoTaskerInitialEvent>(_onInitialEvent);
    on<ToDoTaskerPreviousDateEvent>(_onPreviousDateEvent);
    on<ToDoTaskerNextDateEvent>(_onNextDateEvent);
    on<ToDoTaskerTapDateEvent>(_onTapDateEvent);
    on<ToDoTaskerDateFilterEvent>(_onDateFilterEvent);
    on<ToDoTaskerShowCompleteEvent>(_onShowCompleteEvent);
  }

  /* BEGIN: API CALLS */
  Future<List<Map<String, dynamic>>?> _fetchToDoList({String? resourceId}) async => await _toDoProcessor.getToDoList(selectedDate, isCompleted, resourceId: resourceId);
  /* END: API CALLS */

  // INITIAL EVENT PROCESSOR
  /// FETCH TO-DO LISTING API
  void _onInitialEvent(
      ToDoTaskerInitialEvent event, Emitter<ToDoTaskerState> emit) async {
    await CommonHelper.instance.waitForPostFrameCallback();
    try {
      toDos.clear();
      emit(ToDoTaskerLoadingState());
      await _toDoProcessor.initialize();
      var response = await _fetchToDoList();
      toDos = response ?? [];
      emit(ToDoTaskerLoadedState());
    } catch (e) {
      Console.of.error(e);
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onPreviousDateEvent(
      ToDoTaskerPreviousDateEvent event, Emitter<ToDoTaskerState> emit) async {
    selectedDate = selectedDate.subtract(const Duration(days: 1));
    _reFetchToDos();
  }

  void _onNextDateEvent(
      ToDoTaskerNextDateEvent event, Emitter<ToDoTaskerState> emit) async {
    selectedDate = selectedDate.add(const Duration(days: 1));
    _reFetchToDos();
  }

  void _onTapDateEvent(
      ToDoTaskerTapDateEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerDatePickerState());
  }

  void _onDateFilterEvent(
      ToDoTaskerDateFilterEvent event, Emitter<ToDoTaskerState> emit) async {
    selectedDate = event.selectedDate ?? DateTime.now();
    _reFetchToDos();
  }

  void _onShowCompleteEvent(
      ToDoTaskerShowCompleteEvent event, Emitter<ToDoTaskerState> emit) async {
    isCompleted = event.showCompleted;
    _reFetchToDos();
  }

  void _reFetchToDos() async {
    try {
      toDos.clear();
      emit(ToDoTaskerLoadingState());
      var response = await _fetchToDoList();
      toDos = response ?? [];
      emit(ToDoTaskerLoadedState());
    } catch (e) {
      Console.of.error(e);
      emit(ToDoTaskerErrorState(e));
    }
  }
}
