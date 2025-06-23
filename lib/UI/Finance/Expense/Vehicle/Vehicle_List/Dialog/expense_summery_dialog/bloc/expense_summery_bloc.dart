import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expense_summery_event.dart';
part 'expense_summery_state.dart';

class ExpenseSummeryBloc extends Bloc<ExpenseSummeryEvent, ExpenseSummeryState>{

  List<dynamic>? summeryData;
  double total = 0.0;

  ExpenseSummeryBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
  }
  void _onInitialEvent(InitialEvent event, Emitter<ExpenseSummeryState> emit){
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<ExpenseSummeryState> emit){
    Console.of.log(error);
    emit(ErrorState(error));
  }

}