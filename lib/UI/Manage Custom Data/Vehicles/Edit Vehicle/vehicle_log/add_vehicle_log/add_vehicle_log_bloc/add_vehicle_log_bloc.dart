import 'dart:async';
import 'dart:io';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log/add_vehicle_log/add_vehicle_log_bloc/add_vehicle_log_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log/add_vehicle_log/add_vehicle_log_bloc/add_vehicle_log_states.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddVehicleLogBloc extends Bloc<AddVehicleLogEvent, AddVehicleLogState> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  File? video, audio, image;
  final APiRepository _aPiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  dynamic vin;

  String? get currentUserId => Session.of.getString(Str.userIdPrefText);

  AddVehicleLogBloc() : super(AddVehicleLogLoadingState()) {
    on<AddVehicleLogInitialEvent>(_onInitialEvent);
    on<AddVehicleLogRecordVideoEvent>(_onRecordVideoEvent);
    on<AddVehicleLogRecordAudioEvent>(_onRecordAudioEvent);
    on<AddVehicleLogUploadImageEvent>(_onUploadImageEvent);
    on<AddVehicleLogSubmitEvent>(_onSubmitEvent);
    on<AddVehicleLogAudioInsertEvent>(_onAudioInsertEvent);
  }

  Future<Map<String, dynamic>?> _uploadLog(
          {Map<String, dynamic>? body, Map<String, String?>? files}) async =>
      await _aPiRepository.uploadExpenseLogs(infusedFiles: files, body: body);

  Future<File?> _pickVideo() async {
    var result = await ImagePicker().pickVideo(source: ImageSource.camera);
    return (result != null) ? File(result.path) : null;
  }

  Future<File?> _pickImage() async {
    var result = await ImagePicker().pickImage(source: ImageSource.gallery);
    return (result != null) ? File(result.path) : null;
  }

  void _onRecordVideoEvent(AddVehicleLogRecordVideoEvent event,
      Emitter<AddVehicleLogState> emit) async {
    video = await _pickVideo();
    emit(AddVehicleLogCommonState());
  }

  void _onRecordAudioEvent(AddVehicleLogRecordAudioEvent event,
      Emitter<AddVehicleLogState> emit) async {
    emit(AddVehicleLogRecorderAudioState());
  }

  void _onUploadImageEvent(AddVehicleLogUploadImageEvent event,
      Emitter<AddVehicleLogState> emit) async {
    image = await _pickImage();
    emit(AddVehicleLogCommonState());
  }

  void _onSubmitEvent(
      AddVehicleLogSubmitEvent event, Emitter<AddVehicleLogState> emit) async {
    try {
      if ((video == null) &&
          (audio == null) &&
          (image == null) &&
          (notesController.text.trim().isNullOrEmpty)) {
        emit(AddVehicleLogErrorState("At least one file or note is required"));
        return;
      }
      var mapData = <String, String>{
        "vin": vin ?? "",
        "user_id": currentUserId ?? "",
        "notes": notesController.text,
        "title": titleController.text,
        "type" : 'inline'
      };

      var fileFusion = {
        "audio": audio?.path,
        "image": image?.path,
        "video": video?.path,
      };

      emit(AddVehicleLogLoadingState());

      mapData.removeWhere((key, value) => value.isNullOrEmpty);

      fileFusion.removeWhere((key, value) => value.isNullOrEmpty);

      var response = await _uploadLog(body: mapData, files: fileFusion);
      emit(AddVehicleLogCommonState());
      if (response != null) {
        _broadcast.stickyBroadcast("vehicle_log", value: true);
        _clearAll();
        emit(AddVehicleLogCommonState());
      } else {
        emit(AddVehicleLogErrorState("Something went wrong"));
      }
    } catch (e) {
      Console.of.log(e);
      emit(AddVehicleLogErrorState(e));
    }
  }

  void _clearAll() {
    titleController..clear()..clearComposing();
    notesController..clear()..clearComposing();
    video = null;
    audio = null;
    image = null;
  }

  void _onInitialEvent(
      AddVehicleLogInitialEvent event, Emitter<AddVehicleLogState> emit) {
    vin = event.vin;
    emit(AddVehicleLogCommonState());
  }

  void _onAudioInsertEvent(
      AddVehicleLogAudioInsertEvent event, Emitter<AddVehicleLogState> emit) {
    audio = event.file;
    emit(AddVehicleLogCommonState());
  }
}
