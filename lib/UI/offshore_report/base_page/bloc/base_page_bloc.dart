part of '../ui/base_page_ui.dart';

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