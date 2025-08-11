import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expense_tab_event.dart';
part 'expense_tab_state.dart';

class ExpenseTabBloc extends Bloc<ExpenseTabEvent, ExpenseTabState>{

  List<dynamic> tabs = [];

  int selectedTab = 1;

  ExpenseTabBloc() : super(CommonState()){
    on<InitialEvent>(_onInitialEvent);
    on<TabChangeEvent>(_onTabChangeEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<ExpenseTabState> emit){
    try {
      tabs = AddToDoConfig.expenseTaps;
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onTabChangeEvent(TabChangeEvent event, Emitter<ExpenseTabState> emit){
    try {
      selectedTab = event.tab?['id'];
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<ExpenseTabState> emit){
    Console.of.error(error.toString());
    emit(ErrorState(error));
  }


}