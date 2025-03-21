

import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
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
  int? newItemId;
  List<int> idListAsInt = [];
  List<Map<String, dynamic>> matchingTodos = [];
  var itemCopy;
  List<int>? result;
  String? completeTodoID;
  String? deleteTodoID;

  MaintenanceBloc()
      : super(const MaintenanceState(
    todoItems: {},
    vehicle: {},
    isLoading: false,
    maintenance: [],
    checkboxStates: {},
    selectedDropdownValues: {},
    dropdownValue: null,
  ))
  {


    //Passing Initial items
    on<MaintenanceInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      List<String> middleValues = [];
      List<Map<String, dynamic>> matchingTodos = [];
      List<Map<String, dynamic>> parsedData = [];
      List<int> idListAsInt = [];

      try {
        final response = await todoListRepo.getMaintenanceCheckList();
        final response1 = await todoListRepo.getTodoList();
        if (response == null || response1 == null) {
          print("Response is null");
          emit(state.copyWith(isLoading: false));
          return;
        }

        todoItemsCopy = event.todoItem;
        vehiclesCopy = event.vehicle;
        final todoList = response1.data ?? [];
        final maintenanceCheckList = response.data ?? [];
        final checkboxStates = <int, Map<int, bool>>{};
        final selectedDropdownValues = <dynamic, String>{};
        final notesControllers = <int, TextEditingController>{};

        for (var maintenanceItem in maintenanceCheckList) {
          final maintenanceId = maintenanceItem['id'];
          if (maintenanceId == null) continue;
          checkboxStates[maintenanceId] = {};
          final children = maintenanceItem['children'] ?? [];
          for (var item in children) {
            final itemId = item['id'];
            if (itemId == null) continue;
            checkboxStates[maintenanceId]![itemId] = true;
            selectedDropdownValues[itemId] = "Good";
            notesControllers.putIfAbsent(itemId, () => TextEditingController());
          }
        }

        Map<String, dynamic> todoItem = event.todoItem;
        log("$todoItem",name: "TodoItems");
        log("${event.vehicle}",name: "Vehicles");
        String? fixTasksJson = todoItem['fix_tasks'];
        if (fixTasksJson == null) {
          print("fix_tasks is null");
          emit(state.copyWith(isLoading: false));
          final isAllCheck = event.todoItem['mandatory'] == 1 ? false : true;
          emit(state.copyWith(
            initialDropDown: parsedData,
            matchingTodos: matchingTodos,
            idList: idListAsInt,
            maintenance: maintenanceCheckList,
            checkboxStates: checkboxStates,
            selectedDropdownValues: selectedDropdownValues,
            notesControllers: notesControllers,
            isLoading: false,
            isAllCheck: isAllCheck,
            middleValues: middleValues,
          ));
          return;
        }

        Map<String, dynamic> fixTasksMap;
        try {
          fixTasksMap = jsonDecode(fixTasksJson);
        } catch (e) {
          print("Error decoding fixTasksJson: $e");
          emit(state.copyWith(isLoading: false));
          return;
        }

        List<dynamic> fixTaskValues = fixTasksMap.values.toList();

        List<Map<String, dynamic>> parseMaintenanceData(List<Map<String, dynamic>> todos) {
          try {
            List<Map<String, dynamic>> result = [];
            for (var todo in todos) {
              final maintenanceTaskId = todo["maintenance_task_id"];
              final notes = todo["notes"];
              final comments = todo["comments"];
              if (maintenanceTaskId == null || notes == null || comments == null) {
                continue; // Skip if any required field is null
              }
              List<dynamic> idList = maintenanceTaskId.split(" - ").map((e) => e.trim()).toList();
              List<dynamic> noteList = notes.split(" - ").map((e) => e.trim()).toList();
              for (int i = 0; i < idList.length; i++) {
                result.add({
                  "id": int.tryParse(idList[i]) ?? 0, // Handle invalid IDs
                  "name": i < noteList.length ? (noteList[i] ?? "") : "Unknown",
                  "comments": comments,
                  "fixTaskId": todo['id'],
                });
              }
            }
            return result;
          } catch (e) {
            print("error in parseMaintenanceData: $e");
            return [];
          }
        }

        matchingTodos = todoList
            .where((todo) => fixTaskValues.contains(todo['id']) && todo['status'] != "Completed")
            .map((todo) {
          String? maintenanceTaskId = todo["maintenance_task_id"];
          if (maintenanceTaskId == null) return null;
          String middleValue = maintenanceTaskId.split(" - ")[1];
          middleValues.add(middleValue);
          return {
            "id": todo['id'],
            "maintenance_task_id": maintenanceTaskId,
            "notes": todo["notes"],
            "comments": todo["comments"],
          };
        })
            .where((todo) => todo != null)
            .cast<Map<String, dynamic>>()
            .toList();

        parsedData = parseMaintenanceData(matchingTodos);

        for (var data in matchingTodos) {
          try {
            if (data["maintenance_task_id"] != null) {
              String taskIdsStr = data["maintenance_task_id"];
              List<String> taskIds = taskIdsStr.split(" - ").map((e) => e.trim()).toList();
              if (taskIds.length >= 2) {
                int secondTaskId = int.tryParse(taskIds[1]) ?? -1;
                if (secondTaskId != -1 && notesControllers.containsKey(secondTaskId)) {
                  String commentsValue = data["comments"];
                  notesControllers[secondTaskId]!.text = commentsValue;
                }
              }
            }
          } catch (e) {
            print("Error parsing maintenance_task_id: $e");
          }
        }

        String? maintenanceTaskId = event.todoItem['maintenance_task_id']?.toString();
        if (maintenanceTaskId != null) {
          idListAsInt = maintenanceTaskId
              .split('-')
              .where((id) => id.trim().isNotEmpty)
              .map((id) => int.tryParse(id) ?? 0)
              .where((id) => id != 0)
              .toList();
        }

        final isAllCheck = event.todoItem['mandatory'] == 1 ? false : true;
        emit(state.copyWith(
          initialDropDown: parsedData,
          matchingTodos: matchingTodos,
          idList: idListAsInt,
          maintenance: maintenanceCheckList,
          checkboxStates: checkboxStates,
          selectedDropdownValues: selectedDropdownValues,
          notesControllers: notesControllers,
          isLoading: false,
          isAllCheck: isAllCheck,
          middleValues: middleValues,
        ));
      } catch (error) {
        print("Error fetching checklist: $error");
        emit(state.copyWith(isLoading: false));
      }
    });

    //First Checkbox "is all maintenance check done"
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

    //Multiple Checkbox
    on<IndividualCheckEvent>((event, emit) {
        final updatedIndividualCheckStates = Map<String, bool>.from(state.individualCheckStates);
        print("updatedIndividualCheckStates ${state.individualCheckStates}");
        updatedIndividualCheckStates[event.itemId] = event.status;//{Oil: false, Coolant: false, Front : false, Rear: false, Front: false,}
        print("Updated maintenanceTaskId: $updatedIndividualCheckStates");
        print("IndividualCheckEvent ${event.item}");
        Map<String, dynamic> popupId = event.item ?? {};
        print("popupId data ${popupId}");
        itemCopy = event.item;
        var childrenData = event.item?['children'];
        var childrens = List<Map<String, dynamic>>.from(childrenData ?? []);
        var goodData = childrens.firstWhereOrNull((element) => element['name'].toString().toLowerCase() == ( (event.status) ? "good" : "bad"));


        newItemId = int.parse(event.itemId);
        if (event.status == true && !idListAsInt.contains(newItemId)) {
          idListAsInt.add(newItemId!);
        }
        if (event.status == false && idListAsInt.contains(newItemId)) {
          idListAsInt.remove(newItemId);
        }
        maintenanceTaskId = idListAsInt.map((id) => id.toString()).join('-'); //7-8-6
        print("Updated maintenanceTaskId: $maintenanceTaskId");
        var dropDownData = goodData;
        log("$dropDownData", name: "GOOD_DATA");

        List<int> getMatchingIds(Map<String, dynamic> checkEvent, List<Map<String, dynamic>> maintenanceTasks) {
          List<int> matchingIds = [];

          // Extract relevant IDs from IndividualCheckEvent
          int parentId = checkEvent["id"];
          List<int> childIds = (checkEvent["children"] as List)
              .map((child) => child["id"] as int)
              .toList();

          for (var task in maintenanceTasks) {
            String maintenanceTaskId = task["maintenance_task_id"];
            List<int> taskIds = maintenanceTaskId
                .split(" - ")
                .map((id) => int.tryParse(id) ?? -1)
                .where((id) => id != -1)
                .toList();

            // Check if the task IDs match the hierarchy (parent + child)
            if (taskIds.contains(parentId) && taskIds.any((id) => childIds.contains(id))) {
              matchingIds.add(task["id"]);
            }
          }
          return matchingIds;
        }

        for (var task in matchingTodos) {
          String maintenanceTaskId = task['maintenance_task_id'];
          List<String> taskIdParts = maintenanceTaskId.split(' - ');
          int parentId = int.tryParse(taskIdParts[1]) ?? 0;
          int childId = int.tryParse(taskIdParts[2]) ?? 0;

          print('Parent ID: $parentId, Child ID: $childId');
        }
        print("final value1 ${itemCopy}");
        print("final value2 ${matchingTodos}");
        List<int> result = getMatchingIds(itemCopy, matchingTodos);
        print("final value3 ${result}");

        emit(state.copyWith(
          popupId: popupId,
          individualCheckStates: updatedIndividualCheckStates,
          dropdownValue: dropDownData,
        ));
    });

    //Create Fix Task
    on<createFixTaskEvent>((event, emit) async {
      print("${todoItemsCopy['user_id']} ${todoItemsCopy['user_group_id']} ${event.item} ${event.maintenanceTaskId} ${event.notes}"
          "${event.comments} ${todoItemsCopy['todo_time']} ${todoItemsCopy['todo_date']} ${event.item} ${todoItemsCopy['vehicles']}"
          "${todoItemsCopy['location']} ${todoItemsCopy['location_id']} ${todoItemsCopy['vendor_id']} ${todoItemsCopy['vendor_name']}"
          "${vehiclesCopy['vehicle_number']}");
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
        add(const MaintenanceInitialEvent(todoItem: {}, vehicle: {}));
      }
      catch(e){
        print("catch error ${e.toString()}");
      }
    });


    on<DropDownOptionEvent>((event, emit) async {
      log("event.linkOption ${event.linkOption}");
      emit(state.copyWith(dropdownValue: event.linkOption));
    });

    on<DeleteTodoItemEvent>((event, emit) async {
      try{
        print("result.toString() ${result.toString()}");
        List<int> getMatchingIds(Map<String, dynamic> checkEvent, List<Map<String, dynamic>> maintenanceTasks) {
          List<int> matchingIds = [];

          // Extract relevant IDs from IndividualCheckEvent
          int parentId = checkEvent["id"];
          List<int> childIds = (checkEvent["children"] as List)
              .map((child) => child["id"] as int)
              .toList();

          for (var task in maintenanceTasks) {
            String maintenanceTaskId = task["maintenance_task_id"];
            List<int> taskIds = maintenanceTaskId
                .split(" - ")
                .map((id) => int.tryParse(id) ?? -1)
                .where((id) => id != -1)
                .toList();

            // Check if the task IDs match the hierarchy (parent + child)
            if (taskIds.contains(parentId) && taskIds.any((id) => childIds.contains(id))) {
              matchingIds.add(task["id"]);
            }
          }

          return matchingIds;
        }
        result = getMatchingIds(itemCopy, matchingTodos);
        print("final value ${result}");
        deleteTodoID = result?.first.toString();
        print("final value ${deleteTodoID}");
        await todoListRepo.deleteATodo(deleteTodoID!);
      }
      catch(e){
        print("catch error ${e.toString()}");
      }
    });

    on<CompleteTodoItemEvent>((event,emit) async {
      try{
        List<int> getMatchingIds(Map<String, dynamic> checkEvent, List<Map<String, dynamic>> maintenanceTasks) {
          List<int> matchingIds = [];
          // Extract relevant IDs from IndividualCheckEvent
          int parentId = checkEvent["id"];
          List<int> childIds = (checkEvent["children"] as List)
              .map((child) => child["id"] as int)
              .toList();
          for (var task in maintenanceTasks) {
            String maintenanceTaskId = task["maintenance_task_id"];
            List<int> taskIds = maintenanceTaskId
                .split(" - ")
                .map((id) => int.tryParse(id) ?? -1)
                .where((id) => id != -1)
                .toList();
            // Check if the task IDs match the hierarchy (parent + child)
            if (taskIds.contains(parentId) && taskIds.any((id) => childIds.contains(id))) {
              matchingIds.add(task["id"]);
            }
          }

          return matchingIds;
        }
        result = getMatchingIds(itemCopy, matchingTodos);
        completeTodoID = result?.first.toString();
        print("final value ${completeTodoID}"); // Output: [33646]
        //Api Update Part
        await todoListRepo.completeATodo(completeTodoID,"Completed");
      }
      catch(e){
        print("catch error ${e.toString()}");
      }
    });


  }

}


