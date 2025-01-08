
import 'package:bloc/bloc.dart';
import '../Event/text_upload_event.dart';
import '../Repository/text_upload_repository.dart';
import '../State/text_upload_state.dart';
import '../Repository/todo_list_repository.dart';

class TextUploadBloc extends Bloc<TextUploadEvent, TextUploadState> {
  TaskUploadRepository taskUploadRepository = TaskUploadRepository();
  TodoListRepo todoListRepo = TodoListRepo();

  TextUploadBloc() : super(TextUploadInitial()) {
    on<TextUploadEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CreateTextUpload>((event, emit) async {
      emit(TextUploadLoading());
      await taskUploadRepository.uploadTask(event.id, event.text).then((value) {
        emit(TextUploadLoaded(result: value));
      });
    });
  }
}
