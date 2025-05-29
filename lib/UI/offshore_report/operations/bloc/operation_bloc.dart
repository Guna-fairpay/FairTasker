import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'operation_event.dart';
part 'operation_state.dart';

class OperationBloc extends Bloc<OperationEvent, OperationState>{

  APiRepository apiRepository = APiRepository();

  List<dynamic>? apiResponse;

  String? startDate;
  String? endDate;

  DateRange selectedDateRange = DateRange(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
    DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
  );

  OperationBloc() : super(LoadingState()){
    on<OperationInitialEvent>(_onOperationInitialEvent);
    on<DateRangeSelectedEvent>(_onDateRangeSelectedEvent);
  }

  Future<void> _onOperationInitialEvent(OperationInitialEvent event, Emitter<OperationState> emit) async {
    try {
      emit(LoadingState());
      if (event.startDate != null && event.endDate != null) {
        startDate = event.startDate;
        endDate = event.endDate;
      } else {
        DateTime now = DateTime.now();
        startDate = DateTime(now.year, now.month, 1)
            .toFormat(format: 'yyyy-MM-dd');
        endDate = DateTime(now.year, now.month + 1, 0).toFormat(format: 'yyyy-MM-dd');
      }
      fitchData(startDate, endDate);
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
      fitchData(startDate, endDate);
      emit(CommonState());
      } catch (e) {
      error(e, emit);
    }
  }

  void fitchData (String? startDate, String? endDate) async {
    var body = {'startDate': startDate, 'endDate': endDate};
    var response = await apiRepository.getFairTechSupportTask(body: body);
    apiResponse = response?['data'] ?? [];
  }

    void error(dynamic error,Emitter<OperationState> emit) {
      Toaster.showError(error);
      Console.of.error(error);
      emit(ErrorState(e));
    }
  }
