import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_change_dialog_event.dart';
part 'category_change_dialog_state.dart';

class CategoryChangeDialogBloc extends Bloc<CategoryDialogEvent, CategoryDialogState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  List<dynamic> category =[];
  dynamic selectedCategory;
  List<dynamic> subCategories =[];
  dynamic selectedSubCategory;
  dynamic model;

  CategoryChangeDialogBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<CategoryDropdownEvent>(_onCategoryDropdownEvent);
    on<SubcategoryDropdownEvent>(_onSubcategoryDropdownEvent);
    on<NavigateSubcategoryEvent>(_onNavigateSubcategoryEvent);
    on<UpdateCategoryEvent>(_onUpdateCategoryEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<CategoryDialogState> emit){
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onCategoryDropdownEvent(CategoryDropdownEvent event, Emitter<CategoryDialogState> emit){
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onSubcategoryDropdownEvent(SubcategoryDropdownEvent event, Emitter<CategoryDialogState> emit){
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onNavigateSubcategoryEvent(NavigateSubcategoryEvent event, Emitter<CategoryDialogState> emit){
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onUpdateCategoryEvent(UpdateCategoryEvent event, Emitter<CategoryDialogState> emit){
    try {
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<CategoryDialogState> emit){
    Console.of.error(error.toString());
    emit(ErrorState(error.toString()));
  }


}