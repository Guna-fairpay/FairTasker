import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'subcategory_dialog_state.dart';
part 'subcategory_dialog_event.dart';

class SubcategoryDialogBloc extends Bloc<SubcategoryDialogEvent, SubcategoryDialogState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController subCategoryController = TextEditingController();

  List<dynamic> expenseTo =[];
  dynamic selectedExpenseTo;

  SubcategoryDialogBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<ExpenseToDropdownEvent>(_onExpenseToDropdownEvent);
    on<SaveSubcategoryEvent>(_onSaveSubcategoryEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<SubcategoryDialogState> emit){
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onExpenseToDropdownEvent(ExpenseToDropdownEvent event, Emitter<SubcategoryDialogState> emit){
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onSaveSubcategoryEvent(SaveSubcategoryEvent event, Emitter<SubcategoryDialogState> emit){
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(e, Emitter<SubcategoryDialogState> emit){
    Console.of.log(e);
    emit(ErrorState(e.toString()));
  }
}