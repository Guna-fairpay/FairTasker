import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'archived_event.dart';
part 'archived_state.dart';

class ArchivedBloc extends Bloc<ArchivedEvent, ArchivedState>{

  APiRepository apiRepository = APiRepository();

  DateRange? selectedDateRange = DateRange(DateTime.now(), DateTime.now());
  bool isSelectAll = false;

  ArchivedBloc() : super(LoadingState()){
    on<InitEvent>(_onInitEvent);
    on<DateRangePickerEvent>(_onDateRangePickerEvent);
    on<SelectAllEvent>(_onSelectAllEvent);

  }

  Future<void> _onInitEvent(InitEvent event, Emitter<ArchivedState> emit) async{
    try{
      emit(LoadingState());
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }
  Future<void> _onDateRangePickerEvent(DateRangePickerEvent event, Emitter<ArchivedState> emit) async{
    try{
      emit(LoadingState());
      selectedDateRange = event.selectedDateRange;
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onSelectAllEvent(SelectAllEvent event, Emitter<ArchivedState> emit){
    isSelectAll = !isSelectAll;
    emit(CommonState());
  }

  void _onError(dynamic error, Emitter<ArchivedState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }

}