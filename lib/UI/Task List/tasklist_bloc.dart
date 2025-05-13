

import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/Task%20List/task_list_repository.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_event.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

import '../../Utilities/appC.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  
  List<dynamic> userInitials = [];
  List<dynamic> userListData = [];
  List<dynamic> groupUsers =[];
  List<dynamic> selectedUsers =[];
  List<Map<String,dynamic>> initialData =[];
  List<Map<String,dynamic>> apiResponse =[];
  List<Map<String,dynamic>> groupVehicleData =[];
  List<Map<String,dynamic>> taskExpense =[];
  List<Map<String,dynamic>> vehicleData =[];
  List<dynamic> userIDs=[];
  final TaskListRepository taskListRepo = TaskListRepository();
  List<Map<String, dynamic>> extraHoursCheckData = [];
  List<Map<String, dynamic>> overtimeTakenData = [];
  List<Map<String, dynamic>> extraHoursData = [];
  bool isAscending = false;
  bool offShore = false;

  TaskListBloc() : super(TaskListState(
      pop: false,
    isAscending: false,
    offShore: false,
    selectedDateRange: DateRange(
      DateTime.now().subtract(const Duration(days: 7)),
      DateTime.now(),
    ),
  ))
  {

    on<TaskListInitial>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final value = await taskListRepo.getTaskList(event.startDate, event.endDate);
        final groupResource = await taskListRepo.fetchUserGroupingList();
        final groupVehicle = await taskListRepo.getVehicleGroupData();
        final usersList = await taskListRepo.getUsers();
        final taskExpenseData = await taskListRepo.getTask();
        final vehicle = await taskListRepo.fetchVehicleList();
        vehicleData = vehicle?.data ?? [];
        taskExpense = taskExpenseData?.data ?? [];
        userListData = usersList?.data ?? [];
        groupVehicleData = groupVehicle?.vehicleGroupData ?? [];
        apiResponse = value?.data ?? [];
        groupUsers = groupResource?.data ?? [];

        apiResponse = apiResponse.map((e) => e..["usersList"] = _getUsers(userId: e['user_id'], userGroupId: e['user_group_id'])).toList();
        apiResponse = apiResponse.map((e) => e..["usersName"] =
                                                List.from(e['usersList']).map((e) => <String>[
                                                  (e['first_name'] ?? ""),
                                                  (e['last_name'] ?? "")].toInitial).join(", ")).toList();
        apiResponse = apiResponse.map((e) => e..["time_taken"] = e['complete_time_taken'] != null ? overTime(taskExpense,apiResponse,e['complete_time_taken']) : "").toList();

        calculateAndAddOvertime(apiResponse, taskExpense, vehicleData);
        emit(state.copyWith(
          isLoading: false,
          data: apiResponse,
          groupVehicle: groupVehicleData,
          taskExpense: taskExpense,
        ));

        if (state.hideSupport) {
          emit(state.copyWith(data: apiResponse.where((task) => task['todo_user_type'] != 1).toList()));
        }

        if (state.extraHours) {
          var copy = List<Map<String, dynamic>>.from(taskExpense);
          calculateOvertimeTaken(copy, apiResponse);
          extraHoursData = List.from(overtimeTakenData);
          emit(state.copyWith(data: extraHoursData));
        }

      } catch (error) {
        emit(state.copyWith(isLoading: false));
        log("Error in TaskListInitial: $error");
      }
    });

    on<HideSupportEvent>((event, emit) async {
      try {
        List<Map<String, dynamic>> newData;
        if (event.value) {
          newData = state.data.where((task) => task['todo_user_type'] != 1).toList();
        } else {
          newData = state.extraHours
              ? overtimeTakenData
              : apiResponse;
        }
        emit(state.copyWith(
          data: newData,
          hideSupport: event.value,
        ));
      } catch (error) {
        log("HideSupportEvent Error: $error");
      }
    });

    on<ExtraHoursEvent>((event, emit) async {
      try {
        List<Map<String, dynamic>> newData = [];
        newData.clear();
        if (event.value) {
          var copy = List<Map<String, dynamic>>.from(state.taskExpense);
          calculateOvertimeTaken(copy, apiResponse);
          newData = List.from(overtimeTakenData);

          if (state.hideSupport) {
            newData = newData.where((task) => task['todo_user_type'] != 1).toList();
          }
        } else {
          newData = state.hideSupport
              ? apiResponse.where((task) => task['todo_user_type'] != 1).toList()
              : apiResponse;
        }
        emit(state.copyWith(
          data: newData,
          extraHours: event.value,
        ));
      } catch (error) {
        log("ExtraHoursEvent Error: $error");
      }
    });

    on<TaskIncompleteEvent>((event, emit) async {
      try{
        List<Map<String, dynamic>> TaskIncomplete = [];
        TaskIncomplete.clear();
        TaskIncomplete.addAll(apiResponse);
        //TaskIncomplete.sort((a, b) => b['todo_date'].toString().toDateTime()?.compareTo(a['todo_date'].toString().toDateTime() ?? DateTime.now()) ?? 0);
        var inComplete = TaskIncomplete.where((element) => element['complete_time_approved'] == 0);
        var completed = TaskIncomplete.where((element) => element['complete_time_approved'] == 1);
        if(event.value) {
          if(state.offShore){
            add(OffShoreTeamEvent(value: false));
          }
          log("${event.value} ---> ");
          TaskIncomplete = [...inComplete, ...completed];
          emit(state.copyWith(data: TaskIncomplete,isAscending: event.value));
          log("Ascending triggered ---> ");
        } else {
          log("${event.value} ---> ");
          //apiResponse = [...completed, ...inComplete];
          // apiResponse.sort((a,b) => b['complete_time_approved'].compareTo(a['complete_time_approved']));
          emit(state.copyWith(data: apiResponse,isAscending: event.value));
          log("Rollback triggered ---> ");
        }
      }catch (e){
        log(e.toString());
      }
    });

    on<OffShoreTeamEvent>((event, emit) async {
      try{
        List<Map<String, dynamic>> OffShoreTeamData = [];
        OffShoreTeamData.clear();
        OffShoreTeamData.addAll(apiResponse);
        var offShore = OffShoreTeamData.where((element) => element['todo_user_type'] == 1);
        var inOffShore = OffShoreTeamData.where((element) => element['todo_user_type'] != 1);
        if(event.value){
          if(state.isAscending){
            add(OffShoreTeamEvent(value: false));
          }
          log("${event.value} ---> ");
          OffShoreTeamData = [...offShore, ...inOffShore];
          //apiResponse.sort((a, b) => b['todo_user_type'].compareTo(a['todo_user_type']));
          emit(state.copyWith(data: OffShoreTeamData,offShore: event.value));
          log("Ascending triggered ---> ");
        } else {
          log("${event.value} ---> ");
          //apiResponse.sort((a, b) => a['todo_user_type'].compareTo(b['todo_user_type']));
          emit(state.copyWith(data: apiResponse,offShore: event.value));
          log("Rollback triggered ---> ");
        }
      } catch (e) {
        log(e.toString());
      }
    });

    on<individualCheckEvent>((event, emit) async {
      try{
        log("${event.id} ${event.value} ------eventval");
        emit(state.copyWith(isLoading: true));
        await taskListRepo.approveTodo(
          event.value ? 1 : 0,
          event.id,
        );
        apiResponse.forEach((element) {
          if (element['id'] == event.id) {
            element['complete_time_approved'] = event.value ? 1 : 0;
          }
        });
        emit(state.copyWith(isLoading: false, isChecked: event.value, data: apiResponse));
      }
      catch (e){
        log(e.toString());
      }
    });

    on<UpdateDateRangeEvent>((event, emit) {
      emit(state.copyWith(selectedDateRange: event.selectedRange));
    });


  }



  List<dynamic> _getUsers({dynamic userId, dynamic userGroupId}) {
    // userInitials; // RESOURCES
    // groupUsers; // GROUP PERSON
    // Console.of.log(userInitials);
    //Console.of.warning("USERID: \t $userId, USERGROUPID: 	 $userGroupId");
    var userIds = [];
    if (userId.toString().isNotNullOrEmpty) {
      userIds.add(userId);
    } else if (userGroupId.toString().isNotNullOrEmpty) {
      var ids = List.from(jsonDecode(groupUsers.firstWhereOrNull((element) => element['id'] == userGroupId)?['userId'] ?? "")).map((e) => e.toString());
      userIds.addAll(ids);
    }
    //Console.of.log(jsonEncode(userIds));
    return userListData.where((user) => userIds.contains(user['id'].toString())).toList();
  }

  int timeToMinutes(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  String overTime(List<Map<String, dynamic>> expenseData,List<Map<String, dynamic>> filteredTasks, String timeTaken) {
    for (var item in filteredTasks) {
      if (item['complete_time_taken'] != null) {
        String taskName = item['title'];

        dynamic matchingRecord = expenseData.firstWhere(
              (record) =>
          record['task'] == taskName,
          orElse: () => {},
        );
        if (matchingRecord == null) continue;

        int actualTime = matchingRecord['time_taken'] is String
            ? int.tryParse(matchingRecord['time_taken']) ?? 0
            : 0;
        int completedTime = timeToMinutes(timeTaken);
        //log("timeTaken ${completedTime} actualTime ${actualTime}", name: "overTime_Before");
        if (completedTime < actualTime) {
          int overtimeTaken = actualTime - completedTime;
          //log("timeTaken ${completedTime} actualTime ${actualTime} remainingTime ${overtimeTaken}",name: "overTime_Extra_true");
          int hours = overtimeTaken ~/ 60;
          int remainder_minutes = overtimeTaken % 60;

          return '${hours.toString().padLeft(2, '0')}:${remainder_minutes.toString().padLeft(2, '0')}'; // Format as HH:MM
        }
        else if(completedTime > actualTime){
          int overtimeTaken = completedTime - actualTime;
          log("timeTaken ${completedTime} actualTime ${actualTime} remainingTime ${overtimeTaken}",name: "overTime_Extra_false");
          int hours = overtimeTaken ~/ 60;
          int remainder_minutes = overtimeTaken % 60;
          return '${hours.toString().padLeft(2, '0')}:${remainder_minutes.toString().padLeft(2, '0')}'; // Format as HH:MM
        } else {
          return "";
        }
      }
    }
    return "";
  }


  void calculateOvertimeTaken(List<Map<String, dynamic>> expenseData,
      List<Map<String, dynamic>> filteredTasks)
  {
    overtimeTakenData.clear();
    for (var item in filteredTasks) {
      if (item['complete_time_taken'] != null) {
        String taskName = item['title'].contains('-')
            ? item['title'].split('-')[0].toLowerCase().replaceAll(' ', '')
            : item['title'].toLowerCase().replaceAll(' ', '');

        dynamic matchingRecord = expenseData.firstWhere(
              (record) =>
          record['task'].toLowerCase().replaceAll(' ', '') == taskName,
          orElse: () => {},
        );
        if (matchingRecord == null) continue;

        int actualTime = matchingRecord['time_taken'] is String
            ? int.tryParse(matchingRecord['time_taken']) ?? 0
            : 0;
        //log("actualTime ${actualTime} time_taken ${timeToMinutes(item['complete_time_taken'])}",name: "overTime");
        int completedTime = timeToMinutes(item['complete_time_taken']);
        if (completedTime != actualTime && item['complete_time_approved'] == 0) {
          int overtimeTaken = completedTime - actualTime;
          //log("timeTaken ${completedTime} actualTime ${actualTime} remainingTime ${overtimeTaken}",name: "overTime");
          int hours = overtimeTaken ~/ 60;
          int remainder_minutes = overtimeTaken % 60;
          Map<String, dynamic> fullRecord = Map<String, dynamic>.from(item);
          fullRecord['overtime'] =
          '${hours.toString().padLeft(2, '0')}:${remainder_minutes.toString().padLeft(2, '0')}'; // Format as HH:MM
          overtimeTakenData.add(fullRecord);
        }
      }
    }
  }

  List<Map<String, dynamic>> calculateAndAddOvertime(List<Map<String, dynamic>> apiResponse,
      List<Map<String, dynamic>> expenseData, List<Map<String, dynamic>> vehicleData)
  {
     return apiResponse.map((task) {
      // complete_time_taken exists
      if (task['complete_time_taken'] != null) {
        String taskName = task['title'].contains('-')
            ? task['title'].split('-')[0].toLowerCase().replaceAll(' ', '')
            : task['title'].toLowerCase().replaceAll(' ', '');

        dynamic matchingRecord = expenseData.firstWhere(
              (record) =>
          record['task'].toLowerCase().replaceAll(' ', '') == taskName,
          orElse: () => {},
        );

        if (matchingRecord != null && matchingRecord.isNotEmpty) {
          int timeTaken = matchingRecord['time_taken'] is String
              ? int.tryParse(matchingRecord['time_taken']) ?? 0
              : matchingRecord['time_taken'] ?? 0;

          int completedTime = timeToMinutes(task['complete_time_taken']);

          if (completedTime != timeTaken && task['complete_time_approved'] == 0) {
            int overtimeTaken = completedTime - timeTaken;
            int hours = overtimeTaken ~/ 60;
            int remainder_minutes = overtimeTaken % 60;
            task['overtime'] =
            '${hours.toString().padLeft(2, '0')}:${remainder_minutes.toString().padLeft(2, '0')}';
          } else if(completedTime != timeTaken && task['complete_time_approved'] == 1){
            int leftOverTime = completedTime - timeTaken;
          }
          else {
            task['overtime'] = '';
          }
        } else {
          task['overtime'] = '';
        }
      } else {
        task['overtime'] = '';
      }
      if (task['user_id'] != null && task['user_group_id'] != null) {
        task['usersList'] = _getUsers(
            userId: task['user_id'],
            userGroupId: task['user_group_id']
        );
      }
      if (task['vehicles'] != null && task['vehicles'].isNotEmpty) {
        final vin = task['vehicles'][0]['vin'];
        final status = _getRentalStatus(vin, vehicleData);
        task['rental_status'] = status['text'];
        task['rental_status_color'] = status['color'];
      } else {
        task['rental_status'] = '';
      }

      return task;
    }).toList();
  }


  Map<String, dynamic> _getRentalStatus(String item, List<Map<String, dynamic>> vehicleData){

    final matchedData = vehicleData.firstWhereOrNull((element) => element['vin'].toString() == item)?['rental_status'] ?? '';

    switch (matchedData) {
      case 1:
        return {'text': '(T)', 'color' : Colors.black};
      case 2:
        return {'text': '(U)', 'color' : const Color(0xFF90EE90)};
      case 3:
        return {'text': '(P)', 'color' : const Color(0xFFFFCC99)};
      case 4:
        return {'text': '(G)', 'color' : const Color(0xFFFFB6C1)};
      default:
        return {};
    }
  }


}