

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Repository/todo_list_repository.dart';
import '../../../Response/create_fix_task_data.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final TodoListRepo todoListRepo = TodoListRepo();
  final TextEditingController notesController = TextEditingController();
  Map<String, dynamic> todoItemsCopy ={};
  Map<String, dynamic> vehiclesCopy ={};
  String? maintenanceTaskId;
  dynamic initialDropdown;
  int? taskId;

  MaintenanceBloc()
      : super(const MaintenanceState(
    todoItems: {},
    vehicle: {},
    isLoading: false,
    maintenance: [],
    checkboxStates: {},
    selectedDropdownValues: {},
    isAllCheck: false,
    dropdownValue: null,
  ))
  {
    on<MaintenanceInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final response = await todoListRepo.getMaintenanceCheckList();
        if (response != null) {
          final maintenanceCheckList = response.data ?? [];
          final checkboxStates = <int, Map<int, bool>>{};
          final selectedDropdownValues = <dynamic, String>{};
          final notesControllers = <int, TextEditingController>{};
          final individualCheckStates = <String, bool>{};

          for (var maintenanceItem in maintenanceCheckList) {
            final maintenanceId = maintenanceItem['id'];
            checkboxStates[maintenanceId] = {};
            for (var item in maintenanceItem['children'] ?? []) {
              checkboxStates[maintenanceId]![item['id']] = true;
              selectedDropdownValues[item['id']] = "Good";
              notesControllers[item['id']] = TextEditingController();
              individualCheckStates[item['name']] = false;
            }
          }
          Map<String, dynamic> todoItem = event.todoItem;
          String fixTasksJson = todoItem['fix_tasks'];
          Map<String, dynamic> fixTasksMap = jsonDecode(fixTasksJson);
          String key = fixTasksMap.keys.first;
          print("Extracted Value: ${key}");

          maintenanceTaskId = event.todoItem['maintenance_task_id'].toString();//65
          List<String> idList = maintenanceTaskId!.split('-');
          List<int> idListAsInt = idList.map((id) => int.parse(id)).toList();
          final isAllCheck = event.todoItem['mandatory'] == 1 ? false : true;


          // Emit the updated state
          emit(state.copyWith(
            initialDropDown: key,
            idList: idListAsInt,
            maintenance: maintenanceCheckList,
            checkboxStates: checkboxStates,
            selectedDropdownValues: selectedDropdownValues,
            notesControllers: notesControllers,
            isLoading: false, // Clear loading state
            isAllCheck: isAllCheck,
            individualCheckStates: individualCheckStates,
          ));
        }
      }
      catch (error) {
        print("Error fetching checklist: $error");
        emit(state.copyWith(isLoading: false));
      }
    });



    on<IsAllMaintenanceCheckEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await todoListRepo.allCheckInMainteance(CreateFixTaskData()
          ..id = taskId
          ..mandatory = event.status==true ? 0 : 1);
        emit(state.copyWith(
          isAllCheck: event.status,
          isLoading: false,
        ));
      }
      catch (error) {
        print("Error updating checklist: $error");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<IndividualCheckEvent>((event, emit) async {
        final updatedIndividualCheckStates = Map<String, bool>.from(state.individualCheckStates);
        updatedIndividualCheckStates[event.itemName] = event.status;
        emit(state.copyWith(
          individualCheckStates: updatedIndividualCheckStates,
        ));
    });

    on<createFixTaskEvent>((event, emit) async {
      try{
        await todoListRepo.createFixTask(CreateFixTaskData()
          ..userId = todoItemsCopy['user_id']
          ..userGroupId = int.tryParse(todoItemsCopy['user_group_id']?.toString() ?? '0') ?? 0
          ..title = event.item == 64 ? 'Oil Change' : 'Fix'
          ..maintenanceTaskId = event.maintenanceTaskId
          ..notes = event.notes
          ..comments = event.comments
          ..todoTime = todoItemsCopy['todo_time']
          ..startAt = todoItemsCopy['todo_date']
          ..identifierId = event.item == 64 ? 126 : null
          ..vehicleList = todoItemsCopy['vehicles']
          ..location = todoItemsCopy['location']
          ..locationId = todoItemsCopy['location_id']
          ..vendorId = todoItemsCopy['vendor_id']
          ..vendorName = todoItemsCopy['vendor_name']
          ..vehicleNumber = vehiclesCopy['vehicle_number']);
      }
      catch(e){
        print("catch error ${e.toString()}");
      }
    });

    on<DropDownOptionEvent>((event, emit) async {
      emit(state.copyWith(dropdownValue: event.linkOption));
    });


  }

}


