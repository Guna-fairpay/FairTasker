import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

part 'tasker_meeting_event.dart';
part 'tasker_meeting_state.dart';

class TaskerMeetingBloc extends Bloc<TaskerMeetingEvent, TaskerMeetingState>{

  final APiRepository _apiRepository = APiRepository();
  QuillController quillMeetingController = QuillController.basic();

  dynamic model;

  Future<Map<String, dynamic>?> _completeToDo({required Map<String, dynamic> body, required dynamic todoId}) async => await _apiRepository.completeTodo(todoId: todoId, body: body);

  TaskerMeetingBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<SubmitEvent>(_onSubmitEvent);
  }
  void _onInitialEvent(InitialEvent event, Emitter<TaskerMeetingState> emit){
    try {
      model = event.model;
      quillMeetingController.document = Document.fromDelta(HtmlToDelta().convert(model?['meeting_summary'] ?? ''));
      emit(CommonState());
    }catch (e) {
      _onErrorEvent(e, emit);
    }
  }
  Future<void> _onSubmitEvent(SubmitEvent event, Emitter<TaskerMeetingState> emit) async {
    try {
      emit(LoadingState());
      Map<String, dynamic> body = {
        "complete_time_approved" : model?['complete_time_approved'],
        "complete_time_taken" : (model?['display']?['completed_time'] ?? model?['complete_time_taken']),
        "meeting_summary":  QuillDeltaToHtmlConverter(
          (quillMeetingController).document.toDelta().toJson(),
          ConverterOptions.forEmail(),).convert(),
        "status" : true
      };
      var response = await _completeToDo(body : body, todoId: model?['id']);
      if((response != null)){
        TaskerHelper.instance.refresh();
        emit(SuccessState(response['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e) {
      _onErrorEvent(e, emit);
    }
  }

  void _onErrorEvent(dynamic error, Emitter<TaskerMeetingState> emit){
    Console.of.error(error);
    emit(ErrorState(error));

  }
}