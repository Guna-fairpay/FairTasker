import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'base_page_state.dart';
part 'base_page_event.dart';

class BasePageBloc extends Bloc<BasePageEvent, BasePageState> {

  dynamic selectedTabValue = 1;

  BasePageBloc() : super(BasePageCommentState()) {
    on<BasePageInitialEvent>(_onBasePageInitialEvent);
    on<BasePageTabEvent>(_onBasePageTabEvent);
  }

  void _onBasePageInitialEvent(BasePageInitialEvent event, Emitter<BasePageState> emit) {
    emit(BasePageCommentState());
  }

  void _onBasePageTabEvent(BasePageTabEvent event, Emitter<BasePageState> emit) {
    selectedTabValue = event.value;
    emit(BasePageCommentState());
  }

}