import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'check_in_event.dart';
part 'check_in_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState>{

  final APiRepository _apiRepository = APiRepository();

  final TextEditingController securityAmountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();

  List<dynamic> internalPicture = [];
  List<dynamic> externalPicture = [];
  List<dynamic> registrationPicture = [];
  List<dynamic> tollPicture = [];
  List<dynamic> odometerPicture = [];
  List<dynamic> oilChangePicture = [];
  List<dynamic> spareTyrePicture = [];
  List<dynamic> spareKeyPicture = [];
  List<dynamic> underhoodPicture = [];

  dynamic model;

  bool showRegistrationSticker = false;
  bool showTollSticker = false;
  bool showSpareTyreSticker = false;
  bool showSpareKeySticker = false;

  CheckInBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<SaveEvent>(_onSaveEvent);
    on<CapturedImageEvent>(_onCapturedImageEvent);
    on<UploadImageEvent>(_onUploadImageEvent);
    on<DeleteImageEvent>(_onDeleteImageEvent);
    on<ViewImageEvent>(_onViewImageEvent);

  }

  void _onInitialEvent(InitialEvent event, Emitter<CheckInState> emit) {
    try {
      emit(LoadingState());
      model = event.data;
      var attachments = List.from(model?['bookingDetails']?['bookingattachments'] ?? []);
      internalPicture = attachments.where((element) => element['label'] == 'checkin_internal_picture').map((e) => e['file_url']).toList();
      externalPicture = attachments.where((element) => element['label'] == 'checkin_external_picture').map((e) => e['file_url']).toList();
      registrationPicture = attachments.where((element) => element['label'] == 'checkin_registration_sticker_picture').map((e) => e['file_url']).toList();
      tollPicture = attachments.where((element) => element['label'] == 'checkin_toll_sticker_picture').map((e) => e['file_url']).toList();
      odometerPicture = attachments.where((element) => element['label'] == 'checkin_odometer_picture').map((e) => e['file_url']).toList();
      oilChangePicture = attachments.where((element) => element['label'] == 'checkin_oilchange_sticker_picture').map((e) => e['file_url']).toList();
      spareTyrePicture = attachments.where((element) => element['label'] == 'checkin_spare_tyre_picture').map((e) => e['file_url']).toList();
      spareKeyPicture = attachments.where((element) => element['label'] == 'checkin_spare_key_picture').map((e) => e['file_url']).toList();
      underhoodPicture = attachments.where((element) => element['label'] == 'checkin_underhood_picture').map((e) => e['file_url']).toList();
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
      emit(CommonState());
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
        switch (event.imageName) {
          case 'Internal_Picture': internalPicture.add(result); break;
          case 'External_Picture': externalPicture.add(result); break;
          case 'Registration_Sticker_Image': registrationPicture.add(result); break;
          case 'Toll_Images': tollPicture.add(result); break;
          case 'Odometer_Images': odometerPicture.add(result); break;
          case 'Oil_Change_Sticker_Picture': oilChangePicture.add(result); break;
          case 'Spare_Tyre_Picture': spareTyrePicture.add(result); break;
          case 'Spare_Key_Picture': spareKeyPicture.add(result); break;
          case 'Underhood_Picture': underhoodPicture.add(result); break;
          default: break;
        }
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onUploadImageEvent(UploadImageEvent event, Emitter<CheckInState> emit) async {
    try {
      var result = await _pickImage();
      if (result.isNotEmpty) {
        switch (event.imageName) {
          case 'Internal_Picture': internalPicture.addAll(result); break;
          case 'External_Picture': externalPicture.addAll(result); break;
          case 'Registration_Sticker_Image': registrationPicture.addAll(result); break;
          case 'Toll_Images': tollPicture.addAll(result); break;
          case 'Odometer_Images': odometerPicture.addAll(result); break;
          case 'Oil_Change_Sticker_Picture': oilChangePicture.addAll(result); break;
          case 'Spare_Tyre_Picture': spareTyrePicture.addAll(result); break;
          case 'Spare_Key_Picture': spareKeyPicture.addAll(result); break;
          case 'Underhood_Picture': underhoodPicture.addAll(result); break;
        }
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteImageEvent(DeleteImageEvent event, Emitter<CheckInState> emit) async {
    try {
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onViewImageEvent(ViewImageEvent event, Emitter<CheckInState> emit) async {
    try {
      emit(CommonState());
      switch (event.imageName) {
        case 'Internal_Picture': emit(ViewImageState(internalPicture)); break;
        case 'External_Picture': emit(ViewImageState(externalPicture)); break;
        case 'Registration_Sticker_Image': emit(ViewImageState(registrationPicture)); break;
        case 'Toll_Images': emit(ViewImageState(tollPicture)); break;
        case 'Odometer_Images': emit(ViewImageState(odometerPicture)); break;
        case 'Oil_Change_Sticker_Picture': emit(ViewImageState(oilChangePicture)); break;
        case 'Spare_Tyre_Picture': emit(ViewImageState(spareTyrePicture)); break;
        case 'Spare_Key_Picture': emit(ViewImageState(spareKeyPicture)); break;
        case 'Underhood_Picture': emit(ViewImageState(underhoodPicture)); break;
        default: break;
      }
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