import 'dart:async';
import 'dart:io';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:fairpytasker/UI/dialog/record_audio/record_audio_events.dart';
import 'package:fairpytasker/UI/dialog/record_audio/record_audio_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordAudioBloc extends Bloc<RecordAudioEvent, RecordAudioState> {

  final AudioRecorder _audioRecorder = AudioRecorder();

  File? audio;
  bool isRecording = false;
  RecordAudioBloc() : super(RecordAudioCommonState()) {
    on<RecordAudioRecordEvent>(_onRecordEvent);
    on<RecordAudioStopEvent>(_onStopEvent);
    on<RecordAudioResetEvent>(_onResetEvent);
    on<RecordAudioSubmitEvent>(_onSubmitEvent);
  }

  Future<bool> get hasPermission async => await _audioRecorder.hasPermission();

  void _onRecordEvent(RecordAudioRecordEvent event, Emitter<RecordAudioState> emit) async {
    if (await hasPermission) {
      var tempDir = await getTemporaryDirectory();
      var filePath = "${tempDir.path}/audio.m4a";
      await _audioRecorder.start(const RecordConfig(), path: filePath);
      isRecording = true;
      emit(RecordAudioCommonState());
    } else {
      await Permission.microphone.request();
      emit(RecordAudioPermissionState());
    }
  }

  void _onStopEvent(RecordAudioStopEvent event, Emitter<RecordAudioState> emit) async {
    var result = await _audioRecorder.stop();
    Console.of.log(result);
    audio = File(result ?? "");
    Console.of.warning(await audio?.exists());
    isRecording = false;
    emit(RecordAudioCommonState());
  }

  void _onResetEvent(RecordAudioResetEvent event, Emitter<RecordAudioState> emit) {
    isRecording = false;
    audio = null;
    emit(RecordAudioCommonState());
  }

  void _onSubmitEvent(RecordAudioSubmitEvent event, Emitter<RecordAudioState> emit) {
    emit(RecordAudioSubmittedState(audio));
  }
}