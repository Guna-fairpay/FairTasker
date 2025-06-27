import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
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
  List<Map<String, dynamic>> filteredApiResponse = List.generate(10, (index) => {
    "id": 9,
    "vehicle_id": 2019187,
    "vehicle_name": "2018 NISSAN ROGUE S SILVR",
    "vin": "5N1AT2MT4JC761637",
    "make": "NISSAN",
    "model": "ROGUE S SILVR",
    "year": "2018",
    "vehicle_number": "SZH 4207",
    "cohort_id": 1,
    "earnings": null,
    "utilization_rate": null,
    "vehicle_status": 3,
    "active": 1,
    "platform": null,
    "platform_from": null,
    "mileage": null,
    "wholesale_amount": null,
    "row_order": 2,
    "note": "Please ignore the last text, typed in error",
    "followup_date": "2025-04-28",
    "purchase_date": "2023-02-28",
    "purchase_price": 9300,
    "sold_date": null,
    "sold_price": null,
    "rental_status": 0,
    "title_registration": null,
    "vehicle_status_update": null,
    "is_vehicle": 1,
    "address": null,
    "bouncie": 1,
    "air_tag": 0,
    "permanent_plate": 1,
    "car_number": null,
    "oil_grade": null,
    "front_tire": null,
    "spare_tire": 1,
    "spare_key": 1,
    "registration_renewal_date": "2025-05-31",
    "rear_tire": null,
    "branch_code": 1,
    "toll_tags": 1,
    "toll_tags_id": "DFW. 04771056",
    "front_license_plate": 0,
    "tire_size": null,
    "insurance_agent": null,
    "insurance_cost": null,
    "current_odometer": null,
    "oil_change_odometer": null,
    "maintenance_check": null,
    "deleted_at": null,
    "created_at": "2023-02-28T15:02:04.000000Z",
    "updated_at": "2025-05-31T23:18:43.000000Z",
    "transaction_comments": null,
    "key_type": null,
    "dateRange": "2025-05-01 to 2025-05-31",
    "totalEarnings": 1288.79,
    "cumulativeCost": 19917.170001983643
  });

  List<Map<String, dynamic>> selectedCohorts = [...[getIt<CommonService>().cohortsList.firstOrNull ?? {}]];

  Future<Map<String, dynamic>?> _getRevenueData({dynamic body}) async => await apiRepository.getRevenueSummary(body: body);

  RevenueBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
    on<SearchEvent>(_onSearchEvent);
    on<CohortEvent>(_onCohortEvent);
  }

  num? get totalAmount => _apiResponse.map((e) => e['totalEarnings'].toString().toNumeric).sum;

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
