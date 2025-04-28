

import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:fbroadcast/fbroadcast.dart';
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
  final FBroadcast _broadcast = FBroadcast.instance();

  MaintenanceBloc()
      : super(const MaintenanceState(
    todoItems: {},
    vehicle: {},
    isLoading: false,
    maintenance: [],
    checkboxStates: {},
    pop: false,
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
        String? fixTasksJson = todoItem['fix_tasks'];//"{\"15\":43963}"
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
        log("${fixTasksMap}", name:'fixTasksMap');//{4: 43536, 5: 43537, 6: 43538}

        List<dynamic> fixTaskValues = fixTasksMap.values.toList();
        log("${fixTaskValues}", name:'fixTaskValues');//[43536, 43537, 43538]


        // In your MaintenanceBloc, modify the parseMaintenanceData function:
        List<Map<String, dynamic>> parseMaintenanceData(List<Map<String, dynamic>> todos) {
          List<Map<String, dynamic>> result = [];
          for (var todo in todos) {
            try {
              final maintenanceTaskId = todo["maintenance_task_id"]?.toString() ?? '';
              final notes = todo["notes"]?.toString() ?? '';
              final comments = todo["comments"]?.toString() ?? '';

              List<String> idParts = maintenanceTaskId.split('-');
              List<String> noteParts = notes.split('-');

              if (idParts.length >= 3) { // Ensure we have all required parts
                result.add({
                  "maintenanceId": int.tryParse(idParts[0]) ?? 0,
                  "itemId": int.tryParse(idParts[1]) ?? 0,
                  "childId": int.tryParse(idParts[2]) ?? 0,
                  "name": noteParts.length > 2 ? noteParts[2] : "Unknown",
                  "comments": comments,
                  "fixTaskId": todo['id'],
                });
              }
            } catch (e) {
              log("Error parsing todo: $e");
            }
          }
          return result;
        }

        matchingTodos = todoList
            .where((todo) => fixTaskValues.contains(todo['id']) && todo['status'] != "Completed")
            .map((todo) {
          String? maintenanceTaskId = todo["maintenance_task_id"];
          log("${maintenanceTaskId}", name:'maintenanceTaskId');
          if (maintenanceTaskId == null) return null;

          List<String> parts = maintenanceTaskId.trim().split("-");
          if (parts.length < 2) {
            print("Invalid maintenanceTaskId format: $maintenanceTaskId");
            return null;
          }
          String middleValue = parts[1];
          print("middleValue: $middleValue");
          middleValues.add(middleValue);

          return {
            "id": todo['id'],
            "maintenance_task_id": maintenanceTaskId,
            "notes": todo["notes"],
            "comments": todo["comments"],
          };
        }).where((todo) => todo != null)
            .cast<Map<String, dynamic>>()
            .toList();

        log("${matchingTodos}", name:'matchingTodos');

        parsedData = parseMaintenanceData(matchingTodos);
        log("${parsedData}", name:'parsedData');

        // Update selectedDropdownValues and checkboxStates based on parsedData
        for (var data in parsedData) {
          final itemId = data['itemId'];
          final status = data['name'].toString().toLowerCase();
          if (itemId != null) {
            selectedDropdownValues[itemId] = status == "bad" ? "Bad" : status; // Handle "Bad" explicitly
            checkboxStates[data['maintenanceId']]?[itemId] = status != "bad"; // Uncheck if "Bad"
            if (status != "good") {
              notesControllers[itemId]?.text = data['comments'] ?? "";
            }
          }
        }

        for (var data in matchingTodos) {
          try {
            if (data["maintenance_task_id"] != null) {
              String taskIdsStr = data["maintenance_task_id"];
              List<String> taskIds = taskIdsStr.trim().split("-").map((e) => e.trim()).toList();

              if (taskIds.length >= 2) {
                int secondTaskId = int.tryParse(taskIds[1]) ?? -1;
                if (secondTaskId != -1 && notesControllers.containsKey(secondTaskId)) {
                  String commentsValue = data["comments"];
                  notesControllers[secondTaskId]!.text = commentsValue;
                  log("${notesControllers[secondTaskId]!.text}", name:'notesControllers');
                }
              }
            }else {
              print("maintenance_task_id is null");
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
        print("Error fetching maintenance checklist: $error");
        emit(state.copyWith(isLoading: false));
      }
    });

    //First Checkbox "is all maintenance check done"
    on<IsAllMaintenanceCheckEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await todoListRepo.allCheckInMainteance(CreateFixTaskData()
          ..id = todoItemsCopy['id']
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
      updatedIndividualCheckStates[event.itemId] = event.status;
      log("Updated individualCheckStates: $updatedIndividualCheckStates", name: "INDIVIDUAL_CHECK");

      final updatedCheckboxStates = Map<int, Map<int, bool>>.from(state.checkboxStates);
      final maintenanceId = event.item?['id'] ?? 0;
      if (!updatedCheckboxStates.containsKey(maintenanceId)) {
        updatedCheckboxStates[maintenanceId] = {};
      }
      updatedCheckboxStates[maintenanceId]![int.parse(event.itemId)] = event.status;

      final updatedSelectedDropdownValues = Map<dynamic, String>.from(state.selectedDropdownValues);
      final childrenData = event.item?['children'];
      var childrens = List<Map<String, dynamic>>.from(childrenData ?? []);

      // Determine dropdown value based on checkbox state
      var badData = childrens.firstWhereOrNull(
            (element) => element['name'].toString().toLowerCase() == "bad",
      );
      log("$badData", name: "BAD_DATA");

      final newDropdownValue = event.status
          ? {"id": childrens.firstWhere((e) => e['name'].toString().toLowerCase() == "good", orElse: () => {"id": 99, "name": "Good"})['id'], "name": "Good"}
          : (badData ?? {"id": 51, "name": "Bad"}); // Use id 51 for "Bad" as per your data
      updatedSelectedDropdownValues[event.itemId] = newDropdownValue['name'];

      // Emit the updated state
      emit(state.copyWith(
        individualCheckStates: updatedIndividualCheckStates,
        checkboxStates: updatedCheckboxStates,
        selectedDropdownValues: updatedSelectedDropdownValues,
        dropdownValue: newDropdownValue,
      ));
    });

    //Create Fix Task
    on<createFixTaskEvent>((event, emit) async {
      try
      {
        await todoListRepo.createFixTask(CreateFixTaskData()
          ..userId = todoItemsCopy['user_id']
          ..userGroupId = int.tryParse(todoItemsCopy['user_group_id']?.toString() ?? '0') ?? 0
          ..todoId = event.todoId
          ..title = event.item == 64 ? 'Oil Change' : 'Fix'
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
          ..maintenanceTaskId = event.maintenanceTaskId
          ..vehicleNumber = vehiclesCopy['vehicle_number']);
        _broadcast.stickyBroadcast("todo_view", value: true);
      }
      catch(e)
      {
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
            List<int> taskIds = maintenanceTaskId.trim()
                .split("-")
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
        await todoListRepo.deleteATodo(deleteTodoID!,'');
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
            List<int> taskIds = maintenanceTaskId.trim()
                .split("-")
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

    //Private Rental Check



// Helper function to get matching todos
    List<Map<String, dynamic>> _getMatchingTodos({
      required List<Map<String, dynamic>> todoList,
      required Map<String, dynamic> fixTasksMap,
    }) {
      final fixTaskValues = fixTasksMap.values.toList();

      return todoList.where((todo) =>
      fixTaskValues.contains(todo['id']) &&
          todo['status'] != "Completed"
      ).map((todo) {
        final maintenanceTaskId = todo["maintenance_task_id"]?.toString() ?? '';
        return {
          "id": todo['id'],
          "maintenance_task_id": maintenanceTaskId,
          "notes": todo["notes"]?.toString() ?? '',
          "comments": todo["comments"]?.toString() ?? '',
        };
      }).toList();
    }

// Helper function to merge and clean data
    List<Map<String, dynamic>> _mergeAndCleanData({
      required List<Map<String, dynamic>> matchingTodos,
      required List<Map<String, dynamic>> checklistData,
    }) {
      final matchedDataMap = <String, Map<String, dynamic>>{};

      // Process matching todos
      for (final todo in matchingTodos) {
        final noteText = todo['notes'].replaceAll(RegExp(r'<[^>]*>'), '').trim();
        final parts = noteText.split('-');

        matchedDataMap[parts.first.trim()] = {
          'dbNote': parts.length > 1 ? parts[1].trim() : '',
          'todoId': todo['id'],
        };
      }

      // Process checklist data
      return checklistData.map((item) {
        final title = item['title']?.toString() ?? '';
        final matchedData = matchedDataMap[title];

        return {
          ...item,
          'isChecked': matchedData == null || matchedData['dbNote']?.isEmpty == true,
          'dbNote': matchedData?['dbNote'],
          'todoId': matchedData?['todoId'],
        };
      }).toList();
    }


  }

}


