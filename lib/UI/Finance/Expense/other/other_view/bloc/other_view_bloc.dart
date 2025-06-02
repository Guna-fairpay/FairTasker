import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
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

  Future<Map<String, dynamic>?> _getOtherExpense() async => await _apiRepository.getOtherExpense(body: body);

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
    var response = await _getOtherExpense();
    apiResponse = List.from(response?['data']);
    totalAmount = apiResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
  }

  Map<String, dynamic> get body => {
    "minDate": selectedDateRange.start.toFormat(),
    "maxDate": selectedDateRange.end.toFormat(),
    "platformCustom": "tasker-app"
  };



}