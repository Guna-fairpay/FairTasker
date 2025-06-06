import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'share_notes_edit_dialog_event.dart';
part 'share_notes_edit_dialog_state.dart';

class ShareNotesEditDialogBloc extends Bloc<ShareNotesEditDialogEvent, ShareNotesEditDialogState>{

  final APiRepository _apiRepository = APiRepository();
  TextEditingController editProductController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final FBroadcast _broadcast = FBroadcast.instance();
  DateTime? selectedDate;
  Map<String, dynamic>? model;
  String? title;
  bool isDelete = false;


  Future<Map<String, dynamic>?> _updateProductsItem({dynamic id, dynamic body}) async => await _apiRepository.updateProductsItem(id: id, body: body);
  Future<Map<String, dynamic>?> _removeProductsItem({dynamic id,}) async => await _apiRepository.removeProductsItem(id: id,);

  ShareNotesEditDialogBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<DateEvent>(_onDateEvent);
    on<DeleteDialogEvent>(_onDeleteDialogEvent);
  }

  Future<void> _onDeleteDialogEvent(DeleteDialogEvent event, Emitter<ShareNotesEditDialogState> emit) async {
    try {
      emit(DeleteDialogState(model));
      } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<ShareNotesEditDialogState> emit) async {
    try {
      Console.of.log(event.model);
      model = event.model ?? {};
      editProductController.text = model?['title'] ?? '';
      dateController.text = model?['end_date'] ?? '';
      selectedDate = model?['end_date'] != null ? DateTime.parse(model?['end_date']) : null;
      Console.of.log(event.list, name: 'LIST');
      title = event.list?.where((element) => element['id'] == model?['products_id']).first?['title'];
      isDelete = event.list?.where((element) => element['id'] == model?['products_id']).first?['products_items'].length != 1;
      Console.of.log(isDelete, name: 'isDelete');
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onSaveEvent(SaveEvent event, Emitter<ShareNotesEditDialogState> emit) async {
    try {
      emit(LoadingState());
      var body = {
        "type":  "Inline",
        "title": editProductController.text,
        "end_date": selectedDate.toFormat(format: 'yyyy-MM-dd'),
        "complete_status": model?['complete_status'],
      };
      var response = await _updateProductsItem(id: model?['id'], body: body);
      if(response?['status'] == true){
        _broadcast.broadcast('shared_notes_update');
        emit(SuccessState(response?['message'] ?? 'Updated Successfully'));
      } else{
        Console.of.error(response);
        emit(ErrorState(response?['message'] ?? "Something went wrong"));
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<ShareNotesEditDialogState> emit) async {
    try {
      emit(LoadingState());
      var response = await _removeProductsItem(id: model?['id']);
      if(response?['status'] == 200){
        _broadcast.broadcast('shared_notes_update');
        emit(SuccessState(response?['message']));
      } else{
        Console.of.error(response);
        emit(ErrorState(response?['message']));
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onDateEvent(DateEvent event, Emitter<ShareNotesEditDialogState> emit) async {
    try {
      selectedDate = event.date;
      dateController.text = selectedDate.toFormat(format: 'dd-MM-yyyy') ?? '';
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _error(dynamic error, Emitter<ShareNotesEditDialogState> emit){
    emit(ErrorState(error.toString()));
    Console.of.error(error);
  }


}