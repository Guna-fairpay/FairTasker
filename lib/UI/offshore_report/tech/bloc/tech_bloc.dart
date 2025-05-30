import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'tech_event.dart';
part 'tech_state.dart';

class TechBloc extends Bloc<TechEvent, TechState> {

  final APiRepository _aPiRepository = APiRepository();

  TextEditingController searchController = TextEditingController();

  List<dynamic>? apiData;
  List<dynamic>? filteredData;

  String? startDate;
  String? endDate;

  DateRange selectedDateRange = DateRange(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
    DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
  );

  int currentPage = 1;
  int itemsPerPage = 10;

  TechBloc() : super(LoadingState()){
    on<TechInitialEvent>(_onTechInitialEvent);
    on<DateRangeSelectedEvent>(_onDateRangeSelectedEvent);
    on<SearchEvent>(_onSearchEvent);
  }

  Future<Map<String, dynamic>?> _getTaskHistory() async => await _aPiRepository.getFairTechTaskHistory(startDate: selectedDateRange.start, endDate: selectedDateRange.end, page: currentPage, itemsPerPage: itemsPerPage);

  Future<void> _onTechInitialEvent(TechInitialEvent event, Emitter<TechState> emit) async {
    try {
      emit(LoadingState());
      await fitchData(startDate, endDate);
      emit(CommonState());
    } catch (e) {
      error(e, emit);
    }
  }

  Future<void> _onDateRangeSelectedEvent(DateRangeSelectedEvent event, Emitter<TechState> emit) async {
    try {
      emit(LoadingState());
      selectedDateRange = event.selectedDateRange;
      startDate = selectedDateRange.start.toFormat(format: 'yyyy-MM-dd');
      endDate = selectedDateRange.end.toFormat(format: 'yyyy-MM-dd');
      await fitchData(startDate, endDate);

      emit(CommonState());
    } catch (e) {
      error(e, emit);
    }
  }

  Future<void> _onSearchEvent(SearchEvent event, Emitter<TechState> emit) async {
    try {
      var query = searchController.text.toLowerCase();
      if (query.trim().isNotNullOrEmpty) {
        filteredData = (apiData ?? []).where((element) {
          return [
            element['todo']?['title'],
            element['todo']?['project']?['name'],
            element['today_activity'],
            element['task_completed_today'],
            "${element['user']?['first_name']} ${element['user']?['last_name']}",
          ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
        }).toList();
      } else {
        filteredData = apiData;
      }
      emit(CommonState());
    }catch(e){
      error(e, emit);
    }
  }

  Future<void> fitchData (String? startDate, String? endDate) async {
    var response = await _getTaskHistory();
    apiData = response?['data']?['data']?['data'] ?? [];
    filteredData = response?['data']?['data']?['data'] ?? [];
  }

  void error(dynamic e,Emitter<TechState> emit){
    Console.of.error(e);
    emit(ErrorState(e));
  }

}