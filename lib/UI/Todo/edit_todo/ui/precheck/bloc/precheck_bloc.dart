import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'precheck_event.dart';
part 'precheck_state.dart';

class PrecheckBloc extends Bloc<PrecheckEvent, PrecheckState> {

  APiRepository apiRepository = APiRepository();

  TextEditingController dateController = TextEditingController();
  TextEditingController odometerController = TextEditingController();

  DateTime? selectedDate;

  List<dynamic> precheckList = [];
  List<dynamic> attachmentList = [];
  List<dynamic> attachmentPaths = [];
  List<dynamic> vinList = [];

  dynamic model;
  dynamic selectedVehicle;

  Future<Map<String, dynamic>?> _deleteImage({dynamic id}) async => await apiRepository.deletePreCheckImage(id: id);
  Future<Map<String, dynamic>?> _savePreCheck({dynamic body, dynamic infusedFiles}) async => await apiRepository.saveFairentalPrecheck(body: body, infusedFiles: infusedFiles);
  Future<List<Map<String, dynamic>>> _getVehicle() async => await getIt<CommonService>().getActiveVehicles();
  Future<Map<String, dynamic>?> _vehicleAddOrUpdateApi({required dynamic id, required dynamic body}) async => await apiRepository.vehicleAddOrUpdateApi(body: body, id: id,);

  PrecheckBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<CheckEvent>(_onCheckEvent);
    on<DatePickEvent>(_onDatePickEvent);
    on<UploadImageEvent>(_onUploadImageEvent);
    on<DeleteImageEvent>(_onDeleteImageEvent);
    on<DeleteImageDialogEvent>(_onDeleteImageDialogEvent);
    on<SaveEvent>(_onSaveEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<PrecheckState> emit) async {
    try{
      emit(LoadingState());
      model = event.payload;
      vinList = event.vinList;
      var vehicles = await _getVehicle();
      selectedVehicle = vehicles.where((element) => element['vin'] == vinList.firstOrNull).firstOrNull;
      precheckList = model?['precheckList'];
      for (var element in precheckList) {
        element['check_value'] = element['is_checked'] == 1? 1 : 2;
        element['controller'] = TextEditingController();
      }
      selectedDate = DateTime.tryParse(precheckList.firstWhere((element) => element['id'] == 6, orElse: () => null)?['last_maintanence_date']);
      odometerController.text = precheckList.firstWhere((element) => element['id'] == 6, orElse: () => null)?['odometer'] ?? '';
      attachmentList = model?['precheckImages'];
      attachmentPaths = attachmentList.map((e) => e['path'].toString().toTaskerStorageURL).toList();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onCheckEvent(CheckEvent event, Emitter<PrecheckState> emit) {
    try{
      if(event.showDialog) return emit(TollAlertDialogState(model: event.payload));
      precheckList.where((element) => element['id'] == event.payload['id'])
          .forEach((e) {
            final value = event.payload['check_value'];
            if (value == 1) {
              e['check_value'] = 0;
            } else if (value == 2 || value == 0) {
              e['check_value'] = 1;
            } else {
              e['check_value'] = 0;
            }
          });
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onDatePickEvent(DatePickEvent event, Emitter<PrecheckState> emit) {
    try{
      selectedDate = event.payload;
      dateController.text = event.payload.toString();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onUploadImageEvent(UploadImageEvent event, Emitter<PrecheckState> emit) async {
    try{
      var result = await _pickFiles();
      if (result.isNotEmpty) {
        var attachments = List.from(attachmentPaths);
        var existingAttachments = List.from(attachmentPaths)
            .whereType<File>()
            .map((e) => (e.path))
            .toList();
        for (var element in result) {
          if (!existingAttachments.contains(element.path)) {
            attachments.add(element);
          }
        }
        attachmentPaths = attachments;
      }
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteImageEvent(DeleteImageEvent event, Emitter<PrecheckState> emit) async {
    try{
      if(event.payload is File) {
        attachmentPaths.remove(event.payload);
      }else{
        var attachmentId = attachmentList
            .where((element) => element['path'] == (event.payload).toString().removeTaskerStorageUrl)
            .map((e) => e['id'])
            .firstOrNull;
        emit(LoadingState());
        await _deleteImage(id: attachmentId);
        attachmentPaths.remove(event.payload);
        emit(CommonState());
      }
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onDeleteImageDialogEvent(DeleteImageDialogEvent event, Emitter<PrecheckState> emit) {
    try{
      emit(DeleteImageState(model: event.payload));
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onSaveEvent(SaveEvent event, Emitter<PrecheckState> emit) async {
    try{
      emit(LoadingState());
      var data = baseBody();
      var response = await _savePreCheck(body: data['body'], infusedFiles: data['file']);
      var vehicleResponse = await _vehicleAddOrUpdateApi(id: selectedVehicle?['id'], body: vehicleBody());
      getIt<CommonService>().getActiveVehicles(reset: true);
      if(response?['status'] == 200){
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<PrecheckState> emit) {
    Console.of.error(error);
    emit(ErrorState(error.toString()));
  }

  Future<List<File>> _pickFiles() async {
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

  Map<String, dynamic> baseBody(){
    Map<String, dynamic> body = {};
    int index = 0;
    int imageIndex = attachmentList.isNotEmpty ? attachmentList.length - 1 : 0;
    List<Map<String, String?>> imageFiles = [];
    body['todo_id'] = model?['id'];
    body['vin'] = vinList.firstOrNull;
    for(var element in precheckList){
      body['checklist[$index][checklist_id]'] = element['id'];
      body['checklist[$index][checked_status]'] = element['check_value'] == 1? 1 : 0;
      if(element['id'] == 6) {
        body['checklist[$index][value]'] = selectedDate?.toString().toFormat(format: "yyyy-MM-dd");
      }else if(element['id'] == 7) {
        body['checklist[$index][value]'] = odometerController.text;
      }else{
        body['checklist[$index][value]'] = '';
      }
      index++;
    }
    List<dynamic> images = attachmentPaths.whereType<File>().map((e) => e.path).toList();
    for(var element in images){
      imageFiles.add({
        'images[$imageIndex]': element,
      });
    }
    Console.of.log(body);
    Console.of.log(imageFiles);
    return {'body': body, 'file': imageFiles};
  }

  Map<String, dynamic> vehicleBody(){
    var airTag = precheckList.firstWhere((element) => element['id'] == 2,);
    var spareKey = precheckList.firstWhere((element) => element['id'] == 3,);
    var tollTags = precheckList.firstWhere((element) => element['id'] == 4,);
    var bouncie = precheckList.firstWhere((element) => element['id'] == 5,);
    Map<String, dynamic> baseBody = {};
    baseBody['vehicle_id'] = selectedVehicle?['vehicle_id'];
    baseBody['vin'] = selectedVehicle?['vin'];
    baseBody['make'] = selectedVehicle?['make'];
    baseBody['model'] = selectedVehicle?['model'];
    baseBody['year'] =  selectedVehicle?['year'];
    baseBody['cohort_id'] = selectedVehicle?['cohort_id'];
    baseBody['earnings'] = selectedVehicle?['earnings'];
    baseBody['utilization_rate'] = selectedVehicle?['utilization_rate'];
    baseBody['platform'] = selectedVehicle?['platform'];
    baseBody['mileage'] = selectedVehicle?['mileage'];
    baseBody['wholesale_amount'] = selectedVehicle?['wholesale_amount'];
    baseBody['vehicle_status'] = selectedVehicle?['vehicle_status'];
    baseBody['active'] = selectedVehicle?['active'];
    baseBody['purchase_price'] = selectedVehicle?['purchase_price'];
    baseBody['purchase_date'] = selectedVehicle?['purchase_date'];
    baseBody['vehicle_number'] = selectedVehicle?['vehicle_number'];
    baseBody['address'] = selectedVehicle?['address'];
    baseBody['bouncie'] = bouncie?['check_value'] == 1? "1" : "0";
    baseBody['air_tag'] = airTag?['check_value'] == 1? "1" : "0";
    baseBody['spare_tire'] = selectedVehicle?['spare_tire'];
    baseBody['spare_key'] = spareKey?['check_value'] == 1? "1" : "0";
    baseBody['permanent_plate'] = selectedVehicle?['permanent_plate'];
    baseBody['car_number'] = selectedVehicle?['car_number'];
    baseBody['oil_grade'] = selectedVehicle?['oil_grade'];
    baseBody['registration_renewal_date'] = selectedVehicle?['registration_renewal_date'];
    baseBody['toll_tags'] = tollTags?['check_value'] == 1? "1" : "0";
    baseBody['toll_tags_id'] = selectedVehicle?['toll_tags_id'];
    baseBody['front_license_plate'] = selectedVehicle?['front_license_plate'];
    baseBody['tire_size'] = selectedVehicle?['tire_size'];
    baseBody['front_tire'] = selectedVehicle?['front_tire'];
    baseBody['rear_tire'] = selectedVehicle?['rear_tire'];
    baseBody['insurance_agent'] = selectedVehicle?['insurance_agent'];
    baseBody['insurance_cost'] = selectedVehicle?['insurance_cost'];
    baseBody['current_odometer'] = selectedVehicle?['current_odometer'];
    baseBody['oil_change_odometer'] = selectedVehicle?['oil_change_odometer'];
    baseBody['maintenance_check'] = selectedVehicle?['maintenance_check'];
    baseBody['platform_from'] = 'tasker-app';
    baseBody['employee_id'] = "${getIt<CommonService>().userId}";
    baseBody['branch_code'] = selectedVehicle?['branch_code'];
    Console.of.log(jsonEncode(baseBody), name: "vehicleBody");
    return baseBody;
  }

}

