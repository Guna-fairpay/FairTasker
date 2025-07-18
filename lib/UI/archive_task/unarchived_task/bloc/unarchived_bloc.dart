import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'unarchived_event.dart';
part 'unarchived_state.dart';

class UnarchivedBloc extends Bloc<UnarchivedEvent, UnarchivedState>{

  APiRepository apiRepository = APiRepository();

  DateRange? selectedDateRange = DateRange(DateTime.now(), DateTime.now());
  bool isSelectAll = false;

  List<dynamic> selectedIds = [];
  List<dynamic> archivedList = [];

  Future<Map<String, dynamic>?> _archive({dynamic from, dynamic to}) async => await apiRepository.getArchive(from: from, to: to, archiveStatus: 0);
  Future<Map<String, dynamic>?> _updateArchive({dynamic body}) async => await apiRepository.updateArchive(body: body);

  UnarchivedBloc() : super(LoadingState()){
    on<InitEvent>(_onInitEvent);
    on<DateRangePickerEvent>(_onDateRangePickerEvent);
    on<SelectAllEvent>(_onSelectAllEvent);
    on<ArchiveStatusEvent>(_onArchiveStatusEvent);
    on<UnArchiveEvent>(_onUnArchiveEvent);
  }

  Future<void> _onInitEvent(InitEvent event, Emitter<UnarchivedState> emit) async{
    try{
      emit(LoadingState());
      await fetchData();
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }
  Future<void> _onDateRangePickerEvent(DateRangePickerEvent event, Emitter<UnarchivedState> emit) async{
    try{
      emit(LoadingState());
      selectedDateRange = event.selectedDateRange;
      await fetchData();
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onSelectAllEvent(SelectAllEvent event, Emitter<UnarchivedState> emit){
    isSelectAll = !isSelectAll;
    if(isSelectAll){
      archivedList.map((e) => e['isChecked'] = 1,).toList();
      selectedIds = archivedList.map((e) => e['id']).toList();
    }else{
      archivedList.map((e) => e['isChecked'] = 0,).toList();
      selectedIds = [];
    }
    emit(CommonState());
  }

  void _onArchiveStatusEvent(ArchiveStatusEvent event, Emitter<UnarchivedState> emit){
    try {
      var model = event.model;
      model['isChecked'] = model['isChecked'] == 1 ? 0 : 1;
      model['isChecked'] == 1 ? selectedIds.add(model['id']) : selectedIds.remove(model['id']);
      selectedIds.length == archivedList.length ? isSelectAll = true : isSelectAll = false;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onUnArchiveEvent(UnArchiveEvent event, Emitter<UnarchivedState> emit) async {
    try{
      emit(LoadingState());
      var body = {
        'archive_status': 1,
        'todoList': selectedIds,
      };
      var response = await _updateArchive(body: body);
      if(response?['status'] == 200){
        await fetchData();
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<UnarchivedState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }

  Future<void> fetchData()async {
    var response = await _archive(from: selectedDateRange?.start.toFormat(), to: selectedDateRange?.end.toFormat());
    archivedList = response?['data'] ?? [];
    archivedList.map((e) => e['isChecked'] = 0,).toList();
    selectedIds = [];
    isSelectAll = false;
  }


}