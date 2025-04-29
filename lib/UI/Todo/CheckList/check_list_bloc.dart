
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:fairpytasker/Response/create_fix_task_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Repository/todo_list_repository.dart';
import '../../../Utilities/utils.dart';
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
            
            
            matchingTodos = todoList
                .where((todo) => fixTaskValues.contains(todo['id']) && todo['status'] != "Completed")
                .map((todo)
            {
              
              int? checklistId = int.tryParse(fixTasksMap.entries
                  .firstWhere((entry) => entry.value == todo['id'])
                  .key);

              var checklistItem = checkListData.firstWhere(
                      (item) => item['id'] == checklistId,
                  orElse: () => {}
              );

              String checklistTitle = checklistItem['title'] ?? '';

              String rawNote = todo["notes"].toString().trim();
              String noteContent = '';

              if (rawNote.contains('-')) {
                noteContent = rawNote.split('-').reversed.firstWhere(
                      (part) => part.trim().isNotEmpty,
                  orElse: () => '',
                ).trim();
              } else {
                noteContent = rawNote;
              }
              log("noteContent: $noteContent");

              notesValues.add(checklistTitle);

              return {
                "id": todo['id'],
                "checklist_id": checklistId,
                "checklist_title": checklistTitle,
                "notes": noteContent,
              };

            }).toList();

            print("matchingTodos: $matchingTodos");
            print("notesValues: $notesValues");

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
        emit(state.copyWith(isLoading: true));
        await todoListRepo.createFixTask( CreateFixTaskData()
        ..todoId = todoItemsCopy['id']
          ..userId = todoItemsCopy['user_id']
            ..userGroupId = todoItemsCopy['user_group_id']
            ..title = event.title
            ..notes = event.notes
            ..todoTime = DateTime.now().toFormat(format: "HH:mm:ss") ?? ""
            ..startAt = DateTime.now().toFormat() ?? ""
            ..vehicleList = todoItemsCopy['vehicles']
            ..locationId = todoItemsCopy['location']
            ..locationId = todoItemsCopy['location_id']
            ..vendorId = todoItemsCopy['vendor_id']
            ..vendorName = todoItemsCopy['vendor_name']
            ..vehicleNumber = vehiclesCopy['vehicle_number']
            ..maintenanceTaskId = event.checklistId.toString()
        );
        Utils.successMobileToast("Fix Task created successfully");
        emit(state.copyWith(isLoading: false, pop: true));
        _broadcast.stickyBroadcast("todo_view", value: true);
      } catch (e) {
        print("Error: $e");
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

    on<CompleteEvent>((event,emit) async {
      log("matchingTodos: $matchingTodos");
      try{
        log("completeTodoID: ${event.todoId}");
        await todoListRepo.completeATodo(event.todoId.toString(),"Completed");
        Utils.successMobileToast("Fix Task completed successfully");
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(state.copyWith(pop:true));
      }
      catch(e){
        print("catch error ${e.toString()}");
      }
    });

    on<DeleteEvent>((event, emit) async {
      try{
        log("deleteTodoID: ${event.todoId}");
        await todoListRepo.deleteATodo(event.todoId.toString(), event.reason!);
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(state.copyWith(pop:true));
      }
      catch(e){
        print("catch error ${e.toString()}");
      }
    });

  }
}