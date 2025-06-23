import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'operation_event.dart';
part 'operation_state.dart';

class OperationBloc extends Bloc<OperationEvent, OperationState>{

  APiRepository apiRepository = APiRepository();
  TextEditingController searchController = TextEditingController();
  List<dynamic>? apiResponse;
  List<dynamic>? filteredResponse;
  String? searchText;
  String? startDate;
  String? endDate;
  DateRange selectedDateRange = DateRange(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
    DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
  );

  OperationBloc() : super(LoadingState()){
    on<OperationInitialEvent>(_onOperationInitialEvent);
    on<DateRangeSelectedEvent>(_onDateRangeSelectedEvent);
    on<SearchEvent>(_onSearchEvent);
  }

  Future<void> _onOperationInitialEvent(OperationInitialEvent event, Emitter<OperationState> emit) async {
    try {
      emit(LoadingState());
      DateTime now = DateTime.now();
      startDate = DateTime(now.year, now.month, 1).toFormat(format: 'yyyy-MM-dd');
      endDate = DateTime(now.year, now.month + 1, 0).toFormat(format: 'yyyy-MM-dd');
      await fitchData(startDate, endDate);
      emit(CommonState());
    } catch (e) {
      error(e,emit);
    }
  }

  Future<void> _onDateRangeSelectedEvent(DateRangeSelectedEvent event, Emitter<OperationState> emit) async {
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

  Future<void> _onSearchEvent(SearchEvent event, Emitter<OperationState> emit) async {
    try {
      var query = searchController.text.toLowerCase();
      if (query.trim().isNotNullOrEmpty) {
        filteredResponse = (apiResponse ?? []).where((element) {
          return [
            element['title'],
            element['notes'],
            element['title'],
            "${element['users']?['first_name']} ${element['users']?['last_name']}",
          ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
        }).toList();
      } else {
        filteredResponse = apiResponse;
      }
      emit(CommonState());
    }catch(e){
      error(e, emit);
    }
  }

  Future<void> fitchData (String? startDate, String? endDate) async {
    var body = {'startDate': startDate, 'endDate': endDate};
    var response = await apiRepository.getFairTechSupportTask(body: body);
    apiResponse = response?['data'] ?? [];
    filteredResponse = response?['data'] ?? [];
  }

    void error(dynamic error,Emitter<OperationState> emit) {
      Console.of.error(error);
      emit(ErrorState(e));
    }
  }
