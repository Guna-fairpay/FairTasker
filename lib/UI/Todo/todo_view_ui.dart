
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/supplies_view_ui.dart';
import 'package:fairpytasker/Bloc/location_data_bloc.dart';
import 'package:fairpytasker/UI/Todo/add_todo_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo_ui.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Location/location_view_ui.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/auto_complete_widget.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Component/drawer_ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Manage Custom Data/Parts/part_view_ui.dart';
import '../Manage Custom Data/Vehicles/vehicle_view_ui.dart';
import '../Manage Employees/Employees/employees_view_ui.dart';
import '../Vehicle/vehicle_history_module_ui.dart';
import 'package:url_launcher/url_launcher.dart';


List<Map<String, dynamic>?>? selectedResourceMain;

class TodoViewUI extends StatefulWidget {
  const TodoViewUI({Key? key}) : super(key: key);

  @override
  State<TodoViewUI> createState() => _TodoViewUIState();
}

class _TodoViewUIState extends State<TodoViewUI> {

  late TodoListRepo todoListRepo;
  TodoViewBloc? todoBloc;
  LocationDataBloc? locationDataBloc;
  final GlobalKey _key = GlobalKey();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Duration duration = const Duration();
  Timer? timer;
  DateTime? editSelectedDate = DateTime.now();

  ScrollController singleChildScrollController = ScrollController();
  TextEditingController notesController = TextEditingController();
  TextEditingController editPartsController = TextEditingController();
  TextEditingController editMultipleVehicleController = TextEditingController();
  TextEditingController editSuppliesController = TextEditingController();
  TextEditingController editMultipleAddressController = TextEditingController();
  TextEditingController editVehicleGroupController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController vehicleSearchController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController taskTimeController = TextEditingController();
  TextEditingController dropdownController = TextEditingController();
  TextEditingController vehiclePersonController = TextEditingController();
  TextEditingController editTodoDateController = TextEditingController();
  TextEditingController todoTimeController = TextEditingController();
  TextEditingController oilChangeOdometerController = TextEditingController();
  TextEditingController nextMilesCheckController = TextEditingController();
  TextEditingController nextOdometerController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();
  final FocusNode vehicleSearchFocusNode = FocusNode();

  List<Map<String, dynamic>> resourceList = [];
  List<Map<String, dynamic>> resourceListForCombination = [];
  List<Map<String, dynamic>> resourceListForPersonField = [];
  List<Map<String, dynamic>> todoListResourceFilter = [];
  List<Map<String, dynamic>> vehicleStatus = [];
  List<Map<String, dynamic>> vendorList = [];
  List<Map<String, dynamic>> taskExpenseList = [];
  List<Map<String, dynamic>> locationList = [];
  List<Map<String, dynamic>> cohortsData = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> vehicleGroupList = [];
  List<Map<String, dynamic>> userGroupList = [];
  List<Map<String, dynamic>> categoriesListData = [];
  List<Map<String, dynamic>> todoList = [];
  List<Map<String, dynamic>> todoListTemp = [];
  List<Map<String, dynamic>> filteredVendorsType = [];
  List<Map<String, dynamic>>? selectedUserGroupOrUser;
  List<Map<String, dynamic>>? addresses;
  List<Map<String, dynamic>> taskCategoryGroupData = [];
  List<Map<String, dynamic>> titleList=[];
  List<Map<String, dynamic>>  subCategoryList = [];
  List<Map<String, dynamic>> editPartsList = [];
  List<Map<String, dynamic>> editMultipleVehicleList = [];
  List<Map<String, dynamic>> editSuppliesList = [];
  List<Map<String, dynamic>> selectedMultipleAddressList = [];
  List<Map<String, dynamic>> multipleLocationAddressList = [];
  List<Map<String, dynamic>> selectedVehicleGroupList = [];
  List<Map<String, dynamic>> editMultipleAddressList = [];
  List<Map<String, dynamic>> editVehicleGroupList = [];
  List<Map<String, dynamic>> taskMiles = [];

  int? selectedIndex;
  int? branchNO;
  int? deleteId;
  int selectedUserCount = 0;
  int selectedTaskCount = 0;

  String? value;
  String? userShortName;
  String? vehicleGroupName;
  String? userGroupConcatenationName;
  String searchQuery = '';
  String chosenDateTimeString = '';
  String previousOdometer='';

  dynamic vendor;
  dynamic vehicleName;
  dynamic selectedVehicle;
  dynamic selectedTime;

  bool isVehicleEdit = false;
  bool isPartsEdit = false;
  bool isSupplyEdit = false;
  bool isMultipleVehicleEdit = false;
  bool isMultipleAddressEdit = false;
  bool isVendorEdit = false;
  bool isVehicleGroupEdit = false;
  bool isNotesEdit = false;
  bool statusFilter = false;
  bool? isSelected = false;
  bool? isVehicleSelected = false;
  bool isFilterCheck = false;
  bool isVehiclePresented = false;
  bool lastSelectedIsPerson = false;
  bool editShowPartsList = false;
  bool editShowSuppliesList = false;
  bool editShowMultipleVehicleList = false;
  bool editShowMultipleAddressList = false;
  bool editShowVehicleGroupList = false;

  Map<String, bool> selectedStates = {};
  Map<String, dynamic> listToFilterVehicle = {};
  Map<String, dynamic> searchedVehicle = {};
  Map<String,dynamic>? nameList;
  Map<String, bool> checkboxStates = {};

  Set<int> selectedIndices = {};
  Set<String> selectedResourceIds = {};
  Set<String> selectedYears = {};
  Set<String> selectedMakes = {};
  Set<String> selectedModels = {};

  List<String> selectedFilters = [];
  List<dynamic> todoImages = [];
  List<dynamic> taskVehicleVin = [];
  List<dynamic> filteredVehicle = [];
  List<dynamic> vehiclesNameData=[];
  List<dynamic> selectedPartsList = [];
  List<dynamic> editPartsSuggestionList = [];
  List<dynamic> selectedMultipleVehicleList = [];
  List<dynamic> editMultipleVehicleSuggestionList = [];
  List<dynamic> editSuppliesSuggestionList = [];
  List<dynamic> editMultipleAddressSuggestionList = [];
  List<dynamic> editVehicleGroupSuggestionList = [];
  List<dynamic> partsNameData=[];
  List<dynamic> selectedSuppliesList = [];
  List<dynamic> suppliesNameData=[];

  @override
  void initState() {
    todoListRepo = TodoListRepo();
    todoBloc = TodoViewBloc();
    locationDataBloc = LocationDataBloc();
    todoBloc?.add(const GetVehicleListData());
    todoBloc?.add(const GetTaskExpenseData());
    todoBloc?.add(const GetVendorData());
    todoBloc?.add(const GetLocationData());
    todoBloc?.add(const GetDropdownData());
    todoBloc?.add(const GetAssignedToList());
    todoBloc?.add(const GetPartsList());
    todoBloc?.add(const GetSuppliesList());
    todoBloc?.add(const GetVehicleGroupingList());
    todoBloc?.add(const GetUserGroupingList());
    todoBloc?.add(const GetVehicleStatusList());
    todoBloc?.add(const GetTaskCategoryGroup());
    todoBloc?.add(const GetTaskMiles());
    taskTimeController.addListener(() {setState(() {});});
    reasonController.addListener(() {setState(() {});});
    super.initState();
  }

  @override
  void dispose() {
    singleChildScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => todoBloc!
                ..add(GetTodoList(
                  selectedDate: filterDate,
                  status: statusFilter ? "Completed" : "In Progress",
                  resourceId:
                  Utils.getStringFromObjectList(selectedResourceMain ?? []),
                  branchId: branchNO.toString(),
                )),
            ),
            BlocProvider(
              create: (context) =>
              locationDataBloc!..add(const GetAddedLocationListData()),
            ),
            BlocProvider(
              create: (context) =>
              locationDataBloc!..add(const GetAddedLocationListData()),
            ),
          ],
          child: MultiBlocListener(
              listeners: [
                BlocListener<TodoViewBloc, TodoViewState>(
                  listener: (context, state) async {
                    if (state is TaskExpenseLoaded) {
                      taskExpenseList = state.resource ?? [];
                    }
                    else if (state is VendorLoaded) {
                      vendorList = state.resource ?? [];
                    }
                    else if (state is PartsLoaded) {
                      if (state.partsList != null) {
                        editPartsList.addAll(state.partsList!);
                      }
                    }
                    else if(state is TaskCategoryGroupLoaded){
                      taskCategoryGroupData.clear();
                      taskCategoryGroupData.addAll(state.data??[]);

                      for (Map<String, dynamic> res in taskCategoryGroupData) {
                        Map<String, dynamic> vehiclesData = {
                          'id': res['id'],
                          'name': res['name'],
                        };
                        titleList.add(vehiclesData);
                        if (res.containsKey('subcategories') && res['subcategories'] is List) {
                          for (Map<String, dynamic> subcategory in res['subcategories']) {
                            Map<String, dynamic> subcategoryData = {
                              'id': subcategory['id'],
                              'name': subcategory['name'],
                              'parent_id': res['id'],
                            };
                            subCategoryList.add(subcategoryData);
                          }
                        }
                      }
                      titleList.insert(0, {'id': -1, 'name': 'Other'});

                    }
                    else if (state is SuppliesLoaded) {
                      if (state.suppliesList != null) {
                        editSuppliesList.addAll(state.suppliesList!);
                      }
                    }
                    else if (state is LocationLoaded) {
                      locationList = state.resource ?? [];
                    }
                    else if (branchNO != branchNO) {
                      todoBloc!.add(GetTodoList(
                        selectedDate: filterDate,
                        status: statusFilter ? "Completed" : "In Progress",
                        resourceId: Utils.getStringFromObjectList(
                            selectedResourceMain ?? []),
                        branchId: branchNO.toString(),
                      ));
                    }
                    else if (state is VehicleDataLoaded) {
                      todoBloc!.add(GetTodoList(
                        selectedDate: filterDate,
                        status: statusFilter ? "Completed" : "In Progress",
                        resourceId: Utils.getStringFromObjectList(
                            selectedResourceMain ?? []),
                        branchId: branchNO.toString(),
                      ));

                      if (state.vehicleData != null) {
                        vehicleList.addAll(state.vehicleData ?? []);
                        editMultipleVehicleList.addAll(state.vehicleData ?? []);
                      }
                    }
                    else if (state is TodoListLoaded) {
                      todoList = [];
                      todoListTemp = [];
                      var userId = userIdGlobal == "1" ? "2" : userIdGlobal;
                      var list1 = state.todoList
                          ?.where((todo) =>
                      todo['user_id'] == userId &&
                          (todo['title'] == "Check In" ||
                              todo['title'] == "Check Out"))
                          .toList() ??
                          [];
                      var list2 = state.todoList
                          ?.where((todo) =>
                      todo['title'] != "Check In" &&
                          todo['title'] != "Check Out")
                          .toList() ??
                          [];
                      var combinedList = [...list1, ...list2];
                      combinedList.sort(
                              (a, b) => a['todo_time']!.compareTo(b['todo_time']!));
                      todoListTemp.addAll(combinedList);
                      todoList.addAll(combinedList);
                      for (dynamic tdl in combinedList) {
                        for (Map<String, dynamic> vd in vehicleList) {
                          if (tdl['vin'].toString() == vd['vin'].toString()) {
                            tdl['vehicle_number'] = vd['vehicle_number'];
                          }
                        }
                      }
                    }
                    else if (state is AssignedToLoaded) {
                      resourceListForCombination.clear();
                      resourceList.clear();
                      resourceListForPersonField.clear();
                      resourceList.addAll(state.resource ?? []);
                      resourceListForPersonField.addAll(state.resource ?? []);
                      resourceList.removeWhere((resource) => resource['id'] == 2);
                      resourceListForCombination.addAll(resourceList);
                      selectedResourceMain = [];
                      selectedResourceMain!.addAll(resourceList);
                      for (Map<String, dynamic> res
                      in resourceListForCombination) {
                        Map<String, dynamic> vehiclesData = {
                          'id': res['id'],
                          'vehicle_name': '${res['first_name']} ${res['last_name']}',
                        };
                        editMultipleVehicleList.add(vehiclesData);
                      }
                    }
                    else if (state is DeleteTodoLoaded) {
                      todoBloc!.add(GetTodoList(
                        selectedDate: filterDate,
                        status: statusFilter ? "Completed" : "In Progress",
                        resourceId: Utils.getStringFromObjectList(
                            selectedResourceMain ?? []),
                        branchId: branchNO.toString(),
                      ));
                    }
                    else if (state is TodoItemCompletedV) {
                      todoBloc!.add(GetTodoList(
                        selectedDate: filterDate,
                        status: statusFilter ? "Completed" : "In Progress",
                        resourceId: Utils.getStringFromObjectList(
                            selectedResourceMain ?? []),
                        branchId: branchNO.toString(),
                      ));
                      if (state.taskName?.toLowerCase() == 'check in') {
                        // getWorkingHourByUser
                        Utils.getIntPreference(Str.hrmIdPrefText).then((value) {
                          todoBloc!.add(GetWorkingHourByUserEvent(id: value));
                        });
                      }
                      show(
                          context,
                          (state.status) == 'In Progress'
                              ? 'Todo moved to In Progress'
                              : 'Todo Completed',
                          (state.status) == 'In Progress'
                              ? 'Completed'
                              : 'In Progress',
                          (state.todoId ?? ''), '');
                    }
                    else if (state is EditTodoLoaded) {
                      todoBloc!.add(const GetUserGroupingList());
                      todoBloc!.add(GetTodoList(
                        selectedDate: filterDate,
                        status: statusFilter ? "Completed" : "In Progress",
                        resourceId: Utils.getStringFromObjectList(
                            selectedResourceMain ?? []),
                        branchId: branchNO.toString(),
                      ));
                      if (state.isDate != null && state.isDate!) {
                        /*if(overlay != null) {
                    overlay?.remove();
                  }*/
                        show(context, 'Task moved Successfully', '',
                            (state.todoId ?? ''), (state.date ?? ''));
                      }
                    }
                    else if (state is VehicleGroupListLoaded) {
                      vehicleGroupList.clear();
                      vehicleGroupList.addAll(state.vehicleGroupDataList ?? []);

                    }
                    else if (state is VehicleGroupLoaded) {
                      todoBloc!.add(const GetVehicleGroupingList());
                      todoBloc!.add(GetTodoList(
                        selectedDate: filterDate,
                        status: statusFilter ? "Completed" : "In Progress",
                        resourceId: Utils.getStringFromObjectList(
                            selectedResourceMain ?? []),
                        branchId: branchNO.toString(),
                      ));
                    }
                    else if (state is UserGroupListLoaded) {
                      userGroupList.clear();
                      userGroupList.addAll(state.userGroupDataList ?? []);
                    }
                    else if (state is DropdownDataLoaded) {
                      categoriesListData.clear();
                      categoriesListData.addAll(
                          state.createExpenseFieldData?.expenseCategories ??
                              []);
                    }
                    else if (state is VehicleStatusListLoaded) {
                      vehicleStatus.clear();
                      vehicleStatus.addAll(state.vehiclesCount ?? []);
                    }
                    else if (state is TaskMilesLoaded) {
                      taskMiles.clear();
                      taskMiles.addAll(state.data ?? []);
                    }
                    else if (state is PreviousOdometerLoaded) {
                      previousOdometer= (state.data ?? 0).toString();
                      showOilCheckPopup(
                        context,
                        oilChangeOdometerController,
                        nextMilesCheckController,
                        nextOdometerController,
                        taskMiles,
                        (state.todoData ?? {}),
                        previousOdometer,
                      );
                      // setState(() {
                      //   previousOdometer=(state.data!).toString();
                      //   print("PREVIOUS ODOMETER----$previousOdometer");
                      // });

                    }
                  },
                ),
                BlocListener<LocationDataBloc, LocationDataState>(
                  listener: (context, state) {
                    if (state is LocationListLoaded) {
                      if (state.resource != null) {
                        multipleLocationAddressList
                            .addAll(state.resource ?? []);
                      }
                    }
                  },
                )
              ],
              child: BlocBuilder<TodoViewBloc, TodoViewState>(
                builder: (context, state) {
                  return SafeArea(
                    child: Stack(
                      children: [
                        RefreshIndicator(
                          color: AppC().base,
                          onRefresh: () async {
                            // fetchFrom = 0;
                            todoBloc!.add(GetTodoList(
                              selectedDate: filterDate,
                              status:
                              statusFilter ? "Completed" : "In Progress",
                              resourceId: Utils.getStringFromObjectList(
                                  selectedResourceMain ?? []),
                              branchId: branchNO.toString(),
                            )
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, bottom: 0, left: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        SizedBox(
                                          width: 36,
                                          child: Transform.scale(
                                              alignment: Alignment.centerLeft,
                                              scale: .6,
                                              child: Switch(
                                                  trackOutlineColor:
                                                  WidgetStateColor
                                                      .resolveWith(
                                                        (states) {
                                                      if (states.contains(
                                                          WidgetState
                                                              .selected)) {
                                                        return AppC.green;
                                                      } else {
                                                        return AppC.grey;
                                                      }
                                                    },
                                                  ),
                                                  activeTrackColor: AppC.green,
                                                  activeColor: AppC.white,
                                                  inactiveThumbColor:
                                                  AppC.white,
                                                  inactiveTrackColor: AppC.grey,
                                                  value: statusFilter,
                                                  onChanged: (value) {
                                                    if (value) {
                                                      todoBloc!.add(GetTodoList(
                                                        selectedDate:
                                                        filterDate,
                                                        status: "Completed",
                                                        resourceId: Utils
                                                            .getStringFromObjectList(
                                                            selectedResourceMain ??
                                                                []),
                                                        branchId:
                                                        branchNO.toString(),
                                                      ));
                                                    } else {
                                                      todoBloc!.add(GetTodoList(
                                                        selectedDate: filterDate,
                                                        status: "In Progress",
                                                        resourceId: Utils.getStringFromObjectList(
                                                            selectedResourceMain ?? []),
                                                        branchId: branchNO.toString(),
                                                      ));
                                                    }
                                                    todoListResourceFilter
                                                        .clear();
                                                    todoListResourceFilter
                                                        .addAll(todoList);
                                                    // filterResource(null, fromOnchange: false);
                                                    statusFilter = value;
                                                    setState(() {});
                                                  })),
                                        ),
                                        const SizedBox(width: 15),
                                        InkWell(
                                          key: _key,
                                          onTap: () async {
                                            filteredVehicle.clear();
                                            for (var item in todoList) {
                                              listToFilterVehicle.addAll(item);
                                              List vehicles = listToFilterVehicle['vehicles'];

                                              if (listToFilterVehicle['vin'] != null) {
                                                var list = vehicleList.firstWhere(
                                                      (item) => item['vin'] == listToFilterVehicle['vin'],
                                                  orElse: () => {},
                                                );
                                                filteredVehicle.add(list);
                                              } else {
                                                for (var vehicle in vehicles) {
                                                  var list = vehicleList.firstWhere(
                                                        (item) => item['vin'] == vehicle['vin'],
                                                    orElse: () => {},
                                                  );
                                                  filteredVehicle.add(list);
                                                }
                                              }
                                            }

                                            final RenderBox renderBox =
                                            _key.currentContext!.findRenderObject() as RenderBox;
                                            final Offset offset = renderBox.localToGlobal(Offset.zero);
                                            final Size size = renderBox.size;

                                            await showMenu(
                                              elevation: 5,
                                              color: AppC.white,
                                              context: context,
                                              position: RelativeRect.fromLTRB(
                                                offset.dx,
                                                offset.dy + size.height,
                                                offset.dx + size.width,
                                                offset.dy,
                                              ),
                                              items: [
                                                PopupMenuItem(
                                                  child: StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Icon(
                                                            Icons.close,
                                                            color: AppC.red,
                                                          ),
                                                          const SizedBox(height: 3),
                                                          SizedBox(
                                                            height: 40,
                                                            child: Utils.getSearchBarUI(
                                                                  () {},
                                                              // onSubmitted: () {
                                                              //       log("DISMISS");
                                                              //   Utils.dismissKeyboard(context);
                                                              // },
                                                                  (value) {
                                                                setState(() {
                                                                  searchQuery = value.toLowerCase();
                                                                });
                                                              },
                                                              vehicleSearchController,
                                                            ),
                                                          ),
                                                          if (filteredVehicle.isNotEmpty)
                                                            ...[
                                                              // Year Filter
                                                              if (filteredVehicle
                                                                  .map((e) => e['year'])
                                                                  .where((year) => year != null && year != '')
                                                                  .isNotEmpty)
                                                                Utils.getText('Year', weight: FontWeight.w700),
                                                              ...filteredVehicle
                                                                  .map((e) => e['year'] ?? '')
                                                                  .toSet()
                                                                  .where((year) => year != '') // Filter out empty or null values
                                                                  .map((year) => Row(
                                                                children: [
                                                                  Transform.scale(
                                                                    scale: 0.8,
                                                                    child: SizedBox(
                                                                      height: 30,
                                                                      width: 30,
                                                                      child: Checkbox(
                                                                        activeColor:AppC.blue,
                                                                        value: selectedYears.contains(year),
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            if (value == true) {
                                                                              selectedYears.add(year);

                                                                            } else {
                                                                              selectedYears.remove(year);
                                                                            }
                                                                            applyFilters();
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Utils.getText('$year'),
                                                                ],
                                                              )),

                                                              // Make Filter
                                                              if (filteredVehicle
                                                                  .map((e) => e['make'])
                                                                  .where((make) => make != null && make != '')
                                                                  .isNotEmpty)
                                                                Utils.getText('Make', weight: FontWeight.w700),
                                                              ...filteredVehicle
                                                                  .map((e) => e['make'] ?? '')
                                                                  .toSet()
                                                                  .map((make) => Row(
                                                                children: [
                                                                  Transform.scale(
                                                                    scale: 0.8,
                                                                    child: SizedBox(
                                                                      height: 30,
                                                                      width: 30,
                                                                      child: Checkbox(
                                                                        activeColor:AppC.blue,
                                                                        value: selectedMakes.contains(make),
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            if (value == true) {
                                                                              selectedMakes.add(make);
                                                                            } else {
                                                                              selectedMakes.remove(make);
                                                                            }
                                                                            applyFilters();
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Utils.getText('$make'),
                                                                ],
                                                              )),
                                                              // Model Filter
                                                              if (filteredVehicle
                                                                  .map((e) => e['model'])
                                                                  .where((model) => model != null && model != '')
                                                                  .isNotEmpty)
                                                                Utils.getText('Model', weight: FontWeight.w700),
                                                              ...filteredVehicle
                                                                  .map((e) => e['model'] ?? '')
                                                                  .toSet()
                                                                  .map((model) => Row(
                                                                children: [
                                                                  Transform.scale(
                                                                    scale: 0.8,
                                                                    child: SizedBox(
                                                                      height: 30,
                                                                      width: 30,
                                                                      child: Checkbox(
                                                                        activeColor:AppC.blue,
                                                                        value: selectedModels.contains(model),
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            if (value == true) {
                                                                              selectedModels.add(model);
                                                                            } else {
                                                                              selectedModels.remove(model);
                                                                            }
                                                                            applyFilters();
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Utils.getText('$model'),
                                                                ],
                                                              )),
                                                            ],
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          child: Image.asset(
                                            Assets.vehicleSearchIcon,
                                            height: 24,
                                            width: 24,
                                            color: selectedYears.isNotEmpty
                                                ? AppC.red
                                                : selectedMakes.isNotEmpty
                                                ? AppC.red
                                                : selectedModels.isNotEmpty
                                                ? AppC.red
                                                : AppC.appColor,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        InkWell(
                                            onTap: () async {
                                              selectedDate =
                                                  selectedDate.subtract(
                                                      const Duration(days: 1));
                                              formattedDate =
                                              (DateFormat("MMM dd")
                                                  .format(selectedDate));
                                              filterDate =
                                              (DateFormat("yyyy-MM-dd")
                                                  .format(selectedDate));
                                              todoBloc!.add(GetTodoList(
                                                selectedDate: filterDate,
                                                status: statusFilter
                                                    ? "Completed"
                                                    : "In Progress",
                                                resourceId: Utils
                                                    .getStringFromObjectList(
                                                    selectedResourceMain ??
                                                        []),
                                                branchId: branchNO.toString(),
                                              ));
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.chevron_left,
                                              color: AppC().base,
                                              size: 24,
                                            )),
                                      ]),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(width: 5,),
                                            InkWell(
                                              onTap: () async {
                                                Utils.todoDatePickerDialog(
                                                  context, '',
                                                  initial: selectedDate,
                                                ).then((value) {
                                                  setState(() {
                                                    if (value != null) {
                                                      selectedDate = value;
                                                      formattedDate = (DateFormat("MMM dd").format(value));
                                                      filterDate = (DateFormat("yyyy-MM-dd").format(value));
                                                      todoBloc!.add(GetTodoList(
                                                        selectedDate: filterDate,
                                                        status: statusFilter
                                                            ? "Completed"
                                                            : "In Progress",
                                                        resourceId: Utils.getStringFromObjectList(
                                                            selectedResourceMain ?? []),
                                                        branchId:branchNO.toString(),
                                                      ));
                                                    }
                                                  });
                                                });
                                              },
                                              child: Utils.getText(
                                                  formattedDate!,
                                                  size: 17,
                                                  weight: FontWeight.w500),
                                            ),
                                            const SizedBox(width: 5,),
                                          ]),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                selectedDate = selectedDate.add(
                                                    const Duration(days: 1));
                                                formattedDate = (DateFormat("MMM dd").format(selectedDate));
                                                filterDate = (DateFormat("yyyy-MM-dd").format(selectedDate));
                                                todoBloc!.add(GetTodoList(
                                                  selectedDate: filterDate,
                                                  status: statusFilter
                                                      ? "Completed"
                                                      : "In Progress",
                                                  resourceId: Utils.getStringFromObjectList(selectedResourceMain ?? []),
                                                  branchId: branchNO.toString(),
                                                ));
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: AppC().base,
                                                size: 24,
                                              )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTapDown: (details) {
                                              showPopupWithCheckBoxDepartmentWise(
                                                resourceListForCombination,
                                                details, // tap details
                                                    (selectedResources) {
                                                  // onSelect callback
                                                  selectedResourceMain = [];
                                                  selectedResourceMain!.addAll(
                                                      selectedResources); // Add selected resources
                                                  todoBloc!.add(GetTodoList(
                                                    selectedDate: filterDate,
                                                    status: statusFilter
                                                        ? "Completed"
                                                        : "In Progress",
                                                    resourceId: Utils
                                                        .getStringFromObjectList(
                                                      selectedResourceMain ??
                                                          [],
                                                    ),
                                                    branchId:
                                                    branchNO.toString(),
                                                  ));
                                                },
                                                selectedStates, // resource list
                                                // Pass selectedStates
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(selectedUserCount >= 1?
                                                Icons.supervisor_account:Icons.person_outline,
                                                  color: AppC().base,
                                                  size: 24,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          InkWell(
                                              onTapDown: (details) {
                                                showObjectPopupMainMenuWithCheckBox(
                                                  context,
                                                  todoListTemp,
                                                  details,
                                                      (resource) {
                                                    todoList = [];
                                                    todoList.addAll(resource as Iterable<Map<String,dynamic>>);
                                                    setState(() {});
                                                  },
                                                  taskCategoryGroupData,
                                                  titleList,
                                                );
                                              },
                                              child:
                                              Row(
                                                children: [
                                                  Icon(selectedTaskCount < 1?
                                                  Icons.filter_alt_outlined:Icons.filter_alt_sharp,
                                                    color: AppC.black,
                                                    size: 22,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Utils.getText('00:00',
                                            weight: FontWeight.bold, size: 13),
                                        const SizedBox(width: 3),
                                        Utils.getText(
                                          'Check in',
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Utils.getText('00:00',
                                            color: AppC.red,
                                            weight: FontWeight.bold,
                                            size: 13),
                                        const SizedBox(width: 3),
                                        Utils.getText(
                                          'Hours Active',
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Utils.getText('00:00',
                                            color: AppC.red,
                                            weight: FontWeight.bold,
                                            size: 13),
                                        const SizedBox(width: 3),
                                        Utils.getText('Hours Total', size: 12),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  color: Colors.blue[50],
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            // Navigate to the CreateTodoUI page and wait for the result
                                            final newTodo = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CreateTodoUI(
                                                  selectedAssignedTo: selectedResourceMain,
                                                ),
                                                fullscreenDialog: true
                                              ),
                                            );
                                            if (newTodo != null) {
                                              setState(() {
                                                todoBloc!.add(const GetUserGroupingList());
                                                todoBloc!.add(GetTodoList(
                                                  selectedDate: filterDate,
                                                  status: statusFilter
                                                      ? "Completed"
                                                      : "In Progress",
                                                  resourceId: Utils.getStringFromObjectList(
                                                      selectedResourceMain ?? []),
                                                  branchId: branchNO.toString(),
                                                ));
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: 24,
                                            color: AppC().base,
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 35,
                                            child: Utils.getSearchBarUI(() {},
                                              // onSubmitted: () {
                                              //   log("DISMISSa");
                                              //   Utils.dismissKeyboard(context);
                                              // },
                                                  (value) {
                                                _filterTodo(value);
                                              }, searchController,),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Icon(
                                            Icons.mic_none,
                                            size: 24,
                                            color: AppC().base,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Visibility(
                                  visible: todoList.isNotEmpty,
                                  replacement: Center(
                                      child: Utils.getEmptyTextWidget(topPadding: 30)
                                  ),
                                  child: Expanded(
                                    child: ReorderableListView.builder(
                                      onReorder: (oldIndex, newIndex) {
                                        todoBloc!.add(SwapTodo(
                                            todoList[oldIndex]['id'].toString(),
                                            todoList[newIndex]['id']
                                                .toString()));
                                      },
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: todoList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                          key: ValueKey(index),
                                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                                          child: listItem(
                                              todoList[index], index, state),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                            visible: state is TodoListLoading,
                            child: Center(
                                child: Utils.getProgressIndicator(context)))
                      ],
                    ),
                  );
                },
              ))),
      drawer: const DrawerView(),
    );
  }

  String stripHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  bool findIsPersonOrVehicle(Map<String, dynamic> vehiclesData) {
    for (Map<String, dynamic> res in resourceList) {
      if ('${res['first_name']} ${res['last_name']}' ==
          (vehiclesData['vehicle_name'] ?? '')) {
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

  Widget _buildTimeField(String label, TextEditingController controller, Function onTapCallback) {
    return Utils.getTextFormField(
      '',
      controller,
      suffixIcon: const Icon(
        Icons.access_time_sharp,
        size: 16,
        color: AppC.appColor,
      ),
      readOnly: true,
      onTapCallback: () async {
        await onTapCallback();
      },
      label: Utils.getText(label, color: AppC.grey),
    );
  }

  String formatShiftTimings(String shiftTimings) {
    try {
      List<String> times = shiftTimings.split('-');
      if (times.length != 2) return "Invalid format";
      DateTime startTime = DateFormat("ha").parse(times[0].trim());
      DateTime endTime = DateFormat("ha").parse(times[1].trim());
      String formattedStartTime = DateFormat("hh:mm a").format(startTime);
      String formattedEndTime = DateFormat("hh:mm a").format(endTime);
      return "$formattedStartTime - $formattedEndTime";
    } catch (e) {
      return "Error formatting shift timings: $e";
    }
  }

  String? timeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the time taken.';
    }
    final timeRegex = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');
    if (!timeRegex.hasMatch(value)) {
      return 'Please enter time in the format HH:mm (e.g., 05:00).';
    }
    return null;
  }

  void applyFilters() {
    setState(() {
      todoList = todoListTemp.where((vehicle) {
        if(vehicle['vehicle_name']!=null){
          vehicleName = vehicle['vehicle_name']?.toString().toLowerCase() ?? '';}
        else{
          vehicleName = (vehicle['vehicles'] != null && vehicle['vehicles'] is List && vehicle['vehicles'].isNotEmpty)
              ? (vehicle['vehicles'][0]['vehicle_name'] ?? '').toString().toLowerCase()
              : '';
        }
        final yearMatch = selectedYears.isEmpty ||
            selectedYears.any((year) => vehicleName.contains(year.toLowerCase()));
        final makeMatch = selectedMakes.isEmpty ||
            selectedMakes.any((make) => vehicleName.contains(make.toLowerCase()));
        final modelMatch = selectedModels.isEmpty ||
            selectedModels.any((model) => vehicleName.contains(model.toLowerCase()));
        return yearMatch && makeMatch && modelMatch;
      }).toList();
    });
  }

  void taskFilter() {
    if (selectedFilters.isEmpty) {
      setState(() {
        todoList = List<Map<String, dynamic>>.from(todoListTemp);
      });
      return;
    }
    setState(() {
      todoList = todoListTemp.where((todo) {
        final title = (todo['title'] ?? '').toString().toLowerCase();
        return selectedFilters.any((filter) => title.toLowerCase() == filter.toLowerCase());
      }).toList();
    });
  }

  void _filterTodo(String query) {
    setState(() {
      final searchQuery = query.toLowerCase();
      todoList = todoListTemp.where((todo) {
        final name = (todo['title'] ?? '').toString().toLowerCase();
        final vehicle = (todo['vehicle_name'] ?? '').toString().toLowerCase();
        final vehicles = (todo['vehicles'] != null && todo['vehicles'] is List && todo['vehicles'].isNotEmpty)
            ? (todo['vehicles'][0]['vehicle_name'] ?? '').toString().toLowerCase()
            : '';
        final time = (todo['todo_time'] ?? '').toString().toLowerCase();
        final firstName = (todo['users']?['first_name'] ?? '').toString().toLowerCase();
        final lastName = (todo['users']?['last_name'] ?? '').toString().toLowerCase();
        final notes = (todo['notes'] ?? '').toString().toLowerCase();
        return name.contains(searchQuery) ||
            vehicle.contains(searchQuery) ||
            vehicles.contains(searchQuery) ||
            time.contains(searchQuery) ||
            firstName.contains(searchQuery) ||
            lastName.contains(searchQuery) ||
            notes.contains(searchQuery);
      }).toList();
    });
  }

  void show(BuildContext context, String message, String status, String id, String oldDate) {
    OverlayEntry? overlay;
    overlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20,
        left: 20,
        child: ToastWidget(message, () {
          if (status.isNotEmpty) {
            todoBloc!.add(CompleteTodoItem(todoId: id, status: status));
          } else {
            String addedDate = DateFormat("yyyy-MM-dd").format(
                DateTime.parse(oldDate).subtract(const Duration(days: 1)));
            todoBloc!.add(EditTodoDate(
                null, true, id.toString(), addedDate, null, null, null, null, null));
          }
          if (overlay != null && overlay!.mounted) {
            overlay?.remove();
            overlay = null;
          }
        }),
      ),
    );
    Overlay.of(context).insert(overlay!);
    Timer(const Duration(seconds: 3), () {
      if (overlay != null && overlay!.mounted) {
        overlay?.remove();
        overlay = null; // Prevent further references
      }
    });
  }

  Future<void> _selectTime(BuildContext context, id) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              dialBackgroundColor: Colors.white,
              hourMinuteTextColor:
                  WidgetStateColor.resolveWith((states) => Colors.black),
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
              dayPeriodTextColor: Colors.black,
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? Colors.white
                      : Colors.white),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      final formattedTime = formatTimeOfDay(_selectedTime);

      todoBloc!.add(EditTodoDate(formattedTime, false, id.toString(), null,
          null, null, null, null, null));
    }
  }

  String getDistance(String? taskVin, reservationVehicles, taskVehicles) {
    if (taskVin != null) {
      return reservationVehicles
              ?.firstWhere(
                (vehicle) => vehicle.vin.toUpperCase() == taskVin.toUpperCase(),
                orElse: () => null,
              )?.distance.toString() ?? '';
    } else if (taskVehicles != null && taskVehicles.length == 1) {
      return reservationVehicles
              ?.firstWhere(
                (vehicle) =>
                    vehicle.vin.toUpperCase() ==
                    taskVehicles[0].vin.toUpperCase(),
                orElse: () => null,
              )?.distance.toString() ?? '';
    } else {
      return '';
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat("HH:mm:ss");
    return format.format(dt);
  }

  String format24TimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat("HH:mm:ss");
    return format.format(dt);
  }

  void _showImageDialog(List<dynamic> imageUrls, int index) {
    Map<String, dynamic> img = {};
    for (var n in todoList) {
      img.addAll(n);
    }
    PageController pageController = PageController(initialPage: index);
    ValueNotifier<double> rotationAngle = ValueNotifier<double>(0.0); // Track rotation angle
    TransformationController transformationController = TransformationController(); // Controls zoom
    double currentScale = 1.0; // Initial zoom level
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppC.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Expanded(
                    child: PageView.builder(
                      itemCount: imageUrls.length,
                      controller: pageController,
                      onPageChanged: (newIndex) {
                        rotationAngle.value = 0.0;
                        transformationController.value = Matrix4.identity(); // Reset zoom on page change
                        currentScale = 1.0; // Reset scale
                      },
                      itemBuilder: (context, index) {
                        final imagePath = imageUrls[index]['path'];
                        return ValueListenableBuilder<double>(
                          valueListenable: rotationAngle,
                          builder: (context, angle, child) {
                            return Transform.rotate(
                              angle: angle, // Apply rotation
                              child: File(imagePath.toString()).existsSync()
                                  ? Image.file(
                                File(imagePath),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              )
                                  : InteractiveViewer(
                                maxScale: 8.0,
                                minScale: 0.01,
                                child: GestureDetector( onTap: (){
                                  if (currentScale == 1.0) {
                                    currentScale = 2.0; // Zoom in
                                  } else {
                                    currentScale = 1.0; // Reset to original scale
                                  }
                                  transformationController.value = Matrix4.identity()..scale(currentScale);
                                },
                                  child: CachedNetworkImage(
                                    imageUrl: img['todoimages'] != null
                                        ? '${Str.TODO_ATTACHMENTS_URL}$imagePath'
                                        : Str.errorImage,
                                    imageBuilder: (context, imageProvider) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return Container(
                                        alignment: Alignment.center,
                                        child: Utils.getText(
                                          "CT",
                                          size: 22,
                                          color: AppC.red,
                                          weight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.whatsAppIcon,
                          height: 24,
                          width: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              rotationAngle.value += 3.14 / 2; // Rotate by 90 degrees (π/2 radians)
                            },
                            child: const Icon(Icons.rotate_right_rounded),
                          ),
                        ),
                        Image.asset(
                          Assets.mail,
                          height: 24,
                          width: 24,
                        ),
                      ],
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showObjectPopupMainMenuWithCheckBox(
      BuildContext context,
      List<Map<String, dynamic>> todoListMenu,
      TapDownDetails details,
      Function(List<Map<String, dynamic>>?) onSelect,
      List<Map<String, dynamic>> taskCategoryGroupData,
      List<Map<String, dynamic>> titleList,)
  async {
    List<Map<String, dynamic>> taskList = [];
    List<Map<String, dynamic>> headList = [];
    List<Map<String, dynamic>> headListName = [];

    for (var data in todoListMenu) {
      var matchedSubcategory = subCategoryList.firstWhere(
            (item) => item['name'].toString().toLowerCase() == data['title'].toString().toLowerCase(),
        orElse: () => {},
      );
      if (matchedSubcategory.isNotEmpty) {
        taskList.add(matchedSubcategory);
        checkboxStates.putIfAbsent(matchedSubcategory['name'].toString(), () => false);
      }
      if (!['Check In', 'Check Out', 'Lunch'].contains(data['title'])
          && !taskList.any((task) => task['id'] == data['id'])
          && matchedSubcategory.isEmpty)
      {
        var newTask = {
          'parent_id': -1,
          'id': data['id'],
          'name': data['title'],
        };
        taskList.add(newTask);
        checkboxStates.putIfAbsent(newTask['name'].toString(), () => false);
      }
    }

    for (var sub in taskList) {
      var matchedGroup = titleList.firstWhere(
            (item) => item['id'] == sub['parent_id'],
        orElse: () => {},
      );
      if (matchedGroup.isNotEmpty && !headList.contains(matchedGroup)) {
        headList.add(matchedGroup);
      }
    }

    for (var head in headList) {
      var matchedTitle = titleList.firstWhere(
            (item) => item['id'] == head['id'],
        orElse: () => {},
      );
      if (matchedTitle.isNotEmpty && !headListName.contains(matchedTitle)) {
        headListName.add(matchedTitle);
      }
    }

    showMenu<List<Map<String, dynamic>>>(
      context: context,
      color: const Color(0xffffffff).withOpacity(0.75),
      constraints: BoxConstraints.tightFor(width: MediaQuery.sizeOf(context).width),
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: <PopupMenuEntry<List<Map<String, dynamic>>>>[
        PopupMenuItem<List<Map<String, dynamic>>>(
          height: 22,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.2),
                ),
               
              ),
              child: Row(
                children: [
                  const Icon(Icons.close, color: Colors.red),
                  const SizedBox(width: 8),
                  Utils.getText('Close', weight: FontWeight.w900),
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem<List<Map<String, dynamic>>>(
          child: StatefulBuilder(
            builder: (context, setState) {
              return PopupMenuTheme(
                data: const PopupMenuThemeData(color: Color(0xfff8f8ff),),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.2),
                        ),
                        
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Utils.getText(
                              'All Todo',
                              size: 12,
                              weight: FontWeight.w900,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                activeColor: AppC.blue,
                                value: checkboxStates['all'] ?? false,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    checkboxStates['all'] = newValue ?? false;
                                    for (var key in checkboxStates.keys) {
                                      if (key != 'all') {
                                        checkboxStates[key] = newValue ?? false;
                                      }
                                    }
                                    if (newValue == true) {
                                      selectedFilters.clear(); // Clear existing filters
                                      selectedFilters.addAll(checkboxStates.keys.where((key) => key != 'all'));
                                    } else {
                                      selectedFilters.clear();
                                    }
                                    selectedTaskCount=selectedFilters.length;
                                    taskFilter();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      children: headListName.map((name) {
                        var childTasks = taskList.where((task) => task['parent_id'] == name['id']).toList();
                        return Padding(
                          padding: const EdgeInsets.symmetric( vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Utils.getText(
                                      name['name'] ?? '',
                                      weight: FontWeight.w700,
                                    ),
                                    Transform.scale(
                                      scale: 0.7,
                                      child: SizedBox(
                                        width: 30,
                                        height: 20,
                                        child: Checkbox(
                                          activeColor: AppC.blue,
                                          value: childTasks.every((task) =>
                                          checkboxStates[task['name'].toString()] ?? false), // Check parent based on children
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              for (var task in childTasks) {
                                                checkboxStates[task['name'].toString()] = newValue ?? false;
                                                if (newValue == true) {
                                                  if (!selectedFilters.contains(task['name'])) {
                                                    selectedFilters.add(task['name']);
                                                  }
                                                } else {
                                                  selectedFilters.remove(task['name']);
                                                }
                                              }
                                              selectedTaskCount=selectedFilters.length;
                                              taskFilter();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Utils.getText(
                                      ' ${childTasks.length}',
                                      weight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                                ...childTasks.fold<Map<String, int>>({}, (acc, task) {
                                  String taskName = task['name'] ?? '';
                                  acc[taskName] = (acc[taskName] ?? 0) + 1;
                                  return acc;
                                }).entries.map((entry) {
                                  String taskName = entry.key;
                                  int count = entry.value;
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Transform.scale(
                                        scale: 0.7,
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                            activeColor: AppC.blue,
                                            value: checkboxStates[taskName.toString()] ?? false,
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                checkboxStates[taskName.toString()] = newValue ?? false;
                                                if (newValue == true) {
                                                  if (!selectedFilters.contains(taskName)) {
                                                    selectedFilters.add(taskName);
                                                  }
                                                } else {
                                                  selectedFilters.remove(taskName);
                                                }
                                                selectedTaskCount=selectedFilters.length;
                                                taskFilter();
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Utils.getText(taskName, weight: FontWeight.w200),
                                      const SizedBox(width: 5,),
                                      Utils.getText('$count', weight: FontWeight.bold),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void showPopupWithCheckBoxDepartmentWise(
    List<Map<String, dynamic>> resourceList,
    details,
    Function(List<Map<String, dynamic>?>) onSelect,
    Map<String, bool> selectedStates,)
  async {
    Map<String, List<Map<String, dynamic>>> groupedResources = {};
    for (var resource in resourceList) {
      String departmentName =
          resource['departments'] != null && resource['departments']!.isNotEmpty
              ? resource['departments']!['name'] ?? 'Unknown'
              : 'Unknown';
      if (departmentName == 'Admin Manager' || departmentName == 'Operations') {
        departmentName = 'Core';
      }
      if (!groupedResources.containsKey(departmentName)) {
        groupedResources[departmentName] = [];
      }
      groupedResources[departmentName]!.add(resource);
      selectedStates.putIfAbsent(resource['id'].toString(), () => false);
    }
    bool isExpanded = false;
    showMenu<List<Map<String, dynamic>?>>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      elevation: 16,
      constraints: const BoxConstraints.tightFor(width: 500),
      surfaceTintColor: AppC.white,
      color: const Color(0xffffffff).withOpacity(0.75),
      items: <PopupMenuEntry<List<Map<String, dynamic>?>>>[
        PopupMenuItem<List<Map<String, dynamic>?>>(
          height: 22,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        ),
        PopupMenuItem<List<Map<String, dynamic>?>>(
          onTap: () {
            for (var key in selectedStates.keys) {
              selectedStates[key] = false;
            }
            todoBloc!.add(GetTodoList(
              selectedDate: filterDate,
              status: statusFilter ? "Completed" : "In Progress",
              resourceId: Utils.getStringFromObjectList([]),
              branchId: branchNO.toString(), // No filters applied
            ));
          },
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Utils.getText(
              'All',
              size: 15,
              weight: FontWeight.bold,
            ),
          ),
        ),
        PopupMenuItem<List<Map<String, dynamic>?>>(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: StatefulBuilder(
            builder: (context, setState) {
              List<String> sortedDepartmentNames =
                  groupedResources.keys.toList()
                    ..sort((a, b) {
                      bool aIsOffshore = a.toLowerCase().contains('offshore');
                      bool bIsOffshore = b.toLowerCase().contains('offshore');
                      if (aIsOffshore && !bIsOffshore) {
                        return 1; // Move Offshore to the end
                      }
                      if (!aIsOffshore && bIsOffshore) return -1;
                      return a.compareTo(b);
                    });
              List<String> displayedDepartments = isExpanded
                  ? sortedDepartmentNames
                  : sortedDepartmentNames.take(2).toList();
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...displayedDepartments.map((departmentName) {
                      List<Map<String, dynamic>> resources =
                          groupedResources[departmentName]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              departmentName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          ...resources.map((resource) {
                            String resourceId = resource['id'].toString();
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedStates[resourceId] =
                                      !(selectedStates[resourceId] ?? false);
                                });

                                selectedUserCount = selectedStates.values
                                    .where((isSelected) => isSelected)
                                    .length;

                                todoBloc!.add(GetTodoList(
                                  selectedDate: filterDate,
                                  status: statusFilter
                                      ? "Completed"
                                      : "In Progress",
                                  resourceId: Utils.getStringFromObjectList(
                                    resourceList.where(
                                          (res) => selectedStates[res['id'].toString()] == true,
                                    ).toList(),
                                  ),
                                  branchId: branchNO.toString(),
                                ));
                              },
                              child: Container(
                                height: 30.0,
                                padding:const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: 0.8,
                                          child: Checkbox(
                                            activeColor: AppC().base,
                                            value: selectedStates[resourceId],
                                            onChanged: (bool? value) {
                                              if (value != null) {
                                                setState(() {
                                                  selectedStates[resourceId] = value;
                                                });
                                                selectedUserCount =
                                                    selectedStates.values
                                                        .where((isSelected) => isSelected)
                                                        .length;
                                                todoBloc!.add(GetTodoList(
                                                  selectedDate: filterDate,
                                                  status: statusFilter
                                                      ? "Completed"
                                                      : "In Progress",
                                                  resourceId: Utils.getStringFromObjectList(
                                                    resourceList.where(
                                                          (res) => selectedStates[res['id'].toString()] == true,
                                                        ).toList(),
                                                  ),
                                                  branchId: branchNO.toString(),
                                                ));
                                              }
                                            },
                                          ),
                                        ),
                                        Utils.getText(
                                          '${resource['first_name'] ?? ''} ${resource['last_name'] ?? ''}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Utils.getText(
                                          resource['unavailable_days'] != null &&
                                              resource['unavailable_days'] ==
                                                  DateFormat('EEEE').format(DateTime.now())
                                              ? 'Unavailable' : (resource['from_time'] != null &&
                                              resource['from_time'].isNotEmpty &&
                                              resource['to_time'] != null &&
                                              resource['to_time'].isNotEmpty)
                                                  ? "${Utils.convertString24HTo12H(resource['from_time'] ?? '')} - ${Utils.convertString24HTo12H(resource['to_time'] ?? '')}"
                                                  : '',
                                          weight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Utils.getText(
                        isExpanded ? 'Less' : 'More',
                        color: Colors.black54,
                        weight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
    onSelect(resourceList
        .where((res) => selectedStates[res['id'].toString()] == true)
        .toList());
  }

  void showTaskCompletionDialog(BuildContext context,String? selectedTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {

            return Align(
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Utils.getText(
                              'Task Completed - Time',
                              size: 16,
                              weight: FontWeight.w700,
                              color: AppC.appColor,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.close_sharp),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Utils.getText(
                          'How long this task taken to complete?',
                          weight: FontWeight.bold,
                        ),
                        Wrap(
                          spacing: 1.5,
                          runSpacing: 1,
                          children: [
                            for (String time in [
                              '00:15', '00:30', '00:45', '01:00', '01:15',
                              '01:30', '01:45', '02:00', '02:15', '02:30',
                              '02:45', '03:00', '03:15', '03:30', '03:45',
                              '04:00',
                            ])
                              ChoiceChip(
                                label: Utils.getText(
                                  time,
                                  color: selectedTime == time ? Colors.white : AppC.appColor,
                                  weight: FontWeight.bold,
                                ),
                                selected: selectedTime == time,
                                labelPadding: EdgeInsets.zero,
                                selectedColor: AppC.appColor,
                                disabledColor: Colors.blue[50],
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: const BorderSide(
                                    color: AppC.appColor,
                                    width: 0.5,
                                  ),
                                ),
                                backgroundColor: Colors.blue[50],
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedTime = selected ? time : null;
                                  });
                                },
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7.5),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTime = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(7.5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    border: Border.all(
                                      width: 0.5,
                                      color: AppC.appColor,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Utils.getText('> 4 hours', color: AppC.red),
                                ),
                              ),
                            ),
                            if (selectedTime == null)
                              Row(
                                children: [
                                  Expanded(
                                    child: Utils.getText(
                                      'Enter the time taken:',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Utils.getTextFormField(
                                      'eg: 05:00',
                                      taskTimeController,
                                      validator: (value) => timeValidator(value),
                                    ),
                                  ),
                                ],
                              ),
                            Visibility(
                              visible: taskTimeController.text.isEmpty && selectedTime == null,
                              child: Utils.getText(
                                'Please select time taken',
                                color: AppC.red,
                              ),
                            ),
                            Visibility(
                              visible: taskTimeController.text.isNotEmpty && selectedTime == null,
                              child: Utils.getText(
                                'Please enter time in the format of 01:00',
                                color: AppC.red,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Utils.getBorderedMultilineTextField('Reason', reasonController, minLines: 2),
                            Visibility(
                              visible: reasonController.text.isEmpty,
                              child: Utils.getText(
                                'Please enter reason for extra time',
                                color: AppC.red,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Utils.getAddFilledButton('Submit', () {}, bgColor: AppC.green),
                              ],
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
      },
    );
  }

  bool isTaskDateValid(String taskStart, DateTime now) {
    final taskDate = DateFormat('yyyy-MM-dd').parse(taskStart);
    return taskDate.isAtSameMomentAs(now) || taskDate.isAfter(now);
  }

  bool isValidTask(String taskStart, String? vin, List<dynamic>? vehicles) {
    final now = DateTime.now();
    return isTaskDateValid(taskStart, now) &&
        (vin != null || (vehicles != null && vehicles.isNotEmpty));
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Utils.getText(
      '$hours:$minutes:$seconds',
    );
  }

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => addTime(),
    );
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  void resetTimer() {
    setState(() => duration = const Duration());
  }

  Widget listItem(Map<String, dynamic> todos, int index, TodoViewState state) {
    final isValid = isValidTask(todos['todo_date'], todos['vin'], vehicleList);
    //final vehicle=vehicleList[index];
    String? vinToFind;
    Map<String, dynamic>? vehicle;
    if (todos['vin'] == null) {
      if (todos['vehicles'] is List && todos['vehicles'].isNotEmpty) {
        vinToFind = todos['vehicles'][0]['vin'];
      }
    } else {
      vinToFind = todos['vin'];
    }

    String? selectedTime = todos['complete_time_taken']??'00:15'; // Set your initial selected time

    vehicle = vinToFind != null
        ? vehicleList.firstWhere(
            (emp) => emp['vin'] == vinToFind,
            orElse: () => {}, // Return null if no match is found
          )
        : null;

    final Map<String, dynamic>? status = vehicle != null
        ? vehicleStatus.firstWhere(
            (data) => data['id'] == vehicle?['vehicle_status'],
            orElse: () => {}, // Return null if no match is found
          )
        : null;

    if (todos['vehicles'] is List && todos['vehicles'].isNotEmpty) {
      vinToFind = todos['vehicles'][0]['vin'];
    }

    final Map<String, dynamic>? image = vinToFind != null
        ? vehicleList.firstWhere(
            (emp) => emp['vin'] == vinToFind,
            orElse: () => {},
          )
        : null;

    if (todos['todoimages'] != null && todos['todoimages'] is List) {
      todoImages.clear();
      todoImages.addAll(todos['todoimages']); // Use addAll to avoid nesting
    }
    return Row(
      children: [
        Column(
          children: [
            CachedNetworkImage(
              imageBuilder: (context, imageProvider) {
                return Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(top: 0, bottom: 2),
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: todos['status'] == "Completed"
                              ? AppC.green
                              : AppC.appColor,
                          width: 1.5),
                      borderRadius: BorderRadius.circular(27),
                      color: AppC.red,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ));
              },
              imageUrl:(getVehicleText(todos) != 'MV')? todos['vehicle_image'] != null
                  ? Str.STORAGE_BASE_URL + todos['vehicle_image']
                  : (image?['images'] != null && image?['images']?.isNotEmpty
                  ? Str.STORAGE_BASE_URL + image!['images'][0]['path']
                  : ''):'',

              placeholder: (context, url) => SizedBox(
                  height: 50,
                  width: 50,
                  child: Utils.getProgressIndicator(context)),
              errorWidget: (context, url, error) {
                return Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: todos['status'] == "Completed"
                            ? AppC.green
                            : AppC.appColor,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(27),
                  ),
                  alignment: Alignment.center,
                  child: Utils.getText(getVehicleText(todos) == 'MV'?'MV':"CT", size: 14, color: todos['status'] == "Completed"
                      ? AppC.green
                      : AppC.appColor,),
                );
              },
            ),
            if (todos['vehicle_number'] != null)
              Utils.getText(
                "${todos['vehicle_number'] ?? "No plate"}",
                size: 10,
                weight: FontWeight.w900,
                color: todos['vehicle_number'] != null ? AppC().base : AppC.red,
              ),
            if (todos['vehicles'].isNotEmpty &&
                todos['vehicles'].length == 1 &&
                todos['vehicle_number'] == null)
              Utils.getText(
                vehicle?['vehicle_number'] ?? 'No plate',
                size: 10,
                weight: FontWeight.w900,
                color: vehicle?['vehicle_number'] != null ? AppC().base : AppC.red,
              ),
          ],
        ),
        const SizedBox(width: 8,),
        Expanded(
          child: Dismissible(
            key: ValueKey(todos['id']),
            background: Container(
              color: AppC.white,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Utils.getText('Tomorrow',
                  color: AppC.red, weight: FontWeight.bold),
            ),
            secondaryBackground: Container(
              color: AppC.white,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                statusFilter ? 'In Progress' : 'Complete',
                style: const TextStyle(color: Colors.green),
              ),
            ),
            confirmDismiss: (direction) async {
              /*if (direction == DismissDirection.startToEnd) {
                showDialog(
                  useSafeArea: true,
                  context: context,
                  builder: (BuildContext context) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          TimeOfDay initialTime = TimeOfDay.now();
                          List<String> parts = todos['todo_time']!.split(':');
                          if (parts.length >= 2) {
                            int? hour = int.tryParse(parts[0]);
                            int? minute = int.tryParse(parts[1]);
                            if (hour != null && minute != null) {
                              setState(() {
                                initialTime =
                                    TimeOfDay(hour: hour, minute: minute);
                              });
                            }
                          }
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SingleChildScrollView(
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        TimePickerDialog(
                                          initialTime: initialTime,
                                          confirmText: null,
                                          cancelText: null,
                                          initialEntryMode:
                                              TimePickerEntryMode.dialOnly,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 482, left: 100),
                                          child: Container(
                                            alignment: Alignment.bottomLeft,
                                            child: GestureDetector(
                                              onTap: () {
                                                String addedDate = DateFormat(
                                                        "yyyy-MM-dd")
                                                    .format(selectedDate.add(
                                                        const Duration(days: 1)));
                                                todoBloc!.add(EditTodoDate(
                                                    null,
                                                    true,
                                                    todos['id'].toString(),
                                                    addedDate,
                                                    null,
                                                    null,
                                                    null,
                                                    null,
                                                    null));
                                                Navigator.pop(
                                                    context); // Close the dialog
                                              },
                                              child: Utils.getText(
                                                'Same Time',
                                                size: 14,
                                                color: Colors.deepPurple.shade600,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ).then((selectedTime) {
                  if (selectedTime != null) {
                    final formattedTime = format24TimeOfDay(selectedTime);
                    String addedDate = DateFormat("yyyy-MM-dd")
                        .format(selectedDate.add(const Duration(days: 1)));
                    todoBloc!.add(EditTodoDate(
                        formattedTime,
                        true,
                        todos['id'].toString(),
                        addedDate,
                        null,
                        null,
                        null,
                        null,
                        null));
                  }
                });
              }
              }*/
              if (direction == DismissDirection.startToEnd) {
                todoTimeController.text=todos['todo_time'];
                editSelectedDate =
                    Utils.convertStringToDateTime(todos['todo_date'] ?? '');
                editTodoDateController.text = todos['todo_date'] ?? '';
                showDialog(
                  useSafeArea: true,
                  context: context,
                  builder: (BuildContext context) {
                    return DefaultTabController(
                      length: 2, // Number of tabs
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(6),
                                color: AppC.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: IntrinsicHeight(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Utils.getText(
                                                  'Select Date & Time',
                                                  size: 16,
                                                  weight: FontWeight.bold,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Icon(
                                                    Icons.clear,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Utils.getTextFormField(
                                                  contentPadding: const EdgeInsets.only(right: 21, left: 10),
                                                  '',
                                                  editTodoDateController,
                                                  readOnly: true,
                                                  onTapCallback: () {
                                                    Utils.todoDatePickerDialog(context, '').then((value) {
                                                      editSelectedDate = value;
                                                      editTodoDateController.text = Utils.convertDateToYearMonthDateFormat(
                                                        value.toString(),
                                                      );
                                                    });
                                                  },
                                                  suffixIcon: const Icon(
                                                    Icons.calendar_month,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: _buildTimeField('', todoTimeController, () async {
                                                  TimeOfDay? pickedTime = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay(
                                                      hour: int.parse(todoTimeController.text.split(":")[0]),
                                                      minute: int.parse(todoTimeController.text.split(":")[1]),
                                                    ),
                                                    builder: (BuildContext context, Widget? child) {
                                                      return MediaQuery(
                                                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                                        child: child!,
                                                      );
                                                    },
                                                  );
                                                  if (pickedTime != null) {
                                                    final formattedTime =
                                                        '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                                                    setState(() {
                                                      todoTimeController.text = formattedTime;
                                                    });
                                                  }
                                                }),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          const TabBar(
                                            labelColor: Colors.black,
                                            unselectedLabelColor: Colors.grey,
                                            indicatorColor: Colors.blue,
                                            tabs: [
                                              Tab(text: 'By Vehicle'),
                                              Tab(text: 'By Day'),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          const SizedBox(
                                            height: 200, // Adjust height for tab content
                                            child: TabBarView(
                                              children: [
                                                Center(child: Text('Content for Tab 1')),
                                                Center(child: Text('Content for Tab 2')),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                if (statusFilter) {
                  todoBloc!.add(CompleteTodoItem(
                      todoId: todos['id'].toString(), status: 'In Progress'));
                }else if(todos['title'] == 'Oil Change' || todos['title'] == 'Oil Change Check'){
                  todoBloc!.add(GetPreviousOdometer(todoDate: todos['todo_date'], identifierId: todos['identifier_id'], vin: vinToFind, todoData: todos));
                  // showOilCheckPopup(
                  //   context,
                  //   oilChangeOdometerController,
                  //   nextMilesCheckController,
                  //   nextOdometerController,
                  //   taskMiles,
                  //   todos,
                  //   previousOdometer,
                  // );
                } else {
                  if (todos['title'] != 'Maintenance Check') {
                    todoBloc!.add(CompleteTodoItem(
                        todoId: todos['id'].toString(),
                        status: 'Completed',
                        taskName: todos['title']
                    ),
                    );
                  }
                  else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTodoUI(
                                todoItem: todos,
                                userGroupList: userGroupList,
                                resourceList: resourceList,
                                categoriesListData: categoriesListData,
                                addressesList: addresses,
                                multipleLocationList:
                                multipleLocationAddressList
                            ),
                        ),
                    );
                  }
                }
                return false;
              }
              return null;
            },
            onDismissed: (direction) {
              setState(() {
                todoList.removeAt(index);
              });
            },
            child: Container(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
              decoration: BoxDecoration(
                border: Border(
                  top: const BorderSide(color: AppC.white, width: 1),
                  left: const BorderSide(color: AppC.white, width: 1),
                  right: const BorderSide(color: AppC.white, width: 1),
                  bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.4), width: 1.2),
                ),
                color: AppC.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (todos['vehicle_group_id'] != null &&
                                  todos['vehicle_group_id'] != 0) {
                                List<Map<String, dynamic>>
                                    selectedVehicleGroupList = [];
                                todos['vehicleGroupList'] = [];
                                for (Map<String, dynamic> element
                                    in vehicleGroupList) {
                                  if (element['id'] ==
                                      todos['vehicle_group_id']) {
                                    if (element['vin'] != null &&
                                        element['vin']!.isNotEmpty) {
                                      vehicleGroupName = element['name'];
                                      List<dynamic> jsonList =
                                          json.decode(element['vin']!);
                                      List<dynamic> resultList =
                                          jsonList.cast<dynamic>();
                                      for (dynamic vin in resultList) {
                                        for (Map<String, dynamic> vd
                                            in vehicleList) {
                                          if (vin.trim().toString() ==
                                              (vd['vin'] ?? '')
                                                  .trim()
                                                  .toString()) {
                                            isSelected = true;
                                            deleteId = element['id'];
                                            // vd.vehicleGroupId = true;
                                            // VehiclesData suppliesData = VehiclesData(vehicleName: element.supplyName, deleteId: element.id, id: int.tryParse(element.supplyId), isSelected: true);
                                            selectedVehicleGroupList.add(vd);
                                          }
                                        }
                                        /*if (element1.id.toString() == element.supplyId) {
                                      element1.isSelected = true;
                                    }*/
                                      }
                                    }
                                  }
                                }
                                todos['vehicleGroupList']!
                                    .addAll(selectedVehicleGroupList);
                              }
                              await getUserGroupList(todos);
                              bool? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTodoUI(
                                      todoItem: todos,
                                      userGroupList: userGroupList,
                                      resourceList: resourceList,
                                      categoriesListData: categoriesListData,
                                      addressesList: addresses,
                                      multipleLocationList:
                                          multipleLocationAddressList),
                                ),
                              );
                           //   if (result != null && result) {
                                todoBloc!.add(const GetUserGroupingList());
                                todoBloc!.add(GetTodoList(
                                  selectedDate: filterDate,
                                  status: statusFilter
                                      ? "Completed"
                                      : "In Progress",
                                  resourceId: Utils.getStringFromObjectList(
                                      selectedResourceMain ?? []),
                                  branchId: branchNO.toString(),
                                ));
                             // }
                            },
                            child: Utils.getText('${todos['title']}',
                                color: todos['time_sensitive'] == 1
                                    ? AppC.red
                                    : AppC().base,
                                weight: FontWeight.w800,
                                overFlow: TextOverflow.ellipsis,
                                size: 13),
                          ),
                          const SizedBox(width: 5,),

                          GestureDetector(
                            onTap: () async {
                              final String link = todos['custom_link_id'] == 3
                                  ? 'https://getaround.com/dashboard/rentals/${todos['reference_id'] ?? todos['reference_id']}'
                                  : 'https://turo.com/us/en/reservation/${todos['reference_id'] ?? todos['reference_id']}';
                              if (await canLaunch(link)) {
                                await launch(link, forceSafariVC: false, forceWebView: false);
                              } else {
                                throw 'Could not launch $link';
                              }
                            },
                            child: Utils.getText(
                              todos['custom_link_id'] != null
                                  ? (todos['custom_link_id'] == 3 ? 'G' : 'T')
                                  : '',
                              color: todos['custom_link_id'] == 3
                                  ? const Color(0xFFA608C0)
                                  : Colors.black,
                              weight: FontWeight.w900,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Visibility(
                            visible:todos['todoimages'].isNotEmpty,
                              child: GestureDetector(
                                onTap: (){
                                  final imagePath= todos['todoimages'];
                                  const int initialIndex = 0; // Or any index from your list
                                  _showImageDialog(imagePath, initialIndex);
                                },
                                child: const Icon(
                                  Icons.remove_red_eye_sharp,
                                  size: 12,
                                  color: AppC.appColor,
                                ),
                              )
                          ),
                        ],
                      )),
                      const SizedBox(width: 5,),
                      InkWell(
                          onTap: () {
                            Utils.todoDatePickerDialog(
                              context,
                              '',
                              initial: DateTime.parse(todos['todo_date']),
                            ).then((value) {
                              setState(() {
                                if (value != null) {
                                  // selectedDate = value;
                                  todoBloc!.add(EditTodoDate(
                                      null,
                                      true,
                                      todos['id'].toString(),
                                      (DateFormat("yyyy-MM-dd").format(value)),
                                      null,
                                      null,
                                      null,
                                      null,
                                      null));
                                }
                              });
                            });
                          },
                          child: const Icon(
                            Icons.calendar_month_outlined,
                            size: 13,
                            color: Colors.black,
                          ),
                      ),
                        Visibility(
                          visible: todos['title'] != 'Check In' && todos['title'] != 'Check Out',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                showTaskCompletionDialog(context,selectedTime);
                              },
                              child: Utils.getText(
                                todos['complete_time_taken'] != null
                                    ? "(${todos['complete_time_taken'].toString()})"
                                    : '00:15',
                              ),
                            ),
                          ),
                        ),
                      InkWell(
                        onTap: () {
                          DateTime.now().copyWith(
                              hour: int.tryParse(
                                  todos['todo_time']!.split(':')[0]),
                              minute: int.tryParse(
                                  todos['todo_time']!.split(':')[1]),
                              second: int.tryParse(
                                  todos['todo_time']!.split(':')[2]));

                          List<String> parts = todos['todo_time']!.split(':');
                          if (parts.length >= 2) {
                            int? hour = int.tryParse(parts[0]);
                            int? minute = int.tryParse(parts[1]);
                            if (hour != null && minute != null) {
                              setState(() {
                                _selectedTime =
                                    TimeOfDay(hour: hour, minute: minute);
                              });
                            }
                          }
                          _selectTime(context, todos['id']);
                        },
                        child: Utils.getText(Utils.convertString24HTo12H(
                            todos['todo_time'] ?? '05:30:00')),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: (todos['vehicles'] != null && todos['vehicles']!.isNotEmpty) ||
                                      (todos['vehicle_name'] != null && todos['vehicle_name'] != 'null') ||
                                      (todos['person'] != null && todos['person'] != 'null') ||
                                      (todos['vehicle_group_id'] != null && todos['vehicle_group_id'] != 0),
                                  child: InkWell(
                                    onTapDown: (TapDownDetails? details) async {
                                      if (details != null) {
                                        if (todos['vehicle_name'] != null) {
                                          vehiclePersonController.text = todos['vehicle_name'] ?? '';
                                        } else {
                                          vehiclePersonController.text = todos['person'] ?? '';
                                        }
                                        if (selectedMultipleVehicleList.isEmpty && todos['vehicles'] != null) {
                                             selectedMultipleVehicleList.addAll(todos['vehicles'] ?? '');
                                        }
                                        int? selectedResourceId;
                                        String? personName;
                                        await showMenu(
                                          elevation: 5,
                                          color: AppC.white,
                                          context: context,
                                          constraints:BoxConstraints.tightFor(width: MediaQuery.of(context).size.width * 0.8,),
                                          position: RelativeRect.fromLTRB(
                                            details.globalPosition.dx,
                                            details.globalPosition.dy,
                                            details.globalPosition.dx,
                                            details.globalPosition.dy,
                                          ),
                                          items: [
                                            PopupMenuItem(
                                              value:selectedMultipleVehicleList,
                                              child:StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          GestureDetector(
                                                            child: const Icon(Icons.save, color: Colors.green,size: 18,weight:20,),
                                                            onTap: () {
                                                              isVehicleEdit = !isVehicleEdit;
                                                              for (final res in resourceList) {
                                                                if ('${res['first_name']} ${res['last_name']}' == selectedMultipleVehicleList[0]['vehicle_name']) {
                                                                  personName = '${res['first_name']} ${res['last_name']}';
                                                                  selectedResourceId = res['id']!;
                                                                }
                                                              }
                                                              for (var sub in selectedMultipleVehicleList) {
                                                                var matchedGroup = vehicleList.where(
                                                                        (item) => item['vehicle_id'] == sub['vehicle_id']).toList();
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
                                                                    vehiclesNameData.add(vehiclesData);
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                              if(personName==null){
                                                              todoBloc?.add(
                                                                EditTodoVehiclePerson(
                                                                  todoId: todos['id']!,
                                                                  vehiclePersonData: vehiclesNameData,
                                                                  person: '',
                                                                  personId: '',
                                                                  vehicleGroupId: '',
                                                                ),
                                                              );
                                                            }
                                                              else{
                                                                todoBloc?.add(
                                                                  EditTodoVehiclePerson(
                                                                    todoId: todos['id']!,
                                                                    vehiclePersonData: const [],
                                                                    person: personName,
                                                                    personId: selectedResourceId.toString(),
                                                                    vehicleGroupId: '',
                                                                  ),
                                                                );

                                                              }
                                                            Navigator.pop(context);
                                                              setState(() {});
                                                            },
                                                          ),
                                                          const SizedBox(width: 10,),
                                                          GestureDetector(
                                                            child: const Icon(Icons.close, color: Colors.red,size: 18,weight: 20,),
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Wrap(
                                                        children: List<Widget>.generate(
                                                          selectedMultipleVehicleList.length,
                                                              (int idx) {
                                                            return Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                child: Chip(
                                                                  onDeleted: () {
                                                                    todoBloc?.add(DeleteVehicles(id: selectedMultipleVehicleList[idx]['id']));
                                                                    selectedMultipleVehicleList.removeAt(idx);
                                                                    setState(() {});
                                                                  },
                                                                  side: const BorderSide(color: AppC.trans),
                                                                  deleteIcon: const Icon(
                                                                    Icons.close,
                                                                    color: AppC.red,
                                                                    size: 18,
                                                                  ),
                                                                  backgroundColor: AppC.green.withOpacity(0.3),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(5)),
                                                                  label: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      if (selectedMultipleVehicleList.isNotEmpty &&
                                                                          selectedMultipleVehicleList[idx]is Map<String, dynamic>)
                                                                        Utils.getText(
                                                                          selectedMultipleVehicleList[idx]['vehicle_name'] ?? '',
                                                                          color: AppC.text,
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ));
                                                          },
                                                        ).toList(),
                                                      ),
                                                      Utils.getTextFormField(
                                                        'Vehicle / Person',
                                                        vehiclePersonController,
                                                        readOnly: false,
                                                        onChangeCallback: (value) {
                                                          editMultipleVehicleSuggestionList.clear();
                                                          if (value.isNotEmpty) {
                                                            List<dynamic> multipleVehicleList =
                                                                editMultipleVehicleList;
                                                            editMultipleVehicleSuggestionList.addAll(
                                                                Utils.searchObjectList(
                                                                    multipleVehicleList, value,
                                                                    isVehicleData: true));
                                                            editShowMultipleVehicleList =
                                                                editMultipleVehicleSuggestionList
                                                                    .isNotEmpty;
                                                          } else {
                                                            editShowMultipleVehicleList = false;
                                                          }
                                                          setState(() {});
                                                        },
                                                        suffixIcon: Visibility(
                                                          visible: editMultipleVehicleSuggestionList.isEmpty && vehiclePersonController.text.isNotEmpty,
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
                                                                        await Navigator.of(context)
                                                                            .push(MaterialPageRoute(
                                                                          builder: (context) => const EmployeesViewUI(),
                                                                        ));
                                                                      }
                                                                    });
                                                                },
                                                              child: Icon(
                                                                Icons.add,
                                                                color: AppC().base,
                                                                size: 20,
                                                              )),
                                                    )
                                                      ),
                                                      Stack(
                                                        children: [
                                                          Visibility(
                                                              visible: editShowMultipleVehicleList,
                                                              child: Utils.customAutoCompleteWithUnSelectedOption(
                                                                  editMultipleVehicleSuggestionList,
                                                                      (index) {
                                                                    editShowMultipleVehicleList = false;
                                                                    if (findIsPersonOrVehicle(
                                                                        editMultipleVehicleSuggestionList[index])) {
                                                                      selectedMultipleVehicleList.clear();
                                                                      selectedMultipleVehicleList.add(editMultipleVehicleSuggestionList[index]);
                                                                      isSelected = true;
                                                                      vehiclePersonController.selection =
                                                                          TextSelection.fromPosition(
                                                                            TextPosition(
                                                                                offset: (vehiclePersonController
                                                                                    .text.length)),
                                                                          );
                                                                      setState(() {});
                                                                      vehiclePersonController.selection =
                                                                          TextSelection.fromPosition(
                                                                            TextPosition(
                                                                                offset: (vehiclePersonController
                                                                                    .text.length)),
                                                                          );
                                                                    } else {
                                                                      if (lastSelectedIsPerson) {
                                                                        selectedMultipleVehicleList.clear();
                                                                        lastSelectedIsPerson = false;
                                                                      }
                                                                      selectedMultipleVehicleList.add(
                                                                          editMultipleVehicleSuggestionList[
                                                                          index]);
                                                                      isSelected = true;
                                                                      vehiclePersonController.selection =
                                                                          TextSelection.fromPosition(
                                                                            TextPosition(
                                                                                offset: (vehiclePersonController
                                                                                    .text.length)),
                                                                          );
                                                                      setState(() {});
                                                                      vehiclePersonController.selection =
                                                                          TextSelection.fromPosition(
                                                                            TextPosition(
                                                                                offset: (vehiclePersonController
                                                                                    .text.length)),
                                                                          );
                                                                    }
                                                                  }, isVehicleData: true)),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                    child: Utils.getText(
                                      (getVehicleText(todos)) ?? (vehicleGroupName ?? ''),
                                      size: 12,
                                      overFlow: TextOverflow.ellipsis,
                                      weight: getVehicleText(todos) == 'MV' ? FontWeight.w900 : FontWeight.normal,
                                    ),
                                  ),),
                              ],
                            ),

                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Visibility(
                            visible: (((todos['vehicle_name'] != null ||
                                vehicle != null )&& getVehicleText(todos) != 'MV')),
                            child: InkWell(
                              onTap: () {
                                dynamic statusName;
                                if (status?['category_name'] == 'Recon' ||
                                    status?['category_name'] == 'Rental' ||
                                    status?['category_name'] == 'Repair') {
                                  statusName = status?['category_name'];
                                }
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppC.white,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Utils.getText(
                                                        todos['vehicle_name'] != null
                                                            ? todos['vehicle_name'] ?? ''
                                                            : vehicle?['vehicle_name'],
                                                        size: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: (status?['category_name']) == 'Recon'
                                                            ? Colors.black87
                                                            : (status?['category_name']) == 'Rental'
                                                            ? AppC.green
                                                            : (status?['category_name']) == 'Repair'
                                                            ? AppC.red
                                                            : AppC.trans,
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Utils.getText(
                                                        statusName ?? '',
                                                        size: 16,
                                                        color: AppC.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  InteractiveViewer(
                                                    maxScale: 8.0,
                                                    minScale: 0.01,
                                                    child: CachedNetworkImage(
                                                      imageBuilder: (context, imageProvider) {
                                                        return Container(
                                                          height: MediaQuery.of(context).size.height * 0.3,
                                                          width: MediaQuery.of(context).size.width * 0.8,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: imageProvider,
                                                              fit: BoxFit.fitWidth,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      imageUrl: todos['vehicle_image'] != null
                                                          ? Str.STORAGE_BASE_URL + todos['vehicle_image']
                                                          : (image?['images'] != null &&
                                                          image?['images']?.isNotEmpty
                                                          ? Str.STORAGE_BASE_URL + image!['images'][0]['path']
                                                          : Str.errorImage),
                                                      placeholder: (context, url) =>
                                                          Utils.getProgressIndicator(context),
                                                      errorWidget: (context, url, error) {
                                                        return Container(
                                                          margin: const EdgeInsets.symmetric(vertical: 0),
                                                          padding: const EdgeInsets.all(0),
                                                          alignment: Alignment.center,
                                                          child: Utils.getText("CT",
                                                              size: 22,
                                                              color: AppC.red,
                                                              weight: FontWeight.bold),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        String imageUrl = todos['vehicle_image'] != null
                                                            ? Str.STORAGE_BASE_URL + todos['vehicle_image']
                                                            : (image?['images'] != null && image?['images']?.isNotEmpty
                                                            ? Str.STORAGE_BASE_URL + image!['images'][0]['path']
                                                            : Str.errorImage);
                                                        if (imageUrl.isNotEmpty) {
                                                          String whatsappUrl =
                                                              "https://wa.me/?text=Check out this image: $imageUrl";
                                                          if (await canLaunch(whatsappUrl)) {
                                                            await launch(whatsappUrl);
                                                          } else {
                                                            print("Could not launch WhatsApp");
                                                          }
                                                        } else {
                                                          print("No image URL to share");
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        Assets.whatsAppIcon,
                                                        height: 24,
                                                        width: 24,
                                                      ),
                                                    ),
                                                    const Icon(Icons.rotate_right_outlined),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        String imageUrl = todos['vehicle_image'] != null
                                                            ? Str.STORAGE_BASE_URL + todos['vehicle_image']
                                                            : (image?['images'] != null && image?['images']?.isNotEmpty
                                                            ? Str.STORAGE_BASE_URL + image!['images'][0]['path']
                                                            : '');
                                                        if (imageUrl.isNotEmpty) {
                                                          String subject = Uri.encodeComponent('Check out this image');
                                                          String body = Uri.encodeComponent('Here is an image: $imageUrl');
                                                          final Uri emailUri = Uri(
                                                            scheme: 'mailto',
                                                            queryParameters: {
                                                              'subject': subject,
                                                              'body': body,
                                                            },
                                                          );
                                                          if (await canLaunchUrl(emailUri)) {
                                                            await launchUrl(emailUri,
                                                                mode: LaunchMode.externalApplication);
                                                          } else {
                                                            print("Could not launch email");
                                                          }
                                                        } else {
                                                          print("No image URL to share");
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        Assets.mail,
                                                        height: 24,
                                                        width: 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.5,
                                                child: VehicleHistoryViewUI(
                                                  vin: vinToFind,
                                                  vehicleName: vehicle?['vehicle_name'] ?? '',
                                                  title: todos['title'],
                                                  showHeader: false,
                                                  showSameTask: true, resourceList: resourceList, userGroupList: userGroupList,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child:
                                Icon(
                                  Icons.remove_red_eye,
                                  color: (status?['category_name']) == 'Recon'
                                      ? AppC.black
                                      : (status?['category_name']) == 'Rental'
                                      ? AppC.green
                                      : (status?['category_name']) == 'Repair'
                                      ? AppC.red
                                      : AppC.blue,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                        Stack(
                          children: [
                            Column(mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: todos['parts'].isNotEmpty && todos['parts'] != null,
                                  child: InkWell(
                                      onTapDown: (TapDownDetails? details) {
                                        if (details != null) {
                                          if (selectedPartsList.isEmpty && todos['parts'] != null) {
                                            selectedPartsList.addAll(todos['parts'] ?? '');
                                          }
                                          showMenu(
                                            elevation: 5,
                                            color: AppC.white,
                                            context: context,
                                            constraints: const BoxConstraints.tightFor(width: 300),
                                            position: RelativeRect.fromLTRB(
                                              details.globalPosition.dx,
                                              details.globalPosition.dy,
                                              details.globalPosition.dx,
                                              details.globalPosition.dy,
                                            ),
                                            items: [
                                              PopupMenuItem(
                                                value:selectedPartsList,
                                                child:StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                    return Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                for (var parts in selectedPartsList) {
                                                                  var matchedPart = editPartsList.where((item) => item['id'] == parts['id']).toList();
                                                                  if (matchedPart.isNotEmpty) {
                                                                    for (var res in matchedPart) {
                                                                      Map<String, dynamic> partsData = {
                                                                        'parts_id': res['id'] ?? '',
                                                                        'parts_name': res['name'] ?? '',
                                                                        };
                                                                      if (partsData.isNotEmpty) {
                                                                        partsNameData.add(partsData);
                                                                      }

                                                                    }
                                                                  }
                                                                }
                                                                todos['parts'] = List.from(selectedPartsList);
                                                                  todoBloc?.add(
                                                                    UpdatePartsForItemEvent(
                                                                      todoId: todos['id']!,
                                                                      selectedPartsList: partsNameData,
                                                                    ),
                                                                  );
                                                                Navigator.pop(context);
                                                                setState(() {});
                                                              },
                                                                child: const Icon(
                                                                  Icons.save,
                                                                  color: AppC.green,
                                                                  size: 18,
                                                                  weight: 20,)
                                                            ),
                                                            GestureDetector(
                                                              onTap:(){
                                                                Navigator.pop(context);
                                                              },
                                                                child:const Icon(
                                                                  Icons.close,
                                                                  color: AppC.red,
                                                                  size: 18,
                                                                  weight: 20,
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                        Wrap(
                                                          children: List<Widget>.generate(
                                                            selectedPartsList.length,
                                                            (int idx) {
                                                              return Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                                  child: Chip(
                                                                    onDeleted: () {
                                                                      final partId = selectedPartsList[idx]['id'];
                                                                      todoBloc?.add(DeletePartsEvent(partsId: partId));
                                                                      selectedPartsList.removeAt(idx);
                                                                      todos['parts'] = List.from(selectedPartsList);
                                                                      setState(() {});
                                                                    },
                                                                    deleteIcon: const Icon(
                                                                      Icons.close,
                                                                      color: AppC.red,
                                                                      size: 18,
                                                                    ),
                                                                    side: const BorderSide(color: AppC.trans),
                                                                    backgroundColor: AppC.green.withOpacity(0.3),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(5)),
                                                                    label: Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Utils.getText(
                                                                            selectedPartsList[idx]['parts_name'] ?? selectedPartsList[idx]['name'] ??'',
                                                                            color: AppC.text),
                                                                      ],
                                                                    ),
                                                                  )
                                                              );
                                                            },
                                                          ).toList(),
                                                        ),
                                                        Utils.getTextFormField(
                                                            'Parts',
                                                            editPartsController,
                                                            readOnly: false,
                                                            onChangeCallback: (value) {
                                                              if(value.isNotEmpty) {
                                                                editPartsSuggestionList.clear();
                                                                List<dynamic> partsList = editPartsList /*.map((e) =>'${e.name}').toList()*/;
                                                                editPartsSuggestionList.addAll(Utils.searchObjectList(partsList, value));
                                                                editShowPartsList = editPartsSuggestionList.isNotEmpty;
                                                              } else {
                                                                editShowPartsList = false;
                                                              }
                                                              setState(() {});
                                                              },
                                                            suffixIcon: Visibility(
                                                              visible: editPartsSuggestionList.isEmpty && editPartsController.text.isNotEmpty,
                                                              child: InkWell(
                                                                  onTap: () async {
                                                                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PartViewUI(),));
                                                                    },
                                                                  child: Icon(
                                                                      Icons.add,
                                                                      color: AppC().base,
                                                                      size: 20)
                                                              ),
                                                            ),
                                                        ),
                                                        Visibility(
                                                            visible: editShowPartsList,
                                                            child: Utils.customAutoCompleteWithUnSelectedOption(
                                                                editPartsSuggestionList,
                                                                    (index) {
                                                                  editShowPartsList = false;
                                                                  selectedPartsList.add(editPartsSuggestionList[index]);
                                                                  editPartsController.selection = TextSelection.fromPosition(
                                                                        TextPosition(offset: (editPartsController.text.length)
                                                                        ),
                                                                      );
                                                                  setState(() {});
                                                                  editPartsController.selection =
                                                                      TextSelection.fromPosition(
                                                                        TextPosition(offset: (editPartsController.text.length)
                                                                        ),
                                                                      );
                                                                }
                                                                )
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                      child: Utils.getText(
                                          "P",
                                          weight: FontWeight.bold,
                                          size: 13
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      Stack(
                        children: [
                          Column(mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                  visible: todos['supplies'].isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: GestureDetector(
                                        onTapDown: (TapDownDetails? details) {
                                          if (details != null) {
                                            if (selectedSuppliesList.isEmpty && todos['supplies'] != null) {
                                              selectedSuppliesList.addAll(todos['supplies'] ?? '');
                                            }
                                            showMenu(
                                              color: AppC.white,
                                              context: context,
                                              constraints: const BoxConstraints.tightFor(
                                                  width: 300),
                                              position: RelativeRect.fromLTRB(
                                                details.globalPosition.dx,
                                                details.globalPosition.dy,
                                                details.globalPosition.dx,
                                                details.globalPosition.dy,
                                              ),
                                              items: [
                                                PopupMenuItem(
                                                  child:StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter setState) {
                                                      return Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              GestureDetector(
                                                                  onTap:(){
                                                                    for (var parts in selectedSuppliesList) {
                                                                      var matchedSupplies = editSuppliesList.where((item) => item['id'] == parts['id']).toList();
                                                                      if (matchedSupplies.isNotEmpty) {
                                                                        for (var res in matchedSupplies) {
                                                                          Map<String, dynamic> suppliesData = {
                                                                            'supplies_id': res['id'] ?? '',
                                                                            'supplies_name': res['name'] ?? '',
                                                                          };
                                                                          if (suppliesData.isNotEmpty) {
                                                                            suppliesNameData.add(suppliesData);
                                                                          }
                                                                        }
                                                                      }
                                                                    }
                                                                    todos['supplies'] = List.from(selectedSuppliesList);
                                                                    todoBloc?.add(
                                                                      UpdateSuppliesForItemEvent(
                                                                        todoId: todos['id']!,
                                                                        selectedSupplyList: suppliesNameData,
                                                                      ),
                                                                    );
                                                                    Navigator.pop(context);
                                                                    setState(() {});
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.save,
                                                                    color: AppC.green,
                                                                    size: 18,
                                                                    weight: 20,)
                                                              ),
                                                              GestureDetector(
                                                                  onTap:(){
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child:const Icon(
                                                                    Icons.close,
                                                                    color: AppC.red,
                                                                    size: 18,
                                                                    weight: 20,
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                          Wrap(
                                                            children: List<Widget>.generate(
                                                              selectedSuppliesList.length,
                                                              (int idx) {
                                                                return Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                                  child: Chip(
                                                                    onDeleted: () {
                                                                      final suppliesId = selectedSuppliesList[idx]['id'];
                                                                      todoBloc?.add(DeleteSupplysEvent(suppliesId: suppliesId));
                                                                      selectedSuppliesList.removeAt(idx);
                                                                      todos['supplies'] = List.from(selectedSuppliesList);
                                                                      setState(() {});
                                                                    },

                                                                    deleteIcon: const Icon(
                                                                      Icons.close,
                                                                      color: AppC.red,
                                                                      size: 18,
                                                                    ),
                                                                    side: const BorderSide(color: AppC.trans),
                                                                    backgroundColor: AppC.green.withOpacity(0.3),
                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                    label: Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Utils.getText(
                                                                            selectedSuppliesList[idx]['name'] ?? selectedSuppliesList[idx]['supplies_name']??'',
                                                                            color: AppC.text),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).toList(),
                                                          ),
                                                          Utils.getTextFormField(
                                                              'Supplies',
                                                              editSuppliesController,
                                                              readOnly: false,
                                                              onChangeCallback: (value) {
                                                                if(value.isNotEmpty){
                                                                editSuppliesSuggestionList.clear();
                                                                List<dynamic> supplyList = editSuppliesList /*.map((e) =>'${e.name}').toList()*/;
                                                            editSuppliesSuggestionList.addAll(
                                                                Utils.searchObjectList(supplyList, value)
                                                            );
                                                            editShowSuppliesList = editSuppliesSuggestionList.isNotEmpty;
                                                                }
                                                                else{
                                                                  editShowSuppliesList=false;
                                                                }
                                                            setState(() {});
                                                            },
                                                              suffixIcon: Visibility(
                                                                visible: editSuppliesList.isEmpty && editSuppliesController.text.isNotEmpty,
                                                                child: InkWell(
                                                                    onTap: () async {
                                                                      await Navigator.of(context).push(
                                                                          MaterialPageRoute(
                                                                            builder: (context) => const SuppliesViewUI(),)
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                        Icons.add,
                                                                        color: AppC().base,
                                                                        size: 20)),
                                                              )),
                                                          Visibility(
                                                              visible: editShowSuppliesList,
                                                              child: Utils.customAutoCompleteWithUnSelectedOption(
                                                                  editSuppliesSuggestionList, (index) {
                                                                    editShowSuppliesList = false;
                                                                    selectedSuppliesList.add(editSuppliesSuggestionList[index]);
                                                                    isSelected = true;
                                                                    editSuppliesController.selection =
                                                                        TextSelection.fromPosition(TextPosition(
                                                                              offset: (editSuppliesController.text.length)),
                                                                        );
                                                                    setState(() {});
                                                                    editSuppliesController.selection =
                                                                        TextSelection.fromPosition(TextPosition(
                                                                            offset: (editSuppliesController.text.length)),
                                                                        );
                                                                  })
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                        child: Utils.getText(
                                            "S",
                                            weight: FontWeight.bold,
                                            size: 13)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      Visibility(
                        visible: getAddressFromLocations(todos) != null,
                        child: InkWell(
                            onTap: () {
                              isMultipleAddressEdit = true;
                              selectedMultipleAddressList = [];
                              editMultipleAddressList = [];
                              List<dynamic> jsonList =
                                  json.decode(todos['address'] ?? '');
                              List<dynamic> resultList =
                                  jsonList.cast<dynamic>();
                              editMultipleAddressList.addAll(addresses ?? []);
                              for (Map<String, dynamic> element
                                  in addresses ?? []) {
                                for (dynamic userId in resultList) {
                                  if (userId.toString() ==
                                      element['id'].toString()) {
                                    isSelected = true;
                                    // Map<String, dynamic> suppliesData = Addresses(
                                    //     address: element['address'],
                                    //     deleteId: element['id'],
                                    //     id: element['id'],
                                    //     isSelected:isSelected,
                                    //     locationId: element['location_id']);
                                    selectedMultipleAddressList.add({
                                      'address': element['address'],
                                      'id': element['id'],
                                      'location_id': element['location_id']
                                    });
                                  }
                                }
                              }
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                if (isValid)
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                // Utils.getText('1', size: 12, color: Colors.red),
                              ],
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            InkWell(
                                onTapDown: (TapDownDetails? details) async {
                                  if (details != null) {
                                    await showMenu(
                                      elevation: 5,
                                      color: AppC.white,
                                      context: context,
                                      constraints:
                                      const BoxConstraints.tightFor(
                                          height: 50,
                                          width: 300),
                                      position: RelativeRect.fromLTRB(
                                        details.globalPosition.dx,
                                        details.globalPosition.dy,
                                        details.globalPosition.dx,
                                        details.globalPosition.dy,
                                      ),
                                      items: [
                                        PopupMenuItem(
                                          height:40,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: AutoCompleteWidget().getAutoComplete(
                                                    context,
                                                    vendorList.map((e) => e['name'] ?? '')
                                                        .toList() + locationList
                                                        .map((e) => e['name'] ?? '')
                                                        .toList(),
                                                    onSelectionCallBack: (value) {
                                                      isVendorEdit = !isVendorEdit;
                                                      setState(() {});
                                                      int? vendorId;
                                                      int? locationId;
                                                      String? vendorName;
                                                      String? locationName;
                                                      for (Map<String, dynamic> res in vendorList) {
                                                        if ('${res['name']}' == value) {
                                                          vendorName = res['name'];
                                                          vendorId = res['id']!;
                                                        }
                                                      }
                                                      if (vendorId == null) {
                                                        for (Map<String,dynamic> veh in locationList) {
                                                          if (veh['name'] == value) {
                                                            locationName = veh['name'];
                                                            locationId = veh['id']!;
                                                          }
                                                        }
                                                      }
                                                      todoBloc!.add(EditTodoVendorLocation(
                                                          todos['id']!,
                                                          vendorName,
                                                          locationName,
                                                          locationId,
                                                          vendorId));
                                                      return value;
                                                      }, fieldViewBuilderL: (
                                                        context,
                                                        vendorController,
                                                        focusNode,
                                                        voidCallback) {
                                                      vendorController.text = todos['vendor_name'] != null &&
                                                          todos['vendor_name'] != 'null'
                                                          ? '${todos['vendor_name']}'
                                                          : todos['location'] != null &&
                                                          todos['location'] != 'null'
                                                          ? '${todos['location']}'
                                                          : '';
                                                      return AutoCompleteWidget().sample(
                                                          context,
                                                          vendorController,
                                                          focusNode,
                                                          (value) {});
                                                    }
                                                    ),
                                              ),
                                              const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                                child: Utils.getText(
                                    todos['vendor_name'] != null &&
                                            todos['vendor_name'] != 'null'
                                        ? '${todos['vendor_name']}'
                                        : todos['location'] != null &&
                                                todos['location'] != 'null'
                                            ? '${todos['location']}'
                                            : '')),
                            if (todos['vendor_name'] != null)
                              const SizedBox(
                              width: 10,
                            ),
                              Visibility(
                                visible: todos['vendor_name'] != null,
                                child: GestureDetector(
                                  onTap: () {
                                    vendor = vendorList.firstWhere(
                                      (vendor) =>
                                          vendor['id'].toString() ==
                                          todos['vendor_id']
                                              .toString(), // Convert both to String or both to int
                                      orElse: () => {},
                                    );
                                    showMenu(
                                      context: context,
                                      surfaceTintColor: AppC.white,
                                      color: AppC.white,
                                      elevation: 20,
                                      shadowColor: AppC.grey,
                                      position: const RelativeRect.fromLTRB(
                                          0, 76, 0, 0),
                                      constraints: const BoxConstraints.tightFor(
                                          width: 500),
                                      items: [
                                        PopupMenuItem(
                                          value: 'Option1',
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Utils.getText('Vendor Info',
                                                      size: 16,
                                                      weight: FontWeight.bold),
                                                  const Icon(Icons.close)
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black12
                                                            .withOpacity(0.4),
                                                        width:
                                                            1), // Border with accent color
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 12),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        _buildInfoRow(
                                                            'Name',
                                                            (vendor['name'] ?? '')
                                                                .toString(),
                                                            icon:
                                                                Icons.person_pin),
                                                        Divider(
                                                          thickness: 1,
                                                          color: Colors.black12
                                                              .withOpacity(0.4),
                                                        ), // Divider between rows
                                                        _buildInfoRow(
                                                            'Vendor Type',
                                                            (vendor['vendor_type']
                                                                        ?[
                                                                        'name'] ??
                                                                    '')
                                                                .toString(),
                                                            icon: Icons
                                                                .person_outlined),
                                                        Divider(
                                                          thickness: 1,
                                                          color: Colors.black12
                                                              .withOpacity(0.4),
                                                        ),
                                                        _buildInfoRow(
                                                            'Phone',
                                                            (vendor['phone'] ??
                                                                    '')
                                                                .toString(),
                                                            icon: Icons.phone),
                                                        Divider(
                                                          thickness: 1,
                                                          color: Colors.black12
                                                              .withOpacity(0.4),
                                                        ),
                                                        _buildInfoRow(
                                                            'Address',
                                                            (vendor['address'] ??
                                                                    '')
                                                                .toString(),
                                                            icon: Icons
                                                                .location_on_outlined),
                                                        Divider(
                                                          thickness: 1,
                                                          color: Colors.black12
                                                              .withOpacity(0.4),
                                                        ),
                                                        _buildInfoRow(
                                                            'Expertise',
                                                            (vendor['expertise'] ??
                                                                    '')
                                                                .toString(),
                                                            icon: Icons
                                                                .manage_accounts_outlined),
                                                        Divider(
                                                          thickness: 1,
                                                          color: Colors.black12
                                                              .withOpacity(0.4),
                                                        ),
                                                        _buildInfoRow(
                                                            'Description',
                                                            (vendor['description'] ??
                                                                    '')
                                                                .toString(),
                                                            icon: Icons
                                                                .description),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  child: const Icon(
                                    Icons.info,
                                    size: 14,
                                    color: Colors
                                        .blue, // Replace with AppC.appColor if defined
                                  ),
                                ),
                              ),
                            if (todos['vendor_name'] != null)
                              const SizedBox(width: 5,),
                              Expanded(
                              child: Visibility(
                                visible: notesController.text.isNotEmpty ||
                                    (todos['notes'] != null &&
                                        todos['notes']!.isNotEmpty &&
                                        todos['notes'] != 'null'),
                                child: InkWell(
                                  onTapDown: (TapDownDetails? details) async {
                                    notesController.text =
                                        stripHtmlTags(todos['notes'] ?? '');
                                    if (details != null) {
                                      await showMenu(
                                        elevation: 5,
                                        color: AppC.white,
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                          details.globalPosition.dx,
                                          details.globalPosition.dy,
                                          details.globalPosition.dx,
                                          details.globalPosition.dy,
                                        ),
                                        items: [
                                          PopupMenuItem(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8, // Example width
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Utils.getBorderedMultilineTextField(
                                                            'notes',
                                                            notesController,
                                                            minLines: 2,
                                                            fillColor:
                                                                AppC.white),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          todoBloc?.add(
                                                              EditTodoDate(
                                                            null,
                                                            null,
                                                            todos['id']
                                                                .toString(),
                                                            null,
                                                            null,
                                                            null,
                                                            notesController
                                                                .text,
                                                            null,
                                                            null,
                                                          ));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Icon(
                                                          Icons.save,
                                                          color: AppC.green,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.close,
                                                        color: AppC.red,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                  child: Utils.getText(
                                    todos['notes'] != null &&
                                            todos['notes'] != 'null'
                                        ? ' (${stripHtmlTags(todos['notes'] ?? '')}) '
                                        : '',
                                    overFlow: TextOverflow.ellipsis,
                                    size: 12,
                                    color: AppC().base,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Visibility(
                            visible: isNotesEdit,
                            child: Row(
                              children: [
                                Visibility(
                                  visible: notesController.text.isNotEmpty,
                                  child: InkWell(
                                    onTap: () {
                                      todoBloc!.add(EditTodoDate(
                                          null,
                                          null,
                                          todos['id'].toString(),
                                          null,
                                          null,
                                          null,
                                          notesController.text,
                                          null,
                                          null));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(0)),
                                          border: Border.all(
                                              color: AppC
                                                  .fieldBase /*, width: 0.2*/)),
                                      child: Icon(
                                        Icons.check,
                                        color: AppC().base,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    isNotesEdit = false;
                                    notesController.clear();
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(0)),
                                        border: Border.all(
                                            color: AppC
                                                .fieldBase /*, width: 0.2*/)),
                                    child: const Icon(
                                      Icons.clear_rounded,
                                      color: AppC.red,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTapDown: (TapDownDetails? details) async {
                          if (details != null) {
                            setState(() {
                              final dynamic userId = todos['users']?['id'];
                              final dynamic userGroupId =
                                  todos['user_group_id'];
                              selectedIndices = <int>{};
                              if (userId != null) {
                                selectedIndices.addAll(resourceList
                                    .asMap()
                                    .entries
                                    .where((entry) => entry.value['id'] == userId)
                                    .map((entry) => entry.key));
                              }
                              if (userGroupId != null) {
                                selectedIndices.addAll(userGroupList
                                    .asMap()
                                    .entries
                                    .where((entry) {
                                  final groupId = entry.value['id'];
                                  final userIds = entry.value['userId'];
                                  return groupId == userGroupId &&
                                      userIds != null &&
                                      userIds.isNotEmpty;
                                }).expand((entry) {
                                  final userIds = entry.value['userId'];
                                  return resourceList
                                      .asMap()
                                      .entries
                                      .where((resEntry) => userIds.contains(
                                          resEntry.value['id'].toString()))
                                      .map((resEntry) => resEntry.key);
                                }));
                              }
                            });
                            await showMenu(
                              elevation: 5,
                              color: Colors.white,
                              context: context,
                              position: RelativeRect.fromLTRB(
                                details.globalPosition.dx,
                                details.globalPosition.dy,
                                details.globalPosition.dx,
                                details.globalPosition.dy,
                              ),
                              items: [
                                PopupMenuItem(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 140,
                                    height: 200,
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      List<String?>?
                                                          selectedResourceIdList =
                                                          selectedIndices.map(
                                                                  (index) => resourceList[index]['id']).where(
                                                                  (id) => id != null
                                                                      && id != -1
                                                                      && id != 0)
                                                              .map((id) => id.toString())
                                                              .toList();
                                                      int? selectedResourceId;
                                                      if (selectedResourceIdList.length == 1) {
                                                        selectedResourceId =
                                                            int.tryParse(
                                                                selectedResourceIdList[0] ?? '0'
                                                            );
                                                        selectedResourceIdList = null;
                                                      }
                                                      if ((selectedResourceId != null &&
                                                          selectedResourceId != 0) ||
                                                          (selectedResourceIdList != null &&
                                                              selectedResourceIdList.isNotEmpty)) {
                                                        todoBloc!.add(EditTodoDate(
                                                          null,
                                                          null,
                                                          todos['id'].toString(),
                                                          null,
                                                          selectedResourceId,
                                                          selectedResourceIdList,
                                                          null,
                                                          null,
                                                          null,
                                                        ));
                                                      } else {
                                                        Utils.showMobileToast(
                                                          Str.createTodoAlertText(
                                                              'Selecting Resource'),
                                                        );
                                                      }
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Icon(
                                                      Icons.save,
                                                      color: Colors.green,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: resourceList.length,
                                                itemBuilder: (context, index) {
                                                  final user =
                                                      resourceList[index];
                                                  final isSelected =
                                                      selectedIndices.contains(index);
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (isSelected) {
                                                          selectedIndices
                                                              .remove(index);
                                                        } else {
                                                          selectedIndices.add(index);
                                                        }
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5.0),
                                                      child: Container(
                                                        color: isSelected
                                                            ? Colors.blue
                                                            : Colors
                                                                .transparent,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 4.0,
                                                        ),
                                                        child: Utils.getText(
                                                          '${user['first_name'] ?? '...'} ${user['last_name'] ?? ''}',
                                                          size: 12,
                                                          weight:
                                                              FontWeight.bold,
                                                          color: isSelected
                                                              ? AppC.white
                                                              : AppC.appColor,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                        child: Visibility(
                          visible: todos['users'] != null ||
                              todos['user_group_id'] != null,
                          child: getUserGroupDataById(todos),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getUserGroupList(Map<String, dynamic> todos) async {
    resourceList.where((element) => isSelected = false).toList();
    if (todos['users'] != null) {
      selectedUserGroupOrUser = [];
      for (Map<String, dynamic> res in resourceList) {
        if (todos['users']!['id'].toString() == res['id'].toString()) {
          isSelected = true;
          selectedUserGroupOrUser!.add(res);
        } else {
          isSelected = false;
          selectedUserGroupOrUser!.add(res);
        }
      }
    } else {
      for (Map<String, dynamic> u in userGroupList) {
        if (u['id'] == todos['user_group_id']) {
          List<dynamic> jsonList = json.decode(u['userId'] ?? '');
          List<dynamic> resultList = jsonList.cast<dynamic>();
          selectedUserGroupOrUser = [];
          for (Map<String, dynamic> res in resourceList) {
            for (dynamic userId in resultList) {
              if (userId.toString() == res['id'].toString()) {
                isSelected = true;
              } else {
                // res.isSelected = false;
              }
            }
            selectedUserGroupOrUser!.add(res);
          }
        }
      }
    }
    if (selectedUserGroupOrUser == null || selectedUserGroupOrUser!.isEmpty) {
      resourceList.where((element) => isSelected = false).toList();
      selectedUserGroupOrUser = [];
      (selectedUserGroupOrUser ?? []).addAll(resourceList);
    }
  }

  Widget getUserGroupDataById(Map<String, dynamic> todos) {
    if (todos['users'] != null) {
      // todos.selectedUserGroupOrUser = [];
      for (Map<String, dynamic> res in resourceList) {
        if (todos['users']!['id']!.toString() == res['id'].toString()) {
          isSelected = true;
          // todos.selectedUserGroupOrUser!.add(res);
        } else {
          isSelected = false;
          // todos.selectedUserGroupOrUser!.add(res);
        }
      }
      userShortName = '${todos['users']?['first_name']?[0].toUpperCase()}'
          '${todos['users']?['last_name']?[0].toUpperCase()}';
      return Utils.getText(userShortName ?? '',
          color: AppC().base, weight: FontWeight.w900);
    } else {
      userGroupConcatenationName = '';
      for (Map<String, dynamic> u in userGroupList) {
        if (u['id'] == todos['user_group_id']) {
          List<dynamic> jsonList = json.decode(u['userId'] ?? '');
          List<dynamic> resultList = jsonList.cast<dynamic>();
          // todos.selectedUserGroupOrUser = [];
          for (Map<String, dynamic> res in resourceList) {
            for (dynamic userId in resultList) {
              if (userId.toString() == res['id'].toString()) {
                isSelected = true;

                if (resultList.length > 1) {
                  final displayNames =
                      '${userGroupConcatenationName ?? ''}${res['first_name']?[0].toUpperCase()}${res['last_name']?[0].toUpperCase()}, ';

                  return Utils.getText('$displayNames...',
                      color: AppC().base, weight: FontWeight.bold);
                } else {
                  userGroupConcatenationName =
                      '${userGroupConcatenationName ?? ''}${res['first_name']?[0].toUpperCase()}${res['last_name']?[0].toUpperCase()}, ';
                }
              } else {}
            }
            // todos.selectedUserGroupOrUser!.add(res);
          }
        }
      }
      return Utils.getText((userGroupConcatenationName ?? ''),
          color: AppC().base, weight: FontWeight.bold);
    }
  }

  String? getVehicleText(Map<String, dynamic> todos) {
    if (todos['vehicles'] is List && todos['vehicles']!.isNotEmpty) {
      if (todos['vehicles'].length > 1) {
        // If there are two or more vehicles in the list, return 'MV'
        return 'MV';
      } else if (todos['vehicles'].length == 1) {
        // If there is only one vehicle in the list, return its name
        return '${todos['vehicles'][0]['vehicle_name']}';
      }
    } else if (todos['vehicle_name'] != null &&
        todos['vehicle_name'] != 'null') {
      return '${todos['vehicle_name']}';
    } else if (todos['person'] != null && todos['person'] != 'null') {
      return '${todos['person']}  ';
    } else if (todos['vehicle_group_id'] != null &&
        todos['vehicle_group_id'] != 0) {
      if (vehicleGroupList.isNotEmpty) {
        for (Map<String, dynamic> v in vehicleGroupList) {
          if (v['id'] == todos['vehicle_group_id']) {
            return '${v['name']}  ';
          }
        }
        return '';
      } else {
        return null /*getVehicleText(todos)*/;
      }
    } else {
      return null;
    }
    return null;
  }

  String? getPartsText(Map<String, dynamic> todos) {
    if (todos['parts'] is List && todos['parts']!.isNotEmpty) {
        return 'P';
    } else {
      return null;
    }
  }

  String? getSuppliesText(Map<String, dynamic> todos) {
    if (todos['supplies'] is List && todos['supplies']!.isNotEmpty) {
      return 'S';
    } else {
      return null;
    }
  }

  filterResource(Map<String, dynamic>? resource, {bool fromOnchange = true}) {
    todoBloc!.add(GetTodoList(
      selectedDate: filterDate,
      status: statusFilter ? "Completed" : "In Progress",
      resourceId: Utils.getStringFromObjectList([resource]),
      branchId: branchNO.toString(),
    ));
  }

  Widget addressWidgetUI(Map<String, dynamic> todos) {
    return Column(
      children: [
        Container(
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
              Wrap(
                children: List<Widget>.generate(
                  selectedMultipleAddressList.length,
                  (int idx) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 2),
                        child: Chip(
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          onDeleted: () {
                            for (var element in editMultipleAddressList) {
                              if (element['id'] ==
                                  selectedMultipleAddressList[idx]['id']) {
                                isSelected = false;
                                // return;
                              }
                            }
                            int deleteId = 0;
                            if (deleteId != 0) {
                              deleteId = deleteId;
                            }
                            Map<String, dynamic>? supplyObj;
                            for (Map<String, dynamic> s in addresses!) {
                              if (s['id'] ==
                                  selectedMultipleAddressList[idx]['id']) {
                                supplyObj = s;
                                // return;
                              }
                            }
                            if (supplyObj != null) {
                              addresses!.remove(supplyObj);
                            }
                            selectedMultipleAddressList.removeAt(idx);
                            if (deleteId != 0) {
                              todoBloc!.add(
                                EditTodoDate(
                                    null,
                                    null,
                                    todos['id'].toString(),
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    selectedMultipleAddressList
                                        .map((e) => deleteId)
                                        .toList()),
                              );
                              // todoBloc!.add(DeletePartsOrSupplyEvent(deleteId, 'address'));
                            }
                            setState(() {});
                          },
                          deleteIcon: const Icon(
                            Icons.close,
                            color: AppC.red,
                            size: 18,
                          ),
                          backgroundColor:
                              AppC().bottomIconColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          // side: BorderSide(),
                          label: Utils.getText(
                              selectedMultipleAddressList[idx]['address'] ?? '',
                              color: AppC.text,
                              size: 13),
                        ));
                  },
                ).toList(),
              ),
              const SizedBox(height: 5),
              Utils.getTextFormField(
                  'Address', editMultipleAddressController,
                  label: Utils.getText('Address'),
                  readOnly: false, onChangeCallback: (value) {
                editMultipleAddressSuggestionList.clear();
                List<Map<String, dynamic>> supplyList =
                    editMultipleAddressList /*.map((e) =>'${e.name}').toList()*/;
                editMultipleAddressSuggestionList.addAll(
                    Utils.searchObjectList(supplyList, value, isAddress: true));
                editShowMultipleAddressList =
                    editMultipleAddressSuggestionList.isNotEmpty;
                setState(() {});
              },
                  suffixIcon: Visibility(
                    visible: !editShowMultipleAddressList,
                    child: InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LocationViewUI(),
                          ));
                        },
                        child: Icon(Icons.add, color: AppC().base, size: 20)),
                  )),
            ],
          ),
        ),
        Visibility(
            visible: editShowMultipleAddressList,
            child: Utils.customAutoCompleteWithUnSelectedOption(
                editMultipleAddressSuggestionList, (index) {
              editShowMultipleAddressList = false;
              // countHyphens('');
              // editPartsController.text = editPartsSuggestionList[index] ?? '';
              selectedMultipleAddressList
                  .add(editMultipleAddressSuggestionList[index]);
              editMultipleAddressSuggestionList[index].isSelected = true;
              editMultipleAddressController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: (editMultipleAddressController.text.length)),
              );
              setState(() {});
              editMultipleAddressController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: (editMultipleAddressController.text.length)),
              );
            }, isAddress: true)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Column(
            children: [
              Icon(icon, color: Colors.blueAccent[100], size: 20),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText(label, weight: FontWeight.w900, size: 12),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label=='Address'?
                GestureDetector(
                  onTap:()async {
                    final Uri mapsUri = Uri(
                      scheme: 'https',
                      host: 'www.google.com',
                      path: '/maps/search/${vendor['address']}',
                      queryParameters: {'q': value},
                    );

                    if (await canLaunchUrl(mapsUri)) {
                      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not open the map.';
                    }
                  },
                  child: Utils.getText(
                    value,
                    color:AppC.appColor ,
                    weight: FontWeight.bold,
                    size: 12,
                  ),
                ):Utils.getText(
                  value,
                  color:AppC.text,
                  weight: FontWeight.bold,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showOilCheckPopup(BuildContext context,
      TextEditingController oilChangeOdometerController,
      TextEditingController nextMilesCheckController,
      TextEditingController nextOdometerController,
      List<Map<String, dynamic>> taskMiles,
      Map<String, dynamic> todos,
      dynamic previousOdometer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("PREVIOUS ODOMETER----$previousOdometer");

        final data = taskMiles.firstWhere(
              (data) => data['identifier_id'] == todos['identifier_id'],
          orElse: () => {}, // Ensure it returns an empty map to avoid null issues
        );

        if (data.isNotEmpty) {
          nextMilesCheckController.text = data['miles'].toString();
        } else {
          nextMilesCheckController.text = '';
        }

        nextOdometerController.text = nextOdometerController.text = ((double.tryParse(oilChangeOdometerController.text.toString()) ?? 0) + ((double.tryParse(nextMilesCheckController.text.toString()) ?? 0))).toString();

        nextMilesCheckController.addListener(() => nextOdometerController.text = ((double.tryParse(oilChangeOdometerController.text.toString()) ?? 0) + ((double.tryParse(nextMilesCheckController.text.toString()) ?? 0))).toString());
        oilChangeOdometerController.addListener(() => nextOdometerController.text = ((double.tryParse(oilChangeOdometerController.text.toString()) ?? 0) + ((double.tryParse(nextMilesCheckController.text.toString()) ?? 0))).toString());

        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      ),
                    ),
                    Text.rich(TextSpan(
                        text: "Previous Oil Change Odometer : ",
                        children: [
                          TextSpan(text: "$previousOdometer", style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900))
                        ]
                    ), style: context.textTheme.labelLarge,),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Utils.getText(
                            'Oil Change Odometer',
                            weight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Utils.getText(
                            'Next Miles Check',
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Utils.getTextFormField(
                              'Oil Change Odometer',
                              autoValidate: AutovalidateMode.always,
                              oilChangeOdometerController,
                              textType: TextInputType.number,
                              inputAction: TextInputAction.next,
                            validator: (val) => (double.tryParse(val.toString()) ?? 0) < (double.tryParse(previousOdometer.toString()) ?? 0) ? "Cannot enter lower than previous oil change odometer" : null,
                          ),
                        ),
                        Expanded(
                          child: Utils.getTextFormField(
                              'Next Miles Check',
                              nextMilesCheckController,
                              textType: TextInputType.number,
                              inputAction: TextInputAction.done
                          ),
                        ),
                      ],
                    ),
                    Utils.getText('Next Odometer', weight: FontWeight.bold),
                    Utils.getTextFormField('Next Odometer', nextOdometerController, readOnly: true),
                    Utils.getAddFilledButton('Submit', () {}, bgColor: AppC.green),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      oilChangeOdometerController.clear();
      nextMilesCheckController.clear();
      nextOdometerController.clear();
    });
  }


  List<Map<String, dynamic>>? getAddressFromLocations(Map<String, dynamic> todos) {
    for (int i = 0; i < multipleLocationAddressList.length; i++) {
      if (todos['location_id'] != null &&
          multipleLocationAddressList[i]['id'] ==
              int.parse(todos['location_id']!)) {
        addresses = [];
        List<Map<String, dynamic>> parsedAddresses =
            (multipleLocationAddressList[i]['addresses'] as List<dynamic>)
                .cast<Map<String, dynamic>>();
        addresses!.addAll(parsedAddresses);
        return addresses;
      }
    }
    return null;
  }
}
