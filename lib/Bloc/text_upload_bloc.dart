
import 'package:bloc/bloc.dart';
import '../Event/text_upload_event.dart';
import '../Repository/text_upload_repository.dart';
import '../State/text_upload_state.dart';
import '../Repository/todo_list_repository.dart';

class TextUploadBloc extends Bloc<TextUploadEvent, TextUploadState> {
  TaskUploadRepository taskUploadRepository = TaskUploadRepository();
  TodoListRepo todoListRepo = TodoListRepo();

  TextUploadBloc() : super(TextUploadInitial()) {
    on<TextUpload>((event, emit) async {
      emit(TextUploadLoading());
      await taskUploadRepository.uploadTask(event.text).then((value) {
        emit(TextUploadLoaded(message: value));
      });
    });

    on<TuroReservationEvent>((event, emit) async {
      emit(TextUploadLoading());
      await taskUploadRepository.uploadTuroReservation(event.text).then((value) {
        emit(TextUploadLoaded(message: value));
      });
    });
  }
}
