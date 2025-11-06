import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_share_notes_event.dart';
part 'edit_share_notes_state.dart';

class EditShareNotesBloc extends Bloc<EditShareNotesEvent, EditShareNotesState>{
  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FBroadcast _broadcast = FBroadcast.instance();
  AutovalidateMode? autoValidateMode;
  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  List<Map<String, dynamic>> noteItems = [];
  Map<String, dynamic>? editModel;
  List<Map<String, dynamic>> initialNotesItems = [];
  List<dynamic> initialIdList = [];
  bool showRemove = false;
  int get _randomId => Random().nextInt(99999); // USING ONLY FOR NEW TASKS



  Future<Map<String, dynamic>?> getNotes({dynamic id}) async => await _apiRepository.getEditSharedNotes(id: id);
  Future<Map<String, dynamic>?> _updateProductsItem({dynamic id, dynamic body}) async => await _apiRepository.updateProductsItem(id: id, body: body);
  Future<Map<String, dynamic>?> _removeProductsItem({dynamic id,}) async => await _apiRepository.removeProductsItem(id: id,);
  Future<Map<String, dynamic>?> _updateSharedNotes({dynamic id, dynamic body}) async => await _apiRepository.updateSharedNotes(id: id, body: body);

  EditShareNotesBloc() : super(CommonState()){
    on<InitialEvent>(_onInitialEvent);
    on<DeleteDialogEvent>(_onDeleteDialogEvent);
    on<AddEvent>(_onAddEvent);
    on<SaveEvent>(_onSaveEvent);
    on<DatePickerEvent>(_onDatePickerEvent);
    on<CheckEvent>(_onCheckEvent);
    on<RemoveEvent>(_onRemoveEvent);
  }

  void _addEmptyNote() {
    noteItems.add({
      "id": _randomId,
      "products_id": 0,
      "end_date": DateTime.now(),
      "title": TextEditingController(),
      "description": TextEditingController(),
      "date": TextEditingController(text: selectedDate?.toFormat(format: "dd-MM-yyyy") ?? ''),
      "complete_status" : 0,
      "shared_users": null,
    });
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<EditShareNotesState> emit) async{
    try {
      emit(LoadingState());
      var response = await getNotes(id: event.data['id'] ?? 0);
      editModel = response?['data'] ?? {};
      noteItems = List<Map<String, dynamic>>.from(editModel?['products_items'] ?? [])
          .map((e) => e..['title'] = TextEditingController(text: e['title'] ?? '')
          ..['date'] = TextEditingController(text: e['end_date'] ?? '')
      ).toList();
      initialNotesItems = List<Map<String, dynamic>>.from(editModel?['products_items'] ?? []);
      initialIdList = List<Map<String, dynamic>>.from(editModel?['products_items'] ?? []).map((e) => e['id']).toList();
      titleController.text = editModel?['title'] ?? '';
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onDeleteDialogEvent(DeleteDialogEvent event, Emitter<EditShareNotesState> emit) async{
    try {
      var isThere = false;
      isThere = initialNotesItems.any((element) => element['id'] == event.model?['id']);
      if(isThere){
        Console.of.log('Entered');
        emit(DeleteDialogState(event.model));
      }else{
        noteItems.removeWhere((element) => element['id'] == event.model?['id']);
        emit(CommonState());
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onRemoveEvent(RemoveEvent event, Emitter<EditShareNotesState> emit) async{
    try{
      emit(LoadingState());
      var response = await _removeProductsItem(id: event.data['id']);
      if(response?['data'] != null){
        _broadcast.broadcast('shared_notes_update');
        noteItems.removeWhere((element) => element['id'] == event.data['id']);
        emit(SuccessState(response?['message']));
      }
      else{
        emit(CommonState());
      }
    }catch (e){
      _error(e, emit);
    }
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<EditShareNotesState> emit) async{
    try {
      _addEmptyNote();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onSaveEvent(SaveEvent event, Emitter<EditShareNotesState> emit) async{
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if(formKey.currentState?.validate() == false) return emit(CommonState());
    try {
      autoValidateMode = null;
      emit(LoadingState());
      var response = await _updateSharedNotes(id: editModel?['id'], body: editShareNotesBody());
      if(response?['data'] != null){
        _broadcast.broadcast('shared_notes_update');
        emit(SuccessState(response?['message']));
      }else{
        Console.of.error(response?['message']);
        emit(ErrorState(response?['message']));
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onDatePickerEvent(DatePickerEvent event, Emitter<EditShareNotesState> emit) async{
    try {
      selectedDate = event.date;
      var data = noteItems.map((e) {
        if (e['id'] == event.model?['id']) {
          e['date'] = TextEditingController(
            text: selectedDate?.toFormat(format: "dd-MM-yyyy") ?? '',);
          e['end_date'] = selectedDate?? '';
        }
        return e;
      }).toList();
      noteItems = List<Map<String, dynamic>>.from(data);
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onCheckEvent(CheckEvent event, Emitter<EditShareNotesState> emit) async{
    try{
      var isThere = false;
      isThere = initialNotesItems.any((element) => element['id'] == event.model?['id']);
      if(isThere){
        emit(LoadingState());
        var response = await _updateProductsItem(id: event.model?['id'], body: {"complete_status": event.completeStatus == true ? 1 : 0,});
        if(response?['status'] == true){
          noteItems.forEach((element) {
          if (element['id'] == event.model?['id']){
            element['complete_status'] = event.model?['complete_status'] == 1 ? 0 : 1;
          }},);
          _broadcast.broadcast('shared_notes_update');
        }
        emit(CommonState());
      } else{
        noteItems.forEach((element) {
          if (element['id'] == event.model?['id']){
            element['complete_status'] = event.model?['complete_status'] == 1 ? 0 : 1;
          }
        },);
        emit(CommonState());
      }
    } catch (e){
      _error(e, emit);
    }
  }

  Map<String, dynamic> editShareNotesBody() {
     Map<String, dynamic> baseBody = {};
     baseBody['branch_id'] = getIt<CommonService>().branchId;
     baseBody['title'] = titleController.text;
     baseBody['sub_products'] = noteItems.map((e) => {
       "complete_status": "${e['complete_status'] ?? ""}",
       "description": "",
       "end_date": DateTime.tryParse(e['end_date'].toString()).toFormat() ?? '',
       "id": initialIdList.contains(e['id']) ? e['id'] : "",
       "title": (e['title'] as TextEditingController).text,
       "todo_id": null
     }).toList();
     Console.of.log(initialIdList);
     Console.of.log(baseBody);
     return baseBody;
  }

  void _error(dynamic error, Emitter<EditShareNotesState> emit){
    emit(ErrorState(error));
    Console.of.error(error);
  }

}