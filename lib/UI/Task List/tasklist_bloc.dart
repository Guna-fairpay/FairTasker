

import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/Task%20List/task_list_repository.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_event.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  
  List<dynamic> userInitials = [];
  List<dynamic> groupUsers =[];
  List<dynamic> selectedUsers =[];
  List<Map<String,dynamic>> apiResponse =[];
  List<dynamic> userIDs=[];
  final TaskListRepository taskListRepo = TaskListRepository();
  List<Map<String,dynamic>> taskListData = [];

  TaskListBloc() : super(const TaskListState(pop: false)) {




    on<TaskListInitial>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final value = await taskListRepo.getTaskList(event.startDate, event.endDate);
        final groupResource = await taskListRepo.fetchUserGroupingList();
        final resource = await taskListRepo.getAssignedTo();
        
        apiResponse=value?.data ?? [];
        userInitials = resource?.resource ?? [];
        groupUsers = groupResource?.data ?? [];

        apiResponse = apiResponse.map((e) => e..["usersList"] = _getUsers(userId: e['user_id'], userGroupId: e['user_group_id'])).toList();
        apiResponse = apiResponse.map((e) => e..["usersName"] = List.from(e['usersList']).map((e) => <String>[(e['first_name'] ?? ""), (e['last_name'] ?? "")].toInitial).join(", ")).toList();

        log("$userIDs",name: 'UsersID');
        Console.of.log(jsonEncode(apiResponse));
        emit(state.copyWith(
          isLoading: false,
          data: apiResponse,
        ));
      } catch (error) {
        emit(state.copyWith(isLoading: false));
        log("Error in TaskListInitial: $error");
      }
    });

    on<HideSupportEvent>((event, emit) async {
      try {
        if(event.value){
          final filteredTasks = taskListData.where((task) =>task['todo_user_type'] != 1).toList();
          emit(state.copyWith(
              data: filteredTasks,
              hideSupport: true
          ));
        } else {
          emit(state.copyWith(
              data: taskListData,
              hideSupport: false
          ));
        }

      } catch (error) {
        log(error.toString());
      }
    });

    on<ExtraHoursEvent>((event, emit) async {
      List<Map<String, dynamic>> overtimeTakenData = [];
      List<Map<String, dynamic>> extraHoursData = [];
      try {
        if(event.value) {
          final taskExpenseData = await taskListRepo.getTask();
          int timeToMinutes(String timeString) {
            List<String> parts = timeString.split(':');
            int hours = int.parse(parts[0]);
            int minutes = int.parse(parts[1]);
            return hours * 60 + minutes;
          }
          void calculateOvertimeTaken(List<Map<String, dynamic>> expenseData,
              List<Map<String, dynamic>> filteredTasks)
          {
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

                int timeTaken = matchingRecord['time_taken'] is String
                    ? int.tryParse(matchingRecord['time_taken']) ?? 0
                    : 0;
                int completedTime = timeToMinutes(item['complete_time_taken']);
                if (completedTime != timeTaken && item['complete_time_approved'] == 0) {
                  int overtimeTaken = completedTime - timeTaken;
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
          calculateOvertimeTaken(taskExpenseData?.data ?? [], taskListData);
          extraHoursData.clear();
          extraHoursData = List.from(overtimeTakenData);
          //log("Final overtimeTakenData: $overtimeTakenData");
          log("Final taskListData: $extraHoursData");
          emit(state.copyWith(extraHours: true, data: extraHoursData));
        } else {
          emit(state.copyWith(extraHours: false,data: taskListData));
        }
      } catch (error) {
        log("Error in ExtraHoursEvent: ${error.toString()}");
        emit(state.copyWith(extraHours: false));
      }
    });

    on<TaskIncompleteEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try{
        emit(state.copyWith(isLoading: false));
        taskListData.sort((a, b) {
          return event.value
              ? a['complete_time_approved'].compareTo(b['complete_time_approved'])
              : b['complete_time_approved'].compareTo(a['complete_time_approved']);
        });
        log("TaskIncompleteEvent---->$taskListData");
        emit(state.copyWith(isLoading: false,data: taskListData,isAscending: event.value));
      }catch (e){
        log(e.toString());
      }
    });

    on<OffShoreTeamEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try{
        emit(state.copyWith(isLoading: false));
        taskListData.sort((a, b) {
          return event.value
            ? a['todo_user_type'].compareTo(b['todo_user_type'])
            : b['todo_user_type'].compareTo(a['todo_user_type']);
        });
        log("OffShoreTeamEvent---->$taskListData");
        emit(state.copyWith(isLoading: false,data: taskListData,offShore: event.value));
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


  }

  List<dynamic> _getUsers({dynamic userId, dynamic userGroupId}) {
    // userInitials; // RESOURCES
    // groupUsers; // GROUP PERSON
    // Console.of.log(userInitials);
    Console.of.warning("USERID: \t $userId, USERGROUPID: 	 $userGroupId");
    var userIds = [];
    if (userId.toString().isNotNullOrEmpty) {
      userIds.add(userId);
    } else if (userGroupId.toString().isNotNullOrEmpty) {
      var ids = List.from(jsonDecode(groupUsers.firstWhereOrNull((element) => element['id'] == userGroupId)?['userId'] ?? "")).map((e) => e.toString());
      userIds.addAll(ids);
    }
    Console.of.log(jsonEncode(userIds));
    return userInitials.where((user) => userIds.contains(user['id'].toString())).toList();
  }
}