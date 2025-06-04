import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'other_expense_details_event.dart';
part 'other_expense_details_state.dart';

class OtherExpenseDetailsBloc extends Bloc<OtherExpenseDetailsEvent, OtherExpenseDetailsState>{

  final APiRepository _apiRepository = APiRepository();

  OtherExpenseDetailsBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<PaginationEvent>(_onPaginationEvent);
    on<EditEvent>(_onEditEvent);

  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<OtherExpenseDetailsState> emit) async {
    try {
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onPaginationEvent(PaginationEvent event, Emitter<OtherExpenseDetailsState> emit) async {
    try {
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onEditEvent(EditEvent event, Emitter<OtherExpenseDetailsState> emit) async {
    try {
      emit(EditState(event.id));
    } catch (e) {
      _error(e, emit);
    }
  }

  void _error(dynamic error, Emitter<OtherExpenseDetailsState> emit){
    emit(ErrorState(error));
    Console.of.error(error);
  }

}