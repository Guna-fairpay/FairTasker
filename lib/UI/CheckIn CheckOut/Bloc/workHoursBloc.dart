
// working_hours_bloc.dart
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/prefs.dart';
import '../../../core/initializer/common_initializer.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';
import '../../../../Repository/api_repository.dart';

class WorkingHoursBloc extends Bloc<WorkingHoursEvent, WorkingHoursState> {
  final APiRepository apiRepository = APiRepository();
  DateRange? selectedDateRange;
  List<Map<String, dynamic>> formattedResources=[];
  List<Map<String, dynamic>> resources=[];
  List<Map<String, dynamic>> workHours = [];
  List<Map<String, dynamic>> workingHistory = [];
  List<Map<String, dynamic>> workActiveHours = [];
  List<Map<String, dynamic>> combinedData=[];
  List<Map<String, dynamic>> ReasonCombinedData=[];
  List<Map<String, dynamic>> dropDownData=[];
  List<String> activeHours = [];
  List<int> totalHoursValue = [];
  List<Map<String, dynamic>> taskComponentsData=[];
  List<Map<String, dynamic>> taskBased = [];
  List<Map<String, dynamic>> hourlyBased = [];
  TextEditingController taskNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController hourlyAmountController = TextEditingController();
  TextEditingController taskNameCtrl=TextEditingController();
  TextEditingController amountCtrl=TextEditingController();
  TextEditingController hourlyAmountCtrl=TextEditingController();
  dynamic userRole;
  String? userId;
  int? branchId;
  int selectedTab = 0;
  List<Map<String, dynamic>> dropDownResource=[];
  Map<String, dynamic> initialDropDown = {'id':0,'full_name':'All'};
  List<String> approveId = ['1','2','3','10','21','22','23'];
  List<Map<String, dynamic>> base = [
    {"id": 1, "base": "Task based"},
    {"id": 2, "base": "Hour based"}
  ];
  dynamic updateBase;
  dynamic updateId;
  dynamic deleteId;

  WorkingHoursBloc() : super(WorkingHoursState (
      userList: const [],
      selectedUser: const {},
    selectedTab: 0,
    selectedDateRange: DateRange(
      DateTime.now().subtract(const Duration(days: 7)),
      DateTime.now(),
    ),
  ))
  {

    on<WorkingHoursInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try
      {
        initialDropDown = {'id':0,'full_name':'All'};
        if(event.minDate.isNotEmpty || event.maxDate.isNotEmpty)
          {
            final response2 = await apiRepository.getActiveHoursResponse(extractDate(event.minDate), extractDate(event.maxDate));
            final response3 = await apiRepository.getAssignedTo();
            final response4 = await apiRepository.getWorkingHoursData(extractDate(event.minDate), extractDate(event.maxDate));
            final response5 = await apiRepository.getWorkingHistoryCount(extractDate(event.minDate), extractDate(event.maxDate));
            final response6 = await apiRepository.fetchPunchList();
            if (response2 != null && response3 != null && response4 != null && response5 != null && response6 != null) {
              workingHistory.clear();
              workingHistory = response5.history!;//1
              workHours.clear();
              workHours = response4.data!;//2
              resources.clear();
              resources=response3.resource!;//3
              workActiveHours.clear();
              workActiveHours = response2.data!;//4

              List<Map<String, dynamic>> punchListData = response6.data ?? [];
              DateTime startDate = DateTime.parse(event.minDate);
              DateTime endDate = DateTime.parse(event.maxDate);

              // Create DateTimeRange
              DateRange dateRange = DateRange(startDate,endDate);
              log("${dateRange}", name: "dateRange");

              List<Map<String, dynamic>> matchedPunchItem = [];
              try {
                matchedPunchItem = punchListData.where(
                      (punchItem) {
                    try {
                      final employeeId = punchItem['employee']?['id']?.toString();
                      if (employeeId == null) return false;

                      final matchedResource = resources.firstWhere(
                            (resource) {
                          final resourceId = resource['hrm_id'];
                          return resourceId != null && resourceId.toString() == employeeId;
                        },
                        orElse: () => {},
                      );


                      if (matchedResource['branch_id'] != null) {
                        final branchId = Session.of.getInt(Str.branchIdPrefText)?.toString();
                        return matchedResource['branch_id'].toString() == branchId;
                      }
                      return false;
                    } catch (e) {
                      log('Error inside: $e', name: 'matchedPunchItem');
                      return false;
                    }
                  },
                ).toList();
              } catch (e) {
                log('Error filtering matchedPunchItem: $e', name: 'matchedPunchItemError');
                matchedPunchItem = [];
              }

              branchId = await Utils.getIntPreference(Str.branchIdPrefText);
              userRole = await Utils.getStringListPreference(Str.rolePrefText);
              branchId = branchId == 0 ? 1 : branchId;

              formattedResources = resources.where((e)=>e['branch_id']==branchId && e['id']!= 1 && e['id']!= 2).map((resource) {
                return {
                  'id': resource['id'],
                  'hrm_id': resource['hrm_id'],
                  'full_name': "${resource['first_name']} ${resource['last_name']}",
                  'first_name': '${resource['first_name']}',
                  'branch_id' : '${resource['branch_id']}',
                };
              }).toList();
              //Helper Function

              List<Map<String, dynamic>> combineAndCalculateData(
                  List<Map<String, dynamic>> workhours,
                  List<Map<String, dynamic>> workhistory,
                  List<Map<String, dynamic>> workActivehours,
                  List<Map<String, dynamic>> formattedResource,
                  )
              {
                List<Map<String, dynamic>> combinedList = [];

                // time string to minutes
                int timeStringToMinutes(String time) {
                  final parts = time.split(':');
                  final hours = int.tryParse(parts[0]) ?? 0;
                  final minutes = int.tryParse(parts[1]) ?? 0;
                  return hours * 60 + minutes;
                }

                // convert minutes to time string
                String minutesToTimeString(int minutes) {
                  final hours = minutes ~/ 60;
                  final remainingMinutes = minutes % 60;
                  return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
                }


                String getFirstWord(String name) {
                  return name.split(' ').first;
                }


                String removeSeconds(String time) {
                  if (time.length >= 8) {
                    return time.substring(0, 5);
                  }
                  return time;
                }

                for (var workhour in workhours) {
                  try {
                    final userId = workhour['user']['id'];
                    final userName = workhour['user']['name'];

                    var empUserId;
                    var foundItems = formattedResource.where((e) => e['hrm_id'].toString() == userId.toString()).toList();
                    if (foundItems.isNotEmpty) {
                      empUserId = foundItems.first['id'];
                    }

                    if (userId == null) {
                      continue;
                    }

                    Map<String, dynamic> historyItem = {};
                    Map<String, dynamic> activeHoursItem = {};
                    Map<String, dynamic> empID = {};
                    // matching history item
                    try {
                      historyItem = workhistory.firstWhere(
                            (item) =>
                        item['users'] != null &&
                            item['users']['hrm_id'] == userId &&
                            formattedResource.any((resource) => item['users']['first_name'] == resource['first_name']),
                        orElse: () => {},
                      );
                    } catch (e) {
                      print("Error finding history item for user $userId: $e");
                    }
                    log("${historyItem}", name: "historyItem");
                    // matching active hours item
                    try {
                      activeHoursItem = workActivehours.firstWhere(
                            (item) =>
                            item['hrm_id'] == userId &&
                            formattedResource.any((resource) => item['user_id'] == resource['user_id']),
                        orElse: () => {},
                      );
                    } catch (e) {
                      print("Error finding active hours item for user $userId: $e");
                    }

                    // matching employee ID from Resource
                    try {
                      empID = formattedResource.firstWhere(
                            (item) => getFirstWord(item['full_name']) == getFirstWord(userName),
                        orElse: () => {},
                      );
                    } catch (e) {
                      print("Error finding employee ID for user $userId: $e");
                    }

                    final taskCount = historyItem['task_count'] ?? 0;
                    // final activeHours = activeHoursItem['active_hours'] ?? "00:00";
                    // if (taskCount == 0 && activeHours == "00:00") {
                    //   continue;
                    // }

                    // Calculate total hours (#)
                    int lessCount = 0;
                    int greaterCount = 0;
                    if (workhour['user']['list'] != null) {
                      for (var task in workhour['user']['list']) {
                        final taskTotalHours = task['total_hours']?.split(':') ?? ['0', '0'];
                        final int taskHours = int.tryParse(taskTotalHours[0]) ?? 0;
                        final int taskMinutes = int.tryParse(taskTotalHours[1]) ?? 0;
                        final int totalMinutes = taskHours * 60 + taskMinutes;
                        if (totalMinutes <= 420) {
                          lessCount++;
                        } else if (totalMinutes >= 540) {
                          greaterCount++;
                        }
                      }
                    }
                    final totalHoursCount = lessCount + greaterCount;

                    // Calculate active hours
                    final relevantHours = workActivehours.where(
                          (activeHour) => activeHour['hrm_id']?.toString() == userId.toString(),
                    );
                    final int totalMinutes = relevantHours.fold(
                      0,
                          (total, current) => total + timeStringToMinutes(current['active_hours']),
                    );
                    final calculatedActiveHours = minutesToTimeString(totalMinutes);
                    final rawHours = workhour['user']['total_working_hours'] ?? "00:00:00";
                    final formattedHours = removeSeconds(rawHours);


                    final combinedItem = {
                      'Employee': empID['first_name'],
                      'Active': empID['first_name'] != null ? calculatedActiveHours : null,
                      'Hours': empID['first_name'] != null ? formattedHours : null,
                      'Task': empID['first_name'] != null ? taskCount : null,
                      '#': empID['first_name'] != null ? totalHoursCount : null,
                      'hrm_id': historyItem['users']?['hrm_id'] ?? userId,
                      'user_id': empUserId ?? '',
                      'list': workhour['user']['list'] ?? [],
                      'first_name': historyItem['users']?['first_name'] ?? empID['first_name'] ?? '',
                      'last_name': historyItem['users']?['last_name'] ?? '',
                      'empID': historyItem['users']?['id'] ?? '',
                    };

                    combinedList.add(combinedItem);
                  } catch (e) {
                    print("Error processing workhour: $e");
                  }
                }

                return combinedList;
              }

              combinedData.clear();
              combinedData = combineAndCalculateData(
                  workHours,
                  workingHistory,
                  workActiveHours,
                  formattedResources,
              );
              log("${combinedData}", name: "combinedData");
              //Punch Card Calculation Start
              List<Map<String, dynamic>> formatEmployeeData(
                  List<Map<String, dynamic>> rawData,
                  List<Map<String, dynamic>> workActiveHours,
                  )
              {
                try {
                  String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

                  String formatTime(String timeStr) {
                    if (timeStr.isEmpty) return "";
                    DateTime dateTime = DateFormat("dd-MM-yyyy HH:mm:ss").parseUtc(timeStr);
                    return DateFormat("hh:mm a").format(dateTime);
                  }

                  String initials(String? name) {
                    if (name == null || name.isEmpty) return "--";
                    return name.split(' ').map((e) => e[0]).take(2).join();
                  }

                  String calculateElapsedTime(String startTime) {
                    DateTime startDateTime = DateFormat("dd-MM-yyyy HH:mm:ss").parseUtc(startTime);
                    DateTime now = DateTime.now().toUtc().subtract(Duration(hours: 5));

                    if (now.isBefore(startDateTime)) return "00:00";

                    Duration elapsed = now.difference(startDateTime);
                    int hours = elapsed.inHours;
                    int minutes = elapsed.inMinutes % 60;

                    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
                  }

                  String sumActiveHours(int hrmId) {
                    int totalMinutes = 0;

                    for (var record in workActiveHours) {
                      if (record['hrm_id'] == hrmId && record['todo_date'] == today) {
                        String activeStr = record['active_hours'] ?? '00:00';
                        List<String> timeParts = activeStr.split(':');
                        int hours = int.tryParse(timeParts[0]) ?? 0;
                        int minutes = int.tryParse(timeParts[1]) ?? 0;

                        totalMinutes += (hours * 60) + minutes;
                      }
                    }

                    int finalHours = totalMinutes ~/ 60;
                    int finalMinutes = totalMinutes % 60;
                    return "${finalHours.toString().padLeft(2, '0')}:${finalMinutes.toString().padLeft(2, '0')}";
                  }

                  return rawData.map((data) {
                    String? startTime = data['start_time'];
                    String? endTime = data['end_time'];
                    Map<String, dynamic>? employee = data['employee'];
                    String? empName = employee?['name'];
                    int? empId = employee?['id'];

                    String totalTime;

                    if (startTime == null || startTime.isEmpty) {
                      totalTime = "00:00";
                    } else if (endTime == null || endTime.isEmpty) {
                      totalTime = calculateElapsedTime(startTime);
                    } else {
                      try {
                        DateTime start = DateFormat("dd-MM-yyyy HH:mm:ss").parseUtc(startTime);
                        DateTime end = DateFormat("dd-MM-yyyy HH:mm:ss").parseUtc(endTime);
                        Duration diff = end.difference(start);
                        int hours = diff.inHours;
                        int minutes = diff.inMinutes % 60;
                        totalTime = "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
                      } catch (_) {
                        totalTime = "00:00";
                      }
                    }

                    return {
                      "User": initials(empName),
                      "CheckIn": startTime != null ? formatTime(startTime) : "--",
                      "CheckOut": (endTime == null || endTime.isEmpty) ? "" : formatTime(endTime),
                      "Active": (empId != null) ? sumActiveHours(empId) : "00:00",
                      "Total": totalTime,
                    };
                  }).toList();
                } catch (e) {
                  print("Error in formatEmployeeData: $e");
                  return [];
                }
              }


              List<Map<String, dynamic>> formattedData = formatEmployeeData(matchedPunchItem,workActiveHours);
              dropDownResource = formattedResources;
              dropDownResource.insert(0, initialDropDown);
              //Punch Card Calculation End
              emit(state.copyWith(
                isLoading: false,
                combinedData: combinedData,
                workActiveHours: workActiveHours,
                activeHours: activeHours,
                totalHoursValue: totalHoursValue,
                resources: formattedResources,
                startDate: event.minDate,
                endDate: event.maxDate,
                selectedDateRange: dateRange,
                punchListData: formattedData,
                loginUserId: userId,
                loginUserRole: userRole[0]
              ));
            }
            else {
              print("Response is null");
            }
          } else {
          emit(state.copyWith(isLoading: false));
          print("Error: startDate ${event.minDate} or endDate ${event.maxDate} is empty");
        }

        emit(state.copyWith(
          isLoading: false,
          combinedData: combinedData,
          workActiveHours: workActiveHours,
          activeHours: activeHours,
          totalHoursValue: totalHoursValue,
          resources: formattedResources,
          startDate: event.minDate,
          endDate: event.maxDate,
          selectedDateRange: selectedDateRange,
            loginUserId: userId,
            loginUserRole: userRole
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
        initialDropDown = event.selectedName;
        dropDownData = (event.selectedName['full_name'] == 'All'
            ? state.combinedData
            : state.combinedData?.where((item) {
          return getFirstWord(item['first_name']) == getFirstWord(event.selectedName['full_name']);
        }).toList()) ?? []; // Ensure it's not null
        emit(state.copyWith(dropDownData: dropDownData));
      } catch (error) {
        print("Error on ResourceDropDownEvent: $error");
      }
    });

    //Task Components - Settings Page
    on<TaskComponentsInitialEvent>((event, emit) async {
      try{
        emit(state.copyWith(isLoading: true));
        final response6 = await apiRepository.fetchGetConfiguration();
        final response3 = await apiRepository.getAssignedTo();
        userRole = await Utils.getStringListPreference(Str.rolePrefText);
        userId = await Utils.getStringPreference(Str.userIdPrefText);
        if(response6 != null && response3 != null){
          taskComponentsData = response6.data!;
          resources = response3.resource!;
          branchId = branchId == null ? 1 : branchId;
          log("${branchId} branchid_task_components");
          formattedResources = resources.map((resource) {
            return {
              'id': resource['id'],
              'full_name': "${resource['first_name']} ${resource['last_name']}",
              'first_name': '${resource['first_name']}',
              'last_name': '${resource['last_name']}',
            };
          }).toList();
          var removeAssignedResource = resources
              .where((e) => e['branch_id'] == branchId &&
              !taskComponentsData.any((task) => task['user_id'].toString() == e['id'].toString()))
              .toList();

          taskBased = taskComponentsData.where((task) => task['type'] == 'task').toList();
          hourlyBased = taskComponentsData.where((task) => task['type'] == 'hourly').toList();

          dynamic selectedBase = updateBase ?? base[0];
          emit(state.copyWith(
            isLoading: false,
            taskComponentsData: taskComponentsData,
            taskBased: taskBased,
            hourlyBased: hourlyBased,
            selectedBase1: base,
            selectedBase: selectedBase,
            resources: formattedResources,
            resource: resources,
            userList: removeAssignedResource,
            loginUserRole: userRole[0],
              loginUserId: userId,
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
      //emit(state.copyWith(isLoading: true));
      List<Map<String, dynamic>> base = [
        {"id": 1, "base": "Task based"},
        {"id": 2, "base": "Hour based"}
      ];

      try{
        deleteId = event.id;
        log("${updateId} == ${event.id} delete_event_trigger");
        await apiRepository.deleteTaskConfiguration(event.id).then((value) {
          if(updateId == deleteId){
            if(event.task == 'task'){
              taskComponentsData.removeWhere((task) => task['id'] == event.id);
              updateBase = base[0];
              add(ExitEditModeEvent());
              add(const TaskComponentsInitialEvent());
            } else {
              add(ExitEditModeEvent());
              taskComponentsData.removeWhere((task) => task['id'] == event.id);
              updateBase = base[1];
              add(const TaskComponentsInitialEvent());
            }
          } else {
            if(event.task == 'task'){
              updateBase = base[0];
              // add(const TaskComponentsInitialEvent());
              taskComponentsData.removeWhere((task) => task['id'] == event.id);
              emit(state.copyWith(taskComponentsData: taskComponentsData));
            } else {
              updateBase = base[1];
              //add(const TaskComponentsInitialEvent());
              taskComponentsData.removeWhere((task) => task['id'] == event.id);
              emit(state.copyWith(taskComponentsData: taskComponentsData));
            }
          }
        });
      }
      catch(error){
        emit(state.copyWith(isLoading: false));
        print("Error on DeleteTaskComponentsEvent: $error");
      }
    });

    //Create Update
    on<CreateTaskEvent>((event, emit) async {
      try{
        emit(state.copyWith(isLoading: true));
        updateBase = event.task == 'task' ? base[0] : base[1];
        await apiRepository.addTaskConfiguration(
            event.id,
            event.userId,
            event.taskName,
            event.amount ?? '',
            event.task);
        emit(state.copyWith(userList: [], selectedUser: {}, isLoading: false, uniqueId: UniqueKey().toString(),));
        add(const TaskComponentsInitialEvent());
        emit(state.copyWith(selectedUser: {}, isLoading: false, userList: [], uniqueId: UniqueKey().toString(),));
      } catch (error){
        emit(state.copyWith(isLoading: false));
        print("Error on CreateTaskEvent: $error");
      }
    });



    on<UpdateTaskEvent>((event, emit) async {
      updateId = event.id;
      print("UpdateTaskEvent called ${event.id} ${event.taskName} ${event.amount} ${event.userId} ${event.task}");
      List<Map<String, dynamic>> base = [
        {"id": 1, "base": "Task based"},
        {"id": 2, "base": "Hour based"}
      ];
      dynamic selectedUser = resources.firstWhere(
            (resource) => resource['id'] == event.userId,
        orElse: () => {},
      );
      if (event.task == 'task') {
        log("${event.taskName} ${event.amount} ${event.task} task_update_event_trigger");
        taskNameCtrl.text = event.taskName?.toString() ?? '';
        amountCtrl.text = event.amount?.toString() ?? '';
        dynamic selectedBase = base[0];
        print("${taskNameController.text} ${amountController.text} task_update_event_trigger");
        emit(state.copyWith(
          taskId: event.id,
          taskNameController: taskNameCtrl,
          amountController: amountCtrl,
          selectedBase1: base,
          selectedBase: selectedBase,
          selectedUser: null, // Explicitly reset
          userId: -1,
        ));
      } else {
        log("${event.userId} ${event.amount} hour_update_event_trigger");
        hourlyAmountCtrl.text = event.amount ?? '';
        hourlyAmountController.text = event.amount ?? '';
        dynamic selectedBase = base[1];
        print("Emitting hourly state: selectedUser=$selectedUser, taskId=${event.id}");
        emit(state.copyWith(
          taskId: event.id,
          userId: event.userId,
          hourlyAmountController: hourlyAmountCtrl,
          selectedBase1: base,
          selectedBase: selectedBase,
          userList: resources,
          selectedUser: selectedUser,
        ));
      }
    });

    on<SwitchTabEvent>((event, emit) {
      print("Switching to ${event.isHourly ? 'Hourly' : 'Task'} Based at ${DateTime.now()}");
      final newState = event.isHourly
          ? state.copyWith(
        isHourlyBased: true,
        selectedBase: {"id": 2, "base": "Hour based"},
        selectedUser: null,
        userId: null,
        hourlyAmountController: hourlyAmountCtrl..clear(),
        taskNameController: taskNameCtrl,
        amountController: amountCtrl,
      )
          : state.copyWith(
        isHourlyBased: false,
        selectedBase: {"id": 1, "base": "Task based"},
        selectedUser: null,
        userId: null,
        taskNameController: taskNameCtrl..clear(),
        amountController: amountCtrl,
        hourlyAmountController: hourlyAmountCtrl,
      );
      print("Emitting ${event.isHourly ? 'hourly' : 'task-based'} state: isHourlyBased=${event.isHourly}");
      emit(newState);
    });

    on<UpdateDropdownValueEvent>((event, emit) {
      hourlyAmountCtrl.clear(); // Clear hourly amount when dropdown changes
      taskNameCtrl.clear();
      amountCtrl.clear();
      if (event.selectedBase['base'] == 'Hour based') {
        emit(state.copyWith(
          selectedBase: event.selectedBase,
          selectedUser: null, // Reset selectedUser when switching to Hourly Based
          userId: null,
          hourlyAmountController: hourlyAmountCtrl,
        ));
      } else {
        emit(state.copyWith(
          selectedBase: event.selectedBase,
          selectedUser: null, // Reset for Task Based as well to avoid carryover
          userId: null,
          taskNameController: taskNameCtrl,
          amountController: amountCtrl,
        ));
      }
    });

    on<ResetDropdownEvent>((event, emit) {
      taskNameCtrl.clear();
      amountCtrl.clear();
      hourlyAmountCtrl.clear();
      emit(state.copyWith(
        selectedBase: event.isTaskBased
            ? {"id": 1, "base": "Task based"}
            : {"id": 2, "base": "Hour based"},
        selectedUser: null,
        userId: null,
        taskNameController: taskNameCtrl,
        amountController: amountCtrl,
      ));
    });

    on<ResetResourceEvent>((event, emit) {
      amountCtrl.clear();
      hourlyAmountCtrl.clear();
      emit(state.copyWith(
        selectedUser: null,
        amountController: amountCtrl,
        userId: null,
        selectedBase: state.selectedBase ?? (state.isHourlyBased ? {"id": 2, "base": "Hour based"} : {"id": 1, "base": "Task based"}),
        isHourlyBased: state.isHourlyBased,
        uniqueId: UniqueKey().toString(),
      ));
    });

    on<EnterEditModeEvent>((event, emit) {
      emit(state.copyWith(isLoading: true));
      emit(state.copyWith(isEditMode: true,isLoading: false));
    });

    on<ResetAllEvent>((event, emit) {
      emit(state.copyWith(
        selectedUser: null,
        userId: null,
        isEditMode: false,
        taskNameController: TextEditingController(),
        amountController: TextEditingController(),
        hourlyAmountController: TextEditingController(),
        uniqueId: UniqueKey().toString(),
      ));
    });

    on<ClearResourceSelectionEvent>((event, emit) {
      emit(state.copyWith(
        selectedUser: null,
        userId: null,
      ));
    });

    on<ExitEditModeEvent>((event, emit) {
      emit(state.copyWith(isLoading: true));
      taskNameCtrl.clear();
      amountCtrl.clear();
      hourlyAmountCtrl.clear();
      emit(state.copyWith(
        isLoading: false,
        isEditMode: false,
        selectedBase: state.selectedBase ?? (state.isHourlyBased ? {"id": 2, "base": "Hour based"} : {"id": 1, "base": "Task based"}), // Force back to Task based
        isHourlyBased: state.isHourlyBased,
        userId: null,
        selectedUser: null,
        taskNameController: taskNameCtrl,
        amountController: amountCtrl,
        hourlyAmountController: hourlyAmountCtrl,
        uniqueId: UniqueKey().toString(),
      ));
      print("Exit edit mode: selectedUser reset to null at ${DateTime.now()}");
    });

    on<TaskDateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedDate: event.selectedDate)));

    on<fetchEmployeeCommentEvent>((event, emit) async {
      print("event data---------> ${event.hrmId} ${event.fromDate} ${event.toDate}");
      //Fetch Data
      final comment = await apiRepository.fetchEmployeeComments(
      hrmId: event.hrmId,
      fromDate: event.fromDate,
      toDate: event.toDate,
      );
      List<Map<String, dynamic>> commentList = [];
      commentList.clear();
      commentList = comment!.comments!;
      print("comment ${commentList}");

      //Helper Function

      DateTime _parseAnyDateFormat(String dateStr) {
        final possibleFormats = [
          'dd/MM/yyyy',
          'MM/dd/yyyy',
          'yyyy-MM-dd',
          'yyyyMMdd',
          'yyyy/MM/dd',
          'dd-MM-yyyy',
          'MM-dd-yyyy',
          'dd.MM.yyyy',
          'MM.dd.yyyy',
        ];

        for (final format in possibleFormats) {
          try {
            return DateFormat(format).parse(dateStr);
          } catch (_) {}
        }

        throw FormatException('Unrecognized date format "$dateStr"');
      }

      List<String> parseDateRange(String? dateRange) {
        // Handle null or empty input by returning last 7 days
        if (dateRange == null || dateRange.trim().isEmpty) {
          final now = DateTime.now();
          final sevenDaysAgo = now.subtract(const Duration(days: 7));
          return [
            DateFormat('dd/MM/yy').format(sevenDaysAgo),
            DateFormat('dd/MM/yy').format(now),
          ];
        }

        try {
          dateRange = dateRange.trim();

          // Handle case where input might be "null" as string
          if (dateRange.toLowerCase() == 'null') {
            throw FormatException('Explicit "null" string provided');
          }

          // Check for single date
          if (!dateRange.contains('-') && !dateRange.contains('/') && !dateRange.contains(' ')) {
            final singleDate = _parseAnyDateFormat(dateRange);
            final formatted = DateFormat('yyyy-MM-dd').format(singleDate);
            return [formatted, formatted];
          }

          // Try different separators
          final separators = [' - ', ' to ', ' until ', '..', '-'];
          String? separator;

          for (final sep in separators) {
            if (dateRange.contains(sep)) {
              separator = sep;
              break;
            }
          }

          if (separator == null) {
            throw FormatException('No valid range separator found. Use " - ", " to ", or similar');
          }

          final parts = dateRange.split(separator);
          if (parts.length != 2) {
            throw FormatException('Expected exactly two dates separated by "$separator"');
          }

          final fromDate = _parseAnyDateFormat(parts[0].trim());
          final toDate = _parseAnyDateFormat(parts[1].trim());

          if (toDate.isBefore(fromDate)) {
            throw FormatException('End date cannot be before start date');
          }

          return [
            DateFormat('yyyy-MM-dd').format(fromDate),
            DateFormat('yyyy-MM-dd').format(toDate)
          ];
        } catch (e) {
          // Provide helpful error message including the original input
          throw FormatException(
              'Failed to parse date range "$dateRange".\n'
                  'Supported formats:\n'
                  '• "dd/MM/yyyy - dd/MM/yyyy"\n'
                  '• "MM/dd/yyyy to MM/dd/yyyy"\n'
                  '• "yyyy-MM-dd until yyyy-MM-dd"\n'
                  '• Single dates like "2023-12-31"\n'
                  '• Empty input returns last 7 days\n\n'
                  'Error details: ${e.toString().replaceFirst('FormatException: ', '')}'
          );
        }
      }


      List<String> result;
      try {
        result = parseDateRange(event.ReasonPopupSelectedDateRange);
      } catch (e) {
        print("Error parsing date range: $e");
        result = [DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7))), DateFormat('yyyy-MM-dd').format(DateTime.now())];
      }

      List<Map<String, dynamic>> combineData(List<dynamic> dataList, List<Map<String, dynamic>> taskCounts) {
        List<Map<String, dynamic>> combinedList = [];
        Map<String, List<Map<String, dynamic>>> taskCountsMap = {};
        combinedList.clear();
        taskCountsMap.clear();
        for (var task in taskCounts) {
          final String? formattedDate = task['date'] != null
              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(task['date'].toString()))
              : null;

          if (formattedDate != null) {
            taskCountsMap.putIfAbsent(formattedDate, () => []).add(task);
          }
        }

        for (var item in dataList) {
          final String? formattedDate = item['date'] != null
              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(item['date'].toString()))
              : null;

          if (formattedDate == null) {
            continue;
          }

          List<Map<String, dynamic>>? taskDataList = taskCountsMap[formattedDate];

          String reason = '';
          String comments = '';
          if (taskDataList != null && taskDataList.isNotEmpty) {
            reason = taskDataList.map((task) => task['reason']?.toString() ?? '').join(', ');
            comments = taskDataList.map((task) => task['comments']?.toString() ?? '').join(', ');
          }

          combinedList.add({
            'date': DateFormat('MM-dd-yy').format(DateTime.parse(formattedDate)),
            'total_hours': item['total_hours'] ?? '',
            'start_time': item['start_time'] ?? '',
            'end_time': item['end_time'] ?? '',
            'reason': reason,
            'comments': comments,
          });
        }

        print("Combined Data on First Open: $combinedList");
        return combinedList;
      }
      ReasonCombinedData = [];
      ReasonCombinedData = List.from(combineData(event.dataList, commentList));
      emit(state.copyWith(
          isLoading: false,comments: ReasonCombinedData));
    });

    //Hours popup initial code
    on<HoursPopupEvent>((event, emit) async {
      final data = await apiRepository.fetchCheckInoutReason(
        hrmId: event.hrmId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      final response = await apiRepository.fetchEmployeeTaskCount(
        userId: event.empID,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      List<Map<String, dynamic>> hoursData = [];
      hoursData = data!.data!;
      List<Map<String, dynamic>> history = [];
      history = response?.history! ?? [];


      List<String> getFromDateAndToDate(String dateRange) {
        try {
          if (dateRange.isEmpty) {
            throw Exception("Date range is empty");
          }

          dateRange = dateRange.trim();
          if (!dateRange.contains(" - ")) {
            throw Exception("Invalid date range format. Expected format: 'dd/MM/yyyy - dd/MM/yyyy'");
          }

          List<String> dates = dateRange.split(" - ").map((d) => d.trim()).toList();
          if (dates.length != 2) {
            throw Exception("Invalid date range format.");
          }

          String normalizeDate(String dateStr) {
            if (dateStr.isEmpty) {
              throw Exception("Date string is empty");
            }

            try {
              if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
                return DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(dateStr));
              } else if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateStr)) {
                return dateStr;
              } else {
                throw Exception("Unrecognized date format: $dateStr");
              }
            } catch (e) {
              throw Exception("Invalid date format: $dateStr");
            }
          }

          String fromDateStr = normalizeDate(dates[0]);
          String toDateStr = normalizeDate(dates[1]);

          return [
            DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(fromDateStr)),
            DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(toDateStr))
          ];
        } catch (e) {
          print("Error parsing date range: $e");
          return [
            DateFormat("yyyy-MM-dd").format(DateTime.now()),
            DateFormat("yyyy-MM-dd").format(DateTime.now())
          ];
        }
      }

      List<String> result;
      try {
        result = getFromDateAndToDate(event.HoursPopupSelectedDateRange);
      } catch (e) {
        print("Error parsing date range: $e");
        result = [DateFormat("yyyy-MM-dd").format(DateTime.now()), DateFormat("yyyy-MM-dd").format(DateTime.now())];
      }

      List<Map<String, dynamic>> combineData(
          List<dynamic> dataList,
          List<Map<String, dynamic>> taskCounts,
          )
      {
        List<Map<String, dynamic>> combinedList = [];

        // Map to organize task counts by date
        Map<String, int> taskCountsMap = {};
        for (var task in taskCounts) {
          try {
            final date = DateFormat('yyyy-MM-dd')
                .format(DateFormat('yyyy-MM-dd').parse(task['todo_date'].toString()));
            taskCountsMap[date] = (taskCountsMap[date] ?? 0) +
                (int.tryParse(task['task_count'].toString()) ?? 0);
          } catch (e) {
            continue;
          }
        }

        // Combine data
        for (var item in dataList) {
          final String? date = item['date']?.toString();
          if (date == null) continue;

          final taskCount = taskCountsMap[date] ?? 0;

          combinedList.add({
            'date': DateFormat('MM-dd-yyyy').format(DateTime.parse(date)),
            'total_hours': item['total_hours'],
            'start_time': item['start_time'] ?? '',
            'end_time': item['end_time'] ?? '',
            'task_count': taskCount.toString(),
          });
        }

        return combinedList;
      }

      // Correctly pass history as taskCounts
      combinedData = combineData(event.dataList, history);
      emit(state.copyWith(isLoading: false, hoursData1: combinedData));
    });


    //Task page initial Event
    on<TaskInitialEvent>((event, emit) async {
      //Api fetching
      emit(state.copyWith(isLoading: true));
      final taskHistory = await apiRepository.fetchEmployeeTaskHistory(
        to: event.to,
        from: event.from,
        userId: event.userId, cohortIds: event?.cohortIds ?? [],
      );
      List<Map<String, dynamic>> combinedHistory = [];
      combinedHistory.addAll(taskHistory?.allHistory ?? []);

      final data = await apiRepository.fetchGetConfiguration();
      final response1 = await apiRepository.fetchCohortData();
      final response2 = await apiRepository.getTaskCategoryGroups();
      List<Map<String, dynamic>> taskCategoryGroup = [];
      taskCategoryGroup = response2?.data ?? [];
      try{
        List<String> titles = taskCategoryGroup.map((item) => item['name'].toString()).toList();

        List<Map<String, dynamic>> sortTitles(List<String> titles, List<Map<String, dynamic>> taskCategoryGroup) {

          Map<String, List<Map<String, dynamic>>> classifiedTask = {
            'Other': [],
            'Parts': []
          };
          Set<String> addedTitles = {};

          List<String> categoryOrder = [
            'Rental',
            'Repair',
            'Parts',
            'Rental Ready',
            'Maintenance',
            'Operations',
            'Other'
          ];
          if (taskCategoryGroup.isNotEmpty) {
            for (var parentCategory in taskCategoryGroup) {
              if (parentCategory['name'] == 'Sales') continue;

              if (parentCategory['name'] != 'Offshore' && parentCategory['name'] != 'Purchase') {
                classifiedTask[parentCategory['name']] = [];
              }

              if (parentCategory.containsKey('subcategories') && parentCategory['subcategories'] is List) {
                for (var childCategory in parentCategory['subcategories']) {
                  for (var title in titles) {
                    String lowercaseTitle = title.toLowerCase();
                    if (lowercaseTitle == childCategory['name'].toLowerCase() && !addedTitles.contains(lowercaseTitle)) {
                      classifiedTask[parentCategory['name']] ??= [];
                      classifiedTask[parentCategory['name']]!.add({
                        'title': title,
                        'id': childCategory['id'] ?? null
                      });
                      addedTitles.add(lowercaseTitle);
                    }
                  }
                }
              }

              for (var title in titles) {
                String lowercaseTitle = title.toLowerCase();
                if (lowercaseTitle == parentCategory['name'].toLowerCase() && !addedTitles.contains(lowercaseTitle)) {
                  classifiedTask[parentCategory['name']]!.add({
                    'title': title,
                    'id': parentCategory['id'] ?? null
                  });
                  addedTitles.add(lowercaseTitle);
                }
              }
            }
          }

          for (var title in titles) {
            String lowercaseTitle = title.toLowerCase();
            if (lowercaseTitle.contains('parts') && !addedTitles.contains(lowercaseTitle)) {
              classifiedTask['Parts']!.add({
                'title': title,
                'id': null
              });
              addedTitles.add(lowercaseTitle);
            }
          }

          for (var title in titles) {
            String lowercaseTitle = title.toLowerCase();
            if (!addedTitles.contains(lowercaseTitle)) {
              classifiedTask['Other']!.add({
                'title': title,
                'id': -1,
              });
              addedTitles.add(lowercaseTitle);
            }
          }

          List<Map<String, dynamic>> sortedTask = [];

          for (var category in categoryOrder) {
            if (classifiedTask.containsKey(category)) {
              sortedTask.add({
                "title": category,
                "subcategory": classifiedTask[category]!.map((e) => {
                  "sub_title": e['title'],
                  "id": e['id'],
                }).toList()
              });
            }
          }

          return sortedTask;
        }
        var result = sortTitles(titles, taskCategoryGroup);
        log("result ${result}",name: "result");

        //Helper Function
        Future<List<Map<String, dynamic>>> formatTaskData(List<Map<String, dynamic>> categoryData, List<Map<String, dynamic>> tasks)
        async {
          Map<String, List<Map<String, dynamic>>> classifiedTasks = {};

          for (var category in categoryData) {
            bool includeCategory = category['title'] != 'Other' || event.cohortIds.contains(-1);
            if (includeCategory) {
              classifiedTasks[category['title']] = [];
            }
          }

          try {
            for (var task in tasks) {
              String taskTitle = task['title'];
              String normalizedTaskTitle = taskTitle.replaceAll(RegExp(r'\s*-\s*'), '-').toLowerCase();
              String taskTitleLower = normalizedTaskTitle;
              bool matched = false;

              for (var category in categoryData) {
                for (var sub in category['subcategory']) {
                  String subTitleLower = sub['sub_title'].toString().replaceAll(RegExp(r'\s*-\s*'), '-').toLowerCase();
                  if (subTitleLower == taskTitleLower && taskTitleLower != 'parts') {
                    classifiedTasks[category['title']]?.add(task);
                    matched = true;
                    log("Exact match: task '${taskTitle}' matched with subcategory '${sub['sub_title']}' under category '${category['title']}'", name: "task_match");
                    break;
                  }
                }
                if (matched) break;
              }

              if (!matched && taskTitleLower.contains('parts')) {
                bool hasExactPartsMatch = false;
                for (var category in categoryData) {
                  if (category['title'] == 'Parts') {
                    for (var sub in category['subcategory']) {
                      String subTitleLower = sub['sub_title'].toString().replaceAll(RegExp(r'\s*-\s*'), '-').toLowerCase();
                      if (subTitleLower == taskTitleLower) {
                        //log("${sub['sub_title']} == ${taskTitleLower} exact_match_parts", name: "task_match");
                        hasExactPartsMatch = true;
                        break;
                      }
                    }
                    break;
                  }
                }

                if (!hasExactPartsMatch && task['parent_id'] == null) {
                  //log("entered_title ${taskTitleLower}");
                  classifiedTasks['Parts']!.add(task);
                  //log("Task '${taskTitle}' added to 'Parts' (no exact match, parent_id null)", name: "task_match");
                  matched = true;
                }
              }

              if (!matched) {
                classifiedTasks['Other'] ??= [];
                classifiedTasks['Other']!.add(task);
                //log("Task '${taskTitle}' not matched, added to 'Other'", name: "task_unmatched");
              }
            }
          } catch (e) {
            log("error ${e}", name: "error match by");
          }

          List<Map<String, dynamic>> finalList = [];

          for (var category in categoryData) {
            List<Map<String, dynamic>> subcategories = [];
            Map<String, Map<String, dynamic>> groupedTasks = {};

            for (var task in classifiedTasks[category['title']] ?? []) {
              String subTitle = task['title'];
              List<Map<String, dynamic>> vehicles = [];

              if (task['vehicle_name'] != null && task['vehicle_name'] != '' && task['vehicle_name'] != 'null') {
                vehicles.add({
                  "vehicle_name": task['vehicle_name'],
                  "todo_date": task['todo_date'] ?? '',
                  "id": task['id'],
                  "complete_time_taken": task['complete_time_taken']?.toString() ?? '',
                });
              } else if(task['vehicles'] is List && task['vehicles'].isNotEmpty && task['vehicles'].length > 1){
                vehicles.add({
                  "vehicle_name": "MV",
                  "todo_date": task['todo_date'] ?? '',
                  "id": task['id'],
                });
              }
              else if (task['vehicles'] != null && task['vehicles'] is List && task['vehicles'].isNotEmpty && task['vehicles'] != []) {

                vehicles = (task['vehicles'] as List<dynamic>)
                    .map<Map<String, dynamic>>((v) => {
                  "vehicle_name": v['vehicle_name'],
                  "todo_date": task['todo_date'] ?? '',
                  "id": task['id'],
                  "complete_time_taken": task['complete_time_taken']?.toString() ?? '',
                }).toList();
              }
              else if(task['vin'] != null){
                final response = await getIt<CommonService>().getActiveVehicles(reset: true);
                final vehicle = response.firstWhere(
                      (e) => e['vin']?.toString() == task['vin']?.toString(),
                  orElse: () => {},
                );
                vehicles.add({
                  "vehicle_name": vehicle['vehicle_name'],
                  "todo_date": task['todo_date'] ?? '',
                  "id": task['id'],
                  "complete_time_taken": task['complete_time_taken']?.toString() ?? '',
                });
              }
              else {
                vehicles.add({
                  "person": task['person']?.toString() ?? null,
                  "todo_date": task['todo_date'] ?? '',
                });
              }

              if (groupedTasks.containsKey(subTitle)) {
                groupedTasks[subTitle]!['vehicles'].addAll(vehicles);
                groupedTasks[subTitle]!['count'] += vehicles.length;
              } else {
                groupedTasks[subTitle] = {
                  "sub_title": subTitle,
                  "count": vehicles.length,
                  "vehicles": vehicles,
                };
              }
            }

            subcategories = groupedTasks.values.toList();
            log("subcategories ${subcategories}",name: "subcategories");
            finalList.add({
              "title": category['title'],
              "count": subcategories.length,
              "subcategory": subcategories
            });
          }
          return finalList;
        }
        List<Map<String, dynamic>> taskData = await formatTaskData(result, combinedHistory);

        log("taskData ${taskData}",name: "taskData");

        //Total amount calculation
        Map<String, dynamic> _calculateTotals(
            List<Map<String, dynamic>> taskData,
            List<Map<String, dynamic>> paymentData,
            )
        {
          final tasks = <Map<String, dynamic>>[];
          int totalAmount = 0;
          int totalCount = 0;

          final paymentMap = {
            for (var payment in paymentData.where((p) => p['type'] == 'task'))
              payment['task_name']?.toString(): _toInt(payment['amount']),
          };

          final taskGroups = <String, Map<String, dynamic>>{};

          for (final category in taskData) {
            final subcategories = category['subcategory'] as List<dynamic>? ?? [];

            for (final subcategory in subcategories) {
              final taskName = subcategory['sub_title']?.toString() ?? '';
              final count = _toInt(subcategory['count']);

              String? matchedTask;
              if (paymentMap.containsKey(taskName)) {
                matchedTask = taskName;
              }
              else {
                for (final paymentTask in paymentMap.keys) {
                  if (paymentTask != null && taskName.toLowerCase().contains(paymentTask.split('/')[0].toLowerCase())) {
                    matchedTask = paymentTask;
                    break;
                  } else {
                    matchedTask = paymentTask;
                  }
                }
              }
              if (matchedTask != null) {
                final amount = paymentMap[matchedTask];
                final key = matchedTask;

                taskGroups.update(key, (existing) => {
                  'name': existing['name'],
                  'count': (existing['count'] as int) + count,
                  'amount': (existing['amount'] as int) + (amount! * count),
                }, ifAbsent: () => {
                  'name': matchedTask!,
                  'count': count,
                  'amount': amount! * count,
                });
              }
            }
          }

          tasks.addAll(taskGroups.values);
          totalAmount = tasks.fold(0, (int sum, task) => sum + (task['amount'] as int));
          totalCount = tasks.fold(0, (int sum, task) => sum + (task['count'] as int));

          return {
            'tasks': tasks,
            'totalAmount': totalAmount,
            'totalCount': totalCount,
          };

        }
        int totalAmount = _calculateTotals(taskData, data!.data ?? [])['totalAmount'];
        //Total amount calculation End

        emit(state.copyWith(
          isLoading: false,
          categoryGroupData: taskData,
          combinedHistory: combinedHistory,
          cohortsData: response1?.data ?? [],
          totalAmount: totalAmount,
          taskData: taskData,
          amountData: data?.data ?? [],
        ));
      }
      catch (e){
        print("error $e");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<ExtendedDetailsTaskEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final response = await apiRepository.editTodoData(id: event.id);
        final response1 = await apiRepository.getAssignedTo();
        final response2 = await apiRepository.fetchUserGroupingList();

        if (response == null || response1 == null || response2 == null) {
          throw Exception('One or more API responses are null');
        }

        final dynamic userId = response.editTodos?['user_id'] ??
            response.editTodos?['user_group_id'];

        if (userId == null) {
          throw Exception('Both user_id and user_group_id are null');
        }

        final userGroup = response2.data?.firstWhere(
              (element) => element['id'] == userId,
          orElse: () => {},
        );

        final userGroupIds = userGroup?['userId']?.toString();

        String getInitials(String ids, List<Map<String, dynamic>> resources) {
          try {
            // Parse IDs string like "[10,16]"
            final idList = ids
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((s) => int.tryParse(s.trim()))
                .where((id) => id != null)
                .toList();

            if (idList.isEmpty) return '';

            return idList.map((id) {
              // Find matching user in resources
              final user = resources.firstWhere(
                    (u) => u['id'] == id,
                orElse: () => {},
              );

              // Extract and format initials
              final firstName = user['first_name']?.toString() ?? '';
              final lastName = user['last_name']?.toString() ?? '';

              final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';
              final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '?';

              return '$firstInitial$lastInitial';
            }).where((initials) => initials.isNotEmpty).join(',');
          } catch (e) {
            log('Initials extraction error: $e');
            return '';
          }
        }

        final initials = userGroupIds != null && response1.resource != null
            ? getInitials(userGroupIds, response1.resource!)
            : '';

        emit(state.copyWith(
          isLoading: false,
          extendedDetails: response.editTodos,
          groupInitials: initials,
        ));

      } catch (e) {
        log('Error in ExtendedDetailsTaskEvent: $e');
        emit(state.copyWith(
          isLoading: false,
        ));
      }
    });

    on<ExtendedDetailsDayEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      Map<String, dynamic> checkInDetails = {};
      final response2 = await apiRepository.getActiveHoursResponse(extractDate(event.startDate), extractDate(event.endDate));
      final response = await apiRepository.fetchEmployeeTaskHistoryByTask(
        date: formatedDate(event.data['date']),
        userId: event.userId, cohortIds: event?.cohortIds ?? [],
      );
      final relevantHours = response2?.data?.where(
            (activeHour) => activeHour['user_id']?.toString() == event.userId.toString() && activeHour['todo_date'].toString() == formatedDate(event.data['date']),
      );
      final int? totalMinutes = relevantHours?.fold(
        0,(total, current) => total! + timeStringToMinutes(current['active_hours']),
      );

      final calculatedActiveHours = minutesToTimeString(totalMinutes!);
      checkInDetails.clear();
      checkInDetails.addAll({
        "checkIn": formatedTime(event.data['start_time']),
        "checkOut": formatedTime(event.data['end_time']),
        "active_hours": calculatedActiveHours,
        "total_hours": formatTime(event.data['total_hours']),
        "date": formatDate(event.data['date']),
      });

      //ByTask Tab calculation

      emit(state.copyWith(checkInDetails: checkInDetails, isLoading: false));
    });

    on<ByDayInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final response = await apiRepository.getEmployeeTaskHistoryByDay(formatedDate(event.date),event.userId);
      log("${response?['data']}", name: "by_day_data");
      emit(state.copyWith(isLoading: false, byDayData: response?['data']));
    });

    on<ByTaskInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      log("${event.date} ${formatedDate(event.date)}", name: "by_task_data");
      final response1 = await apiRepository.fetchCohortData();
      final response3 = await apiRepository.getTaskCategoryGroups();
      final response = await apiRepository.fetchEmployeeTaskHistoryByTask(
        date: formatedDate(event.date),
        userId: event.userId, cohortIds: event?.cohortIds ?? [],
      );
      log("${response?.allHistory}", name: "cohorts_data");
      List<String>? titles = response3?.data?.map((item) => item['name'].toString()).toList();

      List<Map<String, dynamic>> sortTitles(List<String> titles, List<Map<String, dynamic>> taskCategoryGroup) {

        Map<String, List<Map<String, dynamic>>> classifiedTask = {
          'Other': [],
          'Parts': []
        };
        Set<String> addedTitles = {};

        List<String> categoryOrder = [
          'Rental',
          'Repair',
          'Parts',
          'Rental Ready',
          'Maintenance',
          'Operations',
          'Other'
        ];
        if (taskCategoryGroup.isNotEmpty) {
          for (var parentCategory in taskCategoryGroup) {
            if (parentCategory['name'] == 'Sales') continue;

            if (parentCategory['name'] != 'Offshore' && parentCategory['name'] != 'Purchase') {
              classifiedTask[parentCategory['name']] = [];
            }

            if (parentCategory.containsKey('subcategories') && parentCategory['subcategories'] is List) {
              for (var childCategory in parentCategory['subcategories']) {
                for (var title in titles) {
                  String lowercaseTitle = title.toLowerCase();
                  if (lowercaseTitle == childCategory['name'].toLowerCase() && !addedTitles.contains(lowercaseTitle)) {
                    classifiedTask[parentCategory['name']] ??= [];
                    classifiedTask[parentCategory['name']]!.add({
                      'title': title,
                      'id': childCategory['id'] ?? null
                    });
                    addedTitles.add(lowercaseTitle);
                  }
                }
              }
            }

            // Classify titles matching the parent category name
            for (var title in titles) {
              String lowercaseTitle = title.toLowerCase();
              if (lowercaseTitle == parentCategory['name'].toLowerCase() && !addedTitles.contains(lowercaseTitle)) {
                classifiedTask[parentCategory['name']]!.add({
                  'title': title,
                  'id': parentCategory['id'] ?? null
                });
                addedTitles.add(lowercaseTitle);
              }
            }
          }
        }

        // title related to 'Parts'
        for (var title in titles) {
          String lowercaseTitle = title.toLowerCase();
          if (lowercaseTitle.contains('parts') && !addedTitles.contains(lowercaseTitle)) {
            classifiedTask['Parts']!.add({
              'title': title,
              'id': null
            });
            addedTitles.add(lowercaseTitle);
          }
        }

        // Add remaining titles to 'Other'
        for (var title in titles) {
          String lowercaseTitle = title.toLowerCase();
          if (!addedTitles.contains(lowercaseTitle)) {
            classifiedTask['Other']!.add({
              'title': title,
              'id': -1,
            });
            addedTitles.add(lowercaseTitle);
          }
        }

        // Convert classifiedTask map into list format
        List<Map<String, dynamic>> sortedTask = [];

        for (var category in categoryOrder) {
          if (classifiedTask.containsKey(category)) {
            sortedTask.add({
              "title": category,
              "subcategory": classifiedTask[category]!.map((e) => {
                "sub_title": e['title'],
                "id": e['id'],
              }).toList()
            });
          }
        }

        return sortedTask;
      }
      var result = sortTitles(titles!, response3!.data ?? []);

      List<Map<String, dynamic>> formatTaskData(List<Map<String, dynamic>> categoryData, List<Map<String, dynamic>> tasks)
      {
        Map<String, List<Map<String, dynamic>>> classifiedTasks = {};

        // Initialize categories
        for (var category in categoryData) {
          bool includeCategory = category['title'] != 'Other' || event.cohortIds!.contains(-1);
          if (includeCategory) {
            classifiedTasks[category['title']] = [];
          }
        }

        // Classify tasks
        for (var task in tasks) {
          String taskTitle = task['title'];
          bool matched = false;

          for (var category in categoryData) {
            for (var sub in category['subcategory']) {
              if (sub['sub_title'].toString().toLowerCase() == taskTitle.toLowerCase()) {
                classifiedTasks[category['title']]!.add(task);
                matched = true;
                break;
              }
              // else if(taskTitle.toLowerCase().contains(sub['sub_title'].toLowerCase()))
              // {
              //   classifiedTasks[category['title']]!.add(task);
              //   matched = true;
              //   log("matched ${taskTitle} ${sub['sub_title']}",name: "matched");
              //   break;
              // }
            }
            if (matched) break;
          }

          if (!matched || event.cohortIds!.contains(-1)) {
            classifiedTasks['Other'] ??= [];
            classifiedTasks['Other']!.add(task);
          }
        }

        List<Map<String, dynamic>> finalList = [];

        for (var category in categoryData) {
          List<Map<String, dynamic>> subcategories = [];
          Map<String, Map<String, dynamic>> groupedTasks = {}; // Group by sub_title

          for (var task in classifiedTasks[category['title']] ?? []) {
            String subTitle = task['title'];
            List<Map<String, dynamic>> vehicles = [];

            if(task['vehicles'] is List && task['vehicles'].isNotEmpty && task['vehicles'].length > 1){
              vehicles.add({
                "vehicle_name": "MV",
                "todo_date": task['todo_date'] ?? '',
                "id": task['id'],
              });
            }
            else if (task['vehicle_name'] != null && task['vehicle_name'] != '' && task['vehicle_name'] != 'null') {
              vehicles.add({
                "vehicle_name": task['vehicle_name'],
                "todo_date": task['todo_date'] ?? '',
                "id": task['id'],
                "complete_time_taken": task['complete_time_taken']?.toString() ?? '',
              });
            }
            else if (task['vehicles'] != null && task['vehicles'] is List && task['vehicles'].isNotEmpty && task['vehicles'] != []) {
              // Otherwise, check inside `task['vehicles']`
              vehicles = (task['vehicles'] as List<dynamic>)
                  .map<Map<String, dynamic>>((v) => {
                "vehicle_name": v['vehicle_name'],
                "todo_date": task['todo_date'] ?? '',
                "id": task['id'],
                "complete_time_taken": task['complete_time_taken']?.toString() ?? '',
              }).toList();
            } else {
              vehicles.add({
                "person": task['person']?.toString() ?? null,
                "todo_date": task['todo_date'] ?? '',
              });
            }

            if (groupedTasks.containsKey(subTitle)) {
              // Merge vehicles under the same sub_title
              groupedTasks[subTitle]!['vehicles'].addAll(vehicles);
              groupedTasks[subTitle]!['count'] += vehicles.length;
            } else {
              groupedTasks[subTitle] = {
                "sub_title": subTitle,
                "count": vehicles.length,
                "vehicles": vehicles,
              };
            }
          }

          subcategories = groupedTasks.values.toList();
          finalList.add({
            "title": category['title'],
            "count": subcategories.length,
            "subcategory": subcategories
          });
        }
        return finalList;
      }
      List<Map<String, dynamic>> taskData = formatTaskData(result, response!.allHistory);


      emit(state.copyWith(isLoading: false, byTaskData: taskData,cohortsData: response1?.data ?? [],));
    });

    on<TabChangeEvent>((TabChangeEvent event, Emitter<WorkingHoursState> emit) {
      selectedTab = event.tabIndex;
      emit(state.copyWith(selectedTab: selectedTab));
    });

  }


  String formatedDate(String dateString){
    DateFormat format = DateFormat("MM-dd-yyyy");
    DateTime date = format.parse(dateString);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  }

  String formatDate(String dateString){
    DateFormat format = DateFormat("MM-dd-yyyy");
    DateTime date = format.parse(dateString);
    String formattedDate = DateFormat('dd-MMM-yyyy').format(date);
    return formattedDate;
  }

  String formatedTime(String dateString){
    log("${dateString}",name: "date_string");
    if(dateString != ''){
      DateFormat format = DateFormat("HH:mm:ss");
      DateTime date = format.parse(dateString);
      String formattedDate = DateFormat('jm').format(date);
      return formattedDate;
    } else {
      return "";
    }

  }

  String formatTime(String dateString){
    DateFormat format = DateFormat("HH:mm:ss");
    DateTime date = format.parse(dateString);
    String formattedDate = DateFormat('hh:mm').format(date);

    return formattedDate;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
  String extractDate(String datetime) {
    return datetime.split(' ').first;
  }
  String minutesToTimeString(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
  }
  int timeStringToMinutes(String time) {
    final parts = time.split(':');
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    return hours * 60 + minutes;
  }
}


