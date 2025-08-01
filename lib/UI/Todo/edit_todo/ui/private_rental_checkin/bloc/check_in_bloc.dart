import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'check_in_event.dart';
part 'check_in_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState>{
  final APiRepository _apiRepository = APiRepository();

  dynamic model;

  CheckInBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<SaveEvent>(_onSaveEvent);
    on<CapturedImageEvent>(_onCapturedImageEvent);
    on<UploadImageEvent>(_onUploadImageEvent);

  }

  void _onInitialEvent(InitialEvent event, Emitter<CheckInState> emit) {
    try {
      emit(LoadingState());
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onSaveEvent(SaveEvent event, Emitter<CheckInState> emit) {
    try {
      emit(LoadingState());
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onCapturedImageEvent(CapturedImageEvent event, Emitter<CheckInState> emit) async {
    try {
      var result = await _captureImages();
      if (result != null) {

      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onUploadImageEvent(UploadImageEvent event, Emitter<CheckInState> emit) async {
    try {
      var result = await _pickImage();
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic message, Emitter<CheckInState> emit) {
    Console.of.error(message);
    emit(ErrorState(message));
  }

  Future<List<File>> _pickImage() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf',]);
    return result?.paths
        .where((element) => (element?.isNotEmpty ?? false))
        .map((e) => File(e!))
        .toList() ??
        [];
  }

  Future<File?> _captureImages() async {
    final XFile? pickedFiles =
    await ImagePicker().pickImage(source: ImageSource.camera);
    return (pickedFiles != null) ? File(pickedFiles.path) : null;
  }


}