import 'dart:convert';

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
  CheckListBloc() : super(const CheckListState(
    isLoading: false,
    todoItems: {},
    vehicle: {},
  )) {

    on<CheckListInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      List<Map<String, dynamic>> checkListData = [];
      final Map<int, TextEditingController> controllers = {};

      try {
        final response = await todoListRepo.getCheckList();
        final response1 = await todoListRepo.getTodoList();

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


            matchingTodos = todoList
                .where((todo) => fixTaskValues.contains(todo['id']) && todo['status'] != "Completed")
                .map((todo) {
              String notes = todo["notes"];
              String firstWord = notes.split(RegExp(r'[\s\-<]')).first;
              notesValues.add(firstWord);
              return {
                "id": todo['id'],
                "notes": todo["notes"],
              };
            }).toList();

            print("matchingTodos: $matchingTodos");
            print("notesValues: $notesValues");

            // Insert notes into corresponding TextEditingController
            for (var todo in matchingTodos) {
              String notes = todo['notes']; // Example: "Lights - <p>Testfixdb</p>"

              // Extract checklist title (e.g., "Lights")
              String? matchingTitle = checkListData.firstWhere(
                      (item) => notes.contains(item['title']), // Match by title keyword
                  orElse: () => {}
              )['title'];

              if (matchingTitle != null) {
                int? checklistId = checkListData.firstWhere(
                        (item) => item['title'] == matchingTitle,
                    orElse: () => {}
                )['id'];

                if (checklistId != null && controllers.containsKey(checklistId)) {
                  controllers[checklistId]!.text = notes; // Assign notes
                }
              }
            }
          }
        }

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
      emit(state.copyWith(isLoading: true));
      try {
        await todoListRepo.createFixTask( CreateFixTaskData()
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
        );
        emit(state.copyWith(isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<CompleteEvent>((event,emit) async {
      try{
        List<int> getMatchingIds(
            Map<String, dynamic> checkEvent, List<Map<String, dynamic>> maintenanceTasks) {
          List<int> matchingIds = [];

          for (var task in maintenanceTasks) {
            String notes = task["notes"] ?? "";
            String firstWord = notes.split(RegExp(r'[\s\-<]')).first; // Extract first word

            if (firstWord == checkEvent["title"]) {
              matchingIds.add(task["id"]); // Add matching ID
            }
          }
          return matchingIds;
        }
        result = getMatchingIds(checkListData, matchingTodos);
        completeTodoID = result?.first.toString();
        await todoListRepo.completeATodo(completeTodoID,"Completed");
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
            String notes = task["notes"] ?? "";
            String firstWord = notes.split(RegExp(r'[\s\-<]')).first; // Extract first word

            if (firstWord == checkEvent["title"]) {
              matchingIds.add(task["id"]); // Add matching ID
            }
          }
          return matchingIds;
        }
        result = getMatchingIds(checkListData, matchingTodos);
        completeTodoID = result?.first.toString();
        await todoListRepo.deleteATodo(deleteTodoID!);
      }
      catch(e){
        print("catch error ${e.toString()}");
      }
    });

  }
}