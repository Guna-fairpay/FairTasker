
// working_hours_bloc.dart
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Repository/job_list_repository.dart';
import '../../../Repository/todo_list_repository.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/Utils.dart';
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
  TextEditingController hourlyAmountCtrl=TextEditingController();
  final TextEditingController dateController = TextEditingController();
  List<Map<String,dynamic>>?selectedResources=[];
  dynamic userRole;
  String? userId;
  int? hrmId;
  int? branchId;
  List<Map<String, dynamic>> dropDownResource=[];
  Map<String, dynamic> initialDropDown = {'id':0,'full_name':'All'};
  dynamic selectedUser;

  WorkingHoursBloc() : super(WorkingHoursState (
      userList: const [],
      selectedUser: const {},
    selectedDateRange: DateRange(
      DateTime.now().subtract(const Duration(days: 7)),
      DateTime.now(),
    ),
  )) {

    String extractDate(String datetime) {
      return datetime.split(' ').first;
    }

    on<WorkingHoursInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try
      {
        initialDropDown = {'id':0,'full_name':'All'};
        if(event.minDate.isNotEmpty || event.maxDate.isNotEmpty)
          {
            log("${extractDate(event.minDate)} ${extractDate(event.maxDate)}", name: "date print");
            final response1 = await todoListRepo.getWorkingHistory(extractDate(event.minDate), extractDate(event.maxDate));//no need
            final response2 = await todoListRepo.getActiveHoursResponse(extractDate(event.minDate), extractDate(event.maxDate));
            final response3 = await authenticationRepo.getAssignedTo();
            final response4 = await todoListRepo.getWorkingHoursData(extractDate(event.minDate), extractDate(event.maxDate));
            final response5 = await todoListRepo.getWorkingHistoryCount(extractDate(event.minDate), extractDate(event.maxDate));
            final response6 = await taskRepo.fetchPunchList();
            if (response1 != null && response2 != null && response3 != null && response4 != null && response5 != null && response6 != null) {
              workingHistory.clear();
              workingHistory = response5!.history!;//1
              workHours.clear();
              workHours = response4.data!;//2
              resources.clear();
              resources=response3.resource!;//3
              workActiveHours.clear();
              workActiveHours = response2.data!;//4


              branchId = await Utils.getIntPreference(Str.branchIdPrefText);
              userRole = await Utils.getStringListPreference(Str.rolePrefText);
              userId = await Utils.getStringPreference(Str.userIdPrefText);
              //hrmId = await Utils.getIntPreference(Str.hrmIdPrefText);


              formattedResources = resources.where((e)=>e['branch_id']==branchId && e['id']!= 1 && e['id']!= 2).map((resource) {
                return {
                  'id': resource['id'],
                  'full_name': "${resource['first_name']} ${resource['last_name']}",
                  'first_name': '${resource['first_name']}',
                  'branch_id' : '${resource['branch_id']}',
                };
              }).toList();
              //print("formattedResources $formattedResources");
              //Helper Function

              List<Map<String, dynamic>> combineAndCalculateData(
                  List<Map<String, dynamic>> workhours,
                  List<Map<String, dynamic>> workhistory,
                  List<Map<String, dynamic>> workActivehours,
                  List<Map<String, dynamic>> formattedResource,
                  )
              {
                List<Map<String, dynamic>> combinedList = [];

                // Helper function to convert time string to minutes
                int timeStringToMinutes(String time) {
                  final parts = time.split(':');
                  final hours = int.tryParse(parts[0]) ?? 0;
                  final minutes = int.tryParse(parts[1]) ?? 0;
                  return hours * 60 + minutes;
                }

                // Helper function to convert minutes to time string
                String minutesToTimeString(int minutes) {
                  final hours = minutes ~/ 60;
                  final remainingMinutes = minutes % 60;
                  return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
                }

                // Helper function to get the first word of a name
                String getFirstWord(String name) {
                  return name.split(' ').first;
                }

                // Helper function to remove seconds from time string
                String removeSeconds(String time) {
                  if (time.length >= 8) { // Check if the time string is in hh:mm:ss format
                    return time.substring(0, 5); // Extract hh:mm
                  }
                  return time; // Return as-is if not in expected format
                }

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
                        orElse: () => {},
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
                        orElse: () => {},
                      );
                    } catch (e) {
                      print("Error finding active hours item for user $userId: $e");
                    }

                    // Find matching employee ID from formattedResource
                    try {
                      empID = formattedResource.firstWhere(
                            (item) => getFirstWord(item['full_name']) == getFirstWord(userName),
                        orElse: () => {},
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

                    // Format the total working hours to remove seconds
                    final rawHours = workhour['user']['total_working_hours'] ?? "00:00:00";
                    final formattedHours = removeSeconds(rawHours);

                    // Combine data into a single item formatted for the table
                    final combinedItem = {
                      'Employee': historyItem['users']?['first_name'] ?? empID['first_name'] ?? getFirstWord(userName),
                      'Active': calculatedActiveHours,
                      'Hours': formattedHours,
                      'Task': taskCount,
                      '#': totalHoursCount,
                      'hrm_id': historyItem['users']?['hrm_id'] ?? userId,
                      'user_id': historyItem['users']?['id'] ?? '',
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
              log("${combinedData}",name:"CombinedData");

              //Punch Card Calculation Start
              List<Map<String, dynamic>> formatEmployeeData(
                  List<Map<String, dynamic>> rawData,
                  List<Map<String, dynamic>> workActiveHours) {

                String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
                log("${today}", name: "Today");

                String formatTime(String timeStr) {
                  if (timeStr.isEmpty) return "";

                  DateTime dateTime = DateFormat("dd-MM-yyyy HH:mm:ss").parseUtc(timeStr);

                  return DateFormat("hh:mm a").format(dateTime);
                }

                String initials(String name) {
                  return name.split(' ').map((e) => e[0]).take(2).join();
                }

                String formatTotal(String total) {
                  List<String> parts = total.split(':');
                  return "${parts[0]}:${parts[1]}"; // Extract HH:MM (Hours and Minutes)
                }

                String calculateElapsedTime(String startTime) {
                  DateTime startDateTime = DateFormat("dd-MM-yyyy HH:mm:ss").parseUtc(startTime);
                  DateTime now = DateTime.now().toUtc().subtract(Duration(hours: 5)); // Convert to EST (UTC-5)

                  if (now.isBefore(startDateTime)) {
                    return "00:00"; // Prevent errors if time is in the future
                  }

                  Duration elapsed = now.difference(startDateTime);
                  int hours = elapsed.inHours;
                  int minutes = elapsed.inMinutes % 60;

                  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
                }

                // Function to sum active hours for today's date
                String sumActiveHours(int hrmId) {
                  int totalMinutes = 0;

                  for (var record in workActiveHours) {
                    if (record['hrm_id'] == hrmId && record['todo_date'] == today) {
                      List<String> timeParts = record['active_hours'].split(':');
                      int hours = int.parse(timeParts[0]);
                      int minutes = int.parse(timeParts[1]);

                      totalMinutes += (hours * 60) + minutes;
                    }
                  }

                  // Convert total minutes into HH:MM format
                  int finalHours = totalMinutes ~/ 60;
                  int finalMinutes = totalMinutes % 60;
                  return "${finalHours.toString().padLeft(2, '0')}:${finalMinutes.toString().padLeft(2, '0')}";
                }

                return rawData.map((data) {
                  String totalTime;

                  if (data['end_time'].isEmpty) {
                    totalTime = calculateElapsedTime(data['start_time']);
                  } else {
                    totalTime = formatTotal(data['total_hours']);
                  }

                  return {
                    "User": initials(data['employee']['name']),
                    "CheckIn": formatTime(data['start_time']),
                    "CheckOut": data['end_time'].isEmpty ? "" : formatTime(data['end_time']),
                    "Active": sumActiveHours(data['employee']['id']), // Assuming active time isn't provided
                    "Total": totalTime,
                  };
                }).toList();
              }

              List<Map<String, dynamic>> formattedData = formatEmployeeData(response6?.data ?? [],workActiveHours);
              log("${formattedData}",name:"FormattedData");
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
                selectedDateRange: selectedDateRange,
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
      emit(state.copyWith(isLoading: true));
      try{
        List<dynamic> resource;
        final response6 = await todoListRepo.getTaskHistoryConfiguration();
        final response3 = await authenticationRepo.getAssignedTo();
        userRole = await Utils.getStringListPreference(Str.rolePrefText);
        userId = await Utils.getStringPreference(Str.userIdPrefText);
        if(response6 != null && response3 != null){
          taskComponentsData = response6.data!;
          resources = response3.resource!;

          formattedResources = resources.map((resource) {
            return {
              'id': resource['id'],
              'full_name': "${resource['first_name']} ${resource['last_name']}",
              'first_name': '${resource['first_name']}',
              'last_name': '${resource['last_name']}',
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
            isLoading: false,
            taskComponentsData: taskComponentsData,
            taskBased: taskBased,
            hourlyBased: hourlyBased,
            selectedBase1: base,
            selectedBase: selectedBase,
            resources: formattedResources,
            resource: resource,
            userList: resources,
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
        {"id": 1, "base": "Task based"},
        {"id": 2, "base": "Hour based"}
      ];
      final apiResponse = await authenticationRepo.getAssignedTo();
      var userListData = apiResponse?.resource;
      dynamic selectedUser = userListData?.firstWhere(
            (resource) => resource['id'] == event.userId,
        orElse: () => {},
      );
      log("${selectedUser}", name: 'TEST1');
      if (event.userId == null) {
        taskNameCtrl.text = event.taskName ?? '';
        amountCtrl.text = event.amount ?? '';
        dynamic selectedBase = base[0];
        log("${selectedBase}", name: 'TEST2');
        print("Emitting task-based state: selectedUser=null, taskId=${event.id}");
        emit(state.copyWith(
          taskId: event.id,
          taskNameController: taskNameCtrl,
          amountController: amountCtrl,
          selectedBase1: base,
          selectedBase: selectedBase,
          selectedUser: null, // Explicitly reset
          userId: null,
        ));
      } else {
        hourlyAmountCtrl.text = event.amount ?? '';
        dynamic selectedBase = base[1];
        log("${selectedBase}", name: 'TEST1');
        print("Emitting hourly state: selectedUser=$selectedUser, taskId=${event.id}");
        emit(state.copyWith(
          taskId: event.id,
          userId: event.userId,
          hourlyAmountController: hourlyAmountCtrl,
          selectedBase1: base,
          selectedBase: selectedBase,
          userList: userListData,
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
        uniqueId: UniqueKey().toString(),
      ));
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
      log("$ReasonCombinedData",name:"combinedData");
      emit(state.copyWith(
          isLoading: false,comments: ReasonCombinedData));
    });

    //Hours popup initial code
    on<HoursPopupEvent>((event, emit) async {
      final data = await taskRepo.fetchCheckInoutReason(
        hrmId: event.hrmId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      final response = await taskRepo.fetchEmployeeTaskCount(
        userId: event.empID,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      List<Map<String, dynamic>> hoursData = [];
      hoursData = data!.data! ?? [];
      List<Map<String, dynamic>> history = [];
      history = response?.history! ?? [];

      print("hoursData $hoursData");
      print("history $history");

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
      log("$combinedData", name: "Hours_popup");
      emit(state.copyWith(isLoading: false, hoursData1: combinedData));
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
          // Change classifiedTask to store a list of maps with title and id
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
                      // Store both title and id (if available, otherwise null)
                      classifiedTask[parentCategory['name']]!.add({
                        'title': title,
                        'id': childCategory['id'] ?? null // Use id from subcategory if it exists
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
                    'id': parentCategory['id'] ?? null // Use id from parent category if it exists
                  });
                  addedTitles.add(lowercaseTitle);
                }
              }
            }
          }

          // Classify any title related to 'Parts'
          for (var title in titles) {
            String lowercaseTitle = title.toLowerCase();
            if (lowercaseTitle.contains('parts') && !addedTitles.contains(lowercaseTitle)) {
              classifiedTask['Parts']!.add({
                'title': title,
                'id': null // No id available here unless sourced elsewhere
              });
              addedTitles.add(lowercaseTitle);
            }
          }

          // Add remaining titles to 'Other' category
          for (var title in titles) {
            String lowercaseTitle = title.toLowerCase();
            if (!addedTitles.contains(lowercaseTitle)) {
              classifiedTask['Other']!.add({
                'title': title,
                'id': null // No id available here unless sourced elsewhere
              });
              addedTitles.add(lowercaseTitle);
            }
          }

          // Convert classifiedTask map into the required list format
          List<Map<String, dynamic>> sortedTask = [];

          for (var category in categoryOrder) {
            if (classifiedTask.containsKey(category)) {
              sortedTask.add({
                "title": category,
                "subcategory": classifiedTask[category]!.map((e) => {
                  "sub_title": e['title'],
                  "id": e['id'] // Include id in the output
                }).toList()
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
            List<Map<String, dynamic>> tasks)
        {
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
        //log("$result",name: "result");
        List<Map<String, dynamic>> taskData = formatTaskData(result, combinedHistory);


        int _convertToInt(dynamic value) {
          if (value is int) return value;
          if (value is double) return value.toInt();
          if (value is String) return int.tryParse(value) ?? 0;
          return 0;
        }
        int calculateTotalAmount(
            List<Map<String, dynamic>> taskData,
            List<Map<String, dynamic>> paymentData,
            ) {
          int total = 0;

          // Create a map of task names to amounts with proper type conversion
          final paymentMap = {
            for (var payment in paymentData.where((p) => p['type'] == 'task'))
              payment['task_name']?.toString(): _convertToInt(payment['amount'])
          };

          // Helper function to check for partial matches
          int? findPaymentAmount(String taskName) {
            // Try exact match first
            if (paymentMap.containsKey(taskName)) {
              return paymentMap[taskName];
            }

            // Check for partial matches
            for (final paymentTask in paymentMap.keys) {
              if (paymentTask != null && taskName.contains(paymentTask.split('/')[0])) {
                return paymentMap[paymentTask];
              }
            }

            return null;
          }

          // Process each task in taskData
          for (final category in taskData) {
            final subcategories = category['subcategory'] as List<dynamic>? ?? [];

            for (final subcategory in subcategories) {
              final taskName = subcategory['sub_title']?.toString() ?? '';
              final count = _convertToInt(subcategory['count'] ?? 0);

              final amount = findPaymentAmount(taskName);
              if (amount != null) {
                total += amount * count;
              }
            }
          }

          return total;
        }

        int totalAmount = calculateTotalAmount(taskData,data?.data ?? []);
        log("$totalAmount",name: "totalAmount");

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
        final response = await todoListRepo.editTodoData(id: event.id);
        final response1 = await authenticationRepo.getAssignedTo();
        final response2 = await todoListRepo.fetchUserGroupingList();

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

        log("${response.editTodos}", name: "userIds");
        log("$userGroupIds", name: "userGroupIds");

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
        log("Extracted initials: $initials", name: "InitialsResult");


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

    on<UpdateDateRangeEvent>((event, emit) {
      emit(state.copyWith(selectedDateRange: event.selectedRange));
    });

  }
}


