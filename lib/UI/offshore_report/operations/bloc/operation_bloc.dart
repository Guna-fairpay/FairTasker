import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'operation_event.dart';
part 'operation_state.dart';

class OperationBloc extends Bloc<OperationEvent, OperationState>{
  OperationBloc() : super(OperationLoadingState()){
    on<OperationInitialEvent>(_onOperationInitialEvent);
  }

  Future<void> _onOperationInitialEvent(OperationInitialEvent event, Emitter<OperationState> emit) async {
    try {
      emit(OperationLoadingState());
      emit(OperationCommonState());
    } catch (e) {
      error(e.toString(),emit);
    }
  }

    void error(String error,Emitter<OperationState> emit) {
      Toaster.showError(error);
      Console.of.error(error);
      emit(OperationCommonState());
    }
  }
