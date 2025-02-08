import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/Component/custom_task_identifier.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Response/todo_list_response.dart';
import '../../Utilities/image_pick_helper.dart';
import '../../widget/time_picker_only.dart';
import '../Manage Custom Data/Parts/part_view_ui.dart';
import '../Manage Custom Data/Supplies/supplies_view_ui.dart';
import '../Vehicle/vehicle_history_module_ui.dart';

class CreateTodoUI extends StatefulWidget {
  final List<Map<String, dynamic>?>? selectedAssignedTo;
  final bool showHeader;

  const CreateTodoUI(
      {Key? key, this.selectedAssignedTo, this.showHeader = true})
      : super(key: key);

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


  List<Map<String, dynamic>> resourceList = [];
  List<Map<String, dynamic>> resourceListForCombination = [];
  List<Map<String, dynamic>> vendorList = [];
  List<Map<String, dynamic>> taskExpenseList = [];
  List<Map<String, dynamic>> locationList = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> selectedPartsList = [];

  List<Map<String, dynamic>> editPartsList = [];
  List<Map<String, dynamic>> selectedSuppliesList = [];
  ValueNotifier<List<Map<String, dynamic>>> selectedMultipleVehicleList = ValueNotifier([]);
  List<Map<String, dynamic>> selectedMultipleAddressList = [];
  List<Map<String, dynamic>> editMultipleAddressList = [];
  List<Map<String, dynamic>> todoImages = [];
  List<Map<String, dynamic>> editSuppliesList = [];
  List<Map<String, dynamic>> editMultipleVehicleList = [];

  List<dynamic> selectedVehicleName = [];


  List<String> selectedIds = [];

  List<String> priorityList = ['High - On Time', 'Medium', 'Low', 'Feature'];
  List<String> daysList = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<Map<String, dynamic>> customTaskOptions = [
    {'id': "1", 'label': "Custom Link"},
    {'id': "2", 'label': "Turo Reservation ID"},
    {'id': "3", 'label': "Getaround ReservationID"},
  ];
  List<Map<String, dynamic>> repeatList = [
    {'id': 1, 'label': "Doesn't repeat"},
    {'id': 2, 'label': "Daily"},
    {'id': 3, 'label': "Weekly"},
    {'id': 4, 'label': "Monthly"},
    {'id': 1, 'label': "Yearly"},
  ];
  List<dynamic> monthsList = [
    {'month': 'January'},
    {'month': 'February'},
    {'month': 'March'},
    {'month': 'April'},
    {'month': 'May'},
    {'month': 'June'},
    {'month': 'July'},
    {'month': 'August'},
    {'month': 'September'},
    {'month': 'October'},
    {'month': 'November'},
    {'month': 'December'},
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

  TextEditingController todoDateController = TextEditingController();
  TextEditingController todoNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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

  ValueNotifier<List<Map<String, dynamic>>> selectedVPersons = ValueNotifier(List.empty(growable: true));
  ValueNotifier<Map<String, dynamic>> selectedTask = ValueNotifier({});
  ValueNotifier<Map<String, dynamic>> selectedVLocation = ValueNotifier({});
  ValueNotifier<bool> showPlatformCheck = ValueNotifier(false);

  bool enablePlatformCheck = false;

  @override
  void initState() {
    todoListRepo = TodoListRepo();
    todoBloc = TodoViewBloc();
    vehicleDataBloc = VehicleDataBloc();
    // todoBloc!.add(const GetDropdownData());
    todoBloc!.add(const GetVehicleListData());
    todoBloc!.add(const GetTaskExpenseData());
    todoBloc!.add(const GetVendorData());
    todoBloc!.add(const GetLocationData());
    todoBloc!.add(const GetPartsList());
    todoBloc!.add(const GetSuppliesList());
    // todoBloc!.add(const GetVehicleGroupingList());
    // todoBloc!.add(const GetUserGroupingList());
    selectedPriority = priorityList[1];
    todoListRepo!.chosenDateTime = selectedDate;
    todoListRepo!.chosenDateTimeString =
        DateFormat("hh:mm a").format(todoListRepo!.chosenDateTime!);
    todoListRepo!.startTimeTFString =
        DateFormat("HH:mm:ss").format(todoListRepo!.chosenDateTime!);
    for (var s in monthsList) {
      MonthsPojo monthsPojo =
          MonthsPojo(monthName: s['month'], selected: false);
      monthsPojoList.add(monthsPojo);
    }
    for (String s in daysList) {
      DaysPojo daysPojo = DaysPojo(dayName: s, selected: false);
      daysPojoList.add(daysPojo);
    }
    todoDateController.text =
        Utils.convertDateTimeToTheFormat(selectedDate.toString());
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 60));
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 45));
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 30));
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 15));
    selectedCleanCarTime = cleanCarTimeValuesList[0];
    vehicleDataBloc = VehicleDataBloc();
    locationDataBloc = LocationDataBloc();
    Utils.getStringPreference(Str.userIdPrefText).then((id) {
      if (id != '1') {
        selectedIds = id.split(',');
      }
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
    _listenVNotifier(); // LISTEN NOTIFIER FOR SELECTED VALUES
    super.initState();
  }

  void _listenVNotifier() {
    selectedTask.addListener(() {
      log("SelectedTask:\t${selectedTask.value}", name: "AddToDoTask");
      var value = selectedTask.value['value'];
      todoNameController.text = value['task'];
      showPlatformCheck.value = Str.platFormCheckIds.contains(value['id']);
      showPlatformCheck.notifyListeners();
    });
    selectedVPersons.addListener(() {
      log("selectedVPersons:\t${selectedVPersons.value}", name: "AddToDoTask");
      var value = selectedVPersons.value.map((e) => e['name']).toList();
      selectedMultipleVehicleList.value = selectedVPersons.value.map<Map<String, dynamic>>((e) => e['value']).toList();
      selectedMultipleVehicleList.notifyListeners();
    });
    selectedVLocation.addListener(() {
      log("selectedVLocation:\t${selectedVLocation.value}", name: "AddToDoTask");
      var value = selectedVLocation.value['name'];
      vendorLocationController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.showHeader)
        ? Scaffold(
            backgroundColor: AppC.white,
            appBar: widget.showHeader
                ? AppBar(
                    elevation: 0,
                    backgroundColor: AppC.appColor,
                    foregroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    title: Utils.getText('Add Todo',
                        size: 18, weight: FontWeight.w700, color: AppC.white),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          var result = await MultiImagePickHelper()
                              .getMultiImage(ImageSource.gallery);
                          if (result.isNotEmpty) {
                            todoImages = [
                              ...todoImages,
                              ...result.map((e) => {"path": e}).toList()
                            ];
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.upload_rounded),
                        padding: EdgeInsets.zero,
                        // constraints: const BoxConstraints(),
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // the '2023' part
                        ),
                      ),
                      if (todoImages.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            final imagePath = todoImages
                                .map((attachment) =>
                                    attachment['path'].toString())
                                .toList();
                            final imageFiles =
                                imagePath.map((e) => File(e)).toList();
                            ShowAttachmentsDialog.of.show(context,
                                attachments: imageFiles, title: "Add ToDo");
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          padding: EdgeInsets.zero,
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // the '2023' part
                          ),
                        ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        radius: 2,
                        splashFactory: InkSplash.splashFactory,
                        onTap: () => setState(() => timeSensitive = !timeSensitive),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: 10,
                              child: Checkbox(
                                value: timeSensitive,
                                checkColor: AppC.white, // The color of the check mark
                                shape: ContinuousRectangleBorder(
                                    side: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                side: BorderSide.none,
                                fillColor:
                                WidgetStateProperty.resolveWith<Color>((states) {
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
                            Utils.getText('Time Sensitive',
                                color: AppC.white, weight: FontWeight.bold)
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: doCreateTodo,
                        icon: const Icon(Icons.save),
                        padding: EdgeInsets.zero,
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // the '2023' part
                        ),
                      ),
                      const CloseButton(
                        color: Colors.white,
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // the '2023' part
                        ),
                      ),
                    ],
                  )
                : null,
            body: body,
          )
        : body;
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
                if (state is TodoListLoading) {
                  EasyLoading.show();
                } else {
                  if (EasyLoading.isShow) EasyLoading.dismiss();
                }
                if (state is VehicleDataLoaded) {
                  if (state.vehicleData != null) {
                    vehicleList.addAll(state.vehicleData ?? []);
                    editMultipleVehicleList.addAll(state.vehicleData ?? []);
                    selectedVehicleName.addAll(state.vehicleData ?? []);
                  }
                } else if (state is AssignedToLoaded) {
                  resourceList = [];
                  resourceList = state.resource ?? [];
                  resourceList.removeWhere((resource) => resource['id'] == 2);
                  resourceList.removeWhere((resource) => ((!Str.reqTaskManagerIds.contains(resource['id'])) && (resource['branch_id'] != Session.of.getInt(Str.branchIdPrefText))) || (resource['deleted_at'] != null));
                  log("Branch ID:\t${Session.of.getInt(Str.branchIdPrefText)}", name: "BRANCH_ID");
                  log("RESOURCE_IDs:\t${resourceList.map((e) => e['id'])}", name: "RESOURCE_ID");
                  // resourceList.toList().removeWhere((resource) => (resource['branch_id'] != Session.of.getInt(Str.branchIdPrefText)) && (!Str.reqTaskManagerIds.contains(resource['id'])));
                  isSelected = true;
                  selectedAssignedTo?.add(resourceList[0]);
                  resourceListForCombination = state.resource ?? [];
                  for (Map<String, dynamic> res in resourceListForCombination) {
                    Map<String, dynamic> vehiclesData = {
                      'id': res['id'],
                      'vehicle_name': '${res['first_name']}${res['last_name']}',
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
                }
              },
            ),
            BlocListener<VehicleDataBloc, VehicleDataState>(
              listener: (context, state) {
                if (state is VehicleDataLoading) {
                  EasyLoading.show();
                } else {
                  if (EasyLoading.isShow) EasyLoading.dismiss();
                }
                if (state is TodoItemCompletedVeh) {
                  show(
                      context,
                      (state.status) == 'In Progress'
                          ? 'The todo marked as In Progress.'
                          : 'The todo marked as Completed.',
                      (state.status) == 'In Progress'
                          ? 'Completed'
                          : 'In Progress');
                  // if (state.result != null && state.result!) {
                  //   vehicleDataBloc!.add(GetVehicleHistoryEvent(
                  //       vin: createTodoParamForVHistory.vin,
                  //       vehicleGroupId:
                  //           createTodoParamForVHistory.vehicleGroupId != null
                  //               ? int.parse(
                  //                   createTodoParamForVHistory.vehicleGroupId!)
                  //               : null));
                  // }
                }
              },
            ),
            BlocListener<LocationDataBloc, LocationDataState>(
              listener: (context, state) {
                if (state is LocationDataLoading) {
                  EasyLoading.show();
                } else {
                  if (EasyLoading.isShow) EasyLoading.dismiss();
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
                }
              },
            )
          ],
          child: BlocBuilder<TodoViewBloc, TodoViewState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                physics: (widget.showHeader)
                    ? const AlwaysScrollableScrollPhysics()
                    : const ScrollPhysics(),
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
                      // TODO: TASK IDENTIFIER
                      TaskIdentifier(
                        taskIdentifierController:
                        taskIdentifierController,
                        location: locationList,
                        persons: resourceListForCombination,
                        tasks: taskExpenseList,
                        vehicles: vehicleList,
                        vendors: vendorList,
                        selectedTask: selectedTask,
                        selectedVLocations: selectedVLocation,
                        selectedVPersons: selectedVPersons,
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
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

  Future<CreateTodoParams> getSelectedVendorLocation(
      CreateTodoParams createTodoParams) {
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
    log("Cursor Position: $cursorPosition, Text: $text, Length: ${text.length}, Text Before Cursor: ${text.substring(0, cursorPosition)}, Text After Cursor: ${text.substring(cursorPosition)}, Selected Text: ${selection.end}",
        name: "CURSOR_POS");

    if (cursorPosition > 0 && cursorPosition <= text.length) {
      return text.substring(0, cursorPosition);
    } else {
      return '';
    }
  }

  Widget dailyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Center(
              child: Utils.getText('Occur Every', weight: FontWeight.bold)),
        ),
        Expanded(
          flex: 4,
          child: Utils.getTextFormField('eg:1,2,3', occurEveryDayController,
              textType: TextInputType.number,
              textInputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
              ]),
        ),
        Expanded(
            flex: 1,
            child:
                Center(child: Utils.getText('days', weight: FontWeight.bold)))
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
            Expanded(
              flex: 2,
              child: Center(
                  child: Utils.getText('Occur Every', weight: FontWeight.bold)),
            ),
            Expanded(
              flex: 4,
              child: Utils.getTextFormField(
                  'eg:1,2,3', occurEveryWeekController,
                  textType: TextInputType.number,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ]),
            ),
            Expanded(
                flex: 1,
                child: Center(
                    child: Utils.getText('weeks', weight: FontWeight.bold)))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
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
                    SizedBox(
                      width: 20,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                    child: Utils.getTextFormField('Day', dayMonthlyController,
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
                        child: Utils.getTextFormField(
                          'eg: first,last',
                          monthController,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: Utils.getTextFormField(
                          'eg: monday,tuesday',
                          dayController,
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
    return CustomDropdown<Map<String, dynamic>>(
      items: repeatList,
      itemAsString: (item) => item['label'].toString(),
      onChanged: (value) {
        selectedRepeat = value;
      },
    );
    return Utils.dropdownBox(
      '',
      repeatList,
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
      },
      labelKey: 'label',
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
              SizedBox(
                width: 40,
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
              const SizedBox(
                width: 10,
              ),
              Utils.getText(endDateModuleString, weight: FontWeight.bold),
              const SizedBox(
                width: 10,
              ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Utils.getTextFormField(
          'Task Name',
          todoNameController,
          label: Utils.getText('Task Name'),
          borderColor:
          isTaskNameFieldEmpty && todoNameController.text.isEmpty
              ? Colors.red
              : AppC.fieldBase,
          suffixIcon:
          isTaskNameFieldEmpty && todoNameController.text.isEmpty
              ? const Icon(Icons.error_outline, color: Colors.red)
              : null,
        ),
        CustomVehiclePersonField(vehiclesList: vehicleList, personsList: resourceListForCombination, selectedVPersons: selectedVPersons, controller: vehiclePersonController,),
        vendorLocationStack(),
      ],
    );
  }

  Widget vendorLocationStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomVendorLocationField(vendorsList: vendorList, locationsList: locationList, selectedVLocations: selectedVLocation, controller: vendorLocationController,),
        partsStack()
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
                      await doCreateTodo(
                          todoName: 'Clean Car',
                          time:
                              DateFormat("HH:mm:ss").format(modifiedDateTime!));
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
        ) // TODO: NEED_TO_ADD_CLEAN_CAR_TIME
      ],
    );
  }

  Widget partsStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Utils.getTextFormField('Notes', notesController,
            label: Utils.getText('Notes'),
            readOnly: false,
            onChangeCallback: (value) {}),
        const SizedBox(
          height: 10,
        ),
        ValueListenableBuilder(valueListenable: showPlatformCheck, builder: (context, value, child) {
          return Visibility(
            visible: value,
            child: Utils.getCircleCheckWidget(() {
              enablePlatformCheck = !enablePlatformCheck;
              doSetState();
            }, enablePlatformCheck, 'Platform Check'),
          );
        }),
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: Utils.dropdownBox(
                        '',
                        customTaskOptions,
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
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    key: _key,
                    onTap: () async {
                      final RenderBox renderBox = _key.currentContext!
                          .findRenderObject() as RenderBox;
                      final Offset offset =
                      renderBox.localToGlobal(Offset.zero);
                      final Size size = renderBox.size;
                      await showMenu(
                        elevation: 5,
                        color: AppC.white,
                        context: context,
                        constraints: BoxConstraints.tightFor(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45),
                        position: RelativeRect.fromLTRB(
                          offset.dx,
                          offset.dy + size.height,
                          offset.dx + size.width,
                          offset.dy,
                        ),
                        // Adjust as needed
                        items: [
                          PopupMenuItem(
                            height: 30,
                            child: Builder(builder: (context) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 30,
                                      child: selectedLink['id'] == '1'
                                          ? Utils.getTextFormField(
                                          'Link', linkController)
                                          : Utils.getTextFormField(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Icon(
                                        Icons.close,
                                        color: AppC.red,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppC.appColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3.0),
                      child: Utils.getText(
                        selectedLink['id'] == '1'
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
          child: CustomMultiSelectionChipsField<Map<String, dynamic>>(selectedPartsList: selectedPartsList, suggestionsList: editPartsList,
            controller: editPartsController,
            labelText: "Parts",
            itemAsString: (item) => item['name'].toString(),
            onEmptyTap: () => context.push(const PartViewUI(), fullscreenDialog: true)
          ),
        ),
        suppliesStack()
      ],
    );
  }

  Widget suppliesStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Visibility(
          visible: isSupplyChecked && showMore,
          child: CustomMultiSelectionChipsField<Map<String, dynamic>>(selectedPartsList: selectedSuppliesList, suggestionsList: editSuppliesList,
            controller: editSuppliesController,
            labelText: "Supplies",
            itemAsString: (item) => item['name'].toString(),
            onEmptyTap: () => context.push(const SuppliesViewUI(), fullscreenDialog: true)
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: Utils.dropdownBox(
                        '',
                        customTaskOptions,
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
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    key: _key,
                    onTap: () async {
                      final RenderBox renderBox = _key.currentContext!
                          .findRenderObject() as RenderBox;
                      final Offset offset =
                      renderBox.localToGlobal(Offset.zero);
                      final Size size = renderBox.size;
                      await showMenu(
                        elevation: 5,
                        color: AppC.white,
                        context: context,
                        constraints: BoxConstraints.tightFor(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45),
                        position: RelativeRect.fromLTRB(
                          offset.dx,
                          offset.dy + size.height,
                          offset.dx + size.width,
                          offset.dy,
                        ),
                        // Adjust as needed
                        items: [
                          PopupMenuItem(
                            height: 30,
                            child: Builder(builder: (context) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 30,
                                      child: selectedLink['id'] == '1'
                                          ? Utils.getTextFormField(
                                          'Link', linkController)
                                          : Utils.getTextFormField(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Icon(
                                        Icons.close,
                                        color: AppC.red,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppC.appColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3.0),
                      child: Utils.getText(
                        selectedLink['id'] == '1'
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
                    url = reservationController.text.toTuroReserveUrl;
                  } else if (selectedLink['id'] == '3') {
                    url = reservationController.text.toGetAroundReserveUrl;
                  } else if (selectedLink['id'] == '1') {
                    url = linkController.text;
                  }
                  Utils.openURL(url);
                },
                child: Utils.getText(
                  (selectedLink['id'] == '2' ||
                      selectedLink['id'] == '3') &&
                      reservationController.text.isNotEmpty
                      ? 'Reservation No - ${reservationController.text}'
                      : linkController.text,
                  color: AppC.appColor,
                  decoration: TextDecoration.underline,
                  colorDecoration: AppC.appColor,
                  overFlow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
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
                  final resourceId =
                  resourceList[idx]['id'].toString();
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: 2),
                    child: ChoiceChip(
                      showCheckmark: false,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                      labelPadding:
                      const EdgeInsets.symmetric(horizontal: 4),
                      selectedColor: AppC.appColor,
                      backgroundColor: const Color(0xfff3f6f9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: const BorderSide(color: AppC.appColor),
                      label: Utils.getText(
                        '${resourceList[idx]['first_name']} ${resourceList[idx]['last_name']}',
                        color: selectedIds.contains(resourceId)
                            ? AppC.white
                            : AppC.text,
                        size: 12,
                      ),
                      selected: selectedIds.contains(resourceId),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            if (!selectedIds.contains(resourceId)) {
                              selectedIds.add(resourceId);
                              selectedAssignedTo
                                  ?.add(resourceList[idx]);
                            }
                          } else {
                            selectedIds.remove(resourceId);
                            selectedAssignedTo?.removeWhere(
                                  (item) =>
                              item?['id'] ==
                                  resourceList[idx]['id'],
                            );
                          }
                        });
                      },
                    ),
                  );
                },
              ).toList(),
            ),
            const SizedBox(
              height: 5,
            ),
            if (selectedIds.isEmpty)
              Utils.getText('Please select task manager',
                  color: const Color(0xffd01601)),
            const SizedBox(
              height: 10,
            ),
            Utils.getText('Task Date/Time',
                weight: FontWeight.w500),
            const SizedBox(
              height: 10,
            ),
            Row(
              spacing: 5,
              children: [
                Flexible(
                  child: Utils.getTextFormField(
                      style: context.textTheme.titleMedium,
                      isDense: true,
                      'Todo Date',
                      todoDateController,
                      contentPadding: const EdgeInsets.all(5),
                      readOnly: true, onTapCallback: () {
                    Utils.todoDatePickerDialog(context, '', lastYear: 5000)
                        .then((value) {
                      selectedDate = value!;
                      todoDateController.text =
                          Utils.convertDateTimeToTheFormat(
                              value.toString());
                    });
                  }, label: Utils.getText('Todo Date')),
                ),
                Flexible(
                    child: TimePickerViewOnly(
                      todoListRepo: todoListRepo,
                      textStyle: context.textTheme.titleMedium,
                      padding: 5.padding,
                      voidCallback: doSetState,
                    )),
                Expanded(child: repeatDropdown(), flex: 2,)
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ],
    );
  }

  Widget yearlyWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Utils.getText('Date', weight: FontWeight.bold),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Utils.getTextFormField('date', dayYearlyController,
              textType: TextInputType.number, onChangeCallback: (value) {
            String prev = dayYearlyController.text;
            if (int.tryParse((value ?? '0'))! > 31) {
              dayYearlyController.clear();
              dayYearlyController.text = value[0];
              dayYearlyController.selection = TextSelection.fromPosition(
                  TextPosition(offset: (dayYearlyController.text.length)));
            } else {}
          }),
        ),
        const SizedBox(
          width: 15,
        ),
        Utils.getText('Month', weight: FontWeight.bold),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 1,
          child: Utils.dropdownBox(
            '',
            monthsList,
            (selectedValue) {
              setState(() {
                selectedMonth = selectedValue;
              });
            },
            labelKey: 'month',
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
    } else if (selectedRepeat['label'] == "Weekly" &&
        occurEveryWeekController.text.isEmpty) {
      Utils.showMobileToast(Str.createTodoAlertText('Occurrence every weeks'));
      return;
    } else if (selectedRepeat['label'] != "Doesn't repeat" &&
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
      if (reservationController.text.isNotEmpty ||
          linkController.text.isNotEmpty) {
        createTodoParams.customLinkId = int.parse(selectedLink['id']);
      }
      if (selectedLink['id'] == 1) {
        createTodoParams.customLink = linkController.text;
      } else if (selectedLink['id'] == '2' || selectedLink['id'] == '3') {
        createTodoParams.referenceId = reservationController.text;
      }
      if (isPartChecked) {
        for (var parts in selectedPartsList) {
          var matchedPart =
              editPartsList.where((item) => item['id'] == parts['id']).toList();
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
          var matchedSupplies = editSuppliesList
              .where((item) => item['id'] == parts['id'])
              .toList();
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

      if (selectedMultipleVehicleList.value.isNotEmpty ||
          vehiclePersonController.text.isNotEmpty) {
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

      todoBloc!.add(CreateTodoEvent(
          createTodoParams: createTodoParams, exitTheScreen: todoName == null));
    }
  }

  Future<CreateTodoParams> getSelectedVehiclePerson(CreateTodoParams createTodoParams) {
    List<dynamic> vehiclesNameData = [];
    for (Map<String, dynamic> res in resourceList) {
      if (selectedMultipleVehicleList.value.isNotEmpty &&
          '${res['first_name']}${res['last_name']}' ==
              selectedMultipleVehicleList.value[0]['vehicle_name']) {
        createTodoParams.person = '${res['first_name']} ${res['last_name']}';
        createTodoParams.personId = res['id']!.toString();
      } else if ('${res['first_name']} ${res['last_name']}' ==
          vehiclePersonController.text.trim()) {
        createTodoParams.person = '${res['first_name']} ${res['last_name']}';
        createTodoParams.personId = res['id']!.toString();
      }
    }
    for (Map<String, dynamic> veh in selectedMultipleVehicleList.value) {
      var matchedGroup = vehicleList
          .where((item) => item['vehicle_id'] == veh['vehicle_id'])
          .toList();
      if (matchedGroup.isNotEmpty) {
        for (var res in matchedGroup) {
          Map<String, dynamic> vehiclesData = {
            'vin': res['vin'] ?? '',
            'vehicle_name': res['vehicle_name'] ?? '',
            'cohort_id': res['cohort_id'] ?? '',
            'cohort_name': res['cohort']['cohort'] ?? '',
            'vehicle_image': res['images']?.isNotEmpty == true
                ? res['images'][0]['path'] ?? ''
                : '',
          };
          if (vehiclesData.isNotEmpty &&
              !vehiclesNameData.contains(vehiclesData)) {
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
                  'clean car'
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