
// working_hours_bloc.dart
import 'dart:developer';
import 'package:date_time/date_time.dart' hide DateRange;
import 'package:flutter/cupertino.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  List<Map<String, dynamic>> ReasonCombinedData=[];
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

              formattedResources = resources.where((e)=>e['branch_id']==1 || e['branch_id']==null).map((resource) {
                return {
                  'id': resource['id'],
                  'full_name': "${resource['first_name']} ${resource['last_name']}",
                  'first_name': '${resource['first_name']}',
                };
              }).toList();
              print("formattedResources $formattedResources");
              //Helper Function
              String getFirstWord(String fullName) {
                return fullName.split(' ').first;
              }

              List<Map<String, dynamic>> combineData(
                  List<Map<String, dynamic>> workhours,
                  List<Map<String, dynamic>> workhistory,
                  List<Map<String, dynamic>> workActivehours,
                  List<Map<String, dynamic>> formattedResource,
                  ) {
                List<Map<String, dynamic>> combinedList = [];

                for (var workhour in workhours) {
                  try {
                    final userId = workhour['user']['id'];
                    final userName = workhour['user']['name'];

                    // Skip if userId is null
                    if (userId == null) {
                      continue;
                    }

                    Map<String, dynamic> historyItem = {};
                    Map<String, dynamic> activeHoursItem = {};
                    Map<String, dynamic> empID = {};

                    // Find matching history item
                    try {
                      historyItem = workhistory.firstWhere(
                            (item) =>
                        item['users'] != null &&
                            item['users']['hrm_id'] == userId &&
                            formattedResource.any((resource) =>
                            item['users']['first_name'] == resource['first_name']),
                      );
                    } catch (e) {
                      print("Error finding history item for user $userId: $e");
                    }

                    // Find matching active hours item
                    try {
                      activeHoursItem = workActivehours.firstWhere(
                            (item) =>
                        item['active_hours'] != "00:00" &&
                            item['hrm_id'] == userId &&
                            formattedResource.any((resource) => item['user_id'] == resource['user_id']),
                      );
                    } catch (e) {
                      print("Error finding active hours item for user $userId: $e");
                    }

                    // Find matching employee ID from formattedResource
                    try {
                      empID = formattedResource.firstWhere(
                            (item) => getFirstWord(item['full_name']) == getFirstWord(userName),
                      );
                    } catch (e) {
                      print("Error finding employee ID for user $userId: $e");
                    }

                    // Skip if both taskCount and activeHours are default values
                    final taskCount = historyItem['task_count'] ?? 0;
                    final activeHours = activeHoursItem['active_hours'] ?? "00:00";
                    if (taskCount == 0 && activeHours == "00:00") {
                      continue;
                    }

                    // Combine data into a single item
                    final combinedItem = {
                      'id': userId,
                      'empID': historyItem['users']?['id'],
                      'hrmID': historyItem['users']?['hrm_id'] ?? 0,
                      'total_working_hours': workhour['user']['total_working_hours'],
                      'list': workhour['user']['list'],
                      'task_count': taskCount,
                      'first_name': empID['first_name'] ?? '',
                    };

                    combinedList.add(combinedItem);
                  } catch (e) {
                    print("Error processing workhour: $e");
                  }
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
              totalHoursValue.clear();
              activeHours.clear();
              for(var employee in combinedData){
                int lessCount = 0;
                int greaterCount = 0;
                if (employee['list'] != null) {
                  for (var task in employee['list']) {
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
                print("Total hours ${lessCount + greaterCount}");
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
        }).toList()) ?? []; // Ensure it's not null

        log("${dropDownData}", name: "Filtered DropDownData");
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



    on<TaskDateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedDate: event.selectedDate)));

    on<fetchEmployeeCommentEvent>((event, emit) async {
      print("event data---------> ${event.hrmId} ${event.fromDate} ${event.toDate}");
      //Fetch Data
      final comment = await taskRepo.fetchEmployeeComments(
      hrmId: event.hrmId,
      fromDate: event.fromDate,
      toDate: event.toDate,
      );
      List<Map<String, dynamic>> commentList = [];
      commentList.clear();
      commentList = comment!.comments!;
      print("comment ${commentList}");

      //Helper Function

      List<String> getFromDateAndToDate(String dateRange) {
        try {
          dateRange = dateRange.trim();
          if (!dateRange.contains(" - ")) {
            throw Exception("Invalid date range format. Expected format: 'dd/MM/yyyy - dd/MM/yyyy'");
          }
          List<String> dates = dateRange.split(" - ").map((d) => d.trim()).toList();

          if (dates.length != 2) {
            throw Exception("Invalid date range format. Expected format: 'dd/MM/yyyy - dd/MM/yyyy'");
          }
          String normalizeDate(String dateStr) {
            try {
              if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
                DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(dateStr);
                return DateFormat("dd/MM/yyyy").format(parsedDate);
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
          DateTime fromDateParsed = DateFormat("dd/MM/yyyy").parse(fromDateStr);
          DateTime toDateParsed = DateFormat("dd/MM/yyyy").parse(toDateStr);
          String fromDate = DateFormat("yyyy-MM-dd").format(fromDateParsed);
          String toDate = DateFormat("yyyy-MM-dd").format(toDateParsed);
          log("$fromDate $toDate",name:"fromDateToDate");
          return [fromDate, toDate];
        } catch (e) {
          print("Error parsing date range: $e");
          throw Exception("Error parsing date range: ${e.toString()}");
        }
      }

      List<String> result;
      try {
        result = getFromDateAndToDate(event.ReasonPopupSelectedDateRange);
      } catch (e) {
        print("Error parsing date range: $e");
        result = [DateFormat("yyyy-MM-dd").format(DateTime.now()), DateFormat("yyyy-MM-dd").format(DateTime.now())];
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
      log("$ReasonCombinedData",name:"combinedData");
      emit(state.copyWith(
          isLoading: false,comments: ReasonCombinedData));
    });

    on<HoursPopupEvent>((event, emit) async {
        final data = await taskRepo.fetchCheckInoutReason(
        hrmId: event.hrmId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
        final response = await taskRepo.fetchEmployeeTaskCount(
          userId: event.hrmId,
          fromDate: event.fromDate,
          toDate: event.toDate,
        );
        List<Map<String, dynamic>> hoursData = [];
        hoursData = data!.data!;
        List<Map<String, dynamic>> history = [];
        history = response?.history! ?? [];
        print("hoursData $hoursData");
        //print("history $history");

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
            List<Map<String, dynamic>> checkInout
            ) {
          List<Map<String, dynamic>> combinedList = [];

          // Map to organize task counts by date
          Map<String, int> taskCountsMap = {};
          for (var task in taskCounts) {
            final date = DateFormat('yyyy-MM-dd')
                .format(DateFormat('yyyy-MM-dd').parse(task['todo_date'].toString()));

            taskCountsMap[date] = (taskCountsMap[date] ?? 0) +
                (int.tryParse(task['task_count'].toString()) ?? 0);
          }
          // Map to organize check-in/out reasons by date
          Map<String, List<dynamic>> checkinReasonsMap = {};
          Map<String, List<dynamic>> checkoutReasonsMap = {};
          for (var entry in checkInout) {
            final date = DateFormat('yyyy-MM-dd')
                .format(DateFormat('yyyy-MM-dd').parse(entry['date'].toString()));

            checkinReasonsMap.putIfAbsent(date, () => []);
            checkoutReasonsMap.putIfAbsent(date, () => []);

            checkinReasonsMap[date]?.add(entry['checkin_reason']);
            checkoutReasonsMap[date]?.add(entry['checkout_reason']);
          }
          // Combine data
          for (var item in dataList) {
            final String? date = item['date']?.toString();
            if (date == null) continue;

            final taskCount = taskCountsMap[date] ?? 0;
            final List<dynamic> checkinReason = checkinReasonsMap[date] ?? [];
            final List<dynamic> checkoutReason = checkoutReasonsMap[date] ?? [];

            checkinReason.removeWhere((element) => ((element.toString().isEmpty) || (element == null)));
            checkoutReason.removeWhere((element) => ((element.toString().isEmpty) || (element == null)));
            // Combine into a single map
            combinedList.add({
              'date': DateFormat('MM-dd-yyyy').format(DateTime.parse(date)),
              'total_hours': item['total_hours'],
              'start_time': item['start_time'] ?? '',
              'end_time': item['end_time'] ?? '',
              'task_count': taskCount.toString(),
              'checkin_reason': checkinReason,
              'checkout_reason': checkoutReason,
            });
          }
          return combinedList;
        }
        combinedData=combineData(event.dataList,hoursData,history);

        emit(state.copyWith(isLoading: false,hoursData1: combinedData));
    });


    on<TaskInitialEvent>((event, emit) async{
      //Api fetching
      emit(state.copyWith(isLoading: true));
      final taskHistory = await taskRepo.fetchEmployeeTaskHistory(
        to: event.to,
        from: event.from,
        userId: event.userId, cohortIds: event?.cohortIds ?? [],
      );
      List<Map<String, dynamic>> combinedHistory = [];
      if (taskHistory?.history2 != null && taskHistory!.history2 is List) {
        combinedHistory.addAll(taskHistory.history2!.whereType<Map<String, dynamic>>());
      }
      if (taskHistory?.history3 != null && taskHistory!.history3 is List) {
        combinedHistory.addAll(taskHistory.history3!.whereType<Map<String, dynamic>>());
      }
      final data = await taskRepo.fetchGetConfiguration();
      final response1 = await taskRepo.fetchCohortData();
      final response2 = await todoListRepo.getTaskCategoryGroup();
      List<Map<String, dynamic>> taskCategoryGroup = [];
      taskCategoryGroup = response2?.data ?? [];
      //log("${response1!.data?[0]['cohort']}",name: "response1");
      try{
        List<String> titles = taskCategoryGroup.map((item) => item['name'].toString()).toList();

        List<Map<String, dynamic>> sortTitles(List<String> titles, List<Map<String, dynamic>> taskCategoryGroup) {
          Map<String, List<String>> classifiedTask = {
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
                      classifiedTask[parentCategory['name']]!.add(title);
                      addedTitles.add(lowercaseTitle);
                    }
                  }
                }
              }

              // Classify titles matching the parent category name
              for (var title in titles) {
                String lowercaseTitle = title.toLowerCase();
                if (lowercaseTitle == parentCategory['name'].toLowerCase() && !addedTitles.contains(lowercaseTitle)) {
                  classifiedTask[parentCategory['name']]!.add(title);
                  addedTitles.add(lowercaseTitle);
                }
              }
            }
          }

          // Classify any title related to 'Parts'
          for (var title in titles) {
            String lowercaseTitle = title.toLowerCase();
            if (lowercaseTitle.contains('parts') && !addedTitles.contains(lowercaseTitle)) {
              classifiedTask['Parts']!.add(title);
              addedTitles.add(lowercaseTitle);
            }
          }

          // Add remaining titles to 'Other' category
          for (var title in titles) {
            String lowercaseTitle = title.toLowerCase();
            if (!addedTitles.contains(lowercaseTitle)) {
              classifiedTask['Other']!.add(title);
              addedTitles.add(lowercaseTitle);
            }
          }

          // Convert classifiedTask map into the required list format
          List<Map<String, dynamic>> sortedTask = [];

          for (var category in categoryOrder) {
            if (classifiedTask.containsKey(category)) {
              sortedTask.add({
                "title": category,
                "subcategory": classifiedTask[category]!.map((e) => {"sub_title": e}).toList()
              });
            }
          }

          return sortedTask;
        }
        var result = sortTitles(titles, taskCategoryGroup);
        //log("$result",name: "result");

        //Helper Function
        List<Map<String, dynamic>> formatTaskData(
            List<Map<String, dynamic>> categoryData,
            List<Map<String, dynamic>> tasks) {
          Map<String, List<Map<String, dynamic>>> classifiedTasks = {};

          // Initialize categories
          for (var category in categoryData) {
            classifiedTasks[category['title']] = [];
          }

          // Classify tasks
          for (var task in tasks) {
            String taskTitle = task['title'];
            bool matched = false;

            for (var category in categoryData) {
              for (var sub in category['subcategory']) {
                if (sub['sub_title'] == taskTitle) {
                  classifiedTasks[category['title']]!.add(task);
                  matched = true;
                  break;
                }
              }
              if (matched) break;
            }

            if (!matched) {
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

              if (task['vehicle_name'] != null) {
                // First check if `task` has a `vehicle_name`
                vehicles.add({
                  "vehicle_name": task['vehicle_name'],
                  "todo_date": task['todo_date'] ?? '',
                  "id": task['id'],
                });
              } else if (task['vehicles'] != null && task['vehicles'] is List) {
                // Otherwise, check inside `task['vehicles']`
                vehicles = (task['vehicles'] as List<dynamic>)
                    .map<Map<String, dynamic>>((v) => {
                  "vehicle_name": v['vehicle_name'],
                  "todo_date": task['todo_date'] ?? '',
                  "id": task['id'],
                }).toList();
              }

              if (vehicles.isEmpty) {
                vehicles.add({
                  "vehicle_name": "",
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
                  "complete_time_taken": task['complete_time_taken']?.toString() ?? '',
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

        List<Map<String, dynamic>> taskData = formatTaskData(result, combinedHistory);
        //log("$taskData",name: "taskData");

        emit(state.copyWith(
          isLoading: false,
          categoryGroupData: taskData,
          combinedHistory: combinedHistory,
          cohortsData: response1?.data ?? [],
        ));
      }
      catch (e){
        print("error $e");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<ExtendedDetailsTaskEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final response = await todoListRepo.editTodoData(id: event.id);
      //log("${response?.editTodos}",name: "response");
      try{
        emit(state.copyWith(isLoading: false,extendedDetails: response?.editTodos));
      } catch (e){
        print("error $e");
        emit(state.copyWith(isLoading: false));
      }
    });

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


