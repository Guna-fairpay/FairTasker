import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/UI/Todo/Private%20Rental%20Check/privaterental_event.dart';
import 'package:fairpytasker/UI/Todo/Private%20Rental%20Check/privaterental_state.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:fairpytasker/Response/create_fix_task_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Repository/todo_list_repository.dart';
import '../../../Utilities/utils.dart';


class PrivateRentalsBloc extends Bloc<PrivateRentalsEvent, PrivateRentalsState> {
  final TodoListRepo todoListRepo = TodoListRepo();
  final FBroadcast _broadcast = FBroadcast.instance();
  Map<String, dynamic> todoItemCopy = {};
  Map<String, dynamic> vehicleCopy = {};
  List<Map<String, dynamic>> matchingTodos = [];

  PrivateRentalsBloc() : super(const PrivateRentalsState(
    isLoading: false,
    getPrivateRentalCheckData: [],
    checkBoxStates: {},
    privateRentalNoteControllers: {},
    todoItem: {},
    pop: false
  )) {
    on<PrivateRentalInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      List<Map<String, dynamic>> checkListData = [];
      final Map<int, TextEditingController> controllers = {};
      final Map<int, bool> checkBoxStates = {};

      try {
        final response = await todoListRepo.getPrivateRentalCheck();
        final response1 = await todoListRepo.getTodoList();

        todoItemCopy.addAll(event.todoItem);
        vehicleCopy.addAll(event.vehicle);

        if (response != null) {
          checkListData = response.data ?? [];
          final todoList = response1?.data ?? [];

          for (var item in checkListData) {
            checkBoxStates[item['id']] = true;
            controllers[item['id']] = TextEditingController();
          }

          Map<String, dynamic> todoItem = event.todoItem;
          String? fixTasksJson = todoItem['fix_tasks'];

          if (fixTasksJson != null) {
            Map<String, dynamic> fixTasksMap = jsonDecode(fixTasksJson);
            List<dynamic> fixTaskValues = fixTasksMap.values.toList();

            matchingTodos = todoList
                .where((todo) => fixTaskValues.contains(todo['id']) && todo['status'] != "Completed")
                .map((todo) {
              int? checklistId = int.tryParse(fixTasksMap.entries
                  .firstWhere((entry) => entry.value == todo['id'])
                  .key);
              log("checklistId: $checklistId", name: "PrivateRentalBloc");

              var checklistItem = checkListData.firstWhere(
                    (item) => item['id'] == checklistId,
                orElse: () => {},
              );

              String checklistTitle = checklistItem['title'] ?? '';
              String noteContent = todo["notes"].toString().trim().contains('-')
                  ? todo["notes"].toString().trim().split('-')[1].trim()
                  : todo["notes"];

              return {
                "id": todo['id'],
                "checklist_id": checklistId,
                "checklist_title": checklistTitle,
                "notes": noteContent,
                "todoId": todo['id'].toString(),
              };
            }).toList();

            for (var todo in matchingTodos) {
              int checklistId = todo['checklist_id'];
              String checklistTitle = todo['checklist_title'];
              String noteContent = todo['notes'];

              if (controllers.containsKey(checklistId)) {
                controllers[checklistId]!.text = '$checklistTitle - $noteContent';
                checkBoxStates[checklistId] = false;
              }
            }
          }
        }

        log("checkBoxStates: $checkBoxStates", name: "PrivateRentalBloc");

        emit(state.copyWith(
          isLoading: false,
          getPrivateRentalCheckData: checkListData,
          checkBoxStates: checkBoxStates,
          privateRentalNoteControllers: controllers,
          todoItem: event.todoItem,
          vehicle: event.vehicle,
        ));
      } catch (e) {
        log("Error: $e", name: "PrivateRentalBloc");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<UpdateCheckboxEvent>((event, emit) {
      final updatedCheckBoxStates = Map<int, bool>.from(state.checkBoxStates);
      updatedCheckBoxStates[event.itemId] = event.isChecked;

      log("Updated checkBoxStates: $updatedCheckBoxStates", name: "PrivateRentalBloc");

      emit(state.copyWith(checkBoxStates: updatedCheckBoxStates));
    });

    on<CreatePrivateFixTaskEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        await todoListRepo.createFixTask(CreateFixTaskData()
          ..todoId = todoItemCopy['id']
          ..userId = todoItemCopy['user_id']
          ..userGroupId = todoItemCopy['user_group_id']
          ..title = 'Private Rental Fix'
          ..notes = event.notes
          ..todoTime = DateTime.now().toFormat(format: "HH:mm:ss") ?? ""
          ..startAt = DateTime.now().toFormat() ?? ""
          ..vehicleList = todoItemCopy['vehicles']
          ..locationId = todoItemCopy['location']
          ..locationId = todoItemCopy['location_id']
          ..vendorId = todoItemCopy['vendor_id']
          ..vendorName = todoItemCopy['vendor_name']
          ..vehicleNumber = vehicleCopy['vehicle_number']
          ..maintenanceTaskId = event.id);
        Utils.successMobileToast("Fix Task created successfully");
        emit(state.copyWith(isLoading: false, pop: true));
        _broadcast.stickyBroadcast("todo_view", value: true);
      } catch (e) {
        log("Error creating task: $e", name: "PrivateRentalBloc");
      }
    });

    on<UpdateFixTaskEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        final response = await todoListRepo.UpdateFixTask(event.todoId ?? 0,event.notes ?? ''
        );
        if(response == true){
          Utils.successMobileToast("Fix Task Updated successfully");
          emit(state.copyWith(isLoading: false, pop: true));
          _broadcast.stickyBroadcast("todo_view", value: true);
        } else {
          log("Fix Task Updated failed");
        }
      } catch (e) {
        print("Error: $e");
      }
    });

    on<CompletePrivateRentalItemEvent>((event, emit) async {
      try {
        final response = await todoListRepo.completeATodo(event.todoId, "Completed");
        if (response == true) {
          Utils.successMobileToast("Fix Task completed successfully");
          _broadcast.stickyBroadcast("todo_view", value: true);
          emit(state.copyWith(pop: true));
        }
      } catch (e) {
        log("Error completing task: $e", name: "PrivateRentalBloc");
      }
    });

    on<DeletePrivateRentalItemEvent>((event, emit) async {
      try {
        await todoListRepo.deleteATodo(event.todoId, event.reason);
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(state.copyWith(pop: true));
      } catch (e) {
        log("Error deleting task: $e", name: "PrivateRentalBloc");
      }
    });
  }
}
