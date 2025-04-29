
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_event.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_state.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
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
  List<Map<String, dynamic>> selectedItems = [];

  List<dynamic>addresses=[];


  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  Map<String, dynamic>? model={};
  Map<String, dynamic>? selectedVLocations={};


  TCCDBloc() : super(TCCDLoadingState()) {
   controller.addListener(() {
     Console.of.debug(controller.selectedItems);
   });
    on<TCCDInitialEvents>(_onInitialEvents);
    on<CheckListsDropdownEvent>(_onCheckListsDropdownEvent);
    on<DateChangeEvent>(_onDateChangeEvent);
    on<TimeChangeEvent>(_onTimeChangeEvent);
    on<VLocationChangeEvent>(_onVLocationChangeEvent);
    on<AddressSelectionEvent>(_onAddressSelectionEvent);
  }

  List get vendor => getIt<CommonService>().vendorsList;
  List get location => getIt<CommonService>().locationsList;

  void _onInitialEvents(TCCDInitialEvents event, Emitter<TCCDState> emit) async {
    emit(TCCDLoadingState());


    var response =await _apiRepository.vehicleStatusCheck(vin: event.model?['vin']);
    resource = await getIt<CommonService>().getResources();
    Console.of.log(event.model,name: 'MODEL');
   // Console.of.log(response,name: 'RESPONSE');
    apiResponse = List<Map<String, dynamic>>.from(response?['data']?['categories'] ?? []);
    model = apiResponse.where((e) => e['order_no']==event.model?['vehicle_status']).firstOrNull;
    controller.addItems( List.from(model?['checklists']).map((e) => DropdownItem<Map<String, dynamic>>(
        value: e, label: (e['checklist_name'] ?? "")),).toList());
   // Console.of.log(model,name: 'FILTERED');
    emit(TOCDCommonState());
  }

  void _onCheckListsDropdownEvent(CheckListsDropdownEvent event, Emitter<TCCDState> emit) async {

    selectedItems = event.value;
    var checklist = List.from(model?['checklists'])..removeWhere((e)=>selectedItems.contains(e));
    model?['checklists'] = checklist;
    Console.of.debug(selectedItems,name: 'MODEL');
    // controller.selectedItems.addAll(selectedItems.map((e) => DropdownItem<Map<String, dynamic>>(
    //     value: e, label: (e['checklist_name'] ?? "")),).toList());

    emit(TOCDCommonState());
  }

  void _onDateChangeEvent(DateChangeEvent event, Emitter<TCCDState> emit) async {
    selectedDate = event.selectedDate;
    emit(TOCDCommonState());
  }

  void _onTimeChangeEvent(TimeChangeEvent event, Emitter<TCCDState> emit) async {
    selectedTime = event.selectedTime;
    emit(TOCDCommonState());
  }

  void _onVLocationChangeEvent(VLocationChangeEvent event, Emitter<TCCDState> emit) async {
    //vLocationController.text = event.vLocation;
    selectedVLocations = event.vLocation;
    emit(TOCDCommonState());
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
    emit(TOCDCommonState());
  }

}