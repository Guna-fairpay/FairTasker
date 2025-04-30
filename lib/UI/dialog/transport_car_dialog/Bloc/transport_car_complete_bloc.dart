
import 'dart:convert';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_event.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class TCCDBloc extends Bloc<TCCDEvents, TCCDState> {

  final APiRepository _apiRepository = APiRepository();

  final TextEditingController customTaskController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController vLocationController = TextEditingController();

  final MultiSelectController<Map<String,dynamic>> controller = MultiSelectController<Map<String,dynamic>>();

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> resource = [];
  List<Map<String, dynamic>> vendor = [];
  List<Map<String, dynamic>> location = [];
  List<Map<String, dynamic>> selectedItems = [];
  List<dynamic>addresses=[];

  String? id;

  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  Map<String, dynamic>? _selectedModel; // ONLY USED TO STORE AND CHECK CONDITION (DON'T TOUCH)
  Map<String, dynamic>? model={};
  Map<String, dynamic>? selectedVLocations={};
  Map<String, dynamic>? selectedResource={};

  dynamic selectedButton;

  bool isShow = false;

  int get currentStatus => _selectedModel?['vehicle_status'] ?? 0;

  bool get isBuy =>  (_selectedModel?['vehicle_status'] ?? 0) == 1;

  bool get showNextTask {
    var canShowId = [1,4,5];
    var canShow = ((canShowId.contains(selectedButton)) || canShowId.contains(_selectedModel?['vehicle_status']));
    var check = isShow ? ((isShow && isBuy) || canShow) : (canShowId.contains(selectedButton)) ;
    return check;
  }


  TCCDBloc() : super(TCCDLoadingState()) {
   controller.addListener(() {
     Console.of.debug(controller.selectedItems.map((e) => e.value));
   });
    on<TCCDInitialEvents>(_onInitialEvents);
    on<CheckListsDropdownEvent>(_onCheckListsDropdownEvent);
    on<DateChangeEvent>(_onDateChangeEvent);
    on<TimeChangeEvent>(_onTimeChangeEvent);
    on<VLocationChangeEvent>(_onVLocationChangeEvent);
    on<AddressSelectionEvent>(_onAddressSelectionEvent);
    on<ResourceChangeEvent>(_onResourceChangeEvent);
    on<RadioButtonSelectionEvent>(_onRadioButtonSelectionEvent);
    on<SaveEvent>(_onSaveEvent);
    on<IgnoreEvent>(_onIgnoreEvent);

  }


  // List get vendor => getIt<CommonService>().vendorsList;
  // List get location => getIt<CommonService>().locationsList;

  void _onInitialEvents(TCCDInitialEvents event, Emitter<TCCDState> emit) async {
    emit(TCCDLoadingState());
    isShow = event.isComplete;
    _selectedModel = event.model;
    selectedButton = isBuy ? 1 : null;
    Console.of.debug(event.model,name: 'MODEL');
    resource = await getIt<CommonService>().getResources();
    vendor = await getIt<CommonService>().getVendorsList();
    location =await getIt<CommonService>().getLocationsList();
    try {
      if (event.isComplete == false) {
        var mapBody = toModel(_selectedModel);
        var response = await _apiRepository.createStatusToDo(body: mapBody);
        apiResponse = List<Map<String, dynamic>>.from(
            response?['statusTodo']?['checklist'] ?? []);
        model = apiResponse
            .where((e) => e['id'] == event.model?['vehicle_status'])
            .firstOrNull;
        Console.of.debug(response?['statusTodo'],name: 'apiResponse');

      } else {
        var response =
            await _apiRepository.vehicleStatusCheck(vin: event.model?['vin']);
        apiResponse = List<Map<String, dynamic>>.from(
            response?['data']?['categories'] ?? []);
        model = apiResponse
            .where((e) => e['id'] == event.model?['vehicle_status'] + 1)
            .firstOrNull;
      }
      Console.of.debug(model, name: 'MODEL');
      controller.addItems(List.from(model?['checklists'])
          .map(
            (e) => DropdownItem<Map<String, dynamic>>(
                value: e, label: (e['checklist_name'] ?? "")),
          )
          .toList());
      resource.removeWhere((resource) => resource['id'] == 2);
      resource.removeWhere((resource) =>
          ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
              (resource['branch_id'] !=
                  Session.of.getInt(Str.branchIdPrefText))) ||
          (resource['deleted_at'] != null));
      id = Session.of.getString(Str.userIdPrefText);
      selectedResource =
          resource.where((e) => e['id'].toString() == id.toString()).first;
      emit(TCCDCommonState());
    }catch(e){
      Console.of.error(e);
      emit(TCCDCommonState());
    }
  }

  void _onCheckListsDropdownEvent(CheckListsDropdownEvent event, Emitter<TCCDState> emit) async {

    selectedItems = event.value;
    var checklist = List.from(model?['checklists'])..removeWhere((e)=>selectedItems.contains(e));
    model?['checklists'] = checklist;
    Console.of.debug(selectedItems,name: 'MODEL');
    controller.selectedItems.addAll(selectedItems.map((e) => DropdownItem<Map<String, dynamic>>(
        value: e, label: (e['checklist_name'] ?? "")),).toList());

    emit(TCCDCommonState());
  }

  void _onDateChangeEvent(DateChangeEvent event, Emitter<TCCDState> emit) async {
    selectedDate = event.selectedDate;
    emit(TCCDCommonState());
  }

  void _onTimeChangeEvent(TimeChangeEvent event, Emitter<TCCDState> emit) async {
    selectedTime = event.selectedTime;
    emit(TCCDCommonState());
  }

  void _onVLocationChangeEvent(VLocationChangeEvent event, Emitter<TCCDState> emit) async {
    //vLocationController.text = event.vLocation;
    selectedVLocations = event.vLocation;
    emit(TCCDCommonState());
  }

  void _onAddressSelectionEvent(AddressSelectionEvent event, Emitter<TCCDState> emit) async {
    List<Map<String, dynamic>>? existing = List.from(addresses);
    if (event.isChecked) {
      Console.of.log(event.data);
      if (!existing.contains(event.data)) existing.add(event.data);
    } else {
      if (existing.contains(event.data)) existing.remove(event.data);
    }
    addresses = existing;
    emit(TCCDCommonState());
  }

  void _onResourceChangeEvent(ResourceChangeEvent event, Emitter<TCCDState> emit) async {
    selectedResource = event.data;
    emit(TCCDCommonState());
  }

  void _onRadioButtonSelectionEvent(RadioButtonSelectionEvent event, Emitter<TCCDState> emit) async {
    selectedButton = event.value;
    model={};
    model = apiResponse.where((e) => e['order_no']==selectedButton).firstOrNull;
    controller.addItems( List.from(model?['checklists']).map((e) => DropdownItem<Map<String, dynamic>>(
        value: e, label: (e['checklist_name'] ?? "")),).toList());
    Console.of.debug(model,name: 'MODEL');
    emit(TCCDCommonState());
  }

  void _onSaveEvent(SaveEvent event, Emitter<TCCDState> emit) async {
    try{
      Console.of.debug(_selectedModel,name:'SAVE');
      if(controller.selectedItems.isEmpty){
        return;
      }else{
        Map<String,String> data={
          'branch_id': "${_selectedModel?['branch_code']}",
          'cohort_id': "${_selectedModel?['cohort_id']}",
          'custom_task':customTaskController.text,
          'notes':notesController.text,
          'start_at': "${selectedDate?.toFormat()}",
          'statusTask':"${controller.selectedItems.map((e) => e.value).map((e) => jsonEncode({
            "title" : e['checklist_name'] ?? "",
            "vehicle_status_category" : e['category_id'] ?? 0,
            "vehicle_status_checklist" : e['checklist_id'] ?? 0,
            "vehicle_status_id" : e['id'] ?? 0,
          })).toList()}",
          'todo_time': "${selectedTime?.toHMS()}",
          'user_id': "$id",
          'vehicle_name': "${_selectedModel?['vehicle_name']}",
          'vehicle_status_category': "${_selectedModel?['vehicle_status']}",
          'vin': "${_selectedModel?['vin']}",
        };
        Console.of.debug(data);
        await _apiRepository.vehicleStatusCreateTask(body: data);
        Map<String, dynamic> mapData = {
          "vehicle_status" : _selectedModel?['vehicle_status'],
          "vehicle_status_update" : DateTime.now().toFormat(),
          "vin": _selectedModel?['vin'],
        };
        await _apiRepository.vehicleStatusUpdate(body: mapData);
        FBroadcast.instance().broadcast("vehicleStatus",value:true);
       // emit(TCCDLoadingState());
      }
      emit(TCCDCommonState());
    }catch(e){
      Console.of.error(e);
      emit(TCCDCommonState());
    }
  }

  void _onIgnoreEvent(IgnoreEvent event, Emitter<TCCDState> emit) async {

  }



  Map<String, dynamic> toModel(Map<String, dynamic>? model) {
    return {
      "category_id": model?['category_id'],
      "cohort_id": model?['cohort_id'] ?? "",
      "cohort_name": model?['cohort'] ?? "",
      "user_id": getIt<CommonService>().getUserId,
      "vehicle_image": List<Map<String, dynamic>>.from(model?['images'])
          .firstOrNull?['path'] ?? "",
      "vehicle_name": model?['vehicle_name'] ?? "",
      "vin": model?['vin'] ?? ""
    };
  }

}