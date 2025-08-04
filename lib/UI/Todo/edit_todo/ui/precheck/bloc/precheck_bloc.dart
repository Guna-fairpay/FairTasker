import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'precheck_event.dart';
part 'precheck_state.dart';

class PrecheckBloc extends Bloc<PrecheckEvent, PrecheckState> {

  List<dynamic> precheckList = [];

  dynamic model;

  PrecheckBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<PrecheckState> emit) {
    try{
      model = event.payload;
      precheckList = model['precheckList'];
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<PrecheckState> emit) {
    Console.of.error(error);
    emit(ErrorState(error.toString()));
  }
}

