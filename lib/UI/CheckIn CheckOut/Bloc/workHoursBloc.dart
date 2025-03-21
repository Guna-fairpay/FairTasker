
// working_hours_bloc.dart
import 'dart:developer';
import 'package:date_time/date_time.dart' hide DateRange;
import 'package:flutter/cupertino.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Repository/job_list_repository.dart';
import '../../../Repository/todo_list_repository.dart';
import '../Event/workingHoursEvent.dart';
import '../Repository/workingHoursRepository.dart';
import '../State/workingHoursState.dart';



class WorkingHoursBloc extends Bloc<WorkingHoursEvent, WorkingHoursState> {
  final TaskRepository taskRepo = TaskRepository();
  final TodoListRepo todoListRepo = TodoListRepo();
  final JobListRepo authenticationRepo = JobListRepo();
  DateRange? selectedDateRange;
  List<Map<String, dynamic>> formattedResources=[];
  List<Map<String, dynamic>> resources=[];
  List<Map<String, dynamic>> workHours = [];
  List<Map<String, dynamic>> workingHistory = [];
  List<Map<String, dynamic>> workActiveHours = [];
  List<Map<String, dynamic>> combinedData=[];
  List<Map<String, dynamic>> dropDownData=[];
  List<String> activeHours = [];
  List<int> totalHoursValue = [];
  List<Map<String, dynamic>> taskComponentsData=[];
  List<Map<String, dynamic>> taskBased = [];
  List<Map<String, dynamic>> hourlyBased = [];
  TextEditingController taskNameCtrl=TextEditingController();
  TextEditingController amountCtrl=TextEditingController();
  final TextEditingController dateController = TextEditingController();
  List<Map<String,dynamic>>?selectedResources=[];


  WorkingHoursBloc() : super(const WorkingHoursState (
      userList: [],
      selectedUser: {}
  )) {

    on<WorkingHoursInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try
      {
        DateTime now = DateTime.now();
        DateTime start = now.subtract(const Duration(days: 7));
        DateTime end = now;
        selectedDateRange = DateRange(start, end);
        String startDate =  event.minDate.toString();
        String endDate = event.maxDate.toString();
        if(startDate.isNotEmpty || endDate.isNotEmpty)
          {
            final response1 = await todoListRepo.getWorkingHistory(startDate, endDate);//no need
            final response2 = await todoListRepo.getActiveHoursResponse(startDate, endDate);
            final response3 = await authenticationRepo.getAssignedTo();
            final response4 = await todoListRepo.getWorkingHoursData(startDate, endDate);
            final response5 = await todoListRepo.getWorkingHistoryCount(startDate, endDate);
            if (response1 != null && response2 != null && response3 != null && response4 != null) {
              workingHistory.clear();
              workingHistory = response5!.history!;//1
              workHours.clear();
              workHours = response4.data!;//2
              resources.clear();
              resources=response3.resource!;//3
              workActiveHours.clear();
              workActiveHours = response2.data!;//4

              formattedResources = resources.map((resource) {
                return {
                  'id': resource['id'],
                  'full_name': "${resource['first_name']} ${resource['last_name']}",
                  'first_name': '${resource['first_name']}',
                };
              }).toList();

              //Helper Function
              String getFirstWord(String fullName) {
                return fullName.split(' ').first;
              }

              List<Map<String, dynamic>> combineData(
                  List<Map<String, dynamic>> workhours,
                  List<Map<String, dynamic>> workhistory,
                  List<Map<String, dynamic>> workActivehours,
                  List<Map<String, dynamic>> formattedResource,
                  )
              {
                List<Map<String, dynamic>> combinedList = [];
                Map<String, dynamic> combinedItem={};
                combinedList.clear();
                for (var workhour in workhours)
                {
                  final userId = workhour['user']['id'];
                  final userName = workhour['user']['name'];
                  if(userId==null)
                  {
                    continue;
                  }
                  Map<String, dynamic>? historyItem; // Initialize to null
                  for (var item in workhistory) {
                    if (item['users'] != null && item['users']['hrm_id'] == userId) {
                      historyItem = item; // Assign the matching item
                      break;
                    }
                  }
                  Map<String, dynamic>? activeHoursItem;
                  for (var item in workActivehours) {
                    if (item['active_hours'] != "00:00" && item['hrm_id'] == userId) {
                      activeHoursItem = item; // Assign the matching item
                      break;
                    }
                  }
                  Map<String, dynamic>? empID;
                  for (var item in formattedResource) {
                    if (getFirstWord(item['full_name']) == getFirstWord(userName)) {
                      empID = item;
                      break;
                    }
                  }
                  final taskCount = historyItem?['task_count'] ?? 0;
                  final activeHours = activeHoursItem?['active_hours'] ?? "00:00";
                  if (taskCount == 0 && activeHours == "00:00") {
                    continue;
                  }
                  combinedItem = {
                    'id': userId,
                    'empID':historyItem?['users']['id'],
                    'hrmID': historyItem?['users']['hrm_id'] ?? 0,
                    'total_working_hours': workhour['user']['total_working_hours'],
                    'list': workhour['user']['list'],
                    'task_count': historyItem?['task_count'] ?? 0,
                    'first_name': workhour['user']['name'] ?? '',
                  };
                  combinedList.add(combinedItem);
                }
                return combinedList;
              }
              combinedData.clear();
              combinedData = combineData(workHours, workingHistory, workActiveHours, formattedResources);
              //log("${combinedData}",name:"CombinedData");

              //Active Hours Calculation Start
              int timeStringToMinutes(String time) {
                final minutes = Time.fromStr(time)?.inMins;
                return minutes!;
              }
              String minutesToTimeString(int minutes) {
                final hours = minutes ~/ 60;
                final remainingMinutes = minutes % 60;
                return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
              }

              String calculateActiveHours(List<Map<String, dynamic>> employeeActiveTotalHours, Map<String, dynamic> item)
              {
                final relevantHours = employeeActiveTotalHours.where(
                      (activeHour) => activeHour['hrm_id']?.toString() == item['id']?.toString(),
                );
                final int totalMinutes = relevantHours.fold(
                  0, (total, current) => total + timeStringToMinutes(current['active_hours']),
                );
                return minutesToTimeString(totalMinutes);
              }
              //Active Hours Calculation End

              //Total Hours(#) Calculation Start
              for(var employee in combinedData){
                int lessCount = 0;
                int greaterCount = 0;
                if (employee['list'] != null) {
                  for (var task in employee['list']) {
                    final taskTotalHours = task['total_hours']?.split(':') ?? ['0', '0'];
                    final int taskHours = int.tryParse(taskTotalHours[0]) ?? 0;
                    final int taskMinutes = int.tryParse(taskTotalHours[1]) ?? 0;
                    final int totalMinutes = taskHours * 60 + taskMinutes;
                    if (totalMinutes < 420) {
                      lessCount++;
                    } else if (totalMinutes > 540) {
                      greaterCount++;
                    }
                  }
                }
                print("Total hours ${lessCount + greaterCount}");
                totalHoursValue.clear();
                totalHoursValue.add(lessCount + greaterCount);
                print("Total hours value ${totalHoursValue}");
                activeHours.add(calculateActiveHours(workActiveHours, employee));
              }
              //Total Hours(#) Calculation End

              emit(state.copyWith(
                isLoading: false,
                combinedData: combinedData,
                workActiveHours: workActiveHours,
                activeHours: activeHours,
                totalHoursValue: totalHoursValue,
                resources: formattedResources,
                startDate: startDate,
                endDate: endDate,
                selectedDateRange: selectedDateRange,
              ));
            }
            else {
              print("Response is null");
            }
          } else {
          emit(state.copyWith(isLoading: false));
          print("Error: startDate ${startDate} or endDate ${endDate} is empty");
        }

        emit(state.copyWith(
          isLoading: false,
          combinedData: combinedData,
          workActiveHours: workActiveHours,
          activeHours: activeHours,
          totalHoursValue: totalHoursValue,
          resources: formattedResources,
          startDate: startDate,
          endDate: endDate,
          selectedDateRange: selectedDateRange,
        ));
      }
      catch (error)
      {
        print("Error on initial event: $error");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<ResourceDropDownEvent>((event, emit) async {
      try{
        String getFirstWord(String fullName) {
          return fullName.split(' ').first;
        }
        dropDownData = (event.selectedName['full_name'] == 'All'
            ? state.combinedData
            : state.combinedData?.where((item) {
          return getFirstWord(item['first_name']) == getFirstWord(event.selectedName['full_name']);
        }).toList())!;

        emit(state.copyWith(dropDownData: dropDownData));
      } catch (error) {
        print("Error on ResourceDropDownEvent: $error");
      }
    });

    //Task Components - Settings Page
    on<TaskComponentsInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try{
        List<dynamic> resource;
        emit(state.copyWith(isLoading: false));
        final response6 = await todoListRepo.getTaskHistoryConfiguration();
        final response3 = await authenticationRepo.getAssignedTo();
        if(response6 != null && response3 != null){
          taskComponentsData = response6.data!;
          resources = response3.resource!;

          formattedResources = resources.map((resource) {
            return {
              'id': resource['id'],
              'full_name': "${resource['first_name']} ${resource['last_name']}",
              'first_name': '${resource['first_name']}',
            };
          }).toList();

          List<Map<String, dynamic>> resource = formattedResources.map((resource) {
            return {
              'id': resource['id'],
              'full_name': '${resource['full_name']}',
              'first_name': '${resource['first_name']}'
              };
          }).toList();
          taskBased = taskComponentsData.where((task) => task['type'] == 'task').toList();
          hourlyBased = taskComponentsData.where((task) => task['type'] == 'hourly').toList();

          List<Map<String, dynamic>> base = [
            {"id":1,"base": "Task based"},
            {"id":2,"base": "Hour based"}
          ];
          dynamic selectedBase = base[0];
          emit(state.copyWith(
            taskComponentsData: taskComponentsData,
            taskBased: taskBased,
            hourlyBased: hourlyBased,
            selectedBase1: base,
            selectedBase: selectedBase,
            resources: formattedResources,
            resource: resource,
          ));
          // print("Emitting initial selectedBase1: $selectedBase1");
        } else {
          emit(state.copyWith(isLoading: false));
        }
      }
      catch(error){
        emit(state.copyWith(isLoading: false));
        print("Error on TaskComponentsInitialEvent: $error");
      }
    });


    on<DeleteTaskComponentsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try{
        await todoListRepo.deleteTaskConfiguration(event.id).then((value) {
          add(const TaskComponentsInitialEvent());
        });
      }
      catch(error){
        emit(state.copyWith(isLoading: false));
        print("Error on DeleteTaskComponentsEvent: $error");
      }
    });

    //Create Update
    on<CreateTaskEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try{
        await todoListRepo.addTaskConfiguration(event.id,event.userId,event.taskName,event.amount,event.task);
        add(const TaskComponentsInitialEvent());
      } catch (error){
        emit(state.copyWith(isLoading: false));
        print("Error on CreateTaskEvent: $error");
      }
    });


    on<UpdateTaskEvent>((event, emit) async {
      print("UpdateTaskEvent called ${event.id} ${event.taskName} ${event.amount} ${event.userId}");
      List<Map<String, dynamic>> base = [
        {"id":1,"base": "Task based"},
        {"id":2,"base": "Hour based"}
      ];
      final apiResponse = await authenticationRepo.getAssignedTo();
      var userListData = apiResponse?.resource;
      dynamic selectedUser = userListData?.firstWhere(
            (resource) => resource['id'] == event.userId,
        orElse: () => {},
      );
      log("${selectedUser}",name: 'TEST1');
      if(event.userId == null)
        {
          taskNameCtrl.text = event.taskName ?? '';
          amountCtrl.text = event.amount ?? '';
          dynamic selectedBase = base[0];
          log("${selectedBase}", name: 'TEST2');
          print("event id ${event.id}");
          emit(state.copyWith(
            taskId: event.id,
            taskNameController: taskNameCtrl,
            amountController: amountCtrl,
            selectedBase1: base,
            selectedBase: selectedBase,
          ));
        }
      else {
        amountCtrl.text = event.amount ?? '';
        dynamic selectedBase = base[1];
        log("${selectedBase}", name: 'TEST1');
        emit(state.copyWith(
          taskId: event.id,
          userId: event.userId,
          amountController: amountCtrl,
          selectedBase1: base,
          selectedBase: selectedBase,
          userList: userListData,
          selectedUser:selectedUser,
        ));
      }
    });

    on<UpdateDropdownValueEvent>((event, emit) {
      print("Emitting new selectedBase1: ${event.selectedBase}");
      emit(state.copyWith(selectedBase: event.selectedBase));
    });

    on<ResetDropdownEvent>((event, emit) {
      emit(state.copyWith(
        selectedBase: event.isTaskBased
            ? {"base": "Task based"}
            : {"base": "Hour based"},
      ));
    });

    on<ResetResourceEvent>((event, emit) {
      emit(state.copyWith(
        selectedBase1: [],
        selectedUser: [],
      ));
    });

    on<EnterEditModeEvent>((event, emit) {
      emit(state.copyWith(isEditMode: true,));
    });
    on<ExitEditModeEvent>((event, emit) {
      emit(state.copyWith(isEditMode: false));
    });

    // on<EnterHourEditModeEvent>((event, emit) {
    //   emit(state.copyWith(isHourEditMode: true));
    // });
    // on<ExitHourEditModeEvent>((event, emit) {
    //   emit(state.copyWith(isHourEditMode: false));
    // });

    on<TaskDateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedDate: event.selectedDate)));

    on<fetchEmployeeCommentEvent>((event, emit) async {
      print("event data---------> ${event.hrmId} ${event.fromDate} ${event.toDate}");
      final comment = await taskRepo.fetchEmployeeComments(
      hrmId: event.hrmId,
      fromDate: event.fromDate,
      toDate: event.toDate,
    );
      List<Map<String, dynamic>> commentList = [];
      commentList = comment!.comments!;
      print("comment ${commentList}");
      emit(state.copyWith(comments: commentList));
  });

    on<FetchCheckInoutReasonEvent>((event, emit) async {
        final data = await taskRepo.fetchCheckInoutReason(
        hrmId: event.hrmId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
        List<Map<String, dynamic>> hoursData = [];
        hoursData = data!.data!;
        print("hoursData $hoursData");
        emit(state.copyWith(hoursData1: hoursData));
    });

    on<FetchTaskCountEvent>((event, emit) async {
      List<Map<String, dynamic>> history = [];
      final data = await taskRepo.fetchEmployeeTaskCount(
        userId: event.userId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      history = data!.history!;
      print("history $history");
      emit(state.copyWith(hoursData2: history));
    });



    //   Future<void> _onFetchTaskCount(
//       FetchTaskCountEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoadingState());
//     try {
//       final history = await taskRepo.fetchEmployeeTaskCount(
//         userId: event.userId,
//         fromDate: event.fromDate,
//         toDate: event.toDate,
//       );
//       emit(TaskLoadedState(history!));
//     } catch (e) {
//       emit(TaskErrorState(e.toString()));
//     }
//   }
  }
}
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/Event/workingHoursEvent.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/State/workingHoursState.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/Repository/workingHoursRepository.dart';
//
// import '../Response/taskCategoryGroupResponse.dart';
//
// class TaskBloc extends Bloc<TaskCountEvent, TaskState> {
//   TaskRepository taskRepo = TaskRepository();
//
//   TaskBloc() : super(TaskInitialState()) {
//     on<FetchTaskCountEvent>(_onFetchTaskCount);
//     on<fetchEmployeeComment>(_onFetchComment);
//     on<FetchCheckInoutReasonEvent>(_onFetchCheckInoutReason);
//     on<fetchEmployeeTaskHistoryEvent>(_onFetchTaskHistory);
//     on<fetchWorkingGetConfigurationEvent>(_onFetchGetConfiguration);
//     on<fetchTaskCategoryGroupEvent>(_onFetchCategoryGroup);
//     on<fetchCohortsDataEvent>(_onFetchCohortsData);
//   }
//
//   Future<void> _onFetchTaskCount(
//       FetchTaskCountEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoadingState());
//     try {
//       final history = await taskRepo.fetchEmployeeTaskCount(
//         userId: event.userId,
//         fromDate: event.fromDate,
//         toDate: event.toDate,
//       );
//       emit(TaskLoadedState(history!));
//     } catch (e) {
//       emit(TaskErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onFetchComment(
//       fetchEmployeeComment event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoadingState());
//     try {
//       final comment = await taskRepo.fetchEmployeeComments(
//         hrmId: event.hrmId,
//         fromDate: event.fromDate,
//         toDate: event.toDate,
//       );
//       emit(CommentLoadedState(comment!));
//     } catch (e) {
//       emit(TaskErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onFetchCheckInoutReason(
//       FetchCheckInoutReasonEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoadingState());
//     try {
//       final data = await taskRepo.fetchCheckInoutReason(
//         hrmId: event.hrmId,
//         fromDate: event.fromDate,
//         toDate: event.toDate,
//       );
//       emit(CheckInoutReasonLoadedState(data!));
//     } catch (e) {
//       emit(TaskErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onFetchTaskHistory(
//       fetchEmployeeTaskHistoryEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoadingState());
//     try {
//       final taskHistory = await taskRepo.fetchEmployeeTaskHistory(
//         to: event.to,
//         from: event.from,
//         userId: event.userId,
//       );
//
//       if (taskHistory?.history2 == null || taskHistory!.history2!.isEmpty) {
//         emit(TaskErrorState("No task history found"));
//         return;
//       }
//
//       List<Map<String, dynamic>> combinedList = [];
//
//       void extractData(Map<String, dynamic> item)
//       {
//         combinedList.add({
//           "vehicle_name": item["vehicles"]?.isNotEmpty ?? false
//               ? item["vehicles"][0]["vehicle_name"]
//               : null,
//           "todo_date": item["todo_date"],
//           "complete_time_taken": item["complete_time_taken"],
//           "fname": item["users"]?["first_name"],
//           "lname": item["users"]?["last_name"],
//           "location": item["location"],
//           "notes": item["notes"],
//           "reference_id": item["reference_id"],
//           "mileage": item["mileage"],
//           "expense_amount": item["expense_amount"],
//           "expense_description": item["expense_description"],
//           "category_name": item["category_name"],
//           "subcategory_name": item["subcategory_name"],
//           "expense_attachment": item["expense_attachment"],
//         });
//       }
//
//       taskHistory.history2!.forEach(extractData);
//
//       print("combinedList $combinedList");
//
//       emit(TaskHistoryLoadedState(taskHistory: taskHistory, combinedList: combinedList));
//     } catch (e) {
//       print("taskHistory exception $e");
//       emit(TaskErrorState(e.toString()));
//     }
//   }
//
//
//
//   Future<void> _onFetchGetConfiguration(
//       fetchWorkingGetConfigurationEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoadingState());
//     try {
//       final data = await taskRepo.fetchGetConfiguration();
//       emit(GetConfigurationLoadedState(data: data));
//     } catch (e) {
//       print("FetchConfigExcep $e");
//       emit(TaskErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onFetchCategoryGroup(
//       fetchTaskCategoryGroupEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoadingState());
//     try {
//       final response = await taskRepo.fetchCategoryGroup();
//       final data = response?.data?.map((data) {
//         return {
//           'id': data['id'],
//           'name': data['name'],
//         };
//       }).toList();
//
//       emit(CategoryGroupLoadedState(data: data));
//     } catch (e) {
//       print("CategoryGroupExcep $e");
//       emit(TaskErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onFetchCohortsData(
//       fetchCohortsDataEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoadingState());
//     try {
//       final response = await taskRepo.fetchCohortData();
//
//       final cohortList = response?.data?.map((cohort) {
//         return {
//           'id': cohort['id'],
//           'cohort': cohort['cohort'],
//         };
//       }).toList();
//
//       emit(CohortDataLoadedState(data: cohortList));
//     } catch (e) {
//       print("CohortException $e");
//       emit(TaskErrorState(e.toString()));
//     }
//   }
//
//
// }


