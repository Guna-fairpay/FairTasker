import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'precheck_event.dart';
part 'precheck_state.dart';

class PrecheckBloc extends Bloc<PrecheckEvent, PrecheckState> {

  APiRepository apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  TextEditingController dateController = TextEditingController();
  TextEditingController odometerController = TextEditingController();

  DateTime? selectedDate;

  List<dynamic> precheckList = [];
  List<dynamic> attachmentList = [];
  List<dynamic> attachmentPaths = [];
  List<dynamic> vinList = [];
  List<Map<String, dynamic>>? todoList = [];

  dynamic model;
  dynamic selectedVehicle;
  Map<String, dynamic> fixTask = {};

  Future<Map<String, dynamic>?> _deleteImage({dynamic id}) async => await apiRepository.deletePreCheckImage(id: id);
  Future<Map<String, dynamic>?> _savePreCheck({dynamic body, dynamic infusedFiles}) async => await apiRepository.saveFairentalPrecheck(body: body, infusedFiles: infusedFiles);
  Future<List<Map<String, dynamic>>> _getVehicle() async => await getIt<CommonService>().getActiveVehicles();
  Future<Map<String, dynamic>?> _vehicleAddOrUpdateApi({required dynamic id, required dynamic body}) async => await apiRepository.vehicleAddOrUpdateApi(body: body, id: id,);
  Future<List<Map<String, dynamic>>?> _fetchToDo() async => await apiRepository.todo();
  Future<Map<String, dynamic>?> _addTodo({dynamic body}) async => await apiRepository.addToDo(body: body);
  Future<Map<String, dynamic>?> _editToDo({dynamic body, dynamic id}) async => await apiRepository.updateToDo(body: body, toDoId: id);
  Future<Map<String, dynamic>?> _completeTodo({dynamic body, dynamic id}) async => await apiRepository.completeTodo(body: body, todoId: id);
  Future<Map<String, dynamic>?> _deleteTodo({dynamic id, dynamic reason}) async => await apiRepository.deleteTodo(id: id, reason: reason);

  PrecheckBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<CheckEvent>(_onCheckEvent);
    on<DatePickEvent>(_onDatePickEvent);
    on<UploadImageEvent>(_onUploadImageEvent);
    on<DeleteImageEvent>(_onDeleteImageEvent);
    on<DeleteImageDialogEvent>(_onDeleteImageDialogEvent);
    on<SaveEvent>(_onSaveEvent);
    on<CreateOrUpdateEvent>(_onCreateOrUpdateEvent);
    on<TextTapEvent>(_onTextTapEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
    on<CompleteTaskEvent>(_onCompleteTaskEvent);

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
        element['check_value'] = element['id'] == 1 ? 1 : element['is_checked'] == 1? 1 : 2;
        element['controller'] = TextEditingController();
        element['isTap'] = false;
        element['existing_task'] = 0;
      }
      selectedDate = DateTime.tryParse(precheckList.firstWhereOrNull((element) => element['id'] == 6)?['last_maintanence_date'] ?? '');
      odometerController.text = precheckList.firstWhereOrNull((element) => element['id'] == 7)?['odometer'] ?? '';
      attachmentList = model?['precheckImages'];
      attachmentPaths = attachmentList.map((e) => e['path'].toString().toTaskerStorageURL).toList();
      fixTask = jsonDecode(model?['fix_tasks'] ?? "{}");
      if(fixTask.isNotEmpty){
        await findTaskNotes();
      }
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onCheckEvent(CheckEvent event, Emitter<PrecheckState> emit) {
    try{
      if(event.payload['existing_task'] == 1) return emit(DeleteOrCompleteState(model: event.payload));
      if(event.showDialog) return emit(TollAlertDialogState(model: event.payload));
      if(event.payload['existing_task'] == 1) return;
      if(event.payload['id'] == 7 && odometerController.text.isEmpty) return emit(CommonState());
      if(event.payload['id'] == 8 && attachmentPaths.isEmpty) return emit(ErrorState('Images required to complete'));
      precheckList.where((element) => element['id'] == event.payload['id'])
          .forEach((e) {
            final value = event.payload['check_value'];
            e['isTap'] = false;
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
      await vehicleApiCall();
      if(response?['status'] == 200){
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(SuccessState(message: response?['message'], pop: true));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onCreateOrUpdateEvent(CreateOrUpdateEvent event, Emitter<PrecheckState> emit) async {
    try{
      emit(LoadingState());
      var preCheckData = baseBody();
      if(event.payload['existing_task'] == 1){
        dynamic id;
        fixTask.forEach((key, value){
          if(key == event.payload['id'].toString()){
            id = value;
          }
        },);
       var response =  await _editToDo(id: id, body: {
         "notes": (event.payload['controller'] as TextEditingController).text,
         "type": "inline",
       });
       await _savePreCheck(body: preCheckData['body'], infusedFiles: preCheckData['file']);
       if(response?['status'] == 200){
         _broadcast.stickyBroadcast("todo_view", value: true);
         emit(SuccessState(message:  response?['message'], pop: true));
       }else{
         emit(ErrorState(response?['message']));
       }
      }else{
        var data = addTodoBody(data: event.payload);

        var response = await _addTodo(body: data);
        await _savePreCheck(body: preCheckData['body'], infusedFiles: preCheckData['file']);
        await vehicleApiCall();
        if(response?['status'] == 200){
          fixTask[event.payload['id'].toString()] = List.from(response?['todo'] ?? []).first?['id'];
          Console.of.log(fixTask.runtimeType, name: 'FIX TASK');
          await _editToDo(id: model?['id'], body: {
            "fix_tasks": fixTask,
            "type": "inline"
          });
          _broadcast.stickyBroadcast("todo_view", value: true);
          emit(SuccessState(message:  response?['message'], pop: true));
        }else{
          emit(ErrorState(response?['message']));
        }
      }

    }catch(e){
      _onError(e, emit);
    }
  }

  void _onTextTapEvent(TextTapEvent event, Emitter<PrecheckState> emit) {
    try{
      if(event.payload['existing_task'] == 1) return emit(DeleteOrCompleteState(model: event.payload));
      precheckList.where((element) => element['id'] == event.payload['id']).forEach((e) {
        e['isTap'] = !e['isTap'];
        final value = event.payload['check_value'];
        if (value == 0 || value == 1) {
          e['check_value'] = 2;
          if(value == 0){
            e['isTap'] = false;
          }
        }
      });
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<PrecheckState> emit) async {
    try{
      emit(LoadingState());
      var response = await _deleteTodo(id: event.payload?['existing_task_id'], reason: event.reason);
      if(response?['status'] == 200){
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(SuccessState(message: response?['message'], pop: true));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onCompleteTaskEvent(CompleteTaskEvent event, Emitter<PrecheckState> emit) async {
    try{
      emit(LoadingState());
      var data = completeTodoBody(data: event.payload);
      var response = await _completeTodo(body: data, id: event.payload?['existing_task_id']);
      await vehicleApiCall();
      if(response?['status'] == 200){
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(SuccessState(message: response?['message'], pop: true));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch(e) {
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

  Map<String, dynamic> addTodoBody({dynamic data}){
    Map<String, dynamic> body = {};
    body['address'] = model?['address'];
    body['branch_id'] = model?['branch_id'];
    body['identifier_id'] = data?['identifier_id'];
    body['location'] = model?['location'];
    body['location_id'] = model?['location_id'];
    body['notes'] = (data?['controller'] as TextEditingController).text;
    body['start_at'] = DateTime.now().toFormat() ?? "";
    body['time_sensitive'] = model?['time_sensitive'];
    body['title'] = "Precheck-${data?['task_name']}";
    body['todo_time'] = DateTime.now().toFormat(format: "HH:mm:ss") ?? "";
    body['todo_user_type'] = data?['todo_user_type'];
    body['user_group_id'] = model?['user_group_id'];
    body['user_id'] = model?['user_id'];
    body['vehicle_name'] = model?['vehicle_name'];
    body['vehicles'] = List.from(model?['vehicles'] ?? []).map((e) => jsonEncode(e)).toList();
    body['vendor_id'] = model?['vendor_id'];
    body['vendor_name'] = model?['vendor_name'];
    body['vin'] = model?['vin'];
    return body;
  }

  Map<String, dynamic> completeTodoBody({dynamic data}){
    Map<String, dynamic> body = {};
    body['status'] = true;
    body['complete_time_taken'] = model?['complete_time_taken'];
    body['complete_time_approved'] = model?['complete_time_approved'];
    body["checklist_data"] = {
      "checklist_id": {
        "id": data?['id'],
        "title": data?['title'],
        "description": data?['description'],
        "is_checked": data?['check_value'] == 1 ? true : false,
        "odometer": data?['odometer'],
        "last_maintanence_date": data?['last_maintanence_date'],
        "identifier_id": data?['identifier_id'],
        "task_name": data?['task_name'],
        "todo_user_type": data?['todo_user_type'],
        "checked": false,
        "open": true,
        "note": (data?['controller'] as TextEditingController).text,
        "button_name": "Update Task",
      },
      "todo_id": data?['existing_task_id'],
    };
    Console.of.log(data);
    return body;

  }

  Future<void> findTaskNotes() async {
    todoList = await _fetchToDo();
    fixTask.forEach((key, value) {
      final todoItem = todoList?.firstWhereOrNull((element) => element['id'] == value);
      final notes = todoItem?['notes'];

      if (todoItem != null && todoItem['status'] == "In Progress") {
        precheckList
            .where((element) => element['id'].toString() == key.toString())
            .forEach((e) {
          e['controller'] = TextEditingController(
            text: (notes ?? '').toString().removeHtmlTags,
          );
          e['check_value'] = 0;
          e['existing_task'] = 1;
          e['existing_task_id'] = value;
        });
      }
    });
  }

  Future<void> vehicleApiCall() async {
    await _vehicleAddOrUpdateApi(id: selectedVehicle?['id'], body: vehicleBody());
    getIt<CommonService>().getActiveVehicles(reset: true);
  }

}

