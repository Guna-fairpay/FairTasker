import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'priority_filter_event.dart';
part 'priority_filter_state.dart';

class PriorityFilterBloc extends Bloc<PriorityFilterEvent, PriorityFilterState> {

  bool isAll = true;
  List<dynamic> popupFilterData = [];

  PriorityFilterBloc() : super(CommonState()) {
    on<InitialEvent>(_onInitialEvent);
    on<SelectAllEvent>(_onSelectAllEvent);
    on<SelectedPriorityEvent>(_onSelectedPriorityEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<PriorityFilterState> emit) async {
    popupFilterData = event.model;
    emit(CommonState());
  }

  Future<void> _onSelectAllEvent(SelectAllEvent event, Emitter<PriorityFilterState> emit) async {
    popupFilterData = (popupFilterData).map((e) {
      e['checked'] = !isAll;
      return e;
    }).toList();
    isAll = !isAll;
    emit(OnChangeState(popupFilterData));
  }

  Future<void> _onSelectedPriorityEvent(SelectedPriorityEvent event, Emitter<PriorityFilterState> emit) async {
    popupFilterData = (popupFilterData).map((e) {
      if (e['id'] == event.priority['id']) {
        e['checked'] = !e['checked'];
      }
      return e;
      }).toList();
    isAll = (popupFilterData).every((e) => e['checked'] == true);
    emit(OnChangeState(popupFilterData));
  }
}