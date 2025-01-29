
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/vehicle_expense_edit_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_edit_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_view_ui.dart';
import 'package:fairpytasker/UI/dialog/delete_permission_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fairpytasker/Response/create_expense_field_data.dart';
import 'package:fairpytasker/Response/create_todo_params.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/supplies_view_ui.dart';
import 'package:fairpytasker/UI/Todo/add_todo_ui.dart';
import 'package:fairpytasker/Utilities/priority_data.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart' as vdb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fairpytasker/Utilities/image_pick_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../Bloc/vehicle_data_bloc.dart';
import '../../Component/bottom_nav_for_task.dart';
import '../../Response/create_vehicle_data.dart';
import '../../Response/todo_list_response.dart';
import '../Manage Custom Data/Location/location_view_ui.dart';
import '../Manage Custom Data/Parts/part_view_ui.dart';
import '../Manage Custom Data/Task/task_view_ui.dart';
import '../Manage Custom Data/Vendor/vendor_view_ui.dart';
import '../Manage Employees/Employees/employees_view_ui.dart';
import '../Vehicle/vehicle_history_module_ui.dart';
import '../Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import '../maintenance_check_list_ui.dart';

class EditTodoUI extends StatefulWidget {
  final Map<String, dynamic> todoItem;
  final List<Map<String, dynamic>>? userGroupList;
  final List<Map<String, dynamic>>? resourceList;
  final List<Map<String, dynamic>>? categoriesListData;
  final List<Map<String, dynamic>>? addressesList;
  final List<Map<String, dynamic>>? multipleLocationList;

  const EditTodoUI(
      {Key? key,
      required this.todoItem,
      this.userGroupList,
      this.resourceList,
      this.categoriesListData,
      this.addressesList,
      this.multipleLocationList})
      : super(key: key);

  @override
  State<EditTodoUI> createState() => _EditTodoUIState();
}

class _EditTodoUIState extends State<EditTodoUI> {

  TodoViewBloc? todoBloc;
  vdb.VehicleDataBloc? vehicleDataBloc;
  CreateExpenseFieldData? createExpenseFieldData;

  CreateTodoParams createTodoParamForVHistory = CreateTodoParams();
  TodoListRepo todoListRepo = TodoListRepo();
  TodoListRepo editTodoListRepo = TodoListRepo();

  MonthsPojo? selectedMonth = MonthsPojo();
  final ValueNotifier<bool> onNotifyUser = ValueNotifier(false);
  ImagePickHelper imagePickHelper = ImagePickHelper();
  Color appBarColor = AppC.lowP;
  Color? textColors;
  OverlayEntry? overlay;

  List<DaysPojo> daysPojoList = [];
  List<MonthsPojo> monthsPojoList = [];

  DateTime? selectedDate = DateTime.now();
  DateTime? editSelectedDate = DateTime.now();
  DateTime? endSelectedDate = DateTime.now();
  DateTime? modifiedDateTime;

  final GlobalKey _key = GlobalKey();
  final GlobalKey key = GlobalKey();

  List<dynamic> todoSelectedItem = [];
  List<dynamic> imagePath = [];
  List<dynamic> editSuppliesSuggestionList = [];
  List<dynamic> editMultipleAddressSuggestionList = [];
  List<dynamic> editPartsSuggestionList = [];
  List<dynamic> tireImageFile = [];
  List<dynamic> tollImage = [];
  List<dynamic> uploadRegSticker = [];
  List<dynamic> insuranceImage = [];
  List<dynamic> selectedMultipleVehicleList = [];
  List<dynamic> editMultipleVehicleSuggestionList = [];

  List<Map<String, dynamic>> vehicleGroupList = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> editPartsList = [];
  List<Map<String, dynamic>> selectedAssignedTo = [];
  List<Map<String, dynamic>> selectedPartsList = [];
  List<Map<String, dynamic>> resourceList = [];
  List<Map<String, dynamic>> resourceListForCombination = [];
  List<Map<String, dynamic>> selectedSuppliesList = [];
  List<Map<String, dynamic>> editMultipleAddressList = [];
  List<Map<String, dynamic>> selectedMultipleAddressList = [];
  List<Map<String, dynamic>> todoImages = [];
  List<Map<String, dynamic>> editSuppliesList = [];
  List<Map<String, dynamic>> attachmentImage = [];
  List<Map<String, dynamic>> vendorList = [];
  List<Map<String, dynamic>> taskExpenseList = [];
  List<Map<String, dynamic>> locationList = [];
  List<Map<String, dynamic>> todoList = [];
  List<Map<String, dynamic>> cohortsData = [];
  List<Map<String, dynamic>> categoriesData = [];
  List<Map<String, dynamic>> subCategoriesData = [];
  List<Map<String, dynamic>>? addresses;
  List<Map<String, dynamic>>? vehicleLists;
  List<Map<String, dynamic>>? selectedUserGroupOrUser;
  List<Map<String, dynamic>>? vehicleGroupLists;
  List<Map<String, dynamic>> vehicleName=[];
  List<Map<String, dynamic>> editMultipleVehicleList = [];
  List<Map<String, dynamic>> checkListData = [];
  List<Map<String, dynamic>> userGroupList = [];
  List<Map<String, dynamic>> maintenanceCheckListData = [];
  List<Map<String, dynamic>> childrenData = [];

  List<int?>? selectedResourceIdList;

  List<String> vinList=[];
  List<String?>?selectedResourceList;
  List<String> vendorLocationSuggestionList = [];
  List<String> taskIdentifierSuggestionList = [];
  List<String> vehiclePersonSuggestionList = [];
  List<String>? vehicleGroupVinNumbersList;
  static List<String> stringArr = [];

  List<String> priorityList = ['High - On Time', 'Medium', 'Low', 'Feature'];
  List<String> repeatList = ["Doesn't repeat", 'Daily', 'Weekly', 'Monthly', 'Yearly'];
  List<String> daysList = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  List<String> monthsList = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  List<Map<String, dynamic>> customTaskOptions = [
    { 'id': "1", 'label': "Custom Link" },
    { 'id': "2", 'label': "Turo Reservation ID" },
    { 'id': "3", 'label': "Getaround ReservationID"},
  ];
  List<Map<String, dynamic>> sentiments = [
    {'name':'Positive'},
    {'name':'Neutral'},
    {'name':'Negative'}
  ];

  bool showMore = false;
  bool completeAllDay = false;
  bool allDay = false;
  bool editAllDay = false;
  bool reminder = false;
  bool editReminder = false;
  bool showDaily = false;
  bool showMonthly = false;
  bool showWeekly = false;
  bool showYearly = false;
  bool showList = false;
  bool showVehiclePersonList = false;
  bool showVendorLocationList = false;
  bool editShowList = false;
  bool editShowVehiclePersonList = false;
  bool editShowVendorLocationList = false;
  bool editShowPartsList = false;
  bool isVehiclePresented = false;
  bool editShowSuppliesList = false;
  bool? isVehicleEdit;
  bool? isPartsEdit;
  bool? isSupplyEdit;
  bool? isMultipleVehicleEdit;
  bool? isMultipleAddressEdit;
  bool? isVendorEdit;
  bool? isVehicleGroupEdit;
  bool? isNotesEdit;
  bool? isSelected = false;
  bool? partIsSelected = false;
  bool? suppliesIsSelected = false;
  bool showContainer = false;
  bool tollTags = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  bool lastSelectedIsPerson = false;
  bool bouncie = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool editShowMultipleVehicleList = false;
  bool? isVehicleSelected = false;
  bool editShowMultipleAddressList = false;
  bool showAutoComplete = false;
  bool endDateSwitch = true;
  bool occurrenceDate = true;
  bool isShowVehicleHistoryList = false;
  bool timeSensitive = false;

  Set<int> selectedResources = {};

  Map<String, dynamic> vehicle={};
  Map<String, dynamic> setVehicleList={};
  Map<String, String> taskNameList = {};
  Map<String,dynamic>? carName;
  Map<String, dynamic>? selectedResource;
  late Map<String, dynamic> todoItem;

  dynamic existingExpenseDate;
  dynamic selectedCohort;
  dynamic selectedVehicle;
  dynamic selectedExpenseCategories;
  dynamic selectedExpenseSubCategories;
  dynamic selectedLink;
  dynamic selectedVin;
  dynamic selectedSentiments;

  String? selectedPriority;
  String? editSelectedPriority;
  String? selectedRepeat;
  String appBarTitle = 'Edit Todo';
  String? selectedMultipleAddressId;
  String endDateModuleString = "End Date";
  String expenseIds = '';
  String editedExpenseId = '';
  String? userGroupConcatenationName;
  String? userShortName;
  String? vehicleGroupName;
  String? vinToFind;
  String? vin;
  String? vehicleGroupVinNumbers;
  String lastEditedId = '';

  late int partId;
  int? suppliesId;
  int position = 0;
  int count = 0;
  int cursorPosition = 0;
  int? showExpenseTab;
  int? selectedResourceId;
  int expenseIdsCount = 0;
  int? editedExpenseIdsLength;
  int? vehicleGroupId;
  int? deleteId;

  final FocusNode searchFocusNode = FocusNode();

  PageController pageController=PageController();

  TextEditingController searchController = TextEditingController();
  TextEditingController editTodoDateController = TextEditingController();
  TextEditingController editTodoNameController = TextEditingController();
  TextEditingController editVehiclePersonController = TextEditingController();
  TextEditingController editVendorLocationController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController editPartsController = TextEditingController();
  TextEditingController todoDateController = TextEditingController();
  TextEditingController todoTimeController = TextEditingController();
  TextEditingController todoNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController expenseDescriptionController = TextEditingController();
  TextEditingController odometerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController spareTireController = TextEditingController();
  TextEditingController tollTagsController = TextEditingController();
  TextEditingController insuranceAgentController = TextEditingController();
  TextEditingController insuranceCostController = TextEditingController();
  TextEditingController taskIdentifierController = TextEditingController();
  TextEditingController vehiclePersonController = TextEditingController();
  TextEditingController vendorLocationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController oilGradeController = TextEditingController();
  TextEditingController frontTireController = TextEditingController();
  TextEditingController rearTireController = TextEditingController();
  TextEditingController renewalDateController = TextEditingController();
  TextEditingController editSuppliesController = TextEditingController();
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
  TextEditingController reasonController = TextEditingController();



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

  String getEditedExpenseId(String expenseId) {
    List<String> idList =
        expenseId.replaceAll('[', '').replaceAll(']', '').split(',');
    if (idList.isNotEmpty) {
      editedExpenseIdsLength = idList.length;
      return idList[0];
    }
    return expenseId;
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
            print(selectedUserGroupOrUser);
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
    //log("$todos", name: "TODO_S");
    String getInitials(String? firstName, String? lastName) {
      return '${firstName?[0].toUpperCase() ?? ''}${lastName?[0].toUpperCase() ?? ''}';
    }
    if (todos['users'] != null) {
      String userShortName = getInitials(
        todos['users']?['first_name'],
        todos['users']?['last_name'],
      );

      return Utils.getText(
        userShortName,
        color: AppC().base,
        weight: FontWeight.bold,
      );
    } else {
      String userGroupConcatenationName = '';
      List<String> userInitials = [];

      for (Map<String, dynamic> group in userGroupList) {
        if (group['id'] == todos['user_group_id']) {
          List<dynamic> userList = [];
          try {
            userList = json.decode(group['userId'] ?? '[]');
          } catch (_) {continue;}

          for (Map<String, dynamic> res in resourceList) {
            if (userList.contains(res['id'])) {
              String initials = getInitials(
                res['first_name'],
                res['last_name'],
              );
              userInitials.add(initials);
            }
          }
          break;
        }
      }
      if (userInitials.isNotEmpty) {
        userGroupConcatenationName = userInitials.join(',\n');
      }
      return Utils.getText(
        userGroupConcatenationName,
        color: AppC().base,
        weight: FontWeight.bold,
      );
    }
  }

  Widget getUserGroupDataById2(List<dynamic> todos) {
    //log("$todos", name: "TODO_S");
    String getInitials(String? firstName, String? lastName) {
      return '${firstName?[0].toUpperCase() ?? ''}${lastName?[0].toUpperCase() ?? ''}';
    }
    if (todos.isNotEmpty) {
      String userShortName = todos.map((e) => getInitials(
        e?['first_name'],
        e?['last_name'],
      )).join(",\n");

      return Utils.getText(
        userShortName,
        color: AppC().base,
        weight: FontWeight.bold,
      );
    }
    return SizedBox.shrink();
  }

  void resourceSelection(TapDownDetails? details, Map<String, dynamic> todoItem) async {
    if (details != null) {
      setState(() {
        final userId = todoItem['users']?['id'];
        final userGroupId = todoItem['user_group_id'];

        if (userId != null) {
          selectedResources.addAll(resourceList
              .asMap()
              .entries
              .where((entry) => entry.value['id'] == userId)
              .map((entry) => entry.key));
        }

        if (userGroupId != null) {
          selectedResources.addAll(userGroupList.asMap().entries.where((entry) {
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
                .where((resEntry) =>
                userIds.contains(resEntry.value['id'].toString()))
                .map((resEntry) => resEntry.key);
          }));
        }
      });

      await showMenu(
        elevation: 5,
        color: Colors.white,
        context: context,
        constraints: const BoxConstraints.tightFor(width: 70),
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        items: [
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: 70,
                height: 200,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Icon(
                                Icons.close_sharp,
                                color: Colors.red,
                                size: 20,
                                weight: 0.8,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: resourceList.length,
                            itemBuilder: (context, index) {
                              final user = resourceList[index];
                              final isSelected = selectedResources.contains(index);
                              selectedResourceIdList = selectedResources
                                  .map((index) => resourceList[index]['id'])
                                  .where((id) => id != null && id != -1 && id != 0)
                                  .map((id) => int.tryParse(id.toString()))
                                  .toList();
                              return GestureDetector(
                                onTap: () {
                                  onNotifyUser.value = true;
                                  setState(() {
                                    if (todoSelectedItem.contains(user)) {
                                      todoSelectedItem.remove(user);
                                    } else {
                                      todoSelectedItem.add(user);
                                    }
                                    if (isSelected) {
                                      selectedResources.remove(index);
                                    } else {
                                      selectedResources.add(index);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Container(
                                    color: isSelected
                                        ? AppC.appColor
                                        : Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 2.0,
                                    ),
                                    child: Utils.getText(
                                      '${user['first_name'][0] ?? ''}${user['last_name'][0] ?? ''}',
                                      size: 12,
                                      weight: FontWeight.bold,
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
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }
  }


  @override
  void initState() {
    todoBloc = TodoViewBloc();
    vehicleDataBloc = vdb.VehicleDataBloc();
    todoBloc!.add(const GetDropdownData());
    todoBloc!.add(const GetVehicleListData());
    todoBloc!.add(const GetTaskExpenseData());
    todoBloc!.add(const GetVendorData());
    todoBloc!.add(const GetLocationData());
    todoBloc!.add(const GetAssignedToList());
    todoBloc!.add(const GetPartsList());
    todoBloc!.add(const GetSuppliesList());
    todoBloc!.add(const GetVehicleGroupingList());
    todoBloc!.add(const GetCheckList());
    todoBloc!.add(const GetMaintenanceCheckList());
    todoBloc!.add(const GetUserGroupingList());
    selectedRepeat = repeatList[0];
    selectedPriority = priorityList[1];
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 60));
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 45));
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 30));
    cleanCarTimeValuesList.add(CleanCarTimeValues(minutes: 15));
    selectedCleanCarTime = cleanCarTimeValuesList[0];
    todoItem = widget.todoItem;

    if (widget.todoItem['title'] != 'Check In' &&
        widget.todoItem['title'] != 'Check Out') {
      showExpenseTab = 0;
    }

    if (widget.todoItem['title'] == 'Check In' ||
        widget.todoItem['title'] == 'Check Out') {
      showExpenseTab = 1;
    }

    for (String s in monthsList) {
      MonthsPojo monthsPojo = MonthsPojo(monthName: s, selected: false);
      monthsPojoList.add(monthsPojo);
    }

    for (String s in daysList) {
      DaysPojo daysPojo = DaysPojo(dayName: s, selected: false);
      daysPojoList.add(daysPojo);
    }

    selectedMonth = MonthsPojo(monthName: "Select Month", selected: false);

    editMultipleAddressList = widget.addressesList ?? [];

    if (addresses != null && todoItem['address'] != null) {
      // isShowMultipleAddressField = true;
      selectedMultipleAddressList = [];
      editMultipleAddressList = [];
      List<dynamic> jsonList = json.decode(todoItem['address'] ?? '');
      List<dynamic> resultList = jsonList.cast<dynamic>();
      editMultipleAddressList.addAll(addresses ?? []);
      for (Map<String, dynamic> element in addresses ?? []) {
        for (dynamic userId in resultList) {
          if (userId.toString() == element['id'].toString()) {
            isSelected = true;
            // Map<String, dynamic> suppliesData = Addresses(
            //     address: element['address'],
            //     deleteId: element['id'],
            //     id: element['id'],
            //     isSelected: isSelected,
            //     locationId: element['location_id']);
            selectedMultipleAddressList.add({
              'address': element['address'],
              'id': element['id'],
              'location_id': element['location_id']
            });
          }
        }
      }
    }

    todoTimeController.text =
        Utils.convertToHourMinutes(todoItem['todo_time'] ?? '');

    completeAllDay = (todoItem['status'] == 'Completed');
    editSelectedPriority = todoItem['priority'] ?? '';

    for (PriorityData p in PriorityData().buildPriorityList()) {
      if (p.name!.toLowerCase() == editSelectedPriority!.toLowerCase()) {
        appBarColor = p.color!;
      }
    }

    appBarTitle = todoItem['title']!;
    editTodoNameController.text = todoItem['title']!;
    notesController.text = todoItem['notes'] ?? '';

    if (todoItem['vendor_name'] != null &&
        todoItem['vendor_name']!.isNotEmpty) {
      editVendorLocationController.text = todoItem['vendor_name'] ?? '';
    } else {
      editVendorLocationController.text = todoItem['location'] ?? '';
    }

    editSelectedDate =
        Utils.convertStringToDateTime(todoItem['todo_date'] ?? '');
    editTodoDateController.text = todoItem['todo_date'] ?? '';
    timeSensitive = (todoItem['time_sensitive'] == 1);
    debugPrint(
        'todoItem!.todoTime|allDay: ${todoItem['todo_time'] ?? 'allDay is true'}');

    if (todoItem['todo_time'] != null && todoItem['todo_time']!.isNotEmpty) {
      todoListRepo.chosenDateTime = DateTime.now().copyWith(
          hour: int.tryParse(todoItem['todo_time']!.split(':')[0]),
          minute: int.tryParse(todoItem['todo_time']!.split(':')[1]),
          second: int.tryParse(todoItem['todo_time']!.split(':')[2]));
      todoListRepo.chosenDateTimeString =
          Utils.convertString24HTo12H(todoItem['todo_time']!);
      todoListRepo.startTimeTFString =
          DateFormat("HH:mm:ss").format(todoListRepo.chosenDateTime!);
    } else {
      editAllDay = true;
    }

    debugPrint('todoItem!.reminder: ${todoItem['reminder'] ?? ''}');
    editReminder = (todoItem['reminder'] ?? 'false') == 'true' ? true : false;

    debugPrint('userName: $userGroupConcatenationName');
    debugPrint('userName-1: $userShortName');

    if (todoItem['vin'] == null) {
      if (todoItem['vehicles'] is List && todoItem['vehicles'].isNotEmpty && todoItem['vehicles'].length==1) {
        vinToFind = todoItem['vehicles'][0]['vin'];
      }
      else if(todoItem['vehicles'].length > 1){
        for(int i=0;i<todoItem['vehicles'].length;i++){
        vinList.add(todoItem['vehicles'][i]['vin']);
        }
      }
    } else {
      vinToFind = todoItem['vin'];
    }


    if (vehicleLists != null && vehicleLists!.isNotEmpty) {
      isVehiclePresented = true;
      editVehiclePersonController.text = todoItem['vehicle_name'] ?? '';
    } else {
      isVehiclePresented = false;
      editVehiclePersonController.text = todoItem['person'] ?? '';
    }
    selectedMultipleVehicleList =
        todoItem['vehicles'] ?? editVehiclePersonController.text;

    selectedLink = customTaskOptions.firstWhere(
          (item) => item['id'] == (todoItem['custom_link_id']?.toString() ?? '1'),
      orElse: () => {},
    );
    reservationController.text=todoItem['reference_id'] ?? "";
    reasonController.addListener(() {

      setState(() {});
    });
    if (todoItem['vehicles'] is List) {
      vehicleName.addAll(List<Map<String, dynamic>>.from(todoItem['vehicles']));
    }

    if (todoItem['todoimages'] != null && todoItem['todoimages'] is List) {
      todoImages.addAll((todoItem['todoimages'] as List).cast<Map<String, dynamic>>());
    }
    super.initState();
  }


  @override
  void dispose() {
    reasonController.removeListener(() {});
    reasonController.dispose();
    super.dispose();
  }

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
                              print("DTap");
                            },
                            child: InteractiveViewer(
                              maxScale: 8.0,
                              minScale: 0.01,
                              child: File(imagePath).existsSync()
                                  ? Image.file(
                                File(imagePath),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading file image: $error');
                                  return const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              )
                                  : CachedNetworkImage(
                                imageUrl: todoItem['todoimages'] != null
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppC.white,
        appBar: AppBar(
          titleTextStyle: const TextStyle(color: AppC.white),
          elevation: 0,
          backgroundColor: completeAllDay ?  Colors.green.shade900:appBarColor,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              },
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: AppC.white,
            ),
          ),
          titleSpacing: -8,
          title: Utils.getText(appBarTitle,
              size: 18, color: AppC.white, weight: FontWeight.w700),
          actions: [
            GestureDetector(
              child: const Icon(Icons.upload_outlined, color: AppC.green),
              onTap: () async {
                MultiImagePickHelper imageHelper = MultiImagePickHelper();
                await imageHelper.getMultiImage(ImageSource.gallery).then((selectedFiles) {
                  if (selectedFiles.isNotEmpty) {
                    for (var filePath in selectedFiles) {
                      debugPrint('filePath: $filePath');
                      // Add each image to your todoImages list
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
            GestureDetector(
              child: Transform.scale(
                scale: 0.6,
                child: SizedBox(width: 40,
                  child: Switch(
                      trackOutlineColor: WidgetStateColor.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppC.green;
                          } else {
                            return AppC.grey;
                          }
                        },
                      ),
                      inactiveThumbColor: AppC.white,
                      inactiveTrackColor: AppC.appColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: AppC.white,
                      activeTrackColor: AppC.green,
                      value: completeAllDay,
                      onChanged: (value) {
                        completeAllDay = value;
                        setState(() {});
                        todoBloc!.add(CompleteTodoItem(
                            todoId: todoItem['id'].toString(),
                            status:
                                completeAllDay ? 'Completed' : 'In Progress'));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavigationForTaskView(selectedIndex: 0, message: '',)));
                      }),
                ),
              ),
              onTap: () {},
            ),
            GestureDetector(
              child: const Icon(Icons.delete_outline, color: Colors.red),
              onTap: () {
                DeletePermissionDialog.of.show(context, (val) {
                  setState(() {
                    if(val.isNotEmpty){
                      todoBloc?.add(DeleteTodoEvent(
                          todoId: todoItem['id'].toString()));
                      vehicleDataBloc?.add(vdb.DeleteExpense(
                          id: widget.todoItem['expense_id']));
                    }
                  });
                },);
                return;
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                        return Dialog(
                            backgroundColor: AppC.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10
                              ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.help_outline_sharp,size: 30,color: Colors.blue,),
                               // const SizedBox(height: ),
                                Utils.getText(
                                    'Are you sure?',
                                    size: 20,
                                    weight: FontWeight.w700,
                                    align: TextAlign.center),
                                const SizedBox(height: 8),
                                Utils.getText(
                                  'FairPy Inc, are you sure you want to delete this task? Kindly enter a valid reason to confirm the deletion',
                                  size: 12,
                                  align: TextAlign.center,
                                ),
                                const SizedBox(height: 8),

                                Utils.getTextFormField(
                                    'Enter a reason',
                                    reasonController ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ValueListenableBuilder(valueListenable: reasonController, builder: (context, value, child) => Utils.getFilledButton(
                                      'Yes, delete it!',
                                          (){
                                        setState(() {
                                          if(reasonController.text.isNotEmpty){
                                            Navigator.of(context).pop();
                                            todoBloc!.add(DeleteTodoEvent(
                                                todoId: todoItem['id'].toString()));
                                            vehicleDataBloc!.add(vdb.DeleteExpense(
                                                id: widget.todoItem['expense_id']));
                                          }
                                        });
                                      },
                                      bgColor: (value.text.isNotEmpty) ? AppC.blue : AppC.blue.withOpacity(0.5),
                                    )),
                                    Utils.getFilledButton(
                                      'Cancel',
                                          ()=>Navigator.pop(context, false),
                                      bgColor: AppC.redAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  },
                );
              },
            ),
    /*Utils.getAlertDialog(
    context,
    () {
    Navigator.of(context).pop();
    todoBloc!.add(
    DeleteTodoEvent(todoId: todoItem['id'].toString()));
    },
    content: 'Are you sure want to delete expenses and todo?',
    leftText: 'Delete Todo',
    rightText: 'Cancel',
    isThirdButtonNeeds: widget.todoItem['expense_id'] != null &&
    widget.todoItem['expense_id']!.isNotEmpty,
    thirdButtonText: 'Yes, Delete',
    thirdButtonCallback: () {
    Navigator.of(context).pop();
    vehicleDataBloc!.add(
    vdb.DeleteExpense(id: widget.todoItem['expense_id']));
    todoBloc!.add(
    DeleteTodoEvent(todoId: todoItem['id'].toString()));
    },
    );*/
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              child: const Icon(Icons.save, color: AppC.green),
              onTap: () {
                doCreateEditTodo(todoName: null, time: null);
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
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => todoBloc!
                  ..add(widget.todoItem['expense_id'] != null &&
                          widget.todoItem['expense_id']!.isNotEmpty
                      ? GetExpenseToData(
                          expenseId: getEditedExpenseId(
                              widget.todoItem['expense_id'] ?? ''))
                      : const TodoViewInitialEvent())),
            BlocProvider(
              create: (context) =>
                  vehicleDataBloc!..add(const vdb.VehicleInitial()),
            ),
            /*BlocProvider(
              create: (context) => locationDataBloc!..add(const AddedLocationInitial()),
            ),*/
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<TodoViewBloc, TodoViewState>(
                listener: (context, state) async {

                  if (state is VehicleDataLoaded) {
                    vehicleList.addAll(state.vehicleData ?? []);
                    editMultipleVehicleList.addAll(state.vehicleData ?? []);
                    if (vinToFind != null) {
                      vehicle = vehicleList.firstWhere(
                            (emp) => emp['vin'] == vinToFind,
                        orElse: () => {},
                      );
                      setVehicleList = vehicleList.firstWhere(
                            (emp) => emp['vin'] == vinToFind,
                        orElse: () => {},
                      );
                    }
                    if(vinList.isNotEmpty) {
                      selectedVin = vehicleName.firstWhere(
                        (emp) => emp['vin'] == vinList[0],
                        orElse: () => {},
                      );
                      setVehicleList = vehicleList.firstWhere(
                            (emp) => emp['vin'] == vinToFind,
                        orElse: () => {},
                  );
                    }

                    if (todoItem['vin'] == null) {
                      if (selectedVin != null && selectedVin['vin'] != null) {
                        vin = selectedVin['vin'];
                      } else if (todoItem['vehicles'] is List && todoItem['vehicles'].isNotEmpty) {
                        vin = todoItem['vehicles'][0]?['vin'];
                      }
                    } else {
                      vin = todoItem['vin'];
                    }
                    vin ??= '';

                    setVehicleList =  vehicleList.firstWhere(
                          (emp) => emp['vin'] == vin,
                      orElse: () => {},
                    );

                    // if(editVehiclePersonController.text.isEmpty){
                    //   editVehiclePersonController.text=vehicle?['vehicle_name']??'';
                    //   print('editVehiclePersonController.text-----------------${editVehiclePersonController.text}');
                    // }
                    if (editVehiclePersonController.text.isNotEmpty) {
                      CreateTodoParams createTodoParams =
                          getSelectedVehiclePersonEdit(
                              createTodoParamForVHistory);
                      // .then((value) {
                      if ((createTodoParams.vin != null &&
                              createTodoParams.vin!.isNotEmpty) ||
                          (createTodoParams.vehicleGroupId != null &&
                              createTodoParams.vehicleGroupId!.isNotEmpty)) {
                        // isShowVehicleHistoryList = true;
                        // vehicleDataBloc = VehicleDataBloc();
                        vehicleDataBloc!.add(vdb.GetVehicleHistoryEvent(
                            vin: createTodoParams.vin,
                            vehicleGroupId: /*value.vehicleGroupId != null ?*/
                                /*int.parse(value.vehicleGroupId??'0') :*/ null,
                            needUI: false));
                        setState(() {});
                      }
                      // else {
                      // isShowVehicleHistoryList = false;
                      // setState(() {});
                      // }

                      setState(() {});
                      // });
                    }
                  } else if (state is UserGroupListLoaded) {
                    userGroupList.clear();
                    userGroupList.addAll(state.userGroupDataList ?? []);
                  } else if (state is DropdownDataLoaded) {
                    createExpenseFieldData = state.createExpenseFieldData;
                    if (state.createExpenseFieldData != null) {
                      cohortsData =
                          state.createExpenseFieldData!.cohortsData ?? [];
                      if (categoriesData.isEmpty) {
                        categoriesData =
                            state.createExpenseFieldData!.expenseCategories ??  [];
                      }
                    }
                  }
                  else if (state is AssignedToLoaded) {
                    resourceList = [];
                    resourceList = state.resource ?? [];
                    resourceList.removeWhere((resource) => resource['id'] == 2);
                    isSelected = true;
                    selectedAssignedTo.add(resourceList[0]);
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
                  }
                  else if (state is TaskExpenseLoaded) {
                    taskExpenseList = state.resource ?? [];
                  } else if (state is VendorLoaded) {
                    vendorList = state.resource ?? [];
                  } else if (state is LocationLoaded) {
                    locationList = state.resource ?? [];
                  } else if (state is CreateTodoLoaded) {
                    if (state.result != null && state.result!) {
                      Navigator.of(context).pop(true);
                      //Navigator.push(context,MaterialPageRoute(builder: (context)=>const TodoViewUI()));
                    }
                  } else if (state is CreateExpenseLoaded) {
                    if (state.expenseSummaryResponse != null &&
                        state.isVehicleGroup!) {
                      expenseIdsCount++;
                      if (expenseIds.isEmpty) {
                        expenseIds =
                            '${state.expenseSummaryResponse!.data![0]['id']}';
                      } else {
                        expenseIds =
                            '$expenseIds,${state.expenseSummaryResponse!.data![0]['id']}';
                        if (expenseIdsCount ==
                            vehicleGroupVinNumbersList!.length) {
                          todoBloc!.add(EditTodoDate(
                              null,
                              null,
                              todoItem['id'].toString(),
                              null,
                              null,
                              null,
                              null,
                              "[$expenseIds]",
                              null));
                        }
                      }
                    }
                  } else if (state is TodoItemCompletedV) {
                    if (state.result != null && state.result!) {
                      Navigator.of(context).pop(true);
                    }
                  } else if (state is PartsLoaded) {
                    if (state.partsList != null) {
                      editPartsList.addAll(state.partsList!);
                      if (widget.todoItem['parts'] != null &&
                          widget.todoItem['parts']!.isNotEmpty) {
                        isPartChecked = true;
                        selectedPartsList.clear();
                        for (Map<String, dynamic> parts
                            in widget.todoItem['parts']!) {
                          for (Map<String, dynamic> partsData
                              in editPartsList) {
                            if (parts['parts_id'] ==
                                partsData['id'].toString()) {
                              partIsSelected = true;
                              partId = parts['id'];
                              selectedPartsList.add(partsData);
                            }
                          }
                        }
                      }
                    }
                  } else if (state is DeleteTodoLoaded) {
                    if (state.result != null && state.result!) {
                      Navigator.of(context).pop(true);
                    }
                  } else if (state is SuppliesLoaded) {
                    if (state.suppliesList != null) {
                      editSuppliesList.addAll(state.suppliesList!);
                      if (widget.todoItem['supplies'] != null &&
                          widget.todoItem['supplies']!.isNotEmpty) {
                        isSupplyChecked = true;
                        for (Map<String, dynamic> supply
                            in widget.todoItem['supplies']!) {
                          for (Map<String, dynamic> supplyData
                              in editSuppliesList) {
                            if (supply['supplies_id'] ==
                                supplyData['id'].toString()) {
                              suppliesIsSelected = true;
                              suppliesId = supply['id'];
                              selectedSuppliesList.add(supplyData);
                            }
                          }
                        }
                      }
                    }
                  }
                  else if (state is VehicleGroupListLoaded) {
                    vehicleGroupList.clear();
                    vehicleGroupList.addAll(state.vehicleGroupDataList ?? []);
                    if (editVehiclePersonController.text.isEmpty) {
                      for (Map<String, dynamic> vehicleGroupData
                          in vehicleGroupList) {
                        if (vehicleGroupData['id'] ==
                            todoItem['vehicle_group_id']) {
                          vehicleGroupName = vehicleGroupData['name'] ?? '';
                          editVehiclePersonController.text =
                              vehicleGroupData['name'] ?? '';
                          isVehiclePresented = true;
                        }
                      }
                    }
                  }
                  else if (state is ExpenseTodoLoaded) {
                    existingExpenseDate = state.expenseSummaryData;
                    expenseDescriptionController.text =
                        existingExpenseDate?['expense_description'] ?? '';
                    if (editedExpenseIdsLength != null) {
                      amountController.text =
                          ((existingExpenseDate?['expense_amount'] ?? 0) *
                                  editedExpenseIdsLength!)
                              .toString();
                    } else {
                      amountController.text =
                          (existingExpenseDate?['expense_amount'] ?? 0)
                              .toString();
                    }
                    attachmentImage =
                        (existingExpenseDate['attachments'] ?? []);
                    if ((existingExpenseDate?['category_id'] ?? 0) != 0) {
                      categoriesData.clear();
                      categoriesData = (widget.categoriesListData ?? []);
                      for (int i = 0;
                          i < (widget.categoriesListData ?? []).length;
                          i++) {
                        // var element = categoriesData[i];
                        if (widget.categoriesListData![i]['id'] ==
                            (existingExpenseDate?['category_id'] ?? 0)) {
                          selectedExpenseCategories =
                              widget.categoriesListData![i];
                          existingExpenseDate?['category_name'] =
                              widget.categoriesListData![i]['name'];
                          subCategoriesData = (widget.categoriesListData![i]
                                  ['subcategories'] ??
                              []);
                          for (var element1 in (widget.categoriesListData![i]
                                  ['subcategories'] ??
                              [])) {
                            if (element1.id ==
                                (existingExpenseDate?['subcategory_id'] ?? 0)) {
                              selectedExpenseSubCategories = element1;
                              existingExpenseDate?['subcategory_name'] =
                                  element1.name;
                            }
                          }
                        }
                      }
                    }
                  } else if (state is CheckListLoaded) {
                    checkListData.clear();
                    checkListData.addAll(state.data ?? []);
                  } else if (state is MaintenanceCheckListLoaded) {
                    maintenanceCheckListData.clear();
                    childrenData.clear();
                    maintenanceCheckListData.addAll(state.data ?? []);
                  }
                },
              ),
              BlocListener<vdb.VehicleDataBloc, vdb.VehicleDataState>(
                listener: (context, state) {

                  if (state is vdb.TodoItemCompletedVeh) {
                    show(
                        context,
                        (state.status) == 'In Progress'
                            ? 'The todo marked as In Progress.'
                            : 'The todo marked as Completed.',
                        (state.status) == 'In Progress'
                            ? 'Completed'
                            : 'In Progress');
                    if (state.result != null && state.result!) {
                      vehicleDataBloc!.add(vdb.GetVehicleHistoryEvent(
                          vin: createTodoParamForVHistory.vin,
                          vehicleGroupId: createTodoParamForVHistory
                                      .vehicleGroupId !=
                                  null
                              ? int.parse(
                                  createTodoParamForVHistory.vehicleGroupId!)
                              : null,
                          needUI: true));
                    }
                  } else if (state is vdb.VehicleHistoryLoaded) {
                    if (state.vehicleHistoryList != null) {
                      todoList.clear();
                      todoListRepo.vehicleHistoryTempSearchList.clear();
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
                      list.sort((a, b) =>
                          DateTime.parse(a.createdAt ?? '').compareTo(
                              DateTime.parse(b.createdAt ?? '')));
                     */
                      todoList.addAll(state.vehicleHistoryList!);
                      todoListRepo.vehicleHistoryTempSearchList
                          .addAll(/*todoList*/ state.vehicleHistoryList!);
                      // debugPrint('cleancar.title: ${(todoListRepo.vehicleHistoryTempSearchList)[0].title ?? ''}');

                      /*if (todoList.isNotEmpty) {
                        if (todoList.first.title == 'clean car'){

                        }
                      }*/
                      doSetState();
                    }
                  }
                },
              ),
            ],
            child: BlocBuilder<TodoViewBloc, TodoViewState>(
                builder: (context, state) {

              return SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showList = false;
                          showVehiclePersonList = false;
                          showVendorLocationList = false;
                          editShowList = false;
                          editShowVehiclePersonList = false;
                          editShowVendorLocationList = false;
                          editShowPartsList = false;
                          editShowSuppliesList = false;
                          editShowMultipleAddressList = false;
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: editTodoWidget(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  showBottomTabWidget(),
                                ],
                              ),
                            ),
                            const Divider(
                              indent: 15,
                              endIndent: 15,
                            ),
                            if (showExpenseTab == 0)
                              const Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: SizedBox(
                                    height: 400,
                                    child: ExpenseEditUI(showHeader: false, expense: {},)),
                              )
                            else if (showExpenseTab == 1)
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child:
                                        const CreateTodoUI(showHeader: false)),
                              )
                            else if (showExpenseTab == 2)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: SizedBox(
                                  height: 300, // Set an appropriate height
                                  child: ListView.builder(
                                    itemCount: checkListData.length,
                                    itemBuilder: (context, index) {
                                      return checkList(checkListData[index]);
                                    },
                                  ),
                                ),
                              )
                            else if (showExpenseTab == 3)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.6,
                                        child: MaintenanceCheckListUI(
                                          maintenance: maintenanceCheckListData,
                                        )),
                                  ],
                                ),
                              )
                            else if (showExpenseTab == 4)
                              Column(
                                children: [
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.6,
                                      child: VehicleEditUI(vehicle: setVehicleList,showHeader: false,)
                                  ),
                                ],
                              )
                            else
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                child:
                                    Utils.getText('No Vehicle Exist', size: 16),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: state is TodoListLoading || state is vdb.VehicleDataLoading,
                        child: Center(child: Utils.getProgressIndicator(context))
                    )
                  ],
                ),
              );
            }),
          ),
        ));
  }

  Widget editTodoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Utils.getTextFormField(
                    contentPadding:
                        const EdgeInsets.only(right: 21, left: 10),
                    '',
                    editTodoDateController,
                    readOnly: true,
                    onTapCallback: () {
                      Utils.todoDatePickerDialog(
                        context,
                        '',
                        initial: DateTime.parse(editTodoDateController.text),
                      ).then((value) {
                        editSelectedDate = value;
                        editTodoDateController.text =
                            Utils.convertDateTimeToTheFormats(value.toString());
                      });
                    },
                      suffixIcon:const Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: AppC.appColor,
                      ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !editAllDay,
              child: const SizedBox(width: 10),
            ),
            Visibility(
              visible: !editAllDay,
              child: Expanded(
                child: _buildTimeField('', todoTimeController, () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: int.parse(todoTimeController.text.split(":")[0]),
                      minute: int.parse(todoTimeController.text.split(":")[1]),
                    ),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
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
            ),
            SizedBox(
              width: 20,
              child: Transform.scale(
                scale: 0.7,
                child: Checkbox(
                  value: timeSensitive,
                  checkColor: AppC.white,
                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppC.blue;
                    }
                    return AppC.white;
                  }),
                  onChanged: (bool? value) {
                    setState(() {
                      timeSensitive = value ?? false;
                      todoItem['time_sensitive'] = timeSensitive ? 1 : 0;
                    });
                  },
                ),
              ),
            ),
            Column(
              children: [
                Utils.getText('Time Sensitive'),
              ],
            ),
            const SizedBox(width: 5,),
            InkWell(
              onTapDown: (details) => resourceSelection(details, todoItem),
              child: Visibility(
                visible: todoItem['users'] != null || todoItem['user_group_id'] != null,
                child: getUserGroupDataById(todoItem),
              ),
            ),

            /* InkWell(
              onTapDown: (TapDownDetails? details) async {
                if (details != null) {
                  setState(() {
                    final userId = todoItem['users']?['id'];
                    final userGroupId = todoItem['user_group_id'];
                    if (userId != null) {
                      selectedResources.addAll(resourceList
                          .asMap()
                          .entries
                          .where((entry) => entry.value['id'] == userId)
                          .map((entry) => entry.key));
                    }
                    if (userGroupId != null) {
                      selectedResources.addAll(userGroupList.asMap().entries.where((entry) {
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
                            .where((resEntry) => userIds
                            .contains(resEntry.value['id'].toString()))
                            .map((resEntry) => resEntry.key);
                      }));
                    }
                  });

                  await showMenu(
                    elevation: 5,
                    color: Colors.white,
                    context: context,
                    constraints: const BoxConstraints.tightFor(width: 70),
                    position: RelativeRect.fromLTRB(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 70,
                            height: 200,
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(bottom: 5.0),
                                          child: Icon(
                                            Icons.close_sharp,
                                            color: Colors.red,
                                            size: 20,
                                            weight: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: resourceList.length,
                                        itemBuilder: (context, index) {
                                          final user = resourceList[index];
                                          final isSelected = selectedResources.contains(index);
                                            selectedResourceIdList = selectedResources
                                                .map((index) => resourceList[index]['id'])
                                                .where((id) => id != null && id != -1 && id != 0)
                                                .map((id) => int.tryParse(id.toString()))
                                                .toList();
                                          return GestureDetector(
                                            onTap: () {
                                             // log("RESOURCE:\t${user}", name: "ON_SELECTED");
                                              onNotifyUser.value = true;
                                              setState(() {
                                                if (todoSelectedItem.contains(user)) {
                                                  todoSelectedItem.remove(user);
                                                } else {
                                                  todoSelectedItem.add(user);
                                                }
                                                if (isSelected) {
                                                  selectedResources.remove(index);
                                                } else {
                                                  selectedResources.add(index);
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 2.0),
                                              child: Container(
                                                color: isSelected
                                                    ? AppC.appColor
                                                    : Colors.transparent,
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 2.0,
                                                ),
                                                child: Utils.getText(
                                                  '${user['first_name'][0] ?? ''}${user['last_name'][0] ?? ''}',
                                                  size: 12,
                                                  weight: FontWeight.bold,
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
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
              child: Visibility(
                visible: todoItem['users'] != null ||
                    todoItem['user_group_id'] != null,
                child: getUserGroupDataById(todoItem),
              ),
              *//*child: Visibility(
                visible: true,
                child: ValueListenableBuilder(valueListenable: onNotifyUser, builder: (context, value, child) => (todoSelectedItem.isEmpty) ? Text("SELECT ME") :getUserGroupDataById2(todoSelectedItem),),
              ),*//*
            ),*/
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Utils.getTextFormField(
          'Task Name',
          editTodoNameController,
          readOnly: false,
          onChangeCallback: (value) {
            if(value.isNotEmpty){
              taskIdentifierSuggestionList.clear();
              List vehiclePersonList =
              taskExpenseList.map((e) => e['task'] ?? '').toList();
              taskIdentifierSuggestionList
                  .addAll(Utils.searchList(vehiclePersonList, value));
              editShowList = taskIdentifierSuggestionList.isNotEmpty;
            }
            else{
              editShowList=false;
            }
            setState(() {});
          },
          suffixIcon: Visibility(
               visible: !editShowList && editTodoNameController.text.isNotEmpty,
              child: InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TaskViewUI(),
                    ));
                  },
                  child: Icon(Icons.add, color: AppC().base, size: 20)),
            )
        ),
        Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todoItem['title'] != 'Check In' &&
                    todoItem['title'] != 'Check Out')
                  const SizedBox(
                    height: 15,
                  ),
                if (todoItem['title'] != 'Check In' &&
                    todoItem['title'] != 'Check Out')
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
                                        color: AppC
                                            .trans), // Corrected from Border.all to BorderSide

                                    deleteIcon: const Icon(
                                      Icons.close,
                                      color: AppC.red,
                                      size: 18,
                                    ),
                                    backgroundColor:AppC.lowGreen,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    // side: BorderSide(),
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
                          editVehiclePersonController,
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
                          visible: !editShowMultipleVehicleList && editVehiclePersonController.text.isNotEmpty,
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
                              child: Icon(
                                Icons.add,
                                  color: AppC().base,
                                size: 20,
                            )),
                            )
                        ),

                      ],
                    ),
                  ),

                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (todoItem['title'] != 'Check In' &&
                            todoItem['title'] != 'Check Out')
                          const SizedBox(
                            height: 15,
                          ),
                        if (todoItem['title'] != 'Check In' &&
                            todoItem['title'] != 'Check Out')
                          Utils.getTextFormField(
                            'Vendor / Location',
                            editVendorLocationController,
                            readOnly: false,
                            onChangeCallback: (value) {
                              if(value.isNotEmpty){
                                // String textCurrentlyEditing = getTextBeforeCursor();
                                // debugPrint('textCurrentlyEditing: $textCurrentlyEditing');
                                vendorLocationSuggestionList.clear();
                                List vendorLocationList = vendorList
                                    .map((e) => e['name'] ?? '')
                                    .toList() +
                                    locationList
                                        .map((e) => e['name'] ?? '')
                                        .toList();

                                vendorLocationSuggestionList.addAll(
                                    Utils.searchList(
                                        vendorLocationList, value));
                                editShowVendorLocationList =
                                    vendorLocationSuggestionList.isNotEmpty;
                              }
                           else{
                                editShowVendorLocationList=false;
                              }
                              setState(() {});
                            },
                             suffixIcon: Visibility(
                              visible: !editShowVendorLocationList && editVendorLocationController.text.isNotEmpty,
                              child: InkWell(
                                  onTapDown: (details) {
                                    Utils.showStringPopupMenu(
                                        context,
                                        ['Add Vendor', 'Add Location'],
                                        details, (value) async {
                                      if (value == 'Add Vendor') {
                                        await Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const VendorViewUI(),
                                        ));
                                      } else {
                                        await Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const LocationViewUI(),
                                        ));
                                      }
                                    });
                                  },
                                  child: Icon(
                                      Icons.add,
                                      color: AppC().base,
                                      size: 20
                                  ),
                              ),
                             )
                          ),
                        Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Utils.getTextFormField(
                                  'Notes',
                                  notesController,
                                  readOnly: false,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (todoItem['title'] != 'Check In' &&
                                    todoItem['title'] != 'Check Out')
                                  Visibility(
                                    visible: !showMore,
                                    child: InkWell(
                                        onTap: () {
                                          showMore = !showMore;
                                          setState(() {});
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Utils.getText('More...',
                                                color: Colors
                                                    .lightBlue.shade800),
                                            const SizedBox(width: 20,),
                                            Expanded(child:
                                              SizedBox(height: 30,
                                                child: Utils.dropdownBox(
                                                    '',
                                                 selectedKey: selectedLink,
                                                    customTaskOptions,
                                                        (selectedValue) {
                                                      setState(() {
                                                        selectedLink = selectedValue;
                                                      });
                                                    },
                                                  initialSelection: selectedLink,
                                                     labelKey: 'label',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              key: _key,
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                final RenderBox renderBox = _key
                                                        .currentContext!
                                                        .findRenderObject()
                                                    as RenderBox;
                                                final Offset offset = renderBox
                                                    .localToGlobal(Offset.zero);
                                                final Size size =
                                                    renderBox.size;
                                                await showMenu(
                                                  elevation: 5,
                                                  color: AppC.white,
                                                  context: context,
                                                  constraints:BoxConstraints.tightFor(
                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                      height: 50),
                                                  position:
                                                      RelativeRect.fromLTRB(
                                                    offset.dx,
                                                    offset.dy + size.height,
                                                    offset.dx + size.width,
                                                    offset.dy,
                                                  ), // Adjust as needed
                                                  items: [
                                                    PopupMenuItem(
                                                      height:35,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
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
                                                              Navigator.pop(context); // Close the popup menu
                                                            },
                                                            child:
                                                                const Padding(
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 3.0),
                                                child: Utils.getText(
                                                  selectedLink['id'] =='1'
                                                      ? '+ Link'
                                                      : '+ Reservation',
                                                  color: AppC.white,
                                                  size: 12,
                                                  overFlow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                Visibility(
                                    visible: showMore,
                                    child: Column(
                                      children: [
                                        getPartSupplyCheckBoxRow(),
                                          if(todoItem['identifier_id']==212
                                              ||todoItem['identifier_id']==210
                                          )
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Utils.getTextFormField(
                                                        'Trip driven miles',
                                                        milesController,
                                                    ),
                                                ),
                                                const SizedBox(width: 24,),
                                                Expanded(
                                                  child: Utils.dropdownBox(
                                                      'Select Sentiments',
                                                      sentiments,
                                                          (selectedValue) {
                                                    setState(() {
                                                      selectedSentiments = selectedValue;
                                                    });
                                                  },
                                                      labelKey: 'name'),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    )),
                                Visibility(
                                  visible: isPartChecked && showMore,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 3,
                                           ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppC.fieldBase,
                                              width: Num.borderWidthField,
                                            ),
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(
                                                    Num.subradiusButton)
                                            ),
                                        ),
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
                                                          for (var element in editPartsList) {
                                                            if (element['id'] == selectedPartsList[idx]['id']) {
                                                              partIsSelected = false;
                                                            }
                                                          }
                                                          if (partId != 0) {
                                                            todoBloc!.add(
                                                                DeletePartsEvent(partsId: partId));
                                                          }
                                                          selectedPartsList
                                                              .removeAt(idx);
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
                                            Utils.getTextFormField(
                                                    'Parts/Services',
                                                    editPartsController,
                                                    readOnly: false,
                                                    onChangeCallback: (value) {
                                              editPartsSuggestionList.clear();
                                              List<dynamic> partsList = editPartsList /*.map((e) =>'${e.name}').toList()*/;
                                              editPartsSuggestionList.addAll(
                                                  Utils.searchObjectList(partsList, value));
                                              editShowPartsList =
                                                  editPartsSuggestionList
                                                      .isNotEmpty;
                                              setState(() {});
                                            },
                                                    suffixIcon: Visibility(
                                                      visible:
                                                          !editShowPartsList,
                                                      child: InkWell(
                                                          onTap: () async {
                                                            await Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const PartViewUI(),
                                                            ));
                                                          },
                                                          child: Icon(Icons.add,
                                                              color:
                                                                  AppC().base,
                                                              size: 20)),
                                                    )),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: isSupplyChecked && showMore,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 8,
                                                   ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: AppC.fieldBase,
                                                      width: Num.borderWidthField,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                Num.subradiusButton)
                                                        ),
                                                ),
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
                                                                onDeleted: ()  {
                                                                  for (var element in editSuppliesList) {
                                                                    if (element['id'] == selectedSuppliesList[idx]['id']) {
                                                                      suppliesIsSelected = false;
                                                                    }
                                                                  }
                                                                  if (suppliesId != null &&
                                                                      suppliesId != 0) {
                                                                    todoBloc!.add(DeleteSupplysEvent(
                                                                      suppliesId:suppliesId,)
                                                                    );
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
                                                    Utils.getTextFormField(
                                                        'Supplies',
                                                        editSuppliesController,
                                                        readOnly: false,
                                                        onChangeCallback:
                                                            (value) {
                                                      editSuppliesSuggestionList.clear();
                                                      List<dynamic> supplyList =
                                                          editSuppliesList /*.map((e) =>'${e.name}').toList()*/;
                                                      editSuppliesSuggestionList
                                                          .addAll(Utils
                                                              .searchObjectList(
                                                                  supplyList,
                                                                  value));
                                                      editShowSuppliesList =
                                                          editSuppliesSuggestionList
                                                              .isNotEmpty;
                                                      setState(() {});
                                                    },
                                                        suffixIcon: Visibility(
                                                          visible:
                                                              !editShowSuppliesList,
                                                          child: InkWell(
                                                              onTap: () async {
                                                                await Navigator.of(context).push(MaterialPageRoute(
                                                                  builder: (context) => const SuppliesViewUI(),
                                                                ));
                                                              },
                                                              child: Icon(
                                                                  Icons.add,
                                                                  color: AppC().base,
                                                                  size: 20)),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                            visible: editShowSuppliesList,
                                            child: Utils
                                                .customAutoCompleteWithUnSelectedOption(
                                                    editSuppliesSuggestionList,
                                                    (index) {
                                              editShowSuppliesList = false;
                                              countHyphens('');
                                              selectedSuppliesList.add(
                                                  editSuppliesSuggestionList[
                                                      index]);
                                              isSelected = true;
                                              editSuppliesController.selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        (editSuppliesController
                                                            .text.length)),
                                              );
                                              setState(() {});
                                              editSuppliesController.selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        (editSuppliesController
                                                            .text.length)),
                                              );
                                            })),
                                      ],
                                    ),
                                    Visibility(
                                        visible: editShowPartsList,
                                        child: Utils
                                            .customAutoCompleteWithUnSelectedOption(
                                                editPartsSuggestionList,
                                                (index) {
                                          editShowPartsList = false;
                                          countHyphens('');
                                          // editPartsController.text = editPartsSuggestionList[index] ?? '';
                                          selectedPartsList.add(
                                              editPartsSuggestionList[index]);
                                          partIsSelected = true;
                                          editPartsController.selection =
                                              TextSelection.fromPosition(
                                            TextPosition(
                                                offset: (editPartsController
                                                    .text.length)),
                                          );
                                          setState(() {});
                                          editPartsController.selection =
                                              TextSelection.fromPosition(
                                            TextPosition(
                                                offset: (editPartsController
                                                    .text.length)),
                                          );
                                        })),
                                  ],
                                ),
                                Visibility(
                                  visible: showMore,
                                  child: InkWell(
                                    onTap: () {
                                      showMore = !showMore;
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top :8.0),
                                      child: Row(
                                        children: [
                                          Utils.getText('Less...',
                                              color: Colors.lightBlue.shade800),
                                          const SizedBox(width: 20,),
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
                                          const SizedBox(
                                            width: 10,
                                          ),
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
                                                               height:30,
                                                                child: Utils.getTextFormField(
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
                                if (todoItem['title'] == 'Maintenance Check' ||
                                    todoItem['title'] == 'Getaround Prechecks')
                                  const SizedBox(
                                    height: 10,
                                  ),
                                if (todoItem['title'] == 'Maintenance Check' ||
                                    todoItem['title'] == 'Getaround Prechecks')
                                  Utils.getTextFormField(
                                    'Odometer',
                                    odometerController,
                                    readOnly: false,
                                  ),
                              ],
                            ),
                            Visibility(
                                visible: editShowVendorLocationList,
                                child: Utils.customAutoCompleteList(
                                    vendorLocationSuggestionList,
                                    (index) async {
                                  editShowVendorLocationList = false;
                                  countHyphens('');
                                  editVendorLocationController.text =
                                      vendorLocationSuggestionList[index];
                                  editVendorLocationController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: (editVendorLocationController
                                            .text.length)),
                                  );
                                  setState(() {});
                                  editVendorLocationController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: (editVendorLocationController
                                            .text.length)),
                                  );
                                  if (editVendorLocationController
                                      .text.isNotEmpty) {
                                    await getSelectedVendorLocation(
                                            createTodoParamForVHistory)
                                        .then((value) {
                                      if (value.locationId != null &&
                                          value.locationId!.isNotEmpty) {
                                        selectedMultipleAddressId =
                                            value.locationId!;
                                        for (int i = 0;
                                            i <
                                                widget.multipleLocationList!
                                                    .length;
                                            i++) {
                                          if (selectedMultipleAddressId !=
                                                  null &&
                                              widget.multipleLocationList![i]
                                                      ['id'] ==
                                                  int.parse(
                                                      selectedMultipleAddressId!)) {
                                            addresses = [];
                                            editMultipleAddressList = [];
                                            addresses!.addAll(
                                                widget.multipleLocationList![i]
                                                        ['addresses'] ??
                                                    []);
                                            editMultipleAddressList.addAll(
                                                widget.multipleLocationList![i]
                                                        ['addresses'] ??
                                                    []);
                                          }
                                        }
                                        setState(() {});
                                      }
                                      setState(() {});
                                    });
                                  }
                                })),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Visibility(
                            visible: editShowMultipleVehicleList,
                            child: Utils
                                .customAutoCompleteWithUnSelectedOption(
                                editMultipleVehicleSuggestionList,
                                    (index) {
                                  editShowMultipleVehicleList = false;
                                  countHyphens('');
                                  if (findIsPersonOrVehicle(
                                      editMultipleVehicleSuggestionList[
                                      index])) {
                                    selectedMultipleVehicleList.clear();
                                    selectedMultipleVehicleList.add(
                                        editMultipleVehicleSuggestionList[
                                        index]);
                                    isSelected = true;
                                    vehiclePersonController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: (vehiclePersonController.text.length)),
                                        );
                                    setState(() {});
                                    vehiclePersonController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: (vehiclePersonController.text.length)),
                                        );
                                  } else {
                                    if (lastSelectedIsPerson) {
                                      selectedMultipleVehicleList.clear();
                                      lastSelectedIsPerson = false;
                                    }
                                    selectedMultipleVehicleList.add(
                                        editMultipleVehicleSuggestionList[index]);
                                    isSelected = true;
                                    vehiclePersonController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: (vehiclePersonController.text.length)),
                                        );
                                    setState(() {});
                                    vehiclePersonController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: (vehiclePersonController.text.length)),
                                        );
                                  }
                                },
                                isVehicleData: true)
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
                visible: editShowList,
                child: Utils.customAutoCompleteList(
                    taskIdentifierSuggestionList, (index) async {
                  editShowList = false;
                  editTodoNameController.text =
                      taskIdentifierSuggestionList[index];
                  // (taskNameList[taskIdentifierSuggestionList[index]] ?? '');
                  editTodoNameController.selection = TextSelection.fromPosition(
                    TextPosition(offset: (editTodoNameController.text.length)),
                  );
                  if (editVehiclePersonController.text.isNotEmpty) {
                    await getSelectedVehiclePersonEditF(
                            createTodoParamForVHistory)
                        .then((value) {
                      if ((value.vin != null && value.vin!.isNotEmpty) ||
                          (value.vehicleGroupId != null &&
                              value.vehicleGroupId!.isNotEmpty)) {
                        // isShowVehicleHistoryList = true;
                        // vehicleDataBloc = VehicleDataBloc();
                        vehicleDataBloc!.add(vdb.GetVehicleHistoryEvent(
                            vin: value.vin,
                            vehicleGroupId: /*value.vehicleGroupId != null ?*/
                                /*int.parse(value.vehicleGroupId??'0') :*/ null,
                            needUI: false));
                        setState(() {});
                      }
                      // else {
                      // isShowVehicleHistoryList = false;
                      // setState(() {});
                      // }

                      setState(() {});
                    });
                  }
                  setState(() {});
                  // Move the cursor to the end of the text
                  editTodoNameController.selection = TextSelection.fromPosition(
                    TextPosition(offset: (editTodoNameController.text.length)),
                  );
                })),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Utils.getAddFilledButton(
              'Update',
              () {
                doCreateEditTodo(todoName: null, time: null);
              },
              bgColor: AppC.green,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(todoItem['vehicles'].length > 1)
                  Utils.dropdownBox(
                    'Select Vehicle',
                    vehicleName,
                        (selectedValue) {
                      setState(() {
                        selectedVin = selectedValue;
                      });
                      },
                    labelKey: 'vehicle_name',
                    initialSelection: selectedVin,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => VehicleHistoryViewUI(
                          vehicleName: todoItem['vehicle_name'] ??
                              vehicle['vehicle_name']??selectedVin['vehicle_name'],
                          vin: vinToFind??selectedVin['vin'], resourceList: resourceList, userGroupList: userGroupList,
                        ),
                      ));
                    },
                    child: Utils.getText(
                      todoItem['vehicle_name'] != null
                          ? 'Task History - ${todoItem['vehicle_name']}'
                          : vehicle['vehicle_name'] != null
                          ? 'Task History - ${vehicle['vehicle_name']}'
                          : selectedVin is Map && selectedVin['vin'] != null
                          ? 'Task History - ${selectedVin['vin']}'
                          : '',
                      size: 12,
                      color: AppC().base,
                      align: TextAlign.end,
                    ),

                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            String url = '';
                            if (selectedLink['id'] == '2') {
                              url = 'https://turo.com/us/en/reservation/${todoItem['reference_id']}';
                            } else if (selectedLink['id'] == '3') {
                              url = 'https://getaround.com/dashboard/rentals/${todoItem['reference_id']}';
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
                              size: 12,
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        getRecurringDetails(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Future<void> doCreateEditTodo({String? todoName, String? time}) async {
    if (editTodoNameController.text.isEmpty) {
      Utils.showMobileToast(Str.createTodoAlertText('Task Name'));
      return;
    }
    else {
      CreateTodoParams editCreateTodoParams = CreateTodoParams();
      if (todoName == null) {
        editCreateTodoParams.userId = todoItem['id']!.toString();
      }
      editCreateTodoParams.todoTitle = todoName ?? editTodoNameController.text;
      editCreateTodoParams.todoDate = editTodoDateController.text;
      editCreateTodoParams.todoTime = todoTimeController.text;

      //editCreateTodoParams.todoTime = time??(editAllDay ? '' : todoListRepo.startTimeTFString);

      editCreateTodoParams.todoReminder = editReminder ? 'true' : 'false';

      editCreateTodoParams.priority = editSelectedPriority;
      editCreateTodoParams.notes = notesController.text;
      if (addresses != null) {
        editCreateTodoParams.multipleAddressList = selectedMultipleAddressList
            .map((e) => e['id']!)
            .cast<int>()
            .toList();
      }
      // editCreateTodoParams.resource = (selectedResource?.id ?? '').toString();
      // todoBloc!.add(EditTodoDate(null, null, widget.todoItem!.id.toString(), null, selectedResourceId, selectedResourceIdList, null));
      debugPrint('todoItem!.userId: ${todoItem['user_id'] ?? ''}');
      editCreateTodoParams.existingUserGroupId = todoItem['user_group_id'];
      if (todoItem['user_id'] != null && todoItem['user_id']!.isNotEmpty) {
        editCreateTodoParams.selectedUserId = int.parse(todoItem['user_id']!);
        editCreateTodoParams.assignedTo = [editCreateTodoParams.selectedUserId];
      } else {
        editCreateTodoParams.selectedUserGroupId =
            getSelectedResourceList(selectedUserGroupOrUser ?? resourceList).cast<int?>();
        editCreateTodoParams.assignedTo =
            editCreateTodoParams.selectedUserGroupId;
      }
      editCreateTodoParams.timeSensitive = timeSensitive ? 1 : 0;
      debugPrint(
          'existingUserGroupId: ${editCreateTodoParams.existingUserGroupId}');
      debugPrint('selectedUserId: ${editCreateTodoParams.selectedUserId}');
      debugPrint(
          'selectedUserGroupId: ${editCreateTodoParams.selectedUserGroupId}');
      if (selectedResourceIdList != null && selectedResourceIdList!.length<=1) {
        editCreateTodoParams.selectedUserId = selectedResourceId;
        editCreateTodoParams.selectedUserGroupId = null;
        editCreateTodoParams.assignedTo = selectedResourceId as List<int?>?;
      } else if (selectedResourceIdList != null && selectedResourceIdList!.length>1) {
        editCreateTodoParams.selectedUserId = null;
        editCreateTodoParams.selectedUserGroupId = selectedResourceIdList;
        editCreateTodoParams.assignedTo =
            editCreateTodoParams.selectedUserGroupId;
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
                editCreateTodoParams.partList.add(partsData);
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
                editCreateTodoParams.supplyList.add(suppliesData);
              }
            }
          }
        }
      }
      if(reservationController.text.isNotEmpty || linkController.text.isNotEmpty){
        editCreateTodoParams.customLinkId=int.parse(selectedLink['id']);
      }
      if(selectedLink['id']==1){
        editCreateTodoParams.customLink=linkController.text;
      }else if(selectedLink['id']=='2' || selectedLink['id']=='3'){
        editCreateTodoParams.referenceId=reservationController.text;
      }
      for (Map<String, dynamic> res in vendorList) {
        if ('${res['name']}' == editVendorLocationController.text.trim()) {
          editCreateTodoParams.vendorName = res['name'];
          editCreateTodoParams.vendorId = res['id']!.toString();
        }
      }
      if (editCreateTodoParams.vendorId == '') {
        for (Map<String, dynamic> veh in locationList) {
          if (veh['name'] == editVendorLocationController.text.trim()) {
            editCreateTodoParams.location = veh['name'];
            editCreateTodoParams.locationId = veh['id']!.toString();
          }
        }
      }

      for (Map<String, dynamic> res in resourceList) {
        if ('${res['first_name']} ${res['last_name']}' ==
            editVehiclePersonController.text.trim()) {
          editCreateTodoParams.person =
              '${res['first_name']} ${res['last_name']}';
          editCreateTodoParams.personId = res['id']!.toString();
        }
      }
      if (selectedMultipleVehicleList.isNotEmpty || vehiclePersonController.text.isNotEmpty) {
        await getSelectedVehiclePerson(editCreateTodoParams);
      }

      log('editCreateTodoParams.parameters: '
          'id : ${editCreateTodoParams.userId},'
          'todoTitle: ${editCreateTodoParams.todoTitle},'
          'todoDate: ${editCreateTodoParams.todoDate},'
          'todoTime: ${editCreateTodoParams.todoTime},'
          'priority: ${editCreateTodoParams.priority},'
          // 'resource: ${editCreateTodoParams.resource},'
          'selectedUserId: ${editCreateTodoParams.selectedUserId},'
          'selectedUserGroupId: ${editCreateTodoParams.selectedUserGroupId},'
          'assignedTo: ${editCreateTodoParams.assignedTo},'
          'cohortId: ${editCreateTodoParams.cohortId},'
          'cohortName: ${editCreateTodoParams.cohortName},'
          'vehicleName: ${editCreateTodoParams.vehicleName},'
          'vehicleImage: ${editCreateTodoParams.vehicleImage},'
          'vin: ${editCreateTodoParams.vin},'
          'person: ${editCreateTodoParams.person},'
          'personId: ${editCreateTodoParams.personId},'
          'vendorId: ${editCreateTodoParams.vendorId},'
          'vendorName: ${editCreateTodoParams.vendorName},'
          'locationId: ${editCreateTodoParams.locationId},'
          'location: ${editCreateTodoParams.location},'
          'todoReminder: ${editCreateTodoParams.todoReminder},'
          'vehicleGroupId: ${editCreateTodoParams.vehicleGroupId},'
          'endAfter: ${editCreateTodoParams.endAfter}');

      if ((editCreateTodoParams.selectedUserId == null ||
              editCreateTodoParams.selectedUserId == 0) &&
          (editCreateTodoParams.selectedUserGroupId == null ||
              editCreateTodoParams.selectedUserGroupId!.isEmpty)) {
        Utils.showMobileToast(Str.createTodoAlertText('Selecting Resource'));
      } else {
        todoBloc!.add(CreateTodoEvent(
            createTodoParams: editCreateTodoParams,
            exitTheScreen: todoName == null));
      }
    }
  }

  CreateTodoParams getSelectedVehiclePersonEdit(CreateTodoParams createTodoParams) {
    for (Map<String, dynamic> res in resourceList) {
      if ('${res['first_name']} ${res['last_name']}' ==
          editVehiclePersonController.text.trim()) {
        createTodoParams.person = '${res['first_name']} ${res['last_name']}';
        createTodoParams.personId = res['id']!.toString();
      }
    }
    if (createTodoParams.personId == '') {
      for (Map<String, dynamic> veh in vehicleGroupList) {
        if (veh['name'] == editVehiclePersonController.text.trim()) {
          createTodoParams.vehicleGroupId = veh['id'].toString();
          createTodoParams.vehicleGroupName = veh['name'].toString();
          createTodoParams.vehicleGroupVinNumbers = veh['vin'];
          vehicleGroupVinNumbers = veh['vin'] ?? '';
        }
      }
    }
    if (createTodoParams.vehicleGroupId == '') {
      for (Map<String, dynamic> veh in vehicleList) {
        if (veh['vehicle_name'] == editVehiclePersonController.text.trim()) {
          createTodoParams.vehicleName = veh['vehicle_name']!;
          createTodoParams.cohortId = veh['cohort_id'].toString();
          createTodoParams.vin = veh['vin'];
          createTodoParams.vehicleImage = veh['images']?[0]['path'] ?? '';
          createTodoParams.cohortName = veh['cohort']?['cohort'] ?? '';
        }
      }
    }
    /*vehicleName: createTodoParamForVHistory.vehicleName,
     vehicleGroupId: int.parse(createTodoParamForVHistory.vehicleGroupId??'0'),
     vin: createTodoParamForVHistory.vin,
     vehicleImage: createTodoParamForVHistory.vehicleImage*/
    return createTodoParams;
  }

  Future<CreateTodoParams> getSelectedVehiclePersonEditF(
      CreateTodoParams createTodoParams) async {
    for (Map<String, dynamic> res in resourceList) {
      if ('${res['first_name']} ${res['last_name']}' ==
          editVehiclePersonController.text.trim()) {
        createTodoParams.person = '${res['first_name']} ${res['last_name']}';
        createTodoParams.personId = res['id']!.toString();
      }
    }
    if (createTodoParams.personId == '') {
      for (Map<String, dynamic> veh in vehicleGroupList) {
        if (veh['name'] == editVehiclePersonController.text.trim()) {
          createTodoParams.vehicleGroupId = veh['id'].toString();
          createTodoParams.vehicleGroupName = veh['name'].toString();
        }
      }
    }
    if (createTodoParams.vehicleGroupId == '') {
      for (Map<String, dynamic> veh in vehicleList) {
        if (veh['vehicle_name'] == editVehiclePersonController.text.trim()) {
          createTodoParams.vehicleName = veh['vehicle_name']!;
          createTodoParams.cohortId = veh['cohort_id'].toString();
          createTodoParams.vin = veh['vin'];
          createTodoParams.vehicleImage = veh['images']?[0].path ?? '';
          createTodoParams.cohortName = veh['cohort']?.cohort ?? '';
        }
      }
    }
    return createTodoParams;
  }

  Future<CreateTodoParams> getSelectedVehiclePerson(CreateTodoParams editCreateTodoParams) {
    List<dynamic> vehiclesNameData=[];
    for (Map<String, dynamic> res in resourceList) {
      if (selectedMultipleVehicleList.isNotEmpty
          &&'${res['first_name']}${res['last_name']}'
              == selectedMultipleVehicleList[0]['vehicle_name']) {
        editCreateTodoParams.person = '${res['first_name']} ${res['last_name']}';
        editCreateTodoParams.personId = res['id']!.toString();
      }
      else if('${res['first_name']} ${res['last_name']}' ==
          vehiclePersonController.text.trim()){
        editCreateTodoParams.person = '${res['first_name']} ${res['last_name']}';
        editCreateTodoParams.personId = res['id']!.toString();
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
            editCreateTodoParams.vehicleList?.add(vehiclesData);
          }
        }
      }
    }
    return Future.value(editCreateTodoParams);
  }

  Future<CreateTodoParams> getSelectedVendorLocation(
      CreateTodoParams createTodoParams) {
    for (Map<String, dynamic> res in vendorList) {
      if ('${res['name']}' == editVendorLocationController.text.trim()) {
        createTodoParams.vendorName = res['name'];
        createTodoParams.vendorId = res['id']!.toString();
      }
    }
    if (createTodoParams.vendorId == '') {
      for (Map<String, dynamic> veh in locationList) {
        if (veh['name'] == editVendorLocationController.text.trim()) {
          createTodoParams.location = veh['name'];
          createTodoParams.locationId = veh['id']!.toString();
          debugPrint(
              'createTodoParams.locationId: ${createTodoParams.locationId}');
        }
      }
    }
    return Future.value(createTodoParams);
  }

  Widget getRecurringDetails() {
    return Visibility(
      visible: todoItem['recurring'] != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Utils.getText('Recurring Details', weight: FontWeight.bold),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Column(
                children: [
                  Icon(Icons.refresh),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    Utils.getText(todoItem['recurring'] ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget showBottomTabWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (todoItem['title'] != 'Check In' &&
                    todoItem['title'] != 'Check Out')
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showExpenseTab = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppC.trans,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        border: Border.all(
                          color: showExpenseTab == 0
                              ? AppC().base
                              : AppC.trans, // Set your desired border color here
                          width: 1.0, // Set the border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Utils.getText(
                          'Expense',
                            weight: FontWeight.bold,
                            color:AppC.appColor
                        ),
                      ),
                    ),
                  ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      showExpenseTab = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppC.trans,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      border: Border.all(
                        color: showExpenseTab == 1
                            ? AppC().base
                            : AppC.trans, // Set your desired border color here
                        width: 1.0, // Set the border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Utils.getText(
                        'Next Task',
                          weight: FontWeight.bold,
                          color:AppC.appColor
                      ),
                    ),
                  ),
                ),
                if (todoItem['title'] == 'Getaround Prechecks')
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showExpenseTab = 2;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppC.trans,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        border: Border.all(
                          color: showExpenseTab == 2
                              ? AppC().base
                              : AppC.trans, // Set your desired border color here
                          width: 1.0, // Set the border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Utils.getText(
                          'Check List',
                            weight: FontWeight.bold,
                            color:AppC.appColor
                        ),
                      ),
                    ),
                  ),
                if (todoItem['title'] == 'Maintenance Check')
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showExpenseTab = 3;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppC.trans,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        border: Border.all(
                          color: showExpenseTab == 3
                              ? AppC().base
                              : AppC.trans, // Set your desired border color here
                          width: 1.0, // Set the border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Utils.getText(
                          'Maintenance',
                            weight: FontWeight.bold,
                            color:AppC.appColor
                        ),
                      ),
                    ),
                  ),
                if (todoItem['title'] != 'Check In' &&
                    todoItem['title'] != 'Check Out')
                  // if(todoItem['vehicle_name'] != 'Multiple Vehicles')
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showExpenseTab = 4;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppC.trans,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        border: Border.all(
                          color: showExpenseTab == 4
                              ? AppC().base
                              : AppC.trans, // Set your desired border color here
                          width: 1.0, // Set the border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Utils.getText(
                          'Set Vehicle',
                          weight: FontWeight.bold,
                          color:AppC.red
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget checkBoxWithTwoText({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
    required String label1,
  }) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Utils.getText(label),
            Utils.getText('($label1)'),
          ],
        ),
      ],
    );
  }

  Widget checkBoxWithSingleText({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
  }) {
    return Row(
      children: [
        Transform.scale(scale: 0.8,
            child: SizedBox(height: 30,
                width: 30,
                child: Checkbox(value: value, onChanged: onChanged,activeColor: AppC.blue,))),
        Utils.getText(label,weight: FontWeight.w600),
      ],
    );
  }

  Widget checkBoxWithSingleTextAndTexBox({
    required bool checkboxValue,
    required ValueChanged<bool?> onCheckboxChanged,
    required String label,
    required Map<String, dynamic>? selected,
    required List<Map<String, dynamic>> data,
    required ValueChanged<Map<String, dynamic>?> onDropdownChanged,
  }) {
    return Row(
      children: [
        // Checkbox with label
        Checkbox(
          value: checkboxValue,
          onChanged: onCheckboxChanged,
        ),
        Utils.getText(label), // Assuming Utils.getText is a valid function
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppC.fieldBase, // Assuming AppC is a valid class
                width: Num.borderWidthField, // Assuming Num is defined
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(Num.subradiusButton), // Assuming Num is defined
              ),
            ),
            child: DropdownButton<Map<String, dynamic>>(
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Utils.getText('Not Checked', color: AppC.grey),
              ),
              value: selected,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 3,
              dropdownColor: AppC.white,
              underline: Container(height: 0, color: Colors.transparent),
              onChanged: onDropdownChanged,
              items: data.map<DropdownMenuItem<Map<String, dynamic>>>(
                (Map<String, dynamic> value) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Utils.getText('${value['expense_to']}'),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget checkList(Map<String, dynamic> checkListData) {
    bool front = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: front,
          onChanged: (bool? value) {
            setState(() {
              front = value ?? false;
            });
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Utils.getText(checkListData['title']?.toString() ?? ''),
            Utils.getText(
                "(${checkListData['description']?.toString() ?? ''})"),
          ],
        ),
      ],
    );
  }

  Widget setVehicle() {

    if (todoItem['vin'] == null) {
      if (selectedVin != null && selectedVin['vin'] != null) {
        vin = selectedVin['vin'];
      } else if (todoItem['vehicles'] is List && todoItem['vehicles'].isNotEmpty) {
        vin = todoItem['vehicles'][0]?['vin'];
      }
    } else {
      vin = todoItem['vin'];
    }
     vin ??= '';

     setVehicleList =  vehicleList.firstWhere(
            (emp) => emp['vin'] == vin,
            orElse: () => {},
          );
    addressController.text = setVehicleList['address'] ?? '';
    plateNumberController.text = setVehicleList['vehicle_number'] ?? '';
    carNumberController.text = (setVehicleList['car_number']?.toString()) ?? '';
    oilGradeController.text = setVehicleList['oil_grade'] ?? '';
    frontTireController.text = setVehicleList['front_tire'] ?? '';
    rearTireController.text = setVehicleList['rear_tire'] ?? '';
    renewalDateController.text = setVehicleList['registration_renewal_date'] ?? '';
    bouncie = setVehicleList['bouncie'] == 1;
    airTag = setVehicleList['air_tag'] == 1;
    permanentPlate = setVehicleList['permanent_plate'] == 1;
    spareTire = setVehicleList['spare_tire'] == 1;
    tollTags=setVehicleList['toll_tags']==1;
    spareKey=setVehicleList['spare_key']==1;
    frontLicensePlate=setVehicleList['front_license_plate']==1;

    tireImageFile = (setVehicleList['images'] as List<dynamic>?)
            ?.where((image) => image['vehicle_image_type'] == 2)
            .toList() ?? [];
    tollImage = (setVehicleList['images'] as List<dynamic>?)
        ?.where((image) => image['vehicle_image_type'] == 5)
        .toList() ?? [];
    uploadRegSticker = (setVehicleList['images'] as List<dynamic>?)
        ?.where((image) => image['vehicle_image_type'] == 3)
        .toList() ?? [];
    insuranceImage = (setVehicleList['images'] as List<dynamic>?)
        ?.where((image) => image['vehicle_image_type'] == 4)
        .toList() ?? [];

    void save() {
      setState(() {});

      final createVehicleData = CreateVehicleData();
      createVehicleData.id = setVehicleList['id'];
      createVehicleData.year = setVehicleList['year'];
      createVehicleData.make = setVehicleList['make'];
      createVehicleData.model = setVehicleList['model'];
      createVehicleData.vehicleNumber = setVehicleList['vehicle_number'];
      createVehicleData.vin = setVehicleList['vin'];
      createVehicleData.vehicleId = (setVehicleList['vehicle_id']??'').toString();
      createVehicleData.earnings = (setVehicleList['earnings']??'').toString();
      createVehicleData.utilizationRate = (setVehicleList['utilization_rate']??'').toString();
      createVehicleData.platform = (setVehicleList['platform']??'').toString();
      createVehicleData.mileage = (setVehicleList['mileage']??'').toString();
      createVehicleData.wholesaleAmount = (setVehicleList['wholesale_amount']??'').toString();
      createVehicleData.purchaseDate = (setVehicleList['purchase_date']??'').toString();
      createVehicleData.purchasePrice = (setVehicleList['purchase_price']??'').toString();
      createVehicleData.selectedVehicleStatus = setVehicleList['vehicle_status']??'';
      createVehicleData.address = addressController.text;
      createVehicleData.bouncie = bouncie ? 1 : 0;
      createVehicleData.airTag = airTag ? 1 : 0;
      createVehicleData.permanentPlate = permanentPlate ? 1 : 0;
      createVehicleData.spareTire = spareTire ? 1 : 0;
      createVehicleData.carNumber = carNumberController.text;
      createVehicleData.oilGrade = oilGradeController.text;
      createVehicleData.frontTire = frontTireController.text;
      createVehicleData.rearTire = rearTireController.text;
      createVehicleData.regStickerDate = renewalDateController.text;
      createVehicleData.selectedCohort = setVehicleList['cohort_id'];
      createVehicleData.chosenFiles = setVehicleList['images']
          .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
          .where((element) => element != null)
          .cast<File>()
          .toList();
      createVehicleData.chosenPurchaseReceipts = setVehicleList['expenses']['attachments']
          .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
          .where((element) => element != null)
          .cast<File>()
          .toList();
      createVehicleData.isActive = setVehicleList['active'];

      final updateVehicle = createVehicleData;
      vehicleDataBloc?.add(
        AddVehicleDataEvent(createVehicleData: updateVehicle),
      );
    }

    void savePopUpMenu(){
      showDialog(
        context: context,
        builder: (BuildContext context) {
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
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Utils.getText(
                            'Confirmation',
                            size: 18,
                            weight: FontWeight.bold,
                            color: const Color(0xff495057)
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Utils.getAddFilledButton('Save', (){
                            save();
                            Navigator.pop(context);
                          }),
                          // const SizedBox(width: 16,),
                          Utils.getAddFilledButton('Save With Spare Key Task', (){},bgColor: AppC.green),
                          // const SizedBox(width: 16,),
                          Utils.getAddFilledButton('Cancel', (){
                            Navigator.pop(context);
                          }, bgColor: AppC.redAccent),

                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );

        },

      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Utils.getText(
            setVehicleList['vehicle_name'] ?? '',
            weight: FontWeight.bold,
          ),
        ),
        Utils.getBorderedMultilineTextField(
          'Address',
          addressController,
          minLines: 3,
          fillColor: AppC.white,
          hintTextColor: AppC.grey,
          textColor: AppC.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  checkBoxWithSingleText(
                    value: bouncie,
                    onChanged: (bool? value) {
                      setState(() {
                        bouncie = value ?? false;
                        setVehicleList['bouncie'] = bouncie ? 1 : 0;
                      });
                    },
                    label: 'Bouncie',
                  ),
                  checkBoxWithSingleText(
                    value: tollTags,
                    onChanged: (bool? value) {
                      setState(() {
                        tollTags = value ?? false;
                        setVehicleList['toll_tags'] = tollTags ? 1 : 0;
                      });
                    },
                    label: 'Toll tags',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  checkBoxWithSingleText(
                    value: airTag,
                    onChanged: (bool? value) {
                      setState(() {
                        airTag = value ?? false;
                        setVehicleList['air_tag'] = airTag ? 1 : 0;
                      });
                    },
                    label: 'AirTag',
                  ),
                  checkBoxWithSingleText(
                    value: spareTire,
                    onChanged: (bool? value) {
                      setState(() {
                        spareTire = value ?? false;
                        setVehicleList['spare_tire'] = spareTire ? 1 : 0;
                      });
                    },
                    label: 'Spare Tire',
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Visibility(
                      visible: tollTags,
                      child:Utils.getTextFormField('Enter the tag id', tollTagsController) ),
                 const SizedBox(height: 10,),
                  Visibility(
                    visible: tollTags,
                    child: Container(height: 35,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppC.fieldBase,
                            width: Num.borderWidthField,
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(Num.subradiusButton))),
                      child: Utils.getOutlinedButton('Toll Image', () async {
                        await imagePickHelper
                            .getSingleImage(ImageSource.gallery)
                            .then((value) {
                          if (value != null) {
                            debugPrint('value.path: ${value.path}');
                            // Attachments ve = Attachments(
                            //     file: value, path: '');
                            tollImage.add({'file': value, 'path': ''});
                            setState(() {});
                          } else {
                            return;
                          }
                            });
                        },
                          iconData: const Icon(Icons.image,
                              color: AppC.green, size: 12),
                          verticalPadding: 0,
                          radius: BorderRadius.zero,
                          bgColor: AppC.trans,
                          borderColor: AppC.trans,
                          textColor: AppC.grey),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: tollImage.isNotEmpty,
                    child: SizedBox(
                      height: 80, // Set a height for the ListView
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tollImage.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                (tollImage[index]['path'] ?? '').isNotEmpty
                                    ? Utils.getOvalCachedImageNetworkDisplay(
                                    context, tollImage[index]['path'] ?? '')
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    File(tollImage[index]['file']?.path ?? ''),
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: InkWell(
                                    onTap: () {
                                      if ((tollImage[index]['path'] ?? '').isEmpty) {
                                        tollImage.removeAt(index);
                                      } else {
                                        // vehicleDataBloc.add(
                                        //   DeleteExpenseImage(id: images[index]['id']),
                                        //);
                                        tollImage.removeAt(index);
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppC.red.shade400,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: AppC.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Visibility(visible: spareTire,
                  child:Utils.getTextFormField('e.g.,T165/70D18', spareTireController) ),
            ),
          ],
        ),

        Row(
          children: [
            checkBoxWithSingleText(
              value: spareKey,
              onChanged: (bool? value) {
                setState(() {
                  spareKey = value ?? false;
                  setVehicleList['spare_key'] = spareKey ? 1 : 0;
                });
              },
              label: 'Spare Key',
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: checkBoxWithSingleText(
                value: permanentPlate,
                onChanged: (bool? value) {
                  setState(() {
                    permanentPlate = value ?? false;
                    setVehicleList['permanent_plate'] = permanentPlate ? 1 : 0;
                  });
                },
                label: 'Permanent Plate',
              ),
            ),
            Expanded(
              child: Visibility(visible: permanentPlate,
                  child:checkBoxWithSingleText(
                    value: frontLicensePlate,
                    onChanged: (bool? value) {
                      setState(() {
                        frontLicensePlate = value ?? false;
                        setVehicleList['front_license_plate'] = frontLicensePlate ? 1 : 0;
                      });
                    },
                    label: 'Front license plate',
                  ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(height: 35,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppC.fieldBase,
                          width: Num.borderWidthField,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Num.subradiusButton)
                        )
                    ),
                    child: Utils.getOutlinedButton('Tire Image Upload', () async {
                      await imagePickHelper
                          .getSingleImage(ImageSource.gallery)
                          .then((value) {
                        if (value != null) {
                          debugPrint('value.path: ${value.path}');
                          // Attachments ve = Attachments(
                          //     file: value, path: '');
                          tireImageFile.add({'file': value, 'path': ''});
                          setState(() {});
                        } else {
                          return;
                        }
                      });
                    },
                        iconData: const Icon(Icons.image,
                            color: AppC.green, size: 12),
                        verticalPadding: 0,
                        radius: BorderRadius.zero,
                        bgColor: AppC.trans,
                        borderColor: AppC.trans,
                        textColor: AppC.grey),
                  ),
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: tireImageFile.isNotEmpty,
                    child: SizedBox(
                      height: 80, // Set a height for the ListView
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tireImageFile.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                (tireImageFile[index]['path'] ?? '').isNotEmpty
                                    ? Utils.getOvalCachedImageNetworkDisplay(
                                    context, tireImageFile[index]['path'] ?? '')
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    File(tireImageFile[index]['file']?['path'] ?? ''),
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: InkWell(
                                    onTap: () {
                                      if ((tireImageFile[index]['path'] ?? '').isEmpty) {
                                        tireImageFile.removeAt(index);
                                      } else {
                                        // vehicleDataBloc.add(
                                        //   DeleteExpenseImage(id: images[index]['id']),
                                        //);
                                        tireImageFile.removeAt(index);
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppC.red.shade400,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: AppC.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Utils.getTextFormField(
                  'Plate Number', plateNumberController,
                  hintTextColor: AppC.grey),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: Utils.getTextFormField(
                  'Car Number', carNumberController,
                  hintTextColor: AppC.grey),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Utils.getTextFormField(
                  'Oil grade', oilGradeController,
                  hintTextColor: AppC.grey),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Utils.getTextFormField(
                  'Front tire', frontTireController,
                  hintTextColor: AppC.grey),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Utils.getTextFormField(
                  'Rear tire', rearTireController,
                  hintTextColor: AppC.grey),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Utils.getText('Reg Stick date'),

        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
             child: Column(
               children: [
                   Stack(
                    alignment: Alignment.centerRight,
                    children: [
                       Utils.getTextFormField(
                        'Date',
                        renewalDateController,
                        hintTextColor: AppC.grey,
                        suffixIcon: const Icon(
                          Icons.date_range,
                          color: AppC.appColor,
                          size: 15,
                        ),
                        readOnly: true,
                        onTapCallback: () {
                          Utils.todoDatePickerDialog(context, '',
                                  initial: DateTime.parse(renewalDateController.text))
                              .then((value) {
                            if (value != null) {
                              renewalDateController.text =
                                  Utils.convertDateTimeToTheFormat(value.toString());
                            }
                          });
                        },
                      ),
                    ],
                  ),
               ],
             ),
           ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(height: 35,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppC.fieldBase,
                          width: Num.borderWidthField,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Num.subradiusButton))),
                    child: Utils.getOutlinedButton('Upload Reg Sticker', () async {
                      await imagePickHelper
                          .getSingleImage(ImageSource.gallery)
                          .then((value) {
                        if (value != null) {
                          debugPrint('value.path: ${value.path}');
                          // Attachments ve = Attachments(
                          //     file: value, path: '');
                          uploadRegSticker.add({ 'file': value,
                            'path': '',});
                          debugPrint('uploadRegSticker: ${uploadRegSticker}');
                          setState(() {});
                        } else {
                          return;
                        }
                      });
                    },
                        iconData: const Icon(Icons.image,
                            color: AppC.green, size: 10),
                        verticalPadding: 0,
                        radius: BorderRadius.zero,
                        bgColor: AppC.trans,
                        borderColor: AppC.trans,
                        textColor: AppC.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: uploadRegSticker.isNotEmpty,
              child: SizedBox(
                height: 80, // Set a height for the ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: uploadRegSticker.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      key: ValueKey(uploadRegSticker[index]['id']),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          (uploadRegSticker[index]['path'] ?? '').isNotEmpty
                              ? Utils.getOvalCachedImageNetworkDisplay(
                                  context, uploadRegSticker[index]['path'] ?? '')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    File(uploadRegSticker[index]['file']
                                        ?.path ?? ''),
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: InkWell(
                              onTap: () {
                                if ((uploadRegSticker[index]['path'] ?? '').isEmpty) {
                                  uploadRegSticker.removeAt(index);
                                } else {
                                  // vehicleDataBloc.add(
                                  //   DeleteExpenseImage(id: images[index]['id']),
                                  //);
                                  uploadRegSticker.removeAt(index);
                                }
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppC.red.shade400,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.delete_outline_outlined,
                                  color: AppC.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Utils.getTextFormField(
                'Insurance Agent',
                insuranceAgentController
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(child: Utils.getTextFormField(
                'Insurance Cost',
                insuranceCostController
            ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        Container(height: 35,
          decoration: BoxDecoration(
              border: Border.all(
                color: AppC.fieldBase,
                width: Num.borderWidthField,
              ),
              borderRadius: const BorderRadius.all(
                  Radius.circular(Num.subradiusButton))),
          child: Utils.getOutlinedButton('Insurance Image', () async {
            await imagePickHelper
                .getSingleImage(ImageSource.gallery)
                .then((value) {
              if (value != null) {
                debugPrint('value.path: ${value.path}');
                // Attachments ve = Attachments(
                //     file: value, path: '');
                insuranceImage.add({'file': value, 'path': ''});
                setState(() {});
              } else {
                return;
              }
            });
          },
              iconData: const Icon(Icons.image,
                  color: AppC.green, size: 12),
              verticalPadding: 0,
              radius: BorderRadius.zero,
              bgColor: AppC.trans,
              borderColor: AppC.trans,
              textColor: AppC.grey),
        ),
        Visibility(
          visible: insuranceImage.isNotEmpty,
          child: SizedBox(
            height: 80, // Set a height for the ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: insuranceImage.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      (insuranceImage[index]['path'] ?? '').isNotEmpty
                          ? Utils.getOvalCachedImageNetworkDisplay(
                          context, insuranceImage[index]['path'] ?? '')
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(
                          File(insuranceImage[index]['file']?.path ?? ''),
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: InkWell(
                          onTap: () {
                            if ((insuranceImage[index]['path'] ?? '').isEmpty) {
                              insuranceImage.removeAt(index);
                            } else {
                              // vehicleDataBloc.add(
                              //   DeleteExpenseImage(id: images[index]['id']),
                              //);
                              insuranceImage.removeAt(index);
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppC.red.shade400,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.delete_outline_outlined,
                              color: AppC.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: Utils.getAddFilledButton(
                'Save',
                () {
                  savePopUpMenu();
                },
                bgColor: AppC.green,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );

  }

// Widget maintenance(Map<String, dynamic> maintenanceCheckListData) {
//   bool check = false;
// TextEditingController notesController=TextEditingController();
//   // Assuming 'children' is a List<dynamic>
//   var children = maintenanceCheckListData['children'] as List<dynamic>;
//
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Display the 'name' field from maintenanceCheckListData
//       Utils.getText(
//         maintenanceCheckListData['name']?.toString() ?? '',
//         weight: FontWeight.bold,
//       ),
//
//       // Loop through the children list or manually add checkboxes for specific indices
//       for (var i = 0; i < children.length; i++)
//         checkBoxWithSingleTextAndTexBox(
//           checkboxValue: check,
//           onCheckboxChanged: (bool? value) {
//             setState(() {
//               check = value ?? false;
//             });
//           },
//           label: children[i]['name']?.toString() ?? 'Default Label',
//           selected: {}, data: [], onDropdownChanged: (Map<String, dynamic>? value) {  },
//         ),
//     ],
//   );
// }

  String getTextBeforeCursor() {
    TextSelection selection = taskIdentifierController.selection;
    int cursorPosition = selection.baseOffset;
    String text = taskIdentifierController.text;
    if (cursorPosition > 0 && cursorPosition <= text.length) {
      // Retrieve the text before the cursor position
      return text.substring(0, cursorPosition);
    } else {
      return '';
    }
  }

  int countHyphens(String inputString) {
    // Split the string into a list based on hyphen
    List<String> stringArrLocal = inputString.split("-");

    // Count the number of parts in the list (which is the number of hyphens + 1)
    int hyphenCount = stringArrLocal.length - 1;
    stringArr = taskIdentifierController.text.split("-");

    return hyphenCount;
  }
  TextEditingController milesController=TextEditingController();
  bool isPartChecked = false;
  bool isSupplyChecked = false;
  int? availCar;
  CleanCarTimeValues? selectedCleanCarTime;
  List<CleanCarTimeValues> cleanCarTimeValuesList = [];

  Widget getPartSupplyCheckBoxRow() {
    return Row(
      children: [
        Row(
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
          ],
        ),
      ],
    );
  }

  Widget getDetailsInWraps(List<String> list, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8,),
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

  List<dynamic> getSelectedResourceList(
      List<Map<String, dynamic>> resourceList) {
    userGroupConcatenationName = '';
    return resourceList
        .where((element) =>
            (isSelected ?? false) &&
            (element['id'] != null) &&
            (element['id'] != -1) &&
            (element['id'] != 0))
        .map((e) {
      userGroupConcatenationName = '${userGroupConcatenationName ?? ''},'
          ' ${e['first_name'][0].toUpperCase()}'
          '${e['last_name'][0].toUpperCase()}';
      return e['id'] ?? 0;
    }).toList();
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
                    vehicleDataBloc!.add(vdb.CompleteTodoItemVeh(
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
                              (vehicleGroupId != null && vehicleGroupId != 0),
                          child: InkWell(
                              onTap: () {},
                              child: isPartsEdit!
                                  ? getDetailsInWraps(
                                      (todos['parts'] ?? [])
                                          .map((e) => (e['parts_name'] ?? ''))
                                          .toList(),
                                      '')
                                  : isSupplyEdit!
                                      ? getDetailsInWraps(
                                          (todos['supplies'] ?? [])
                                              .map((e) =>
                                                  (e['supply_name'] ?? ''))
                                              .toList(),
                                          '')
                                      : isVehicleGroupEdit!
                                          ? getDetailsInWraps(
                                              (vehicleGroupLists ?? [])
                                                  .map((e) =>
                                                      (e['vehicle_name'] ?? '')
                                                          as String)
                                                  .toList(),
                                              vehicleGroupName ?? '')
                                          : Utils.getText('')
                              // : Utils.getText(''),
                              ),
                        ),
                      ),
                      Visibility(
                        visible: isPartsEdit! ||
                            isSupplyEdit! ||
                            isVehicleGroupEdit!,
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
                        visible: (todos['supplies'] ?? []).isNotEmpty,
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
                              child: Utils.getText(
                                  todos['notes'] != null &&
                                          todos['notes'] != 'null'
                                      ? ' (${todos['notes'] ?? ''}) '
                                      : '',
                                  overFlow: TextOverflow.ellipsis,
                                  color: textColors!),
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

  void show(BuildContext context, String message, String status) {
    overlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16.0,
        left: MediaQuery.of(context).size.width * 0.1,
        child: ToastWidget(message, () {
          if (overlay != null) {
            overlay?.remove();
          }
          vehicleDataBloc!.add(
              vdb.CompleteTodoItemVeh(todoId: lastEditedId, status: status));
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
