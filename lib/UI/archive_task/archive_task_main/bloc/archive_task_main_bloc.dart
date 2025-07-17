import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'archive_task_main_event.dart';
part 'archive_task_main_state.dart';

class ArchiveTaskMainBloc extends Bloc<ArchiveTaskMainEvent,ArchiveTaskMainState>{

  dynamic selectedTabValue = 1;

  ArchiveTaskMainBloc() : super(CommonState()){
    on<InitialEvent>(_onInitialEvent);
    on<TabEvent>(_onTabEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<ArchiveTaskMainState> emit) {
    emit(CommonState());
  }

  void _onTabEvent(TabEvent event, Emitter<ArchiveTaskMainState> emit) {
    selectedTabValue = event.value;
    emit(CommonState());
  }
}