
import 'dart:convert';
import 'dart:developer';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:fairpytasker/Response/create_fix_task_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Repository/todo_list_repository.dart';
import 'check_list_event.dart';
import 'check_list_state.dart';

class CheckListBloc extends Bloc<CheckListEvent, CheckListState> {
  final TodoListRepo todoListRepo = TodoListRepo();
  final notesControllers = <int, TextEditingController>{};
  List<Map<String, dynamic>> matchingTodos = [];
  Map<String, dynamic> todoItemsCopy ={};
  Map<String, dynamic> vehiclesCopy ={};
  Map<String, dynamic>checkListData = {};
  final Map<int, bool> checkBoxStates = {};
  List<dynamic> fixTaskValues = [];
  List<String> notesValues = [];
  List<int>? result;
  String? completeTodoID;
  String? deleteTodoID;
  final FBroadcast _broadcast = FBroadcast.instance();
  CheckListBloc() : super(const CheckListState(
    isLoading: false,
    todoItems: {},
    vehicle: {},
    pop: false,
  )
  )
  {

    on<CheckListInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      List<Map<String, dynamic>> checkListData = [];
      final Map<int, TextEditingController> controllers = {};

      try {
        final response = await todoListRepo.getCheckList();
        final response1 = await todoListRepo.getTodoList();

        //todoItemsCopy = event.todoItems;
        todoItemsCopy.addAll(event.todoItems);
        vehiclesCopy.addAll(event.vehicle);

        if (response != null) {
          checkListData = response.data ?? [];
          final todoList = response1?.data ?? [];

          print("checkListData: $checkListData");
          print("todoList: $todoList");

          for (var item in checkListData) {
            checkBoxStates[item['id']] = true;
            controllers[item['id']] = TextEditingController();
          }

          Map<String, dynamic> todoItem = event.todoItems;
          String? fixTasksJson = todoItem['fix_tasks'];

          print("fixTasksJson: $fixTasksJson");

          if (fixTasksJson != null) {
            Map<String, dynamic> fixTasksMap = jsonDecode(fixTasksJson);
            fixTaskValues = fixTasksMap.values.toList();

            print("fixTasksMap: $fixTasksMap");
            print("fixTaskValues: $fixTaskValues");


            // 1. First, find all matching todos that are in fixTasksMap and not completed
            matchingTodos = todoList
                .where((todo) => fixTaskValues.contains(todo['id']) && todo['status'] != "Completed")
                .map((todo)
            {
              // Get the checklist ID that corresponds to this todo ID
              int? checklistId = int.tryParse(fixTasksMap.entries
                  .firstWhere((entry) => entry.value == todo['id'])
                  .key);

              // Find the checklist item
              var checklistItem = checkListData.firstWhere(
                      (item) => item['id'] == checklistId,
                  orElse: () => {});

              // Get the checklist title
              String checklistTitle = checklistItem['title'] ?? '';

              // Extract just the custom note part (after the hyphen)
              String noteContent = todo["notes"].toString().trim().contains('-')
                  ? todo["notes"].toString().trim().split('-')[1]
                  : todo["notes"].toString().trim();

              // Store the checklist title in notesValues for reference
              notesValues.add(checklistTitle);

              return {
                "id": todo['id'],
                "checklist_id": checklistId,
                "checklist_title": checklistTitle,
                "notes": noteContent, // Store just the custom note part
              };
            }).toList();

            print("matchingTodos: $matchingTodos");
            print("notesValues: $notesValues");

            // Insert notes into corresponding TextEditingController
            for (var todo in matchingTodos) {
              int checklistId = todo['checklist_id'];
              String checklistTitle = todo['checklist_title'];
              String noteContent = todo['notes'];

              if (controllers.containsKey(checklistId)) {
                // Reconstruct the full note with checklist title
                controllers[checklistId]!.text = '$checklistTitle - $noteContent';

                // Also update the checkbox state to unchecked since there's a task
                checkBoxStates[checklistId] = false;
              }
            }
          }
        }
        log("${checkBoxStates}" , name: "checkBoxStates");
        log("${controllers.toString()}" , name: "controllers");
        log("${notesValues}" , name: "notesValues");

        emit(state.copyWith(
          isLoading: false,
          checkListData: checkListData,
          checkBoxStates: checkBoxStates,
          notesControllers: controllers,
          notesValues: notesValues,
        ));
      } catch (e) {
        print("Error: $e");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<IndividualCheckEvent>((event, emit) {
      final updatedIndividualCheckStates = Map<int, bool>.from(
          state.checkBoxStates ?? {});

      updatedIndividualCheckStates[int.parse(event.itemId)] = event.status;
      print("Updated maintenanceTaskId: $updatedIndividualCheckStates");
      checkListData = event.checkListData;
      print("IndividualCheckEvent ${event.checkListData}");
      emit(state.copyWith(checkBoxStates: updatedIndividualCheckStates));
    });

    on<AddFixTaskEvent>((event, emit) async {
      try {
        await todoListRepo.createFixTask( CreateFixTaskData()
        ..todoId = todoItemsCopy['id']
          ..userId = todoItemsCopy['user_id']
            ..userGroupId = todoItemsCopy['user_group_id']
            ..title = event.title
            ..notes = event.notes
            ..todoTime = todoItemsCopy['todo_time']
            ..startAt = todoItemsCopy['todo_date']
            ..vehicleList = todoItemsCopy['vehicles']
            ..locationId = todoItemsCopy['location']
            ..locationId = todoItemsCopy['location_id']
            ..vendorId = todoItemsCopy['vendor_id']
            ..vendorName = todoItemsCopy['vendor_name']
            ..vehicleNumber = vehiclesCopy['vehicle_number']
            ..maintenanceTaskId = event.checklistId.toString()
        );
        _broadcast.stickyBroadcast("todo_view", value: true);
      } catch (e) {
        print("Error: $e");
      }
    });

    on<CompleteEvent>((event,emit) async {
      log("matchingTodos: $matchingTodos");
      try{
        List<int> getMatchingIds(
            Map<String, dynamic> checkEvent, List<Map<String, dynamic>> maintenanceTasks) {
          List<int> matchingIds = [];

          for (var task in maintenanceTasks) {
            String title = task['checklist_title'];

            if (title == checkEvent["title"]) {
              matchingIds.add(task["id"]); // Add matching ID
            }
          }
          return matchingIds;
        }
        log("getMatchingIds: $getMatchingIds");

        result = getMatchingIds(checkListData, matchingTodos);
        completeTodoID = result?.first.toString();
        log("completeTodoID: $completeTodoID");
        await todoListRepo.completeATodo(completeTodoID,"Completed");
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(state.copyWith(pop:true));
      }
      catch(e){
        print("catch error ${e.toString()}");
      }
    });

    on<DeleteEvent>((event, emit) async {
      try{
        List<int> getMatchingIds(
            Map<String, dynamic> checkEvent, List<Map<String, dynamic>> maintenanceTasks) {
          List<int> matchingIds = [];

          for (var task in maintenanceTasks) {
            String title = task['checklist_title'];

            if (title == checkEvent["title"]) {
              matchingIds.add(task["id"]); // Add matching ID
            }
          }
          return matchingIds;
        }
        result = getMatchingIds(checkListData, matchingTodos);
        completeTodoID = result?.first.toString();
        await todoListRepo.deleteATodo(deleteTodoID!);
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(state.copyWith(pop:true));
      }
      catch(e){
        print("catch error ${e.toString()}");
      }
    });

  }
}