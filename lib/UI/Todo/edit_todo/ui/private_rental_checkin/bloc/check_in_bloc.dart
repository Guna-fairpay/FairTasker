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

  String? token;

  bool showRegistrationSticker = true;
  bool showTollSticker = true;
  bool showSpareTyreSticker = true;
  bool showSpareKeySticker = true;

  Future<Map<String, dynamic>?> _getToken() async => await _apiRepository.getRentalToken();
  Future<Map<String, dynamic>?> _updateDeposit({dynamic body, dynamic id}) async => await _apiRepository.updateDeposit(body: body, id: id, token: token);
  Future<Map<String, dynamic>?> _checkInOdometer({dynamic body}) async => await _apiRepository.checkInOdometer(body: body, token: token);
  Future<Map<String, dynamic>?> _getCheckInImages({dynamic id}) async => await _apiRepository.getCheckInImages(id: id, token: token);
  Future<Map<String, dynamic>?> _uploadCheckInImages({dynamic body, dynamic files}) async => await _apiRepository.uploadCheckInImages(body: body, infusedFiles: files);

  CheckInBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<CapturedImageEvent>(_onCapturedImageEvent);
    on<UploadImageEvent>(_onUploadImageEvent);
    on<DeleteImageEvent>(_onDeleteImageEvent);
    on<ViewImageEvent>(_onViewImageEvent);
    on<ShowImageUploadEvent>(_onShowImageUploadEvent);
    on<SaveDepositEvent>(_onSaveDepositEvent);
    on<SaveOdometerEvent>(_onSaveOdometerEvent);
    on<SaveImagesEvent>(_onSaveImagesEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<CheckInState> emit) async {
    try {
      emit(LoadingState());
      await getToken();
      model = event.data;
      final feeTypes = List.from((model?['bookingDetails']?['cost_summary']?['feeTypes']) ?? []);
      final firstFee = feeTypes.firstOrNull;
      securityAmountController.text = (firstFee?['overrideAmount'] ?? firstFee?['amount'])?.toString() ?? '';
      reasonController.text = List.from((model?['bookingDetails']?['cost_summary']?['feeTypes']) ?? []).firstOrNull?['reason'] ?? '';
      odometerController.text = "${model?['bookingDetails']?['checkin']?['odometer'] ?? ''}";
      await fetchData();
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
      emit(CommonState());
    }
  }

  Future<void> _onSaveDepositEvent(SaveDepositEvent event, Emitter<CheckInState> emit) async {
    if(securityAmountController.text.isEmpty){
      emit(ErrorState("security deposit amount is required"));
    }
    try {
      emit(LoadingState());
      var response = await _updateDeposit(
        id: model?['rental_booking_id'],
        body:{
          "new_value": securityAmountController.text,
          "reason": reasonController.text,
        },
      );
      if (response?['success'] == true) {
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSaveOdometerEvent(SaveOdometerEvent event, Emitter<CheckInState> emit) async {
    if (odometerController.text.isEmpty) {
      emit(ErrorState("odometer is required"));
    }
    try {
      emit(LoadingState());
      var response = await _checkInOdometer(
        body: {
          "booking_id": model?['rental_booking_id'],
          "odometer": odometerController.text,
        },
      );
      if (response?['success'] == true) {
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
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
      switch (event.imageName) {
        case 'Internal_Picture': internalPicture.remove(event.data); break;
        case 'External_Picture': externalPicture.remove(event.data); break;
        case 'Registration_Sticker_Image': registrationPicture.remove(event.data); break;
        case 'Toll_Images': tollPicture.remove(event.data); break;
        case 'Odometer_Images': odometerPicture.remove(event.data); break;
        case 'Oil_Change_Sticker_Picture': oilChangePicture.remove(event.data); break;
        case 'Spare_Tyre_Picture': spareTyrePicture.remove(event.data); break;
        case 'Spare_Key_Picture': spareKeyPicture.remove(event.data); break;
        case 'Underhood_Picture': underhoodPicture.remove(event.data); break;
        default: break;
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onShowImageUploadEvent(ShowImageUploadEvent event, Emitter<CheckInState> emit) {
    try {
      switch (event.checkBoxName) {
        case 'Registration_Sticker_Image': showRegistrationSticker = !showRegistrationSticker; break;
        case 'Toll_Images': showTollSticker = !showTollSticker; break;
        case 'Spare_Tyre_Picture': showSpareTyreSticker = !showSpareTyreSticker; break;
        case 'Spare_Key_Picture': showSpareKeySticker = !showSpareKeySticker; break;
        default: break;
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onViewImageEvent(ViewImageEvent event, Emitter<CheckInState> emit) async {
    try {
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
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSaveImagesEvent(SaveImagesEvent event, Emitter<CheckInState> emit) async {
    try {
      emit(LoadingState());
      var data = bodyData();
      var response = await _uploadCheckInImages(body: data['body'], files: data['files']);
      if (response?['success'] == true) {
        await fetchData();
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
      emit(CommonState());
    }catch(e){
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

  Future<void> getToken() async {
    var tokenResponse = await _getToken();
    token = tokenResponse?['data'];
  }

  Future<void> fetchData() async {
    var response = await _getCheckInImages(id: model?['rental_booking_id']);
    var attachments = List.from(response?['data']?['adminUploaded'] ?? []);
    internalPicture = attachments.where((element) => element['label'] == 'checkin_internal_picture').map((e) => e['file_url']).toList();
    externalPicture = attachments.where((element) => element['label'] == 'checkin_external_picture').map((e) => e['file_url']).toList();
    registrationPicture = attachments.where((element) => element['label'] == 'checkin_registration_sticker_picture').map((e) => e['file_url']).toList();
    tollPicture = attachments.where((element) => element['label'] == 'checkin_toll_sticker_picture').map((e) => e['file_url']).toList();
    odometerPicture = attachments.where((element) => element['label'] == 'checkin_odometer_picture').map((e) => e['file_url']).toList();
    oilChangePicture = attachments.where((element) => element['label'] == 'checkin_oilchange_sticker_picture').map((e) => e['file_url']).toList();
    spareTyrePicture = attachments.where((element) => element['label'] == 'checkin_spare_tyre_picture').map((e) => e['file_url']).toList();
    spareKeyPicture = attachments.where((element) => element['label'] == 'checkin_spare_key_picture').map((e) => e['file_url']).toList();
    underhoodPicture = attachments.where((element) => element['label'] == 'checkin_underhood_picture').map((e) => e['file_url']).toList();
  }

  Map<String, dynamic> bodyData() {
    Map<String, dynamic> data = {};
    List<Map<String, String?>> imageFiles = [];
    int indexValue = 0;

    void addImages(List<dynamic> pictureList, String label) {
      List<dynamic> images = pictureList.whereType<File>().map((e) => e.path).toList();
      if (images.isEmpty) return;

      for (var img in images) {
        imageFiles.add({
          'attachments[$indexValue][file]': img,
        });
        data['attachments[$indexValue][label]'] = label;
        data['attachments[$indexValue][type]'] = "upload";
        indexValue++;
      }
    }
    data['booking_id'] = model?['rental_booking_id'];
    addImages(internalPicture, "checkin_internal_picture");
    addImages(externalPicture, "checkin_external_picture");
    if(showRegistrationSticker) addImages(registrationPicture, "checkin_registration_sticker_picture");
    if(showTollSticker) addImages(tollPicture, "checkin_toll_sticker_picture");
    addImages(odometerPicture, "checkin_odometer_picture");
    addImages(oilChangePicture, "checkin_oilchange_sticker_picture");
    if(showSpareTyreSticker) addImages(spareTyrePicture, "checkin_spare_tyre_picture");
    if(showSpareKeySticker) addImages(spareKeyPicture, "checkin_spare_key_picture");
    addImages(underhoodPicture, "checkin_underhood_picture");

    return {"body": data, "files": imageFiles};
  }

}