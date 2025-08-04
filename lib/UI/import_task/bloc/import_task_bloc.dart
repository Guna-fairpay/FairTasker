import 'dart:async';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/import_task/bloc/import_task_events.dart';
import 'package:fairpytasker/UI/import_task/bloc/import_task_states.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/core/initializer/receive_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ImportTaskBloc extends Bloc<ImportTaskEvent, ImportTaskState> {
  final GlobalKey<FormState> textFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> turoFormKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final TextEditingController turoController = TextEditingController();
  final APiRepository _aPiRepository = APiRepository();
  int currentPageIndex = 0;
  ImportTaskBloc() : super(ImportTaskLoadingState()) {
    on<ImportTaskInitialEvent>(_onInitialEvent);
    on<ImportTaskPageEvent>(_onPageEvent);
    on<ImportTaskSaveEvent>(_onSaveEvent);
  }

  Future<Map<String, dynamic>?> _uploadTuro() async => await _aPiRepository.importTuroReservation(text: turoController.text);
  Future<Map<String, dynamic>?> _uploadToDo() async => await _aPiRepository.uploadToDo(text: textController.text);

  void _onPageEvent(ImportTaskPageEvent event, Emitter<ImportTaskState> emit) {
    currentPageIndex = event.pageIndex;
    emit(ImportTaskCommonState());
  }

  void _onTextSaveEvent() async {
    try {
      if (textFormKey.currentState?.validate() == false) return;
      if(!isClosed) emit(ImportTaskLoadingState());
      var response = await _uploadToDo();
      Console.of.log(response);
      if ((response != null) && ([200,201,202].contains(response['status']))) {
        textController.clear();
        if(!isClosed) emit(ImportTaskCompletedState());
      } else {
        if (!isClosed) emit(ImportTaskErrorState(response?['message'] ?? "Something went wrong, please try again later"));
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      if(!isClosed) emit(ImportTaskErrorState(e));
    }
  }

  void _onTuroReservationEvent() async {
    try {
      if (turoFormKey.currentState?.validate() == false) return;
      if(!isClosed) emit(ImportTaskLoadingState());
      var response = await _uploadTuro();
      Console.of.log(response);
      if ((response != null) && ([200,201,202].contains(response['status']))) {
        turoController.clear();
        if(!isClosed) emit(ImportTaskCompletedState());
      } else {
        if (!isClosed) emit(ImportTaskErrorState(response?['message'] ?? "Something went wrong, please try again later"));
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      if(!isClosed) emit(ImportTaskErrorState(e));
    }
  }

  void _onSaveEvent(ImportTaskSaveEvent event, Emitter<ImportTaskState> emit) {
    if (currentPageIndex == 0) {
      _onTextSaveEvent();
    } else {
      _onTuroReservationEvent();
    }
  }

  void _onInitialEvent(ImportTaskInitialEvent event, Emitter<ImportTaskState> emit) {
    var copiedMedia = List<SharedMediaFile>.from(getIt<ReceiveIntent>().medias).firstOrNull;
    Console.of.log(copiedMedia?.toMap());
    textController.text = copiedMedia?.path ?? "";
    if ((copiedMedia != null) && (copiedMedia.toMap().isNotEmpty)) getIt<ReceiveIntent>().clear();
    currentPageIndex = event.fixedPageIndex ?? 0;
    emit(ImportTaskCommonState());
  }
}