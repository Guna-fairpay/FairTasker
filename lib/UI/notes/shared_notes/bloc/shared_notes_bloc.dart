import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'shared_notes_event.dart';
part 'shared_notes_state.dart';

class SharedNotesBloc  extends Bloc<SharedNotesEvent, SharedNotesState> {

  final APiRepository apiRepository = APiRepository();

  DateTime selectedDate = DateTime.now();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>>? apiResponse = [], unfilteredResponse = [];

  Future<Map<String, dynamic>?> _getSharedNotes() async => await apiRepository.getSharedNotes(dateTimeString: "${selectedDate.toFormat()}");
  Future<Map<String, dynamic>?> _updateProductsStatus({Map<String, dynamic>? body, dynamic id}) async => await apiRepository.updateProductsStatus(id: id, body: body);
  Future<Map<String, dynamic>?> _updateSharedNotes({Map<String, dynamic>? body, dynamic id}) async => await apiRepository.updateSharedNotes(id: id, body: body);

  SharedNotesBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<DatePickerEvent>(_onDatePickerEvent);
    on<SearchEvent>(_onSearchEvent);
    on<MoveCompleteEvent>(_onMoveCompleteEvent);
    on<MoveTomorrowEvent>(_onMoveTomorrowEvent);
    getIt<CommonService>().branchUpdate(callback: () => add(InitialEvent()));
  }

  void _onInitialEvent(InitialEvent event, Emitter<SharedNotesState> emit) async{
    try {
      emit(LoadingState());
      await _fetchData();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onDatePickerEvent(DatePickerEvent event, Emitter<SharedNotesState> emit) async{
    try {
      if(event.date != null){
        emit(LoadingState());
        selectedDate = event.date ?? DateTime.now();
        await _fetchData();
        emit(CommonState());
      } else{
        emit(DatePickerState(selectedDate));
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onSearchEvent(SearchEvent event, Emitter<SharedNotesState> emit) async{
    try {
      emit(LoadingState());
      if (searchController.text.trim().isNotEmpty) {
        apiResponse = unfilteredResponse?.where((element) => element['title'].toString().toLowerCase().contains(searchController.text.toLowerCase())).toList();
      } else {
        apiResponse = unfilteredResponse;
      }
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onMoveCompleteEvent(MoveCompleteEvent event, Emitter<SharedNotesState> emit) async{
    try {
      emit(LoadingState());
      var body = {
        "all" : true,
        "complete_time_approved" : 1,
        "complete_time_taken" : "00:15",
        "status" : true
      };
      var response = await _updateProductsStatus(id: event.data['id'], body: body);
      if(response?['status'] == true){
        apiResponse?.removeWhere((element) => element['id'] == event.data['id']);
        await _fetchData();
        emit(SuccessState(response?['message'] ?? ""));
      } else{
        emit(ErrorState(response?['message'] ?? ""));
      }

    } catch (e) {
      _error(e, emit);
    }

  }

  void _onMoveTomorrowEvent(MoveTomorrowEvent event, Emitter<SharedNotesState> emit) async{
    try {
      emit(LoadingState());
      var body = {
        'date': selectedDate.add(const Duration(days: 1)).toFormat(),
        'title': event.data['title'],
        'type': "inline",
      };
      var response = await _updateSharedNotes(id: event.data['id'], body: body);
      if(response?['status'] == true){
        await _fetchData();
        emit(SuccessState(response?['message'] ?? ""));
      } else{
        emit(ErrorState(response?['message'] ?? ""));
      }
    } catch(e) {
      _error(e, emit);
    }
  }

  Future <void> _fetchData() async{
    var response = await _getSharedNotes();
    unfilteredResponse = List.from(response?['data'] ?? []);
    unfilteredResponse?.removeWhere((element) => ((element['branch_id']).toString()) != ((getIt<CommonService>().branchId).toString()));
    apiResponse = unfilteredResponse;
  }

  void _error(dynamic error, Emitter<SharedNotesState> emit) async{
    emit(ErrorState(error));
    Console.of.error(error);
  }

}