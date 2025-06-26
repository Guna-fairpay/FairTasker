import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'revenue_event.dart';
part 'revenue_state.dart';

class RevenueBloc extends Bloc<RevenueEvent, RevenueState> {
  APiRepository apiRepository = APiRepository();

  DateRange selectedDateRange = DateRange(DateTime(DateTime.now().year, DateTime.now().month - 1, 1), DateTime(DateTime.now().year, DateTime.now().month, 0));
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> _apiResponse = [];
  List<Map<String, dynamic>> filteredApiResponse = List.generate(10, (index) => <String, dynamic>{});
  List<Map<String, dynamic>> selectedCohorts = [...[getIt<CommonService>().cohortsList.firstOrNull ?? {}]];

  Future<Map<String, dynamic>?> _getRevenueData({dynamic body}) async => await apiRepository.getRevenueSummary(body: body);

  RevenueBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
    on<SearchEvent>(_onSearchEvent);
    on<CohortEvent>(_onCohortEvent);
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
    Map<String, dynamic> params = {
      'startDate' : selectedDateRange.start.toFormat(),
      'endDate' : selectedDateRange.end.toFormat(),
    };
    if (selectedCohorts.isNotEmpty) params['cohortId[]'] = selectedCohorts.map((e) => e['id']).toList();
    if (selectedCohorts.isEmpty) params['cohortId[]'] = getIt<CommonService>().cohortsList.firstOrNull?['id'];
    var response = await _getRevenueData(body: params);
    if(response != null){
      _apiResponse = List.from(response['data']?['vehicles'] ?? []);
      filteredApiResponse = _apiResponse;
    }
  }

  void _onError(dynamic error , Emitter<RevenueState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }

  void _onSearchEvent(SearchEvent event, Emitter<RevenueState> emit) {
    Console.of.debug('search event: ${event.query}');
    if (event.query.trim().isNullOrEmpty) {
      filteredApiResponse = _apiResponse;
    } else {
      var query = event.query.toLowerCase();
      filteredApiResponse = _apiResponse.where((item) =>
          item['vehicle_name'].toString().toLowerCase().contains(query) ||
          item['vehicle_id'].toString().toLowerCase().contains(query) ||
          item['vehicle_number'].toString().toLowerCase().contains(query) ||
          item['totalEarnings'].toString().toLowerCase().contains(query)
      ).toList();
    }
    emit(CommonState());
  }

  void _onCohortEvent(CohortEvent event, Emitter<RevenueState> emit) async {
    selectedCohorts = event.cohort;
    emit(LoadingState());
    await fetchData();
    add(SearchEvent(searchController.text));
  }
}
