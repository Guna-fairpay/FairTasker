
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_view_ui.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Bloc/location_data_bloc.dart';
import 'package:fairpytasker/Response/create_todo_params.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:fairpytasker/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Response/todo_list_response.dart';
import '../../Utilities/image_pick_helper.dart';
import '../../widget/time_picker_only.dart';
import '../Manage Custom Data/Parts/part_view_ui.dart';
import '../Manage Custom Data/Supplies/supplies_view_ui.dart';
import '../Manage Employees/Employees/employees_view_ui.dart';
import '../Vehicle/vehicle_history_detail_ui.dart';
import '../Vehicle/vehicle_history_module_ui.dart';

class CreateTodoUI extends StatefulWidget {
  final List<Map<String, dynamic>?>? selectedAssignedTo;
  final bool showHeader;

  const CreateTodoUI({Key? key, this.selectedAssignedTo, this.showHeader = true}) : super(key: key);

  @override
  State<CreateTodoUI> createState() => _CreateTodoUIState();
}

class _CreateTodoUIState extends State<CreateTodoUI> {

  TodoListRepo? todoListRepo;

  TodoViewBloc? todoBloc;
  VehicleDataBloc? vehicleDataBloc;
  LocationDataBloc? locationDataBloc;

  final GlobalKey _key = GlobalKey();

  CreateTodoParams createTodoParamForVHistory = CreateTodoParams();

  CleanCarTimeValues? selectedCleanCarTime;
  DateTime? endSelectedDate = DateTime.now();
  DateTime? modifiedDateTime;
  OverlayEntry? overlay;
  Color? textColors;
  Color textColor = AppC.text;

  List<CleanCarTimeValues> cleanCarTimeValuesList = [];
  List<DaysPojo> daysPojoList = [];
  List<MonthsPojo> monthsPojoList = [];

  List<Map<String, dynamic>?>? selectedAssignedTo = [];
  List<Map<String, dynamic>> vehicleHistoryData = [];
  List<Map<String, dynamic>>? todoItem;
  List<Map<String, dynamic>> resourceList = [];
  List<Map<String, dynamic>> resourceListForCombination = [];
  List<Map<String, dynamic>> vendorList = [];
  List<Map<String, dynamic>> taskExpenseList = [];
  List<Map<String, dynamic>> locationList = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> selectedPartsList = [];
  List<Map<String, dynamic>> editPartsSuggestionList = [];
  List<Map<String, dynamic>> editPartsList = [];
  List<Map<String, dynamic>> vehicleGroupList = [];
  List<Map<String, dynamic>> userGroupList = [];
  List<Map<String, dynamic>> categoriesListData = [];
  List<Map<String, dynamic>> selectedSuppliesList = [];
  List<Map<String, dynamic>> selectedMultipleVehicleList = [];
  List<Map<String, dynamic>> selectedMultipleAddressList = [];
  List<Map<String, dynamic>> editMultipleAddressList = [];
  List<Map<String, dynamic>> todoImages = [];
  List<Map<String, dynamic>>? vehicleGroupLists;
  List<Map<String, dynamic>> editSuppliesList = [];
  List<Map<String, dynamic>> editMultipleVehicleList = [];
  List<Map<String, dynamic>> cohortsData = [];
  List<Map<String, dynamic>> todoList = [];

  List<dynamic> editSuppliesSuggestionList = [];
  List<dynamic> editMultipleVehicleSuggestionList = [];
  List<dynamic> editMultipleAddressSuggestionList = [];
  List<dynamic> selectedVehicleName = [];

  List<String> taskIdentifierSuggestionList = [];
  List<String> vehiclePersonSuggestionList = [];
  List<String> vendorLocationSuggestionList = [];
  List<String> taskSuggestionList = [];
  List<String> selectedIds = [];

  List<String> priorityList = ['High - On Time', 'Medium', 'Low', 'Feature'];
  List<String> daysList = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  List<Map<String, dynamic>> customTaskOptions = [
    { 'id': "1", 'label': "Custom Link" },
    { 'id': "2", 'label': "Turo Reservation ID" },
    { 'id': "3", 'label': "Getaround ReservationID"},
  ];
  List<dynamic> repeatList = [
    { 'id': "1", 'label': "Doesn't repeat" },
    { 'id': "2", 'label': "Daily" },
    { 'id': "3", 'label': "Weekly" },
    { 'id': "4", 'label': "Monthly" },
    { 'id': "1", 'label': "Yearly" },];
  List<dynamic> monthsList = [
    {'month' : 'January'},
    {'month' : 'February'},
    {'month' : 'March'},
    {'month' : 'April'},
    {'month' : 'May'},
    {'month' : 'June'},
    {'month' : 'July'},
    {'month' : 'August'},
    {'month' : 'September'},
    {'month' : 'October'},
    {'month' : 'November'},
    {'month' : 'December'},
  ];

  static List<String> stringArr = [];

  bool isShowVehicleHistoryList = false;
  bool isShowMultipleAddressField = false;
  bool showDaily = false;
  bool showMonthly = false;
  bool showWeekly = false;
  bool showYearly = false;
  bool showList = false;
  bool showVehiclePersonList = false;
  bool showVendorLocationList = false;
  bool showTaskList = false;
  bool allDay = false;
  bool reminder = false;
  bool? isSelected = false;
  bool? isVehicleSelected = false;
  bool editShowSuppliesList = false;
  bool editShowMultipleVehicleList = false;
  bool editShowPartsList = false;
  bool editShowAddressList = false;
  bool showAutoComplete = false;
  bool? isPartsEdit;
  bool? isSupplyEdit;
  bool? isVehicleGroupEdit;
  bool timeSensitive = false;
  bool showMore = false;
  bool endDateSwitch = true;
  bool occurrenceDate = true;
  bool isTaskNameFieldEmpty = false;
  bool lastSelectedIsPerson = false;
  bool isPartChecked = false;
  bool isSupplyChecked = false;
  bool isMultipleVehicleChecked = true;
  bool isVisibleIcon = false;

  final FocusNode searchFocusNode = FocusNode();

  TextEditingController vehicleSearchController = TextEditingController();
  TextEditingController todoDateController = TextEditingController();
  TextEditingController todoNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  String? selectedMultipleAddressId;
  String? selectedPriority;
  String? vehicleGroupName;
  String? userGroupConcatenationName;
  String endDateModuleString = "End Date";
  String lastEditedId = '';

  dynamic selectedCohort;
  dynamic selectedVehicle;
  dynamic selectedLink;
  dynamic selectedRepeat;
  dynamic selectedMonth;

  Map<String, String> taskNameList = {};

  int? availCar;
  int position = 0;
  int count = 0;
  int cursorPosition = 0;

  TextEditingController taskIdentifierController = TextEditingController();
  TextEditingController vehiclePersonController = TextEditingController();
  TextEditingController vendorLocationController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController editPartsController = TextEditingController();
  TextEditingController editSuppliesController = TextEditingController();
  TextEditingController editMultipleVehicleController = TextEditingController();
  TextEditingController editMultipleAddressController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController noOfOccurrencesController = TextEditingController();
  TextEditingController occurEveryDayController = TextEditingController();
  TextEditingController occurEveryWeekController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController dayMonthlyController = TextEditingController();
  TextEditingController dayYearlyController = TextEditingController();
  TextEditingController reservationController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    todoListRepo = TodoListRepo();
    todoBloc = TodoViewBloc();
    vehicleDataBloc = VehicleDataBloc();
    todoBloc!.add(const GetDropdownData());
    todoBloc!.add(const GetVehicleListData());
    todoBloc!.add(const GetTaskExpenseData());
    todoBloc!.add(const GetVendorData());
    todoBloc!.add(const GetLocationData());
    todoBloc!.add(const GetPartsList());
    todoBloc!.add(const GetSuppliesList());
    todoBloc!.add(const GetVehicleGroupingList());
    todoBloc!.add(const GetUserGroupingList());
    selectedPriority = priorityList[1];
    todoListRepo!.chosenDateTime = selectedDate;
    todoListRepo!.chosenDateTimeString =
        DateFormat("hh:mm a").format(todoListRepo!.chosenDateTime!);
    todoListRepo!.startTimeTFString =
        DateFormat("HH:mm:ss").format(todoListRepo!.chosenDateTime!);
    for (var s in monthsList) {
      MonthsPojo monthsPojo = MonthsPojo(monthName: s['month'], selected: false);
      monthsPojoList.add(monthsPojo);
    }
    for (String s in daysList) {
      DaysPojo daysPojo = DaysPojo(dayName: s, selected: false);
      daysPojoList.add(daysPojo);
    }
    todoDateController.text = Utils.convertDateTimeToTheFormat(selectedDate.toString());
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 60));
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 45));
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 30));
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 15));
    selectedCleanCarTime = cleanCarTimeValuesList[0];
    vehicleDataBloc = VehicleDataBloc();
    locationDataBloc = LocationDataBloc();
    Utils.getStringPreference(Str.userIdPrefText).then((id) {
      if(id != '1'){
      selectedIds = id.split(',');}
    });
    selectedLink = customTaskOptions.firstWhere(
          (item) => item['id'] == '1',
      orElse: () => {},
    );

    selectedRepeat = repeatList.firstWhere(
          (item) => item['id'] == '1',
      orElse: () => {},
    );

    selectedMonth = monthsList.firstWhere(
          (item) => item['month'] == 'January',
      orElse: () => {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.showHeader) ?  Scaffold(
      backgroundColor: AppC.white,
      appBar: widget.showHeader
          ? AppBar(
              titleSpacing: -8,
              elevation: 0,
              backgroundColor: AppC.appColor,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: AppC.white,
                  )),
              title: Utils.getText('Add Todo',
                  size: 18, weight: FontWeight.w700, color: AppC.white),
              actions: [
                GestureDetector(
                  child:
                      const Icon(Icons.upload, color: AppC.green),
                  onTap: () async {
                    MultiImagePickHelper imageHelper = MultiImagePickHelper();
                    await imageHelper.getMultiImage(ImageSource.gallery).then((selectedFiles) {
                      if (selectedFiles.isNotEmpty) {
                        for (var filePath in selectedFiles) {
                          debugPrint('filePath: $filePath');
                            todoImages.add({
                            'path': filePath,
                          });
                        }
                        setState(() {}); // Refresh the UI
                      } else {
                        debugPrint("No images selected.");
                      }
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: todoImages.isNotEmpty,
                  child: GestureDetector(
                    onTap: (){
                      final imagePath= todoImages
                          .map((attachment) => attachment['path'].toString())
                          .toList();
                      const int initialIndex = 0; // Or any index from your list
                      _showImageDialog(imagePath, initialIndex);
                    },
                    child: const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 18,
                      color: AppC.green,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 10,
                  child: Checkbox(
                    value: timeSensitive,
                    checkColor: AppC.white, // The color of the check mark
                    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppC.blue;
                      }
                      return AppC.white;
                    }),
                    onChanged: (bool? value) {
                      setState(() {
                        timeSensitive = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Utils.getText('Time Sensitive',
                    color: AppC.white, weight: FontWeight.bold),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: const Icon(Icons.save, color: AppC.green),
                  onTap: () {
                    doCreateTodo();
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.close_sharp, color: AppC.grey),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          : null,
      body: body,
    ) : body;
  }

  Widget get body => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => todoBloc!..add(const GetAssignedToList()),
      ),
      BlocProvider(
        create: (context) => vehicleDataBloc!..add(const VehicleInitial()),
      ),
      BlocProvider(
        create: (context) =>
        locationDataBloc!..add(const AddedLocationInitial()),
      ),
    ],
    child: MultiBlocListener(
      listeners: [
        BlocListener<TodoViewBloc, TodoViewState>(
          listener: (context, state) {
            if (state is VehicleDataLoaded) {
              if (state.vehicleData != null) {
                vehicleList.addAll(state.vehicleData ?? []);
                editMultipleVehicleList.addAll(state.vehicleData ?? []);
                selectedVehicleName.addAll(state.vehicleData ?? []);
              }
            } else if (state is AssignedToLoaded) {
              /* resourceList = state.resource ?? [];
                  if (widget.selectedAssignedTo != null &&
                      widget.selectedAssignedTo!.isNotEmpty) {
                    // selectedAssignedTo = (widget.selectedAssignedTo!??[])!;
                    bool containsAll = widget.selectedAssignedTo!
                        .any((resource) => resource!['id'] == -1);
                    if (containsAll) {
                      for (var element in resourceList) {
                        nameIsSelected = true;
                        (selectedAssignedTo ?? []).add(element);
                      }
                    } else {
                      (selectedAssignedTo ?? [])
                          .addAll(widget.selectedAssignedTo ?? []);
                      for (int i = 0; i < resourceList.length; i++) {
                        if (i < (widget.selectedAssignedTo ?? []).length &&
                            nameIsSelected) {
                          nameIsSelected = true;
                        } else {
                          nameIsSelected = false;
                        }
                      }
                      *//*for (var element in resourceList) {
                        if (element.id == widget.selectedAssignedTo!.id) {
                          element.isSelected = true;
                          selectedAssignedTo.add(element);
                        }
                      }*//*
                    }
                  } else {
                    nameIsSelected = true;
                    (selectedAssignedTo ?? []).add(resourceList[0]);
                  }
                  resourceListForCombination = state.resource ?? [];
                  for (Map<String, dynamic> res in resourceListForCombination) {
                    Map<String, dynamic> vehiclesData = {
                      'id': res['id'],
                      'vehicle_name': '${res['first_name']} ${res['last_name']}',
                      //'isSelected': false
                    };
                    editMultipleVehicleList.add(vehiclesData);
                  }

                  if (todoItem != null) {
                    for (Map<String, dynamic> resource in resourceList) {
                      debugPrint('todoItem!.resource.id: ${resource['id']}');
                    }
                  }*/
              resourceList = [];
              resourceList = state.resource ?? [];
              resourceList.removeWhere((resource) => resource['id'] == 2);
              isSelected = true;
              selectedAssignedTo?.add(resourceList[0]);
              resourceListForCombination = state.resource ?? [];
              // for (Map<String, dynamic> resource in resourceList) {
              //   if (resource['id'].toString().trim() ==
              //       (todoItem['users']?['id'] ?? 0).toString()) {
              //     selectedResource = resource;
              //   }
              // }
              for (Map<String, dynamic> res in resourceListForCombination) {
                Map<String, dynamic> vehiclesData = {
                  'id': res['id'],
                  'vehicle_name':
                  '${res['first_name']}${res['last_name']}',
                  //'isSelected': false
                };
                editMultipleVehicleList.add(vehiclesData);
              }
            } else if (state is TaskExpenseLoaded) {
              taskExpenseList = (state.resource ?? []);
            } else if (state is VendorLoaded) {
              vendorList = (state.resource ?? []);
            } else if (state is LocationLoaded) {
              locationList = (state.resource ?? []);
            } else if (state is CreateTodoLoaded) {
              if (state.result != null && state.result!) {
                if (state.exitTheScreen != null && state.exitTheScreen!) {
                  todoNameController.clear();
                  descriptionController.clear();
                  todoDateController.clear();
                  todoListRepo!.chosenDateTimeString = null;
                  todoListRepo!.selectedHours = null;
                  todoListRepo!.endTimeString = null;
                  selectedPriority = null;
                  selectedAssignedTo = [];
                  Navigator.of(context).pop(true);
                }

              }
            } else if (state is PartsLoaded) {
              if (state.partsList != null) {
                editPartsList.addAll(state.partsList!);
              }
            } else if (state is SuppliesLoaded) {
              if (state.suppliesList != null) {
                editSuppliesList.addAll(state.suppliesList!);
              }
            } else if (state is VehicleGroupListLoaded) {
              vehicleGroupList.clear();
              vehicleGroupList.addAll(state.vehicleGroupDataList ?? []);
            } else if (state is UserGroupListLoaded) {
              userGroupList.clear();
              userGroupList.addAll(state.userGroupDataList ?? []);
            } else if (state is DropdownDataLoaded) {
              categoriesListData.clear();
              categoriesListData.addAll(
                  state.createExpenseFieldData!.expenseCategories ?? []);
            }
          },
        ),
        BlocListener<VehicleDataBloc, VehicleDataState>(
          listener: (context, state) {
            if (state is TodoItemCompletedVeh) {
              show(
                  context,
                  (state.status) == 'In Progress'
                      ? 'The todo marked as In Progress.'
                      : 'The todo marked as Completed.',
                  (state.status) == 'In Progress'
                      ? 'Completed'
                      : 'In Progress');
              if (state.result != null && state.result!) {
                vehicleDataBloc!.add(GetVehicleHistoryEvent(
                    vin: createTodoParamForVHistory.vin,
                    vehicleGroupId:
                    createTodoParamForVHistory.vehicleGroupId != null
                        ? int.parse(
                        createTodoParamForVHistory.vehicleGroupId!)
                        : null));
              }
            } else if (state is VehicleHistoryLoaded) {
              if (state.vehicleHistoryList != null) {
                todoList.clear();
                todoListRepo!.vehicleHistoryTempSearchList.clear();
                for (Map<String, dynamic> todos
                in state.vehicleHistoryList!) {
                  if (todos['status'] == 'Completed') {
                    textColors = AppC().base;
                  } else {
                    textColors = AppC.text;
                  }
                }
                /*List<Todos> list = [];
                      list.addAll(state.vehicleHistoryList ?? []);
                      list.sort((a, b) => DateTime.parse(a.createdAt ?? '')
                          .compareTo(DateTime.parse(b.createdAt ?? '')));
                      todoList.addAll(list.reversed.toList());*/
                todoList.addAll(state.vehicleHistoryList!);
                todoListRepo!.vehicleHistoryTempSearchList
                    .addAll(/*todoList*/ state.vehicleHistoryList!);
                // debugPrint(
                //     'cleancar.title: ${(todoListRepo!.vehicleHistoryTempSearchList)[0]['title'] ?? ''}');
                doSetState();
              }
            } else if (state is VehicleHistoryListLoaded) {
              vehicleHistoryData.clear();
              vehicleHistoryData.addAll(state.todo ?? []);
            }
          },
        ),
        BlocListener<LocationDataBloc, LocationDataState>(
          listener: (context, state) {
            if (state is LocationListLoaded) {
              if (state.resource != null) {
                for (int i = 0; i < state.resource!.length; i++) {
                  if (selectedMultipleAddressId != null &&
                      state.resource![i]['id'] ==
                          int.parse(selectedMultipleAddressId!)) {
                    isShowMultipleAddressField = true;
                    editMultipleAddressList
                        .addAll(state.resource![i]['addresses'] ?? []);
                  }
                }
              }
            }
          },
        )
      ],
      child: BlocBuilder<TodoViewBloc, TodoViewState>(
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: (widget.showHeader) ? NeverScrollableScrollPhysics() : ScrollPhysics(),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    showList = false;
                    showVehiclePersonList = false;
                    showVendorLocationList = false;
                    editShowPartsList = false;
                    editShowSuppliesList = false;
                    editShowMultipleVehicleList = false;
                    editShowAddressList = false;
                    setState(() {});
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      if (widget.showHeader)
                        const SizedBox(
                          height: 15,
                        ),
                      Utils.getTextFormField(
                        'Task Identifier', taskIdentifierController,
                        label: Utils.getText('Task Identifier'),
                        readOnly: false,
                        onChangeCallback: (value) async {
                          setState(() {
                            taskSuggestionList.clear();
                            if (value.isNotEmpty) {
                              List taskList = taskExpenseList
                                  .map((e) => e['task'] ?? '')
                                  .toList();
                              taskSuggestionList.addAll(
                                  Utils.searchList(taskList, value));
                              showTaskList =
                                  taskSuggestionList.isNotEmpty;
                            } else {
                              showTaskList = false;
                            }
                          });
                          String textCurrentlyEditing =
                          getTextBeforeCursor();
                          debugPrint(
                              'textCurrentlyEditing: $textCurrentlyEditing');
                          count = countHyphens(textCurrentlyEditing);
                          debugPrint('count: $count');
                          taskIdentifierSuggestionList.clear();
                          if (count == 0) {
                            taskIdentifierSuggestionList.clear();
                            for (var e in taskExpenseList) {
                              if (e['task_identifier'] != null &&
                                  e['task_identifier']!.isNotEmpty &&
                                  (e['task_identifier']!)
                                      .contains(stringArr[0])) {
                                taskNameList[e['task_identifier']!] =
                                (e['task'] ?? '');
                                taskIdentifierSuggestionList.add(
                                    (e['task_identifier'] ?? '').trim());
                              }
                            }
                            showList = taskIdentifierSuggestionList
                                .isNotEmpty &&
                                stringArr[0].isNotEmpty;
                          } else if (count == 1) {
                            taskIdentifierSuggestionList.clear();
                            // for (dynamic name in editMultipleVehicleList) {
                            //   if (name is Map<String, dynamic> && name.containsKey('vehicle_name')) {
                            //     taskIdentifierSuggestionList.add(name['vehicle_name']);
                            //   } else {
                            //     print("Unexpected data format: $name");
                            //   }
                            // }
                            for (var e in resourceListForCombination) {
                              if ((e['first_name'] != null ||
                                  e['last_name'] != null) &&
                                  ('${e['first_name'] ?? ''} ${e['last_name'] ?? ''}')
                                      .contains(stringArr[1])) {
                                taskIdentifierSuggestionList.add(
                                    '${e['first_name'] ?? ''.trim()} ${e['last_name'] ?? ''.trim()}');
                              }
                            }
                            for (var e in (vehicleList)) {
                              if (e['vehicle_name'] != null &&
                                  (e['vehicle_name']!).contains(stringArr[1])) {
                                taskIdentifierSuggestionList.add(
                                    e['vehicle_name'] ?? ''.trim());
                              }
                            }
                            for (var e in resourceListForCombination) {
                              if ((e['first_name'] != null &&
                                  (e['first_name']!.toLowerCase())
                                      .contains(stringArr[1]
                                      .toLowerCase())) ||
                                  (e['last_name'] != null &&
                                      (e['last_name']!.toLowerCase())
                                          .contains(stringArr[1]
                                          .toLowerCase()))) {
                                taskIdentifierSuggestionList.add(
                                    '${e['first_name']} ${e['last_name']}'
                                        .trim());
                              }
                            }
                            for (var e in vehicleGroupList) {
                              if (e['name'] != null &&
                                  (e['name']!).contains(stringArr[1])) {
                                taskIdentifierSuggestionList
                                    .add(e['name'] ?? ''.trim());
                              }
                            }
                            showList = taskIdentifierSuggestionList
                                .isNotEmpty &&
                                stringArr[1].isNotEmpty;
                            await getSelectedVehiclePerson(
                                createTodoParamForVHistory)
                                .then((value) {
                              if ((value.vin != null &&
                                  value.vin!.isNotEmpty) ||
                                  (value.vehicleGroupId != null &&
                                      value.vehicleGroupId!
                                          .isNotEmpty)) {
                                editShowMultipleVehicleList = true;
                              } else {
                                editShowMultipleVehicleList = false;
                              }
                            });
                          } else if (count == 2) {
                            taskIdentifierSuggestionList.clear();
                            for (var e in vendorList) {
                              if (e['name'] != null &&
                                  (e['name']!).contains(stringArr[2])) {
                                taskIdentifierSuggestionList
                                    .add(e['name'] ?? ''.trim());
                              }
                            }
                            for (var e in locationList) {
                              if (e['name'] != null &&
                                  (e['name']!).contains(stringArr[2])) {
                                taskIdentifierSuggestionList
                                    .add(e['name'] ?? ''.trim());
                              }
                            }
                            showList = taskIdentifierSuggestionList
                                .isNotEmpty &&
                                stringArr[2].isNotEmpty;
                          }
                          todoNameController.text =
                          stringArr.isNotEmpty ? stringArr[0] : '';
                          vehiclePersonController.text =
                          stringArr.length >= 2 ? stringArr[1] : '';
                          vendorLocationController.text =
                          stringArr.length >= 3 ? stringArr[2] : '';
                        },
                        // suffixIcon: Visibility(
                        //   // visible: !editShowPartsList,
                        //   child: InkWell(
                        //       onTap: () async {
                        //         await Navigator.of(context)
                        //             .push(MaterialPageRoute(
                        //           builder: (context) =>
                        //           const TaskViewUI(),
                        //         ));
                        //        },
                        //       child: Icon(Icons.add,
                        //           color: AppC().base, size: 20)),
                        // )
                      ),
                      taskIdentifierStack(),
                      Column(
                        children: [
                          taskManagerDateTimeWidget(),
                          repeatSwitches()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Utils.getAddFilledButton(
                            'Save',
                                () async {
                              await doCreateTodo();
                            },
                            bgColor: AppC.green,
                          ),
                          const SizedBox(width: 5),
                          /* if (selectedMultipleVehicleList.where((item) => item.vehicleId != null).isNotEmpty) ...[
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Utils.getText(
                                              selectedMultipleVehicleList.last.vehicleName ?? '',
                                              color: AppC.text,
                                              weight: FontWeight.bold,
                                              overFlow: TextOverflow.ellipsis, // Add ellipsis to avoid overflow
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => VehicleHistoryViewUI(
                                                    vin: selectedMultipleVehicleList.last.vin,
                                                    vehicleName: selectedMultipleVehicleList.last.vehicleName,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4),
                                                color: AppC.appColor,
                                              ),
                                              padding: const EdgeInsets.all(2.0),
                                              child: Utils.getText(
                                                'History',
                                                color: AppC.white,
                                                weight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],*/
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Visibility(
                      //     visible: isShowVehicleHistoryList,
                      //
                      //     child: BlocBuilder<VehicleDataBloc, VehicleDataState>(
                      //       builder: (context, state) {
                      //         return Column(
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   horizontal: 5.0),
                      //               child: Row(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   Expanded(
                      //                     child: Utils.getText(
                      //                         createTodoParamForVHistory.vin != null
                      //                             ? createTodoParamForVHistory.vehicleName ?? ''
                      //                             : createTodoParamForVHistory.vehicleGroupName ?? '',
                      //                         size: 16,
                      //                         weight: FontWeight.w600),
                      //                   ),
                      //                   const SizedBox(
                      //                     width: 12,
                      //                   ),
                      //                   InkWell(
                      //                     onTap: () {
                      //                       Utils.getImageTitleDialog(context,
                      //                           createTodoParamForVHistory.vehicleName ?? '',
                      //                           createTodoParamForVHistory.vehicleImage ?? '');
                      //                     },
                      //                     child: Icon(
                      //                       Icons.remove_red_eye,
                      //                       color: AppC().base,
                      //                       size: 18,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               height: 15,
                      //             ),
                      //             Visibility(
                      //               visible:
                      //               true /*state is VehicleHistoryLoaded*/,
                      //               child: vehicleHistoryUIWithoutScaffold(
                      //                   outerTodos:(
                      //                       vehicleName:
                      //                       createTodoParamForVHistory
                      //                           .vehicleName,
                      //                       vehicleGroupId: 0,
                      //                       vin:
                      //                       createTodoParamForVHistory
                      //                           .vin,
                      //                       vehicleImage:
                      //                       createTodoParamForVHistory
                      //                           .vehicleImage,
                      //                       vehicleGroupName:
                      //                       createTodoParamForVHistory
                      //                           .vehicleGroupName)),
                      //             )
                      //           ],
                      //         );
                      //       },
                      //     )),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: showTaskList,
                child: Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Utils.customAutoCompleteList(
                      taskSuggestionList,
                          (index) {
                        setState(() {
                          showTaskList = false;
                          countHyphens('');
                          todoNameController.text =
                          taskSuggestionList[index];
                          taskIdentifierController.text =
                          '${taskSuggestionList[index]}-'; // Hide the suggestions list after selection
                          // Set the cursor at the end of the text
                          todoNameController.selection =
                              TextSelection.fromPosition(
                                TextPosition(
                                    offset: todoNameController.text.length),
                              );
                        });
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: state is TodoListLoading,
                  child: Center(child: Utils.getProgressIndicator(context)))
            ],
          );
        },
      ),
    ),
  );

  Future<void> openLink(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      log('Error launching URL: $e');
    }
  }

  void _showImageDialog(List<String> imageUrls, int index) {
    ValueNotifier<int> currentIndex = ValueNotifier<int>(index);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppC.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<int>(
                        valueListenable: currentIndex,
                        builder: (context, currentIndexValue, _) {
                          final imagePath = imageUrls[currentIndexValue];
                          return GestureDetector(
                            onDoubleTap: (){

                            },
                            child: InteractiveViewer(
                                maxScale: 8.0,
                                minScale: 0.01,
                                child: Image.file(
                                  File(imagePath),
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.error, color: Colors.red),
                                    );
                                  },
                                )
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (currentIndex.value > 0) {
                              currentIndex.value -= 1;
                            }
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        SmoothPageIndicator(
                          controller: PageController(initialPage:index),
                          count: imageUrls.length,
                          effect: const JumpingDotEffect(
                            spacing: 8.0,
                            radius: 8.0,
                            dotWidth: 10.0,
                            dotHeight: 10.0,
                            paintStyle: PaintingStyle.fill,
                            strokeWidth: 1.5,
                            dotColor: Colors.grey,
                            activeDotColor: Colors.indigo,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (currentIndex.value < imageUrls.length - 1) {
                              currentIndex.value += 1;
                            }
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool findIsPersonOrVehicle(Map<String, dynamic> vehiclesData) {
    for (Map<String, dynamic> res in resourceList) {
      if ('${res['first_name']}${res['last_name']}' ==
          (vehiclesData['vehicle_name'] ?? '').trim()) {
        lastSelectedIsPerson = true;
        return lastSelectedIsPerson;
      }
    }
    for (Map<String, dynamic> veh in vehicleList) {
      if (veh['vehicle_name'] == (vehiclesData['vehicle_name'] ?? '').trim()) {
        return false;
      }
    }
    return false;
  }

  Future<CreateTodoParams> getSelectedVendorLocation(CreateTodoParams createTodoParams) {
    for (Map<String, dynamic> res in vendorList) {
      if ('${res['name']}' == vendorLocationController.text.trim()) {
        createTodoParams.vendorName = res['name'];
        createTodoParams.vendorId = res['id']!.toString();
      }
    }
    if (createTodoParams.vendorId == '') {
      for (Map<String, dynamic> veh in locationList) {
        if (veh['name'] == vendorLocationController.text.trim()) {
          createTodoParams.location = veh['name'];
          createTodoParams.locationId = veh['id']!.toString();
          debugPrint(
              'createTodoParams.locationId: ${createTodoParams.locationId}');
        }
      }
    }
    return Future.value(createTodoParams);
  }

  String getTextBeforeCursor() {
    TextSelection selection = taskIdentifierController.selection;
    int cursorPosition = selection.baseOffset;
    String text = taskIdentifierController.text;

    if (cursorPosition > 0 && cursorPosition <= text.length) {
      return text.substring(0, cursorPosition);
    } else {
      return '';
    }
  }

  int countHyphens(String inputString) {
    List<String> stringArrLocal = inputString.split("-");

    int hyphenCount = stringArrLocal.length - 1;
    stringArr = taskIdentifierController.text.split("-");

    return hyphenCount;
  }

  Widget dailyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 2,
            child: Center(
                child: Utils.getText('Occur Every',weight: FontWeight.bold)
            ),
        ),
        Expanded(flex: 4,
          child: Utils.getTextFormField(
              'eg:1,2,3', occurEveryDayController,
               textType: TextInputType.number,
              textInputFormatter: [FilteringTextInputFormatter.digitsOnly,]
          ),
        ),
        Expanded(flex: 1, child: Center(child: Utils.getText('days',weight: FontWeight.bold)))
      ],
    );
  }

  Widget weekWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 2,
          child: Center(
              child: Utils.getText('Occur Every',weight: FontWeight.bold)
          ),
        ),
        Expanded(flex: 4,
          child: Utils.getTextFormField(
              'eg:1,2,3', occurEveryWeekController,
              textType: TextInputType.number,
              textInputFormatter: [FilteringTextInputFormatter.digitsOnly,]
          ),
        ),
        Expanded(flex: 1, child: Center(child: Utils.getText('weeks',weight: FontWeight.bold)))
      ],
    ),
        const SizedBox(height: 10,),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 2,
          runSpacing: 10,
          children: List<Widget>.generate(
            daysPojoList.length,
            (int idx) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width:20,
                      height: 20,
                      child: Checkbox(
                          activeColor: AppC().base,
                          value: daysPojoList[idx].selected ?? false,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onChanged: (bool? value) {
                            daysPojoList[idx].selected = value;
                            // daysSelected
                            setState(() {});
                          }),
                    ),
                    const SizedBox(width: 5),
                    Utils.getText(daysPojoList[idx].dayName ?? '')
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  Widget monthlyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 45,
              child: Transform.scale(
                scale: 0.65,
                child: Switch(
                    trackOutlineColor: WidgetStateColor.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppC().base;
                        } else {
                          return AppC.grey;
                        }
                      },
                    ),
                    inactiveThumbColor: AppC.white,
                    inactiveTrackColor: AppC.grey,
                    activeColor: AppC().base,
                    value: occurrenceDate,
                    onChanged: (value) {
                      occurrenceDate = value;
                      setState(() {});
                    }),
              ),
            ),
            Expanded(
                flex: 3,
                child: Center(
                    child: Center(child: Utils.getText('Occurrence Date')))),
            Visibility(
              visible: !occurrenceDate,
              replacement: Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    height: 40,
                    child: Utils.getTextFormField(
                        'Day', dayMonthlyController,
                        textType: TextInputType.number,
                        // maxLength: 2,
                        label: Utils.getText('Day'), onChangeCallback: (value) {
                      if (int.tryParse((value ?? '0'))! > 31) {
                        dayMonthlyController.clear();
                        dayMonthlyController.text = value[0];
                        dayMonthlyController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: (dayMonthlyController.text.length)));
                      }
                    }),
                  ),
                ),
              ),
              child: Expanded(
                flex: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child:
                        Utils.getTextFormField(
                            'eg: first,last', monthController,
                           ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child:
                        Utils.getTextFormField(
                            'eg: monday,tuesday', dayController,
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Center(
                    child: Center(child: Utils.getText('of every month'))))
          ],
        ),
      ],
    );
  }

  Widget repeatDropdown() {
    return
        Utils.dropdownBox('', repeatList,
              selectedKey: selectedRepeat,
              (selectedValue) {
                setState(() {
                  selectedRepeat = selectedValue;
                  if (selectedRepeat['label'] == "Doesn't repeat") {
                    showDaily = false;
                    showMonthly = false;
                    showWeekly = false;
                    showYearly = false;
                  } else if (selectedRepeat['label'] == 'Daily') {
                    showDaily = true;
                    showMonthly = false;
                    showWeekly = false;
                    showYearly = false;
                  } else if (selectedRepeat['label'] == 'Weekly') {
                    showDaily = false;
                    showMonthly = false;
                    showWeekly = true;
                    showYearly = false;
                  } else if (selectedRepeat['label'] == 'Monthly') {
                    showDaily = false;
                    showMonthly = true;
                    showWeekly = false;
                    showYearly = false;
                  } else if (selectedRepeat['label'] == 'Yearly') {
                    showDaily = false;
                    showMonthly = false;
                    showWeekly = false;
                    showYearly = true;
                  }
                });

        }, labelKey: 'label',
        initialSelection: selectedRepeat,
        );
  }

  Widget repeatSwitches() {
    return Visibility(
      visible: showDaily || showWeekly || showMonthly || showYearly,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 40,
                child: Transform.scale(
                  scale: 0.65,
                  child: Switch(
                      trackOutlineColor: WidgetStateColor.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppC().base;
                          } else {
                            return AppC.grey;
                          }
                        },
                      ),
                      inactiveThumbColor: AppC.white,
                      inactiveTrackColor: AppC.grey,
                      activeColor: AppC().base,
                      value: endDateSwitch,
                      onChanged: (value) {
                        endDateSwitch = value;
                        if (endDateSwitch) {
                          endDateModuleString = "End Date";
                        } else {
                          endDateModuleString = "End After";
                        }
                        setState(() {});
                      }),
                ),
              ),
              const SizedBox(width: 10,),
              Utils.getText(endDateModuleString,weight: FontWeight.bold),
              const SizedBox(width: 10,),
              Expanded(
                child: Visibility(
                  visible: endDateSwitch,
                  replacement: Utils.getTextFormField(
                      'No. of occurrences', noOfOccurrencesController,
                      // textType: TextInputType.number,
                      // maxLength: 3,
                      label: Utils.getText('No. of occurrences')),
                  child: Utils.getTextFormField(
                      'Select Date', endDateController, readOnly: true,
                      onTapCallback: () {
                        Utils.todoDatePickerDialog(context, '').then((value) {
                          endSelectedDate = value;
                          endDateController.text =
                              Utils.convertDateTimeToTheFormat(value.toString());
                        });
                      }, label: Utils.getText('Select Date')),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget taskManagerDateTimeWidget() {
    return Stack(
      children: [
        Visibility(visible: showDaily, child: dailyWidget()),
        Visibility(visible: showWeekly, child: weekWidget()),
        Visibility(visible: showMonthly, child: monthlyWidget()),
        Visibility(visible: showYearly, child: yearlyWidget()),
      ],
    );
  }

  Widget taskIdentifierStack() {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            //const SizedBox(height: 10),
            Utils.getTextFormField(
                'Task Name', todoNameController,
                label: Utils.getText('Task Name'),
              borderColor: isTaskNameFieldEmpty && todoNameController.text.isEmpty
                  ? Colors.red
                  : AppC.fieldBase,
              suffixIcon: isTaskNameFieldEmpty && todoNameController.text.isEmpty
                  ? const Icon(
                  Icons.error_outline,
                  color: Colors.red):null,
            ),
            Visibility(
              visible: isMultipleVehicleChecked,
              child: Column(
                children: [
                  /*const SizedBox(
                    height: 15,
                  ),*/
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppC.fieldBase,
                          width: Num.borderWidthField,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Num.subradiusButton))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: List<Widget>.generate(
                            selectedMultipleVehicleList.length,
                            (int idx) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Chip(
                                    // deleteIconColor: AppC.red,
                                    onDeleted: () {
                                      for (var element
                                          in editMultipleVehicleList) {
                                        if (element['vehicle_name'] ==
                                            selectedMultipleVehicleList[idx]
                                                ['vehicle_name']) {
                                          isVehicleSelected = false;
                                          // element.isMultipleVehSelected = false;
                                        }
                                      }
                                      selectedMultipleVehicleList.removeAt(idx);
                                      setState(() {});
                                    },
                                    side: const BorderSide(
                                        color: AppC.trans),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      color: AppC.red,
                                      size: 18,
                                    ),
                                    backgroundColor: const Color(0xffb5d2bb),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    // side: BorderSide(),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Utils.getText(
                                            selectedMultipleVehicleList[idx]
                                                    ['vehicle_name'] ??
                                                '',
                                            color: AppC.text),
                                      ],
                                    ),
                                  ));
                            },
                          ).toList(),
                        ),
                        const SizedBox(height: 5),
                        Utils.getTextFormField(
                          'Vehicle/Person', vehiclePersonController,
                          label: Utils.getText('Vehicle/Person'),
                          readOnly: false,
                          onChangeCallback: (value) {
                            editMultipleVehicleSuggestionList.clear();
                            if (value.isNotEmpty) {
                              List<dynamic> multipleVehicleList =
                                  editMultipleVehicleList; // Keep your original list
                              editMultipleVehicleSuggestionList.addAll(
                                  Utils.searchObjectList(
                                      multipleVehicleList, value,
                                      isVehicleData: true));
                              editShowMultipleVehicleList =
                                  editMultipleVehicleSuggestionList.isNotEmpty;
                            } else {
                              // If the input is empty, set editShowMultipleVehicleList to false
                              editShowMultipleVehicleList = false;
                            }
                            setState(() {});
                          },
                          suffixIcon: Visibility(
                            visible: !editShowMultipleVehicleList && vehiclePersonController.text.isNotEmpty,
                            child: InkWell(
                                onTapDown: (details) {
                                  Utils.showStringPopupMenu(
                                      context, ['Add Vehicle', 'Add Person'], details,
                                          (value) async {
                                        if (value == 'Add Vehicle') {
                                          await Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => const VehicleViewUI(),
                                          ));
                                        } else {
                                          await Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => const EmployeesViewUI(),
                                          ));
                                        }
                                      });
                                },
                                child: Icon(Icons.add, color: AppC().base, size: 20)),
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Column(
                  children: [
                    vendorLocationStack()
                  ],
                ),
                Visibility(
                    visible: editShowMultipleVehicleList,
                    child: Utils.customAutoCompleteWithUnSelectedOption(
                        editMultipleVehicleSuggestionList, (index) {
                      editShowMultipleVehicleList = false;
                      countHyphens('');
                      if (findIsPersonOrVehicle(
                          editMultipleVehicleSuggestionList[index])) {
                        selectedMultipleVehicleList.clear();
                        selectedMultipleVehicleList
                            .add(editMultipleVehicleSuggestionList[index]);
                        isSelected = true;
                        vehiclePersonController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: (vehiclePersonController.text.length)),
                        );
                        setState(() {});
                        vehiclePersonController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: (vehiclePersonController.text.length)),
                        );
                      }
                      else {
                        if (lastSelectedIsPerson) {
                          selectedMultipleVehicleList.clear();
                          lastSelectedIsPerson = false;
                        }
                        selectedMultipleVehicleList
                            .add(editMultipleVehicleSuggestionList[index]);
                        isSelected = true;
                        vehiclePersonController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: (vehiclePersonController.text.length)),
                        );
                        setState(() {});
                        vehiclePersonController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: (vehiclePersonController.text.length)),
                        );
                      }
                    }, isVehicleData: true
                    ),
                ),
              ],
            ),
          ],
        ),
        Visibility(
          visible: showList,
          child: Container(
            decoration: BoxDecoration(
                color: AppC.white,
                borderRadius: BorderRadius.circular(Num.radiusButton),
                border: Border.all(
                  color: AppC.fieldBase,
                  width: Num.borderWidthThinField,
                )),
            height: (30.0 * (taskIdentifierSuggestionList.length) > 350
                ? 350
                : (30.0 * (taskIdentifierSuggestionList.length))),
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                itemCount: taskIdentifierSuggestionList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () async {
                        showList = false;
                        if (count == 0) {
                          todoNameController.text = taskNameList[
                                  taskIdentifierSuggestionList[index]] ??
                              '';
                          if (stringArr.length == 1) {
                            taskIdentifierController.text =
                                '${taskIdentifierSuggestionList[index]}-';
                          } else if (stringArr.length == 2) {
                            taskIdentifierController.text =
                                '${taskIdentifierSuggestionList[index]}-${stringArr[1]}-';
                          } else if (stringArr.length == 3) {
                            taskIdentifierController.text =
                                '${taskIdentifierSuggestionList[index]}-${stringArr[1]}-${stringArr[2]}';
                          }
                          cursorPosition =
                              '${taskIdentifierSuggestionList[index]}-'.length;
                        } else if (count == 1) {
                          vehiclePersonController.text =
                              taskIdentifierSuggestionList[index];
                          if (stringArr.length == 2) {
                            taskIdentifierController.text =
                                '${stringArr[0]}-${taskIdentifierSuggestionList[index]}-';
                          } else if (stringArr.length == 3) {
                            taskIdentifierController.text =
                                '${stringArr[0]}-${taskIdentifierSuggestionList[index]}-${stringArr[2]}';
                          }
                          cursorPosition =
                              '${stringArr[0]}-${taskIdentifierSuggestionList[index]}-'
                                  .length;
                          if (vehiclePersonController.text.isNotEmpty) {
                            await getSelectedVehiclePerson(
                                    createTodoParamForVHistory)
                                .then((value) {
                              if ((value.vin != null &&
                                      value.vin!.isNotEmpty) ||
                                  (value.vehicleGroupId != null &&
                                      value.vehicleGroupId!.isNotEmpty)) {
                                isShowVehicleHistoryList = true;
                                // vehicleDataBloc = VehicleDataBloc();
                                vehicleDataBloc!.add(GetVehicleHistoryEvent(
                                    vin: value.vin,
                                    vehicleGroupId: /*value.vehicleGroupId != null ?*/
                                        /*int.parse(value.vehicleGroupId??'0') :*/ null));
                                setState(() {});
                              } else {
                                isShowVehicleHistoryList = false;
                                setState(() {});
                              }

                              setState(() {});
                            });
                          }
                        } else if (count == 2) {
                          vendorLocationController.text =
                              taskIdentifierSuggestionList[index];
                          if (stringArr.length == 3) {
                            taskIdentifierController.text =
                                '${stringArr[0]}-${stringArr[1]}-${taskIdentifierSuggestionList[index]}';
                            cursorPosition =
                                taskIdentifierController.text.length;
                          }
                          if (vendorLocationController.text.isNotEmpty) {
                            await getSelectedVendorLocation(
                                    createTodoParamForVHistory)
                                .then((value) {
                              if (value.locationId != null &&
                                  value.locationId!.isNotEmpty) {
                                isShowMultipleAddressField = true;
                                //TODO: call location GetAddedLocationListData()
                                selectedMultipleAddressId = value.locationId!;
                                locationDataBloc!
                                    .add(const GetAddedLocationListData());
                                setState(() {});
                              } else {
                                isShowMultipleAddressField = false;
                                setState(() {});
                              }

                              setState(() {});
                            });
                          }
                        }
                        taskIdentifierController.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: (cursorPosition)),
                        );
                        setState(() {});
                        // Move the cursor to the end of the text
                        taskIdentifierController.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: (cursorPosition)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child:
                            Utils.getText(taskIdentifierSuggestionList[index]),
                      ));
                }),
          ),
        ),
      ],
    );
  }

  Widget vendorLocationStack() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*const SizedBox(
              height: 15,
            ),*/
            Utils.getTextFormField(
              'Vendor / Location', vendorLocationController,
              label: Utils.getText('Vendor / Location'),
              readOnly: false,
              onChangeCallback: (value) {
                // String textCurrentlyEditing = getTextBeforeCursor();
                // debugPrint('textCurrentlyEditing: $textCurrentlyEditing');
                vendorLocationSuggestionList.clear();
                if (value.isNotEmpty) {
                  List vendorLocationList =
                      vendorList.map((e) => e['name'] ?? '').toList() +
                          locationList.map((e) => e['name'] ?? '').toList();
                  vendorLocationSuggestionList
                      .addAll(Utils.searchList(vendorLocationList, value));
                  showVendorLocationList =
                      vendorLocationSuggestionList.isNotEmpty;
                } else {
                  showVendorLocationList = false;
                }

                setState(() {});
              },
              // suffixIcon: Visibility(
              //   // visible: !editShowVendorLocationList,
              //   child: InkWell(
              //       onTapDown: (details) {
              //         Utils.showStringPopupMenu(
              //             context, ['Add Vendor', 'Add Location'], details,
              //                 (value) async {
              //               if (value == 'Add Vendor') {
              //                 await Navigator.of(context).push(MaterialPageRoute(
              //                   builder: (context) => const VendorViewUI(),
              //                 ));
              //               } else {
              //                 await Navigator.of(context).push(MaterialPageRoute(
              //                   builder: (context) => const LocationViewUI(),
              //                 ));
              //               }
              //             });
              //       },
              //       child: Icon(Icons.add, color: AppC().base, size: 20)),
              // )
            ),
            partsStack()
          ],
        ),
      ],
    );
  }

  Widget getPartSupplyCheckBoxRow() {
    return Row(
      children: [
        Utils.getCircleCheckWidget(() {
          isPartChecked = !isPartChecked;
          setState(() {});
        }, isPartChecked, 'Parts/Services'),
        const SizedBox(
          width: 35,
        ),
        Utils.getCircleCheckWidget(() {
          isSupplyChecked = !isSupplyChecked;
          setState(() {});
        }, isSupplyChecked, 'Supplies'),
        const Spacer(),
        Visibility(
          visible: (availCar = checkCleanCarAvail()) != 0,
          child: Row(
            children: [
              InkWell(
                  onTap: () async {
                    if (modifiedDateTime != null) {
                      // debugPrint('modifiedDateTime1: $modifiedDateTime');
                      await doCreateTodo(
                          todoName: 'Clean Car',
                          time:
                              DateFormat("HH:mm:ss").format(modifiedDateTime!));
                      // debugPrint('modifiedDateTime2: ${DateFormat("HH:mm:ss").format(modifiedDateTime!)}');
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: Utils.getBoxDecoration(
                          borderColor: availCar == 2 ? AppC.red : AppC.green),
                      child: const Icon(Icons.local_car_wash_sharp))),
              const SizedBox(
                width: 15,
              ),
              Container(
                width: 80,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppC.fieldBase,
                      width: Num.borderWidthField,
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Num.radiusButton))),
                child: DropdownButton<CleanCarTimeValues>(
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Utils.getText('', color: AppC.grey),
                  ),
                  value: selectedCleanCarTime,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 0,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  onChanged: (CleanCarTimeValues? value) {
                    // This is called when the user selects an item.
                    selectedCleanCarTime = value;
                    modifiedDateTime = todoListRepo!.chosenDateTime!.subtract(
                        Duration(minutes: selectedCleanCarTime!.minutes!));
                    debugPrint('modifiedDateTime1: $modifiedDateTime');
                    setState(() {});
                  },
                  items: cleanCarTimeValuesList
                      .map<DropdownMenuItem<CleanCarTimeValues>>(
                          (CleanCarTimeValues value) {
                    return DropdownMenuItem<CleanCarTimeValues>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Utils.getText((value.minutes ?? 0).toString()),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget partsStack() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Utils.getTextFormField(
                'Notes', notesController,
                label: Utils.getText('Notes'),
                readOnly: false,
                onChangeCallback: (value) {}),
            const SizedBox(height: 10,),
            Visibility(
              visible: !showMore,
              child: InkWell(
                  onTap: () {
                    showMore = !showMore;
                    setState(() {});
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Utils.getText('More...',
                          color: Colors.lightBlue.shade800),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: SizedBox(height:30,
                          child: Utils.dropdownBox(
                            '',
                            customTaskOptions ,
                                (selectedValue) {
                              setState(() {
                                selectedLink = selectedValue;
                              });
                            },
                            labelKey: 'label',
                            selectedKey: selectedLink,
                            initialSelection: selectedLink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      InkWell(
                        key: _key,
                        onTap: () async {
                          final RenderBox renderBox = _key
                              .currentContext!
                              .findRenderObject()
                          as RenderBox;
                          final Offset offset = renderBox
                              .localToGlobal(Offset.zero);
                          final Size size = renderBox.size;
                          await showMenu(
                            elevation: 5,
                            color: AppC.white,
                            context: context,
                            constraints:BoxConstraints.tightFor(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 45),
                            position: RelativeRect.fromLTRB(
                              offset.dx,
                              offset.dy + size.height,
                              offset.dx + size.width,
                              offset.dy,
                            ), // Adjust as needed
                            items: [
                              PopupMenuItem(
                                height:30,
                                child: Builder(
                                    builder: (context) {
                                      return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [

                                          Expanded(
                                            child: SizedBox(
                                              height: 30,
                                              child:selectedLink['id']=='1'?
                                              Utils.getTextFormField(
                                                  'Link',
                                                  linkController
                                              ): Utils.getTextFormField(
                                                'Reservation',
                                                reservationController,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(
                                                  context); // Close the popup menu
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  8.0),
                                              child: Icon(
                                                Icons.close,
                                                color: AppC.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                ),
                              ),
                            ],
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(4),
                            color: AppC.appColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3.0),
                          child: Utils.getText(
                            selectedLink['id'] =='1'
                                ? '+ Link'
                                : '+ Reservation',
                            color: AppC.white,
                            size: 12,
                            overFlow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Visibility(visible: showMore, child: getPartSupplyCheckBoxRow()),
            Visibility(
              visible: isPartChecked && showMore,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 10, left: 3, right: 3, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppC.fieldBase,
                          width: Num.borderWidthField,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Num.subradiusButton))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: List<Widget>.generate(
                            selectedPartsList.length,
                            (int idx) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Chip(
                                    // deleteIconColor: AppC.red,
                                    onDeleted: () {
                                      selectedPartsList.removeAt(idx);
                                      setState(() {});
                                    },
                                    side: const BorderSide(color: AppC.trans),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      color: AppC.red,
                                      size: 18,
                                    ),
                                    backgroundColor: const Color(0xffb5d2bb),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    // side: BorderSide(),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Utils.getText(
                                            selectedPartsList[idx]['name'] ??
                                                '',
                                            color: AppC.text),
                                      ],
                                    ),
                                  ));
                            },
                          ).toList(),
                        ),
                        //const SizedBox(height: 15),
                        Utils.getTextFormField(
                          'Parts',
                          editPartsController,
                          label: Utils.getText('Parts'),
                          readOnly: false,
                          onChangeCallback: (value) {
                            // Clear the current suggestions and filter the parts based on input
                            setState(() {
                              if (value.isNotEmpty) {
                                editPartsSuggestionList.clear();
                                editPartsSuggestionList = editPartsList
                                    .where((part) => part['name']
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                                // Show the list only if there are suggestions
                                editShowPartsList =
                                    editPartsSuggestionList.isNotEmpty;
                                setState(() {});
                              } else {
                                editShowPartsList = false;
                              }
                            });
                          },
                          suffixIcon: Visibility(
                            visible: !editShowPartsList && editPartsController.text.isNotEmpty,
                            child: InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const PartViewUI(),
                                  ),
                                );
                              },
                          child: Icon(Icons.add, color: AppC().base, size: 20),
                          ),
                           ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            suppliesStack()
          ],
        ),
        Visibility(
          visible: showVendorLocationList,
          child: Utils.customAutoCompleteList(vendorLocationSuggestionList,
              (index) async {
            showVendorLocationList = false;
            countHyphens('');
            vendorLocationController.text =
                vendorLocationSuggestionList[index] ?? '';
            if (stringArr.length == 1) {
              taskIdentifierController.text =
                  '${stringArr[0]}--${vendorLocationSuggestionList[index]}';
            } else if (stringArr.length >= 2) {
              taskIdentifierController.text =
                  '${stringArr[0]}-${stringArr[1]}-${vendorLocationSuggestionList[index]}';
            }
            vendorLocationController.selection = TextSelection.fromPosition(
              TextPosition(offset: (vendorLocationController.text.length)),
            );
            setState(() {});
            vendorLocationController.selection = TextSelection.fromPosition(
              TextPosition(offset: (vendorLocationController.text.length)),
            );
            if (vendorLocationController.text.isNotEmpty) {
              await getSelectedVendorLocation(createTodoParamForVHistory)
                  .then((value) {
                if (value.locationId != null && value.locationId!.isNotEmpty) {
                  selectedMultipleAddressId = value.locationId!;
                  //TODO: call location GetAddedLocationListData()
                  locationDataBloc!.add(const GetAddedLocationListData());
                  setState(() {});
                } /*else {
                  isShowMultipleAddressField = false;
                  setState(() {});
                }
*/
                setState(() {});
              });
            }
          }),
        ),
      ],
    );
  }

  Widget suppliesStack() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: isSupplyChecked && showMore,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 10, left: 3, right: 3, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppC.fieldBase,
                          width: Num.borderWidthField,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Num.subradiusButton))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: List<Widget>.generate(
                            selectedSuppliesList.length,
                            (int idx) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Chip(
                                    // deleteIconColor: AppC.red,
                                    onDeleted: () {
                                      for (var element in editSuppliesList) {
                                        if (element['id'] ==
                                            selectedSuppliesList[idx]['id']) {
                                          isSelected = false;
                                        }
                                      }
                                      selectedSuppliesList.removeAt(idx);
                                      setState(() {});
                                    },
                                    side: const BorderSide(color: AppC.trans),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      color: AppC.red,
                                      size: 18,
                                    ),
                                    backgroundColor: const Color(0xffb5d2bb),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    // side: BorderSide(),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Utils.getText(
                                            selectedSuppliesList[idx]['name'] ??
                                                '',
                                            color: AppC.text),
                                      ],
                                    ),
                                  ));
                            },
                          ).toList(),
                        ),
                        //const SizedBox(height: 15),
                        Utils.getTextFormField(
                          'Supplies', editSuppliesController,
                          label: Utils.getText('Supplies'),
                          readOnly: false,
                          onChangeCallback: (value) {
                            editSuppliesSuggestionList.clear();
                            List<dynamic> supplyList =
                                editSuppliesList /*.map((e) =>'${e.name}').toList()*/;

                            editSuppliesSuggestionList.addAll(
                                Utils.searchObjectList(supplyList, value));
                            editShowSuppliesList =
                                editSuppliesSuggestionList.isNotEmpty;
                            setState(() {});
                          },
                          suffixIcon: Visibility(
                            visible: !editShowSuppliesList && editSuppliesController.text.isNotEmpty,
                            child: InkWell(
                                onTap: () async {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => const SuppliesViewUI(),
                                  ));
                                },
                                child: Icon(Icons.add,
                                    color: AppC().base, size: 20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //SizedBox(height: 10,),
            Visibility(
              visible: showMore,
              child: InkWell(
                onTap: () {
                  showMore = !showMore;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Utils.getText('Less...',
                          color: Colors.lightBlue.shade800),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: SizedBox(height:30,
                          child: Utils.dropdownBox(
                            '',
                            customTaskOptions ,
                                (selectedValue) {
                              setState(() {
                                selectedLink = selectedValue;
                              });
                            },
                            labelKey: 'label',
                            selectedKey: selectedLink,
                            initialSelection: selectedLink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      InkWell(
                        key: _key,
                        onTap: () async {
                          final RenderBox renderBox = _key
                              .currentContext!
                              .findRenderObject()
                          as RenderBox;
                          final Offset offset = renderBox
                              .localToGlobal(Offset.zero);
                          final Size size = renderBox.size;
                          await showMenu(
                            elevation: 5,
                            color: AppC.white,
                            context: context,
                            constraints:BoxConstraints.tightFor(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 45),
                            position: RelativeRect.fromLTRB(
                              offset.dx,
                              offset.dy + size.height,
                              offset.dx + size.width,
                              offset.dy,
                            ), // Adjust as needed
                            items: [
                              PopupMenuItem(
                                height:30,
                                child: Builder(
                                    builder: (context) {
                                      return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [

                                          Expanded(
                                            child: SizedBox(
                                              height: 30,
                                              child:selectedLink['id']=='1'?
                                              Utils.getTextFormField(
                                                  'Link',
                                                  linkController
                                              ): Utils.getTextFormField(
                                                'Reservation',
                                                reservationController,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(
                                                  context); // Close the popup menu
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  8.0),
                                              child: Icon(
                                                Icons.close,
                                                color: AppC.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                ),
                              ),
                            ],
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(4),
                            color: AppC.appColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3.0),
                          child: Utils.getText(
                            selectedLink['id'] =='1'
                                ? '+ Link'
                                : '+ Reservation',
                            color: AppC.white,
                            size: 12,
                            overFlow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      String url = '';
                      if (selectedLink['id'] == '2') {
                        url = 'https://turo.com/us/en/reservation/${reservationController.text}';
                      } else if (selectedLink['id'] == '3') {
                        url = 'https://getaround.com/dashboard/rentals/${reservationController.text}';
                      }
                      else if (selectedLink['id'] == '1') {
                        url = linkController.text;
                      }
                      if (url.isNotEmpty) {
                        openLink(url);
                      }
                    },
                    child: Utils.getText(
                      (selectedLink['id'] == '2' || selectedLink['id'] == '3')&& reservationController.text.isNotEmpty
                          ? 'Reservation No - ${reservationController.text}'
                          : linkController.text,
                      color:AppC.appColor,
                      decoration: TextDecoration.underline,
                      colorDecoration:AppC.appColor,
                      overFlow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Utils.getText('Task Manager', weight: FontWeight.bold),
                        const SizedBox(
                          height: 5,
                        ),
                        Wrap(
                          children: List<Widget>.generate(
                            resourceList.length,
                                (int idx) {
                                  final resourceId = resourceList[idx]['id'].toString();
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
                                child: ChoiceChip(
                                  showCheckmark: false,
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                                  selectedColor: AppC.appColor,
                                  backgroundColor: const Color(0xfff3f6f9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: const BorderSide(color: AppC.appColor),
                                  label: Utils.getText(
                                    '${resourceList[idx]['first_name']} ${resourceList[idx]['last_name']}',
                                    color: selectedIds.contains(resourceId) ? AppC.white : AppC.text,
                                    size: 12,
                                  ),
                                  selected: selectedIds.contains(resourceId),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        if (!selectedIds.contains(resourceId)) {
                                          selectedIds.add(resourceId);
                                          selectedAssignedTo?.add(resourceList[idx]);
                                        }
                                      } else {
                                        selectedIds.remove(resourceId);
                                        selectedAssignedTo?.removeWhere(
                                              (item) => item?['id'] == resourceList[idx]['id'],
                                        );
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        const SizedBox(height: 5,),
                        if(selectedIds.isEmpty)
                         Utils.getText('Please select task manager',color: const Color(0xffd01601)),
                        const SizedBox(height: 10,),
                        Utils.getText('Task Date/Time',
                            weight: FontWeight.w500),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: Utils.getTextFormField(
                                      'Todo Date', todoDateController,
                                      readOnly: true, onTapCallback: () {
                                Utils.todoDatePickerDialog(context, '').then((value) {
                                  selectedDate = value!;
                                  todoDateController.text =
                                      Utils.convertDateTimeToTheFormat(value.toString());
                                });
                              }, label: Utils.getText('Todo Date')),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: SizedBox(
                              height: 35,
                              child: TimePickerViewOnly(
                                todoListRepo: todoListRepo,
                                voidCallback: () {
                                  setState(() {});
                                },
                              ),
                            )),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(child:repeatDropdown()),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
/*
                        Utils.getDropDownSearch(
                            priorityList[0],
                            priorityList,
                                (value) {
                              selectedPriority = value;
                              setState(() {});
                            },
                            selectedPriority,
                            'Priority',
                                (context, value, isSelected) {
                              return Utils.popupDropDownBuilder(label: value);
                            },
                                (context, value) {
                              return Utils.getText(value ?? '');
                            }, showSearch: false),
                        const SizedBox(
                          height: 15,
                        ),
*/
                      ],
                    ),
                    Visibility(
                        visible: editShowSuppliesList,
                        child: Utils.customAutoCompleteWithUnSelectedOption(
                            editSuppliesSuggestionList, (index) {
                          editShowSuppliesList = false;
                          countHyphens('');
                          selectedSuppliesList
                              .add(editSuppliesSuggestionList[index]);
                          isSelected = true;
                          editSuppliesController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: (editSuppliesController.text.length)),
                          );
                          setState(() {});
                          editSuppliesController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: (editSuppliesController.text.length)),
                          );
                        })),
                  ],
                ),
              ],
            ),
          ],
        ),
        Visibility(
          visible: editShowPartsList,
          child: Utils.customAutoCompleteListParts(
            editPartsSuggestionList,
            (index) {
              setState(() {
                editShowPartsList = false;
                countHyphens('');
                // Add selected part to the list and update UI
                selectedPartsList.add(editPartsSuggestionList[index]);
                editPartsController.text =
                    editPartsSuggestionList[index]['name'];

                // Move cursor to the end of the text field
                editPartsController.selection = TextSelection.fromPosition(
                  TextPosition(offset: editPartsController.text.length),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget yearlyWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Utils.getText('Date',weight: FontWeight.bold),
        const SizedBox(width: 15,),
        Expanded(
          child: Utils.getTextFormField(
              'date', dayYearlyController,
              textType: TextInputType.number,
              onChangeCallback: (value) {
            String prev = dayYearlyController.text;
            if (int.tryParse((value ?? '0'))! > 31) {
              dayYearlyController.clear();
              dayYearlyController.text = value[0];
              dayYearlyController.selection = TextSelection.fromPosition(
                  TextPosition(offset: (dayYearlyController.text.length)));
            } else {}
          }),
        ),
        const SizedBox(width: 15,),
        Utils.getText('Month',weight: FontWeight.bold),
        const SizedBox(width: 15,),
        Expanded(
          flex: 1,
          child: Utils.dropdownBox(
              '',
              monthsList,
                  (selectedValue) {
            setState(() {
              selectedMonth = selectedValue;
            }
            );
          }, labelKey: 'month',
            initialSelection: selectedMonth,
          ),
        ),
      ],
    );
  }

  Future<void> doCreateTodo({String? todoName, String? time}) async {
    isTaskNameFieldEmpty = todoNameController.text.isEmpty;
    if (todoNameController.text.isEmpty) {
      //Utils.showMobileToast(Str.createTodoAlertText('Task Name'));
      return;
    }
    else if (selectedRepeat['label'] == "Weekly" &&
        occurEveryWeekController.text.isEmpty) {
      Utils.showMobileToast(Str.createTodoAlertText('Occurrence every weeks'));
      return;
    }
    else if (selectedRepeat['label'] != "Doesn't repeat" &&
        endDateSwitch &&
        endDateController.text.isEmpty) {
      Utils.showMobileToast(Str.createTodoAlertText('End Date'));
      return;
    } else if (selectedRepeat['label'] != "Doesn't repeat" &&
        !endDateSwitch &&
        noOfOccurrencesController.text.isEmpty) {
      Utils.showMobileToast(Str.createTodoAlertText('No of Occurrences'));
      return;
    } else {
      CreateTodoParams createTodoParams = CreateTodoParams();
      createTodoParams.todoTitle = todoName ?? todoNameController.text;
      createTodoParams.todoDate = todoDateController.text;
      createTodoParams.todoTime =
          time ?? (allDay ? '' : todoListRepo!.startTimeTFString);
      createTodoParams.todoReminder = reminder ? 'true' : 'false';
      createTodoParams.timeSensitive = timeSensitive ? 1 : 0;
      createTodoParams.notes = notesController.text;
      createTodoParams.priority = selectedPriority;
      if(reservationController.text.isNotEmpty || linkController.text.isNotEmpty){
       createTodoParams.customLinkId=int.parse(selectedLink['id']);
      }
      if(selectedLink['id']==1){
        createTodoParams.customLink=linkController.text;
      }else if(selectedLink['id']=='2' || selectedLink['id']=='3'){
        createTodoParams.referenceId=reservationController.text;
      }
      if (isPartChecked) {
        for (var parts in selectedPartsList) {
          var matchedPart = editPartsList.where((item) => item['id'] == parts['id']).toList();
          if (matchedPart.isNotEmpty) {
            for (var res in matchedPart) {
              Map<String, dynamic> partsData = {
                'parts_id': res['id'] ?? '',
                'parts_name': res['name'] ?? '',
              };
              if (partsData.isNotEmpty) {
                createTodoParams.partList.add(partsData);
              }
            }
          }
        }
      }
      if (isSupplyChecked) {
        for (var parts in selectedSuppliesList) {
          var matchedSupplies = editSuppliesList.where((item) => item['id'] == parts['id']).toList();
          if (matchedSupplies.isNotEmpty) {
            for (var res in matchedSupplies) {
              Map<String, dynamic> suppliesData = {
                'supplies_id': res['id'] ?? '',
                'supplies_name': res['name'] ?? '',
              };
              if (suppliesData.isNotEmpty) {
                createTodoParams.supplyList.add(suppliesData);
              }
            }
          }
        }
      }
      createTodoParams.assignedTo = [];
      for (var element in (selectedAssignedTo ?? [])) {
        if (element['id'] != null) {
          createTodoParams.assignedTo!.add(element['id']);
        }
      }
      if (selectedRepeat['label'] == "Daily") {
        createTodoParams.repeatDay = occurEveryDayController.text;
      } else if (selectedRepeat['label'] == "Weekly") {
        createTodoParams.repeatWeek = occurEveryWeekController.text;
        if (daysPojoList.isNotEmpty) {
          createTodoParams.weekDay = [];
          for (var element in daysPojoList) {
            if (element.selected!) {
              createTodoParams.weekDay?.add(element.dayName!.toLowerCase());
            }
          }

          debugPrint('createTodoParams.weekDay: ${createTodoParams.weekDay}');
        }
      } else if (selectedRepeat['label'] == "Monthly") {
        createTodoParams.recurMonthlyType = occurrenceDate.toString();
        if (occurrenceDate) {
          createTodoParams.repeatDateMonth = dayMonthlyController.text;
        } else {
          createTodoParams.repeatDayMonth = dayController.text;
          createTodoParams.repeatMonth = monthController.text;
        }
      } else if (selectedRepeat['label'] == "Yearly") {
        createTodoParams.repeatDateYear = dayYearlyController.text;
        createTodoParams.repeatMonthYear = selectedMonth['month'];
      }
      if (selectedRepeat['label'] != "Doesn't repeat") {
        createTodoParams.endType = endDateSwitch.toString();
        if (endDateSwitch) {
          createTodoParams.endAt = endDateController.text;
        } else {
          createTodoParams.endAfter = noOfOccurrencesController.text;
        }
        createTodoParams.repeatPeriod = selectedRepeat['label'];
      } else {
        createTodoParams.repeatPeriod = '';
      }

      if (selectedMultipleVehicleList.isNotEmpty || vehiclePersonController.text.isNotEmpty) {
        await getSelectedVehiclePerson(createTodoParams);
      }
      createTodoParams.todoImage = todoImages
          .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
          .where((element) => element != null)
          .cast<File>()
          .toList();

      await getSelectedVendorLocation(createTodoParams);
      if (isShowMultipleAddressField) {
        createTodoParams.multipleAddressList = selectedMultipleAddressList
            .map((e) => e['id']!)
            .cast<int>()
            .toList();
      }
      debugPrint('createTodoParams.parameters: '
          // 'userId : ${createTodoParams.userId},'
          // 'todoTitle: ${createTodoParams.todoTitle},'
          // 'todoDate: ${createTodoParams.todoDate},'
          // 'todoTime: ${createTodoParams.todoTime},'
          // 'priority: ${createTodoParams.priority},'
          // 'assignedTo: ${createTodoParams.assignedTo},'
          // 'cohortId: ${createTodoParams.cohortId},'
          // 'cohortName: ${createTodoParams.cohortName},'
          // 'vehicleName: ${createTodoParams.vehicleName},'
          // 'vehicleImage: ${createTodoParams.vehicleImage},'
          // 'vin: ${createTodoParams.vin},'
          //  'Time Sensitive: ${createTodoParams.timeSensitive}'
          // 'repeatPeriod: ${createTodoParams.repeatPeriod},'
          // 'repeatDay: ${createTodoParams.repeatDay},'
          // 'repeatWeek: ${createTodoParams.repeatWeek},'
          // 'weekDay: ${createTodoParams.weekDay},'
          // 'recurMonthlyType: ${createTodoParams.recurMonthlyType},'
          // 'repeatDateMonth: ${createTodoParams.repeatDateMonth},'
          // 'repeatMonth: ${createTodoParams.repeatMonth},'
          // 'repeatDayMonth: ${createTodoParams.repeatDayMonth},'
          // 'repeatDateYear: ${createTodoParams.repeatDateYear},'
          // 'repeatMonthYear: ${createTodoParams.repeatMonthYear},'
          // 'endType: ${createTodoParams.endType},'
          // 'endAt: ${createTodoParams.endAt},'
          // 'person: ${createTodoParams.person},'
          // 'personId: ${createTodoParams.personId},'
          // 'vendorId: ${createTodoParams.vendorId},'
          // 'vendorName: ${createTodoParams.vendorName},'
          // 'locationId: ${createTodoParams.locationId},'
          // 'location: ${createTodoParams.location},'
          // 'todoReminder: ${createTodoParams.todoReminder},'
          // 'notes: ${createTodoParams.notes},'
          // 'vehicleGroupId: ${createTodoParams.vehicleGroupId},'
          // 'vehicles: ${createTodoParams.vehicleList},'
          // 'endAfter: ${createTodoParams.endAfter}'
      );

      todoBloc!.add(CreateTodoEvent(
          createTodoParams: createTodoParams,
          exitTheScreen: todoName == null));
    }
  }

  Future<CreateTodoParams> getSelectedVehiclePerson(CreateTodoParams createTodoParams) {
    List<dynamic> vehiclesNameData=[];
    for (Map<String, dynamic> res in resourceList) {
      if (selectedMultipleVehicleList.isNotEmpty
          &&'${res['first_name']}${res['last_name']}'
              == selectedMultipleVehicleList[0]['vehicle_name']) {
        createTodoParams.person = '${res['first_name']} ${res['last_name']}';
        createTodoParams.personId = res['id']!.toString();
      }
      else if('${res['first_name']} ${res['last_name']}' ==
          vehiclePersonController.text.trim()){
        createTodoParams.person = '${res['first_name']} ${res['last_name']}';
        createTodoParams.personId = res['id']!.toString();
      }
    }
    for (Map<String, dynamic> veh in selectedMultipleVehicleList) {
      var matchedGroup = vehicleList.where((item) =>
      item['vehicle_id'] == veh['vehicle_id']).toList();
      if (matchedGroup.isNotEmpty) {
        for (var res in matchedGroup) {
          Map<String, dynamic> vehiclesData = {
            'vin': res['vin'] ?? '',
            'vehicle_name': res['vehicle_name'] ?? '',
            'cohort_id': res['cohort_id'] ?? '',
            'cohort_name': res['cohort']['cohort'] ?? '',
            'vehicle_image': res['images']?.isNotEmpty == true ? res['images'][0]['path'] ?? '' : '',
          };
          if (vehiclesData.isNotEmpty && !vehiclesNameData.contains(vehiclesData)) {
            createTodoParams.vehicleList?.add(vehiclesData);
          }
        }
      }
    }
    return Future.value(createTodoParams);
  }

  int checkCleanCarAvail() {
    debugPrint(
        'selectedDate.isAfter: ${!selectedDate.isAfter(DateTime.now())}');
    debugPrint(
        'contains(dropcar): ${taskIdentifierController.text.toLowerCase().contains('dropcar')}');
    if (todoListRepo!.vehicleHistoryTempSearchList.isNotEmpty) {
      debugPrint(
          'cleancar: ${(todoListRepo!.vehicleHistoryTempSearchList)[0]['title'] ?? ''}');
      debugPrint(
          'cleancar.status: ${(todoListRepo!.vehicleHistoryTempSearchList)[0]['status'] ?? ''}');
    }
    if (!selectedDate.isAfter(DateTime.now())) {
      if (taskIdentifierController.text.toLowerCase().contains('dropcar')) {
        if (todoListRepo!.vehicleHistoryTempSearchList.isNotEmpty) {
          if (todoListRepo!.vehicleHistoryTempSearchList[0]['title']
                      ?.toLowerCase() ==
                  'clean car' /* &&
            todoListRepo!.vehicleHistoryTempSearchList[0].status == 'Completed'*/
              ) {
            debugPrint(
                'todoListRepo!.chosenDateTime: ${todoListRepo!.chosenDateTime}');
            modifiedDateTime = todoListRepo!.chosenDateTime!
                .subtract(Duration(minutes: selectedCleanCarTime!.minutes!));
            debugPrint('modifiedDateTime: $modifiedDateTime');

            return 1;
          } else {
            debugPrint(
                'todoListRepo!.chosenDateTime: ${todoListRepo!.chosenDateTime}');
            modifiedDateTime = todoListRepo!.chosenDateTime!
                .subtract(Duration(minutes: selectedCleanCarTime!.minutes!));
            debugPrint('modifiedDateTime: $modifiedDateTime');

            return 2;
          }
        }
      }
    }
    return 0;
  }

  Widget vehicleHistoryUIWithoutScaffold({outerTodos}) {
    return Stack(
      children: [
        RefreshIndicator(
          color: AppC().base,
          onRefresh: () async {
            vehicleDataBloc!.add(GetVehicleHistoryEvent(
                vin: createTodoParamForVHistory.vin,
                vehicleGroupId:
                    createTodoParamForVHistory.vehicleGroupId != null
                        ? int.parse(createTodoParamForVHistory.vehicleGroupId!)
                        : null));
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  Visibility(
                    visible:
                        todoListRepo!.vehicleHistoryTempSearchList.isNotEmpty,
                    child: Utils.getSearchBarUI(() {
                      //onTap
                    }, (value) {
                      //    onChange
                      todoList.clear();
                      if (value.isEmpty) {
                        todoList
                            .addAll(todoListRepo!.vehicleHistoryTempSearchList);
                      } else {
                        for (Map<String, dynamic> data
                            in todoListRepo!.vehicleHistoryTempSearchList) {
                          if (((data['title'] ?? '').toLowerCase())
                              .contains(value.toLowerCase())) {
                            todoList.add(data);
                          }
                        }
                      }
                      setState(() {});
                    }, searchController),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Visibility(
                    visible: todoList.isNotEmpty,
                    replacement:
                        Center(child: Utils.getEmptyTextWidget(topPadding: 30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () async {
                                bool? result = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => VehicleHistoryDetailUI(
                                    outerTodos: outerTodos,
                                    todos: todoList[index],
                                    categoriesList: const [],
                                  ),
                                ));
                                if (result != null) {
                                  vehicleDataBloc!.add(GetVehicleHistoryEvent(
                                      vin: outerTodos!.vin,
                                      vehicleGroupId:
                                          outerTodos!.vehicleNumber));
                                }
                              },
                              child: listItem(todoList[index], index));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget listItem(Map<String, dynamic> todos, int index) {
    return Row(
      children: [
        Utils.getText(todos['todo_date'] ?? '',
            weight: FontWeight.bold, color: textColors!),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Slidable(
            key: ValueKey(index),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    lastEditedId = todos['id'].toString();
                    vehicleDataBloc!.add(CompleteTodoItemVeh(
                        todoId: lastEditedId,
                        status: (todos['status'] == 'In Progress')
                            ? 'Completed'
                            : 'In Progress'));
                  },
                  foregroundColor: todos['status'] == 'In Progress'
                      ? AppC.green
                      : AppC.black,
                  label: todos['status'] == 'In Progress'
                      ? 'Complete'
                      : 'In Progress',
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: const BorderSide(color: AppC.white, width: 1),
                  left: const BorderSide(color: AppC.white, width: 1),
                  right: const BorderSide(color: AppC.white, width: 1),
                  bottom:
                      BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0,
                        5), // Adjust the offset for the side you want the shadow
                  ),
                ],
                color: AppC.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Utils.getText('${todos['title']}',
                            weight: FontWeight.bold, color: textColors!),
                      ),
                      Utils.getText(
                          Utils.convertString24HTo12H(todos['todo_time']),
                          color: textColors!)
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Visibility(
                          visible: (todos['vehicle_name'] != null &&
                                  todos['vehicle_name'] != 'null') ||
                              (todos['person'] != null &&
                                  todos['person'] != 'null') ||
                              (isPartsEdit != null && isPartsEdit!) ||
                              (isSupplyEdit != null && isSupplyEdit!) ||
                              (todos['vehicle_group_id'] != null &&
                                  todos['vehicle_group_id'] != 0),
                          child: InkWell(
                            onTap: () {},
                            child: (isPartsEdit ?? false)
                                ? getDetailsInWraps(
                                    (todos['parts'] as List<dynamic>? ?? [])
                                        .map((e) =>
                                            (e['parts_name'] as String?) ?? '')
                                        .toList(),
                                    '')
                                : (isSupplyEdit ?? false)
                                    ? getDetailsInWraps(
                                        (todos['supplies'] as List<dynamic>? ??
                                                [])
                                            .map((e) =>
                                                (e['supplies_name']
                                                    as String?) ??
                                                '')
                                            .toList(),
                                        '')
                                    : (isVehicleGroupEdit ?? false)
                                        ? getDetailsInWraps(
                                            (vehicleGroupLists
                                                        as List<dynamic>? ??
                                                    [])
                                                .map((e) =>
                                                    (e.vehicleName
                                                        as String?) ??
                                                    '')
                                                .toList(),
                                            vehicleGroupName ?? '')
                                        : Utils.getText(''),
                          ),

                          // child: InkWell(
                          //     onTap: () {},
                          //     child: (isPartsEdit ?? false)
                          //         ? getDetailsInWraps(
                          //         (todos['parts'] ?? []).map((e) => (e['parts_name'] ?? '')).toList(), '')
                          //         : (isSupplyEdit ?? false)
                          //         ? getDetailsInWraps(
                          //         (todos['supplies'] ?? []).map((e) => (e['supplies_name'] ?? '')).toList(), '')
                          //         : (isVehicleGroupEdit ?? false)
                          //         ? getDetailsInWraps(
                          //         (vehicleGroupLists ?? []).map((e) => (e.vehicleName ?? '')).toList(), vehicleGroupName ?? '')
                          //         : Utils.getText('')
                          // ),
                        ),
                      ),
                      Visibility(
                        visible: (isPartsEdit ?? false) ||
                            (isSupplyEdit ?? false) ||
                            (isVehicleGroupEdit ?? false),
                        child: InkWell(
                          onTap: () {
                            isPartsEdit = false;
                            isSupplyEdit = false;
                            isVehicleGroupEdit = false;
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(0)),
                                border: Border.all(
                                    color: AppC.fieldBase /*, width: 0.2*/)),
                            child: const Icon(
                              Icons.clear_rounded,
                              color: AppC.red,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      // TODO: show parts and supply
                      const SizedBox(
                        width: 12,
                      ),
                      Visibility(
                        visible: (todos['parts'] ?? []).isNotEmpty,
                        child: InkWell(
                            onTap: () {
                              isPartsEdit = true;
                              setState(() {});
                            },
                            child: Utils.getText('P',
                                size: 15,
                                weight: FontWeight.bold,
                                color: textColors!)),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Visibility(
                        visible: (['supplies'] ?? []).isNotEmpty,
                        child: InkWell(
                            onTap: () {
                              isSupplyEdit = true;
                              setState(() {});
                            },
                            child: Utils.getText('S',
                                size: 15,
                                weight: FontWeight.bold,
                                color: textColors!)),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Visibility(
                        visible: (todos['vehicle_group_id'] != null &&
                            todos['vehicle_group_id'] != 0),
                        child: InkWell(
                            onTap: () {
                              isVehicleGroupEdit = true;
                              setState(() {});
                            },
                            child: Utils.getText('G',
                                size: 15,
                                weight: FontWeight.bold,
                                color: textColors!)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Utils.getText(
                                  todos['vendor_name'] != null &&
                                          todos['vendor_name'] != 'null'
                                      ? '${todos['vendor_name']}'
                                      : todos['location'] != null &&
                                              todos['location'] != 'null'
                                          ? '${todos['location']}'
                                          : '',
                                  color: textColors!),
                            ),
                            Visibility(
                              visible: todos['notes'] != null &&
                                  todos['notes'] != 'null',
                              child: Expanded(
                                child: Utils.getText(
                                    todos['notes'] != null &&
                                            todos['notes'] != 'null'
                                        ? ' (${todos['notes'] ?? ''}) '
                                        : '',
                                    overFlow: TextOverflow.ellipsis,
                                    color: textColors!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: todos['users'] != null ||
                            todos['user_group_id'] != null,
                        child: todos['users'] != null
                            ? Utils.getText(
                                '${todos['users']?['first_name']?.characters.first.toUpperCase()}'
                                '${todos['users']?['last_name']?.characters.first.toUpperCase()}',
                                weight: FontWeight.bold,
                                color: textColors!)
                            : getUserGroupDataById(todos),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getUserGroupDataById(Map<String, dynamic> todos) {
    userGroupConcatenationName = '';
    for (Map<String, dynamic> u in (userGroupList ?? [])) {
      if (u['id'] == todos['user_group_id']) {
        List<dynamic> jsonList = json.decode(u['userId'] ?? '');
        List<dynamic> resultList = jsonList.cast<dynamic>();
        for (dynamic userId in resultList) {
          for (Map<String, dynamic> res in (resourceList ?? [])) {
            if (userId.toString() == res['id'].toString()) {
              userGroupConcatenationName = '${userGroupConcatenationName ?? ''}'
                  '${res['first_name']?.characters.first.toUpperCase()}'
                  '${res['first_name']?.characters.first.toUpperCase()}, ';
            }
          }
        }
      }
    }
    return Utils.getText(userGroupConcatenationName ?? '',
        color: textColors!, weight: FontWeight.bold);
  }

  Widget getDetailsInWraps(List<String> list, String title) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(
            color: AppC.fieldBase,
            width: Num.borderWidthField,
          ),
          borderRadius:
              const BorderRadius.all(Radius.circular(Num.radiusButton))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utils.getText(title),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            children: List<Widget>.generate(
              list.length,
              (int idx) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 2),
                    child: Chip(
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                      backgroundColor: AppC().bottomIconColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      label:
                          Utils.getText(list[idx], color: AppC.text, size: 13),
                    ));
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  void show(BuildContext context, String message, String status) {
    overlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16.0,
        left: MediaQuery.of(context).size.width * 0.1,
        child: ToastWidget(message, () {
          if (overlay != null) {
            overlay?.remove();
          }
          vehicleDataBloc!
              .add(CompleteTodoItemVeh(todoId: lastEditedId, status: status));
        }),
      ),
    );
    Overlay.of(context).insert(overlay!);
    Timer(const Duration(seconds: 3), () {
      if (overlay != null) {
        overlay?.remove();
      }
    });
  }

  void doSetState() {
    setState(() {});
  }
}