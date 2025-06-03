import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'other_view_event.dart';
part 'other_view_state.dart';

class OtherViewBloc extends Bloc<OtherViewEvent, OtherViewState>{

  final APiRepository _apiRepository = APiRepository();
  DateRange selectedDateRange = DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  dynamic totalAmount = 0.00;
  List<dynamic> apiResponse = [];
  List<dynamic>? otherAttachments;

  Future<Map<String, dynamic>?> _getOtherExpense({String? startDate, String? endDate}) async => await _apiRepository.getOtherExpense(startDate: startDate, endDate: endDate);

  OtherViewBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<OtherViewState> emit) async{
    try {
      emit(LoadingState());
      await fitchData();
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onDateRangeEvent(DateRangeEvent event, Emitter<OtherViewState> emit) async{
    try {
      emit(LoadingState());
      selectedDateRange = event.dateRange;
      await fitchData();
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<OtherViewState> emit){
    emit(ErrorState(error));
    Console.of.error(error);
  }

  Future<void> fitchData() async {
    var oneMonthResponse = await _getOtherExpense(
      startDate: '${DateTime.now().subtract(const Duration(days: 30)).toFormat()}',
      endDate: '${DateTime.now().toFormat()}');
    var response = await _getOtherExpense(
      startDate: selectedDateRange.start.toFormat(),
      endDate: selectedDateRange.end.toFormat(),
    );
    var filterResponse =
        calculateApprovedAmounts(List.from(response?['data'] ?? []), List.from(oneMonthResponse?['data'] ?? []));
    filterResponse.forEach((element) {
      element['attachments_paths'] = element['attachments'].map((e) => e['path'].toString().toStorageURL).toList();
    });
    Console.of.log(filterResponse);
    apiResponse = filterResponse;
    apiResponse.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
        .compareTo(DateTime.parse(a['created_at'] ?? '')));
    totalAmount = apiResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
  }

  List<Map<String, dynamic>> calculateApprovedAmounts(
      List<Map<String, dynamic>> apiResponse,
      List<Map<String, dynamic>> amountResponse) {
    return apiResponse.map((e) {
      var matchingAmounts = amountResponse
          .where((element) =>
      element['subcategory']?['id'] == e['subcategory']?['id'] &&
          element['approved'] == 1)
          .map((item) => num.tryParse(item['expense_amount'].toString()) ?? 0)
          .sum;
      e["approved_amount"] = matchingAmounts;
      return e;
    }).toList();
  }

  Map<String, dynamic> get body => {
    "minDate": selectedDateRange.start.toFormat(),
    "maxDate": selectedDateRange.end.toFormat(),
    "platformCustom": "tasker-app"
  };



}