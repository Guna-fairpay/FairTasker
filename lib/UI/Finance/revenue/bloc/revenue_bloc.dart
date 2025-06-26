import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'revenue_event.dart';
part 'revenue_state.dart';

class RevenueBloc extends Bloc<RevenueEvent, RevenueState> {
  APiRepository apiRepository = APiRepository();

  DateRange selectedDateRange = DateRange(DateTime(DateTime.now().year, DateTime.now().month - 1, 1), DateTime(DateTime.now().year, DateTime.now().month, 0));
  TextEditingController searchController = TextEditingController();
  List<dynamic> apiResponse = [];
  List<dynamic> filteredApiResponse = [];
  List<dynamic> selectedCohorts = [];

  Future<Map<String, dynamic>?> _getRevenueData({dynamic body}) async => await apiRepository.getRevenueSummary(body: body);

  RevenueBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<RevenueState> emit) async {
    try{
      emit(LoadingState());
      await fetchData();
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onDateRangeEvent(DateRangeEvent event, Emitter<RevenueState> emit) async {
    try{
      emit(LoadingState());
      selectedDateRange = event.selectedDateRange;
      await fetchData();
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> fetchData() async {
    var response = await _getRevenueData(body: {
      'startDate' : selectedDateRange.start.toFormat(),
      'endDate' : selectedDateRange.end.toFormat(),
      'cohortId' : selectedCohorts,
    });
    if(response != null){
      apiResponse = List.from(response['data']?['vehicles'] ?? []);
      filteredApiResponse = apiResponse;
    }
  }

  void _onError(dynamic error , Emitter<RevenueState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }
}
