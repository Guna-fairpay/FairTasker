
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fairpytasker/Response/create_expense_field_data.dart';
import 'package:fairpytasker/Response/create_todo_params.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/vehicle_expense_add_ui.dart';
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
import '../../Component/bottom_nav_for_task.dart';
import '../../Response/todo_list_response.dart';
import '../Manage Custom Data/Parts/part_view_ui.dart';
import '../Vehicle/vehicle_history_module_ui.dart';
import '../Vehicle/vehicle_history_view_ui.dart';
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
  Set<int> selectedIndices = {};

  TodoViewBloc? todoBloc;
  vdb.VehicleDataBloc? vehicleDataBloc;
  late Map<String, dynamic> todoItem;
  bool showMore = false;
  ImagePickHelper imagePickHelper = ImagePickHelper();
  List<Map<String, dynamic>> attachmentImage = [];
  List<dynamic> imagePath = [];
  final FocusNode searchFocusNode = FocusNode();
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
  dynamic existingExpenseDate;
  TextEditingController durationController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  DateTime? editSelectedDate = DateTime.now();
  String? selectedPriority;
  String? editSelectedPriority;
  String? selectedRepeat;
  Color appBarColor = AppC.lowP;
  String appBarTitle = 'Edit Todo';

  List<String> priorityList = ['High - On Time', 'Medium', 'Low', 'Feature'];
  List<String> repeatList = [
    "Doesn't repeat",
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly'
  ];
  bool completeAllDay = false;
  bool allDay = false;
  bool editAllDay = false;
  bool reminder = false;
  bool editReminder = false;
  List<Map<String, dynamic>> selectedAssignedTo = [];
  TodoListRepo todoListRepo = TodoListRepo();
  TodoListRepo editTodoListRepo = TodoListRepo();
  List<Map<String, dynamic>> resourceList = [];
  Map<String, dynamic>? selectedResource;
  List<Map<String, dynamic>> resourceListForCombination = [];
  List<Map<String, dynamic>> selectedPartsList = [];

  TextEditingController editSuppliesController = TextEditingController();
  List<Map<String, dynamic>> selectedSuppliesList = [];
  List<dynamic> editSuppliesSuggestionList = [];
  List<Map<String, dynamic>> editSuppliesList = [];
  bool editShowSuppliesList = false;

  TextEditingController editMultipleAddressController = TextEditingController();
  List<Map<String, dynamic>> selectedMultipleAddressList = [];
  List<dynamic> editMultipleAddressSuggestionList = [];
  List<Map<String, dynamic>> editMultipleAddressList = [];
  bool editShowMultipleAddressList = false;
  // bool isShowMultipleAddressField = false;
  String? selectedMultipleAddressId;
  late int partId;
  int? suppliesId;
  CreateExpenseFieldData? createExpenseFieldData;
  dynamic selectedCohort;
  dynamic selectedVehicle;
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
  List<Map<String, dynamic>> vendorList = [];
  List<Map<String, dynamic>> taskExpenseList = [];
  List<Map<String, dynamic>> locationList = [];
  List<String> taskIdentifierSuggestionList = [];
  List<String> vehiclePersonSuggestionList = [];
  List<Map<String, dynamic>> vehicleGroupList = [];
  List<String> vendorLocationSuggestionList = [];
  List<dynamic> editPartsSuggestionList = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> editPartsList = [];
  TextEditingController taskIdentifierController = TextEditingController();
  TextEditingController vehiclePersonController = TextEditingController();
  TextEditingController vendorLocationController = TextEditingController();
  Map<String, String> taskNameList = {};
  bool showAutoComplete = false;
  List<Map<String, dynamic>> cohortsData = [];
  List<Map<String, dynamic>> categoriesData = [];
  List<Map<String, dynamic>> subCategoriesData = [];
  dynamic selectedExpenseCategories;
  dynamic selectedExpenseSubCategories;
  int position = 0;
  int count = 0;
  int cursorPosition = 0;
  int? showExpenseTab;
  String endDateModuleString = "End Date";
  bool endDateSwitch = true;
  TextEditingController endDateController = TextEditingController();
  TextEditingController noOfOccurrencesController = TextEditingController();
  DateTime? endSelectedDate = DateTime.now();
  TextEditingController occurEveryDayController = TextEditingController();
  TextEditingController occurEveryWeekController = TextEditingController();
  List<String> daysList = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<String> monthsList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<DaysPojo> daysPojoList = [];
  List<MonthsPojo> monthsPojoList = [];
  MonthsPojo? selectedMonth = MonthsPojo();
  bool occurrenceDate = true;
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController dayMonthlyController = TextEditingController();
  TextEditingController dayYearlyController = TextEditingController();
  static List<String> stringArr = [];
  int? selectedResourceId;
  List<int?>? selectedResourceIdList;
  bool isShowVehicleHistoryList = false;
  CreateTodoParams createTodoParamForVHistory = CreateTodoParams();
  List<Map<String, dynamic>> todoList = [];
  String expenseIds = '';
  String editedExpenseId = '';
  int expenseIdsCount = 0;
  int? editedExpenseIdsLength;
  bool timeSensitive = false;
  DateTime? modifiedDateTime;
  TextEditingController reservationController = TextEditingController();
  List<Map<String, dynamic>>? addresses;
  List<Map<String, dynamic>>? vehicleLists;
  String? userGroupConcatenationName;
  String? userShortName;
  List<String>? vehicleGroupVinNumbersList;
  String? vehicleGroupName;
  Color? textColors;
  List<Map<String, dynamic>>? selectedUserGroupOrUser;
  String? vehicleGroupVinNumbers;
  bool? isVehicleEdit;
  bool? isPartsEdit;
  bool? isSupplyEdit;
  bool? isMultipleVehicleEdit;
  bool? isMultipleAddressEdit;
  bool? isVendorEdit;
  bool? isVehicleGroupEdit;
  bool? isNotesEdit;
  int? vehicleGroupId;
  List<Map<String, dynamic>>? vehicleGroupLists;
  bool? isSelected = false;
  bool? partIsSelected = false;
  bool? suppliesIsSelected = false;
  int? deleteId;
  List<Map<String, dynamic>> checkListData = [];
  bool showContainer = false;
  List<Map<String, dynamic>> userGroupList = [];
  TextEditingController addressController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController oilGradeController = TextEditingController();
  TextEditingController frontTireController = TextEditingController();
  TextEditingController rearTireController = TextEditingController();
  TextEditingController renewalDateController = TextEditingController();
  List<dynamic> imageFile = [];
  List<dynamic> tireImageFile = [];
  bool Bouncie = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  List<Map<String, dynamic>> maintenanceCheckListData = [];
  List<Map<String, dynamic>> childrenData = [];
  final GlobalKey _key = GlobalKey();
  final GlobalKey key = GlobalKey();
  List<dynamic> selectedMultipleVehicleList = [];
  List<Map<String, dynamic>> editMultipleVehicleList = [];
  List<dynamic> editMultipleVehicleSuggestionList = [];
  bool editShowMultipleVehicleList = false;
  bool? isVehicleSelected = false;
  String? vinToFind;
  List<String> vinList=[];
  Map<String, dynamic>? vehicle;
  List<Map<String, dynamic>> customTaskOptions = [
    { 'id': "1", 'label': "Custom Link" },
    { 'id': "2", 'label': "Turo Reservation ID" },
    { 'id': "3", 'label': "Getaround ReservationID"},
  ];
  dynamic selectedLink;
  dynamic selectedVin;
  TextEditingController linkController = TextEditingController();
  TextEditingController spareTireController = TextEditingController();
  TextEditingController tollTagsController = TextEditingController();
  TextEditingController insuranceAgentController = TextEditingController();
  TextEditingController insuranceCostController = TextEditingController();
  bool tollTags = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  TextEditingController reasonController = TextEditingController();
  List<Map<String, dynamic>> vehicleName=[];
  List<Map<String, dynamic>> sentiments = [
    {'name':'Positive'},
    {'name':'Neutral'},
    {'name':'Negative'}
  ];
  dynamic selectedSentiments;
  Map<String,dynamic>? carName;
  List<Map<String, dynamic>> todoImages = [];
  PageController pageController=PageController();




  /*int checkCleanCarAvailEdit() {
    debugPrint(
        'editSelectedDate.isAfter: ${editSelectedDate!.isAfter(DateTime.now())}');
    debugPrint(
        'contains(dropcar): ${(editTodoNameController.text.toLowerCase().contains('dropcar') || editTodoNameController.text.toLowerCase().contains('drop car'))}');
    // if (todoListRepo!.vehicleHistoryTempSearchList.isNotEmpty) {
    // debugPrint('cleancar: ${(todoListRepo!.vehicleHistoryTempSearchList)[1].title ?? ''}');
    // debugPrint('cleancar.status: ${(todoListRepo!.vehicleHistoryTempSearchList)[1].status ?? ''}');
    // }
    if (!editSelectedDate!.isAfter(DateTime.now())) {
      if (editTodoNameController.text.toLowerCase().contains('drop car') ||
          editTodoNameController.text.toLowerCase().contains('drop car')) {
        if (todoListRepo.vehicleHistoryTempSearchList
            .isNotEmpty *//* && todoListRepo.vehicleHistoryTempSearchList.length>1*//*) {
          Map<String, dynamic> lastItem =
              todoListRepo.vehicleHistoryTempSearchList.lastWhere(
                  (item) => Utils.convertStringToDateTime(item['todo_date'])
                      .isBefore(editSelectedDate!),
                  orElse: () => {});
          //Todos(id: -1));
          if (lastItem['id'] != -1 &&
                  lastItem['title']?.toLowerCase() ==
                      'clean car' *//* &&
            todoListRepo!.vehicleHistoryTempSearchList[0].status == 'Completed'*//*
              ) {
            debugPrint(
                'todoListRepo!.chosenDateTime: ${todoListRepo.chosenDateTime}');
            modifiedDateTime = todoListRepo.chosenDateTime!
                .subtract(Duration(minutes: selectedCleanCarTime!.minutes!));
            debugPrint('modifiedDateTime: $modifiedDateTime');

            return 1;
          } else {
            debugPrint(
                'todoListRepo!.chosenDateTime: ${todoListRepo.chosenDateTime}');
            modifiedDateTime = todoListRepo.chosenDateTime!
                .subtract(Duration(minutes: selectedCleanCarTime!.minutes!));
            debugPrint('modifiedDateTime: $modifiedDateTime');

            return 2;
          }
        }
      }
    }
    return 0;
  }*/

  bool lastSelectedIsPerson = false;
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
        //   todos.selectedUserGroupOrUser!.add(res);
        } else {
          isSelected = false;
          // todos.selectedUserGroupOrUser!.add(res);
        }
      }
      userShortName = '${todos['users']?['first_name']?[0].toUpperCase()}'
          '${todos['users']?['last_name']?[0].toUpperCase()}';
      return Utils.getText(userShortName ?? '',
          color: AppC().base, weight: FontWeight.bold);
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
    todoItem = widget.todoItem;

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

    debugPrint('todoItem!.vendorName: ${todoItem['vendor_name'] ?? ''}');
    debugPrint('todoItem!.location: ${todoItem['location'] ?? ''}');

    if (todoItem['vendor_name'] != null &&
        todoItem['vendor_name']!.isNotEmpty) {
      editVendorLocationController.text = todoItem['vendor_name'] ?? '';
    } else {
      editVendorLocationController.text = todoItem['location'] ?? '';
    }

    debugPrint('todoItem!.notes: ${todoItem['notes'] ?? ''}');
    debugPrint('todoItem!.parts.length: ${todoItem['parts']?.length ?? 0}');
    debugPrint('todoItem!.priority: ${todoItem['priority'] ?? ''}');

    debugPrint('todoItem!.todoDate: ${todoItem['todo_date'] ?? ''}');
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
        print('VIN-----${vinList}');
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
          (item) => item['id'] == '2',
      orElse: () => {},
    );
    reasonController.addListener(() {
      setState(() {}); // Trigger a rebuild to update the button color
    });
    if (todoItem['vehicles'] is List) {
      vehicleName.addAll(List<Map<String, dynamic>>.from(todoItem['vehicles']));
    }

    if (todoItem['todoimages'] != null && todoItem['todoimages'] is List) {
      todoImages.addAll((todoItem['todoimages'] as List).cast<Map<String, dynamic>>());
    } else {
      print('Invalid data: ${todoItem['todoimages']}');
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
    print('Parsed URI: $uri');
    try {
      if (await canLaunchUrl(uri)) {
        print('Launching URL: $uri');
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        print('URL launched successfully');
      } else {
        print('Cannot launch URL: $uri');
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Widget _buildTimeField(
      String label, TextEditingController controller, Function onTapCallback) {
    return Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                          return InteractiveViewer(
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
                    print("--------------------------$imagePath");
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

                                Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                                    'Enter a reason',
                                    reasonController ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Utils.getFilledButton(
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
                                      bgColor: (reasonController.text.isNotEmpty) ? AppC.blue : AppC.blue.withOpacity(0.5),
                                    ),
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
                    }
                    if(vinList.isNotEmpty) {
                      selectedVin = vehicleName.firstWhere(
                        (emp) => emp['vin'] == vinList[0],
                        orElse: () => {},
                      );
                    }
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
                              child: showBottomTabWidget(),
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
                                    child: ExpenseAddUI(showHeader: false)),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        child: MaintenanceCheckListUI(
                                          maintenance: maintenanceCheckListData,
                                        )),
                                  ],
                                ),
                              )
                            else if (showExpenseTab == 4)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: setVehicle(),
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
                        visible: state is TodoListLoading ||
                            state is vdb.VehicleDataLoading,
                        child:
                            Center(child: Utils.getProgressIndicator(context)))
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
                  Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                    contentPadding:
                        const EdgeInsets.only(right: 21, left: 10),
                    '',
                    editTodoDateController,
                    readOnly: true,
                    onTapCallback: () {
                      Utils.todoDatePickerDialog(context, '').then((value) {
                        editSelectedDate = value;
                        editTodoDateController.text =
                            Utils.convertDateTimeToTheFormats(
                                value.toString());
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 3.0),
                    child: Icon(
                      Icons.calendar_month,
                      size: 16,
                      color: AppC.appColor,
                    ),
                  )
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
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTapDown: (TapDownDetails? details) async {
                if (details != null) {
                  setState(() {
                    final dynamic userId = widget.todoItem['users']?['id'];
                    final dynamic userGroupId = widget.todoItem['user_group_id'];
                    selectedIndices = <int>{};
                    if (userId != null) {
                      selectedIndices.addAll(resourceList
                          .asMap()
                          .entries
                          .where((entry) => entry.value['id'] == userId)
                          .map((entry) => entry.key));
                    }
                    if (userGroupId != null) {
                      selectedIndices.addAll(userGroupList.asMap().entries.where((entry) {
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
                                    // Close icon
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(bottom: 8.0),
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
                                          final isSelected =
                                          selectedIndices.contains(index);
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedIndices.remove(index);
                                                  // widget.todoItem['users'] =
                                                  // resourceList[index];
                                                } else {
                                                  selectedIndices.add(index);

                                                  widget.todoItem['users'] =
                                                  resourceList[index];
                                                  print(resourceList[index]);
                                                }
                                              });
                                              this.setState(() {});
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 2.0),
                                              child: Container(
                                                color: isSelected
                                                    ? Colors.blue
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
                                    const SizedBox(height: 8),
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
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Utils.getBackgroundFilledTextFieldFirstLetterCaps(
          'Task Name',
          editTodoNameController,
          readOnly: false,
          onChangeCallback: (value) {
            taskIdentifierSuggestionList.clear();
            List vehiclePersonList =
                taskExpenseList.map((e) => e['task'] ?? '').toList();
            taskIdentifierSuggestionList
                .addAll(Utils.searchList(vehiclePersonList, value));
            editShowList = taskIdentifierSuggestionList.isNotEmpty;
            setState(() {});
          },
          /*suffixIcon: Visibility(
              // visible: !editShowPartsList,
              child: InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TaskViewUI(),
                    ));
                  },
                  child: Icon(Icons.add, color: AppC().base, size: 20)),
            )*/
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
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
                                    backgroundColor: Colors.green[200],
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
                        Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                                                    /*suffixIcon: Visibility(
                        visible: !editShowVehiclePersonList,
                        child: InkWell(
                            onTapDown: (details) {
                              Utils.showStringPopupMenu(
                                  context, ['Add Vehicle', 'Add Person'], details,
                                  (value) async {
                                if (value == 'Add Vehicle') {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => const VehicleUIs(),
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
                                                    )*/
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
                          Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                            'Vendor / Location',
                            editVendorLocationController,
                            readOnly: false,
                            onChangeCallback: (value) {
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
                              setState(() {});
                            },
                            /* suffixIcon: Visibility(
                              visible: !editShowVendorLocationList,
                              child: InkWell(
                                  onTapDown: (details) {
                                    Utils.showStringPopupMenu(
                                        context,
                                        ['Add Vendor', 'Add Location'],
                                        details, (value) async {
                                      if (value == 'Add Vendor') {
                                        await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const VendorViewUI(),
                                        ));
                                      } else {
                                        await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const LocationViewUI(),
                                        ));
                                      }
                                    });
                                  },
                                  child: Icon(Icons.add,
                                      color: AppC().base, size: 20)),
                            )*/
                          ),
                        Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                                                              Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                                                                'Link',
                                                                linkController
                                                              ): Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                                                    child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                      child: Chip(
                                                        // deleteIconColor: AppC.red,
                                                        onDeleted: () {
                                                          for (var element in editPartsList) {
                                                            if (element['id'] == selectedPartsList[idx]['id']) {
                                                              partIsSelected = false;
                                                            }
                                                          }
                                                          if (partId != null &&
                                                              partId != 0) {
                                                            todoBloc!.add(
                                                                DeletePartsEvent(partsId: partId));
                                                          }
                                                          selectedPartsList
                                                              .removeAt(idx);
                                                          setState(() {});
                                                        },
                                                        deleteIcon: const Icon(
                                                          Icons.close,
                                                          color: AppC.red,
                                                          size: 18,
                                                        ),
                                                        backgroundColor: AppC()
                                                            .bottomIconColor
                                                            .withOpacity(0.1),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                        // side: BorderSide(),
                                                        label: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Utils.getText(
                                                                selectedPartsList[idx]['name'] ?? '',
                                                                color: AppC.text),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              ).toList(),
                                            ),
                                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                      horizontal: 5.0),
                                                              child: Chip(
                                                                // deleteIconColor: AppC.red,
                                                                onDeleted: () {
                                                                  for (var element in editSuppliesList) {
                                                                    if (element['id'] == selectedSuppliesList[idx]['id']) {
                                                                      suppliesIsSelected = false;
                                                                    }
                                                                  }
                                                                  if (suppliesId != null &&
                                                                      suppliesId != 0) {
                                                                    todoBloc!.add(DeleteSupplyEvent(
                                                                      suppliesId:suppliesId,)
                                                                    );
                                                                  }
                                                                  selectedSuppliesList.removeAt(idx);
                                                                  setState(() {});
                                                                },
                                                                deleteIcon: const Icon(
                                                                  Icons.close,
                                                                  color: AppC.red,
                                                                  size: 18,
                                                                ),
                                                                backgroundColor: AppC()
                                                                    .bottomIconColor
                                                                    .withOpacity(0.1),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5)
                                                                ),
                                                                // side: BorderSide(),
                                                                label: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Utils.getText(
                                                                        selectedSuppliesList[idx]['name'] ?? '',
                                                                        color: AppC.text
                                                                    ),
                                                                  ],
                                                                ),
                                                              ));
                                                        },
                                                      ).toList(),
                                                    ),
                                                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                                                                await Navigator.of(
                                                                        context)
                                                                    .push(
                                                                        MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const SuppliesViewUI(),
                                                                ));
                                                              },
                                                              child: Icon(
                                                                  Icons.add,
                                                                  color: AppC()
                                                                      .base,
                                                                  size: 20)),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      /*  Visibility(
                                          visible: addresses != null &&
                                              addresses!.isNotEmpty,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 4,
                                                    left: 8,
                                                    right: 8,
                                                    bottom: 4),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: AppC.fieldBase,
                                                      width: Num.borderWidthField,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(Num.radiusButton)
                                                        ),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Wrap(
                                                      children:
                                                          List<Widget>.generate(
                                                        (selectedMultipleAddressList.length),
                                                        (int idx) {
                                                          return Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(horizontal: 5.0),
                                                              child: Chip(
                                                                // deleteIconColor: AppC.red,
                                                                onDeleted: () {
                                                                  for (var element
                                                                      in editMultipleAddressList) {
                                                                    if (element['id'] == selectedMultipleAddressList[idx]['id']) {
                                                                      isSelected = false;
                                                                    }
                                                                  }
                                                                  */
                                        /*if (selectedMultipleAddressList[idx]
                                                                              .deleteId !=
                                                                          null &&
                                                                      selectedMultipleAddressList[idx]
                                                                              .deleteId !=
                                                                          0) {
                                                                    todoBloc!.add(DeletePartsOrSupplyEvent(
                                                                        selectedMultipleAddressList[idx]
                                                                            .deleteId,
                                                                        'address'));
                                                                  }*/
                                        /*
                                                                  selectedMultipleAddressList
                                                                      .removeAt(
                                                                          idx);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                deleteIcon:
                                                                    const Icon(
                                                                  Icons.close,
                                                                  color:
                                                                      AppC.red,
                                                                  size: 18,
                                                                ),
                                                                backgroundColor: AppC()
                                                                    .bottomIconColor
                                                                    .withOpacity(
                                                                        0.1),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                // side: BorderSide(),
                                                                label: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Utils.getText(
                                                                        selectedMultipleAddressList[idx]['address'] ?? '',
                                                                        color: AppC.text
                                                                    ),
                                                                  ],
                                                                ),
                                                              ));
                                                        },
                                                      ).toList(),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                                                      'Address',
                                                      editMultipleAddressController,
                                                      label: Utils.getText('Address'),
                                                      readOnly: false,
                                                      onChangeCallback:
                                                          (value) {
                                                        editMultipleAddressSuggestionList
                                                            .clear();
                                                        List<dynamic>
                                                            supplyList =
                                                            editMultipleAddressList */
                                        /*.map((e) =>'${e.name}').toList()*//*;
                                                        editMultipleAddressSuggestionList
                                                            .addAll(Utils
                                                                .searchObjectList(
                                                                    supplyList,
                                                                    value,
                                                                    isAddress:
                                                                        true));
                                                        editShowMultipleAddressList =
                                                            editMultipleAddressSuggestionList
                                                                .isNotEmpty;
                                                        setState(() {});
                                                      },
                                                      suffixIcon: Visibility(
                                                        visible:
                                                            !editShowMultipleAddressList,
                                                        child: InkWell(
                                                            onTap: () async {
                                                              await Navigator.of(
                                                                      context)
                                                                  .push(
                                                                      MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const LocationViewUI(),
                                                              ));
                                                            },
                                                            child: Icon(
                                                                Icons.add,
                                                                color:
                                                                    AppC().base,
                                                                size: 20)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),*/
                                       /* Visibility(
                                            visible:
                                                editShowMultipleAddressList,
                                            child: Utils
                                                .customAutoCompleteWithUnSelectedOption(
                                                    editMultipleAddressSuggestionList,
                                                    (index) {
                                              editShowMultipleAddressList =
                                                  false;
                                              countHyphens('');
                                              selectedMultipleAddressList.add(
                                                  editMultipleAddressSuggestionList[
                                                      index]);
                                              editMultipleAddressSuggestionList[
                                                      index]
                                                  .isSelected = true;
                                              editMultipleAddressController
                                                      .selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        (editMultipleAddressController
                                                            .text.length)),
                                              );
                                              setState(() {});
                                              editMultipleAddressController
                                                      .selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        (editMultipleAddressController
                                                            .text.length)),
                                              );
                                            }, isAddress: true)),*/
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
                                                                child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                                  Utils
                                      .getBackgroundFilledTextFieldFirstLetterCaps(
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
                                        // locationDataBloc!.add(const GetAddedLocationListData());
                                        // debugPrint('todoItem!.addresses.length: ${todoItem!.addresses!.length}');
                                        setState(() {});
                                      } /*else {
                  isShowMultipleAddressField = false;
                  setState(() {});
                }
*/
                                      setState(() {});
                                    });
                                  }
                                })),
                          ],
                        ),
                      ],
                    ),
                    // Visibility(
                    //     visible: editShowVehiclePersonList,
                    //     child: Utils.customAutoCompleteWithUnSelectedOption(
                    //         vehiclePersonSuggestionList, (index) {
                    //       editShowVehiclePersonList = false;
                    //       countHyphens('');
                    //       if (findIsPersonOrVehicle(
                    //           vehiclePersonSuggestionList[index] as Map<String, dynamic>)) {
                    //         selectedMultipleVehicleList.clear();
                    //         selectedMultipleVehicleList
                    //             .add(editMultipleVehicleSuggestionList[index]);
                    //         isSelected = true;
                    //         vehiclePersonController.selection =
                    //             TextSelection.fromPosition(
                    //               TextPosition(
                    //                   offset: (vehiclePersonController.text.length)),
                    //             );
                    //         setState(() {});
                    //         vehiclePersonController.selection =
                    //             TextSelection.fromPosition(
                    //               TextPosition(
                    //                   offset: (vehiclePersonController.text.length)),
                    //             );
                    //       } else {
                    //         if (lastSelectedIsPerson) {
                    //           selectedMultipleVehicleList.clear();
                    //           lastSelectedIsPerson = false;
                    //         }
                    //         selectedMultipleVehicleList
                    //             .add(editMultipleVehicleSuggestionList[index]);
                    //         isSelected = true;
                    //         vehiclePersonController.selection =
                    //             TextSelection.fromPosition(
                    //               TextPosition(
                    //                   offset: (vehiclePersonController.text.length)),
                    //             );
                    //         setState(() {});
                    //         vehiclePersonController.selection =
                    //             TextSelection.fromPosition(
                    //               TextPosition(
                    //                   offset: (vehiclePersonController.text.length)),
                    //             );
                    //       }
                    //     }, isVehicleData: true)),

                    Visibility(
                        visible: editShowVehiclePersonList,
                        child: Utils.customAutoCompleteList(
                            vehiclePersonSuggestionList, (index) async {
                          editShowVehiclePersonList = false;
                          countHyphens('');
                          editVehiclePersonController.text =
                              vehiclePersonSuggestionList[index];
                          editVehiclePersonController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset:
                                    (editVehiclePersonController.text.length)),
                          );
                          if (editVehiclePersonController.text.isNotEmpty) {
                            await getSelectedVehiclePersonEditF(
                                    createTodoParamForVHistory)
                                .then((value) {
                              if ((value.vin != null &&
                                      value.vin!.isNotEmpty) ||
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
                          editVehiclePersonController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset:
                                    (editVehiclePersonController.text.length)),
                          );
                        })),
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
            Utils.getFilledButton(
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
                              vehicle?['vehicle_name']??selectedVin['vehicle_name'],
                          vin: vinToFind??selectedVin['vin'],
                        ),
                      ));
                    },
                    child: Utils.getText(
                      todoItem['vehicle_name'] != null
                          ? 'Task History - ${todoItem['vehicle_name']}'
                          : vehicle is Map && vehicle?['vehicle_name'] != null
                          ? 'Task History - ${vehicle?['vehicle_name']}'
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
      if (selectedResourceId != null) {
        editCreateTodoParams.selectedUserId = selectedResourceId;
        editCreateTodoParams.selectedUserGroupId = null;
        editCreateTodoParams.assignedTo = [selectedResourceId];
      } else if (selectedResourceIdList != null) {
        editCreateTodoParams.selectedUserId = null;
        editCreateTodoParams.selectedUserGroupId = selectedResourceIdList;
        editCreateTodoParams.assignedTo =
            editCreateTodoParams.selectedUserGroupId;
      }

      if (isPartChecked) {
        editCreateTodoParams.partList = (selectedPartsList
            .where((element) => (element['id'] == null || element['id'] == 0))
            .toList());
      }
      if (isSupplyChecked) {
        editCreateTodoParams.supplyList = (selectedSuppliesList
            .where((element) => (element['id'] == null || element['id'] == 0))
            .toList());
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
      if (editCreateTodoParams.personId == '') {
        for (Map<String, dynamic> veh in vehicleGroupList) {
          if (veh['name'] == editVehiclePersonController.text.trim()) {
            editCreateTodoParams.vehicleGroupId = veh['id'].toString();
          }
        }
      }
      if (editCreateTodoParams.vehicleGroupId == '') {
        for (Map<String, dynamic> veh in vehicleList) {
          if (veh['vehicle_name'] == editVehiclePersonController.text.trim()) {
            editCreateTodoParams.vehicleName = veh['vehicle_name']!;
            editCreateTodoParams.cohortId = veh['cohort_id'].toString();
            editCreateTodoParams.vin = veh['vin'];
            editCreateTodoParams.vehicleImage =
                veh['images'] != null && veh['images']!.isNotEmpty
                    ? (veh['images']?[0]['path'] ?? '')
                    : '';
            editCreateTodoParams.cohortName = veh['cohort']?['cohort'] ?? '';
          }
        }
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

  CreateTodoParams getSelectedVehiclePersonEdit(
      CreateTodoParams createTodoParams) {
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

  Future<CreateTodoParams> getSelectedVehiclePerson(
      CreateTodoParams createTodoParams) {
    for (Map<String, dynamic> res in resourceList) {
      if ('${res['first_name']} ${res['last_name']}' ==
          vehiclePersonController.text.trim()) {
        createTodoParams.person = '${res['first_name']} ${res['last_name']}';
        createTodoParams.personId = res['id']!.toString();
      }
    }
    if (createTodoParams.personId == '') {
      for (Map<String, dynamic> veh in vehicleGroupList) {
        if (veh['name'] == vehiclePersonController.text.trim()) {
          createTodoParams.vehicleGroupId = veh['id'].toString();
          createTodoParams.vehicleGroupName = veh['name'].toString();
        }
      }
    }
    if (createTodoParams.vehicleGroupId == '') {
      for (Map<String, dynamic> veh in vehicleList) {
        if (veh['vehicle_name'] == vehiclePersonController.text.trim()) {
          createTodoParams.vehicleName = veh['vehicle_name']!;
          createTodoParams.cohortId = veh['cohort_id'].toString();
          createTodoParams.vin = veh['vin'];
          createTodoParams.vehicleImage = veh['images']?[0]['path'] ?? '';
          createTodoParams.cohortName = veh['cohort']?['cohort'] ?? '';
        }
      }
    }
    return Future.value(createTodoParams);
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

  void showObjectPopupMenuWithCheckBox(
      /*BuildContext context,*/
      List<Map<String, dynamic>> resourceListForCombination,
      details,
      Function(List<Map<String, dynamic>?>) onSelect,
      bool fromUserEdit) async {
    List<Map<String, dynamic>?>? selectedValues =
        await showMenu<List<Map<String, dynamic>?>>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      color: AppC.white,
      items: <PopupMenuEntry<List<Map<String, dynamic>?>>>[
        PopupMenuItem<List<Map<String, dynamic>?>>(
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                for (Map<String, dynamic> resource
                    in resourceListForCombination)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppC().base,
                    title: Utils.getText(
                        '${resource['first_name'] ?? ''} ${resource['last_name'] ?? ''}'),
                    value: isSelected ??
                        false /*selectedValues.contains(resource)*/,
                    onChanged: (bool? value) {
                      if (value != null) {
                        if (value && resource['id'] == -1) {
                          resourceListForCombination
                              .map((e) => isSelected = true)
                              .toList();
                          isSelected = true;
                          // selectedValues.add(resource);
                        } else {
                          isSelected = value;
                          // selectedValues.add(resource);
                        }
                        setState(() {});
                      }
                    },
                  ),
              ],
            );
          }),
        ),
        PopupMenuItem<List<Map<String, dynamic>?>>(
          value: resourceListForCombination,
          child: Utils.getText('OK'),
        ),
      ],
    );

    if (resourceListForCombination.isNotEmpty) {
      onSelect(resourceListForCombination);
    }
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
        child: Row(
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
            // Utils.getOutlinedButton('Expense', () {
            //
            //   setState(() { showExpenseTab = 0;});
            // },
            //     verticalPadding: 5,
            //     radius: const BorderRadius.only(
            //         topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            //     borderColor: showExpenseTab==0 ? AppC().base : AppC.trans),
            // if(todoItem['title']!='Check In' && todoItem['title']!='Check Out')
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

            // SizedBox(height: 30,
            //   child: Utils.getOutlinedButton('Next Task', () {
            //     setState(() { showExpenseTab = 1;});
            //     },
            //       //verticalPadding: 5,
            //       radius: const BorderRadius.only(
            //           topLeft: Radius.circular(6),
            //           topRight: Radius.circular(6)),
            //       borderColor: showExpenseTab==1 ? AppC().base : AppC.trans),
            // ),

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
            // Utils.getOutlinedButton('Check List', () {
            //   setState(() {
            //     showExpenseTab = 2;
            //   });
            //   },
            //     verticalPadding: 5,
            //     radius: const BorderRadius.only(
            //         topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            //     borderColor: showExpenseTab==2 ? AppC().base : AppC.trans),

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
            // Utils.getOutlinedButton('Maintenance', () {
            //   setState(() {
            //     showExpenseTab = 3;
            //   });
            // },
            //     verticalPadding: 5,
            //     radius: const BorderRadius.only(
            //         topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            //     borderColor: showExpenseTab==3 ? AppC().base : AppC.trans),
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
    String? vinToFind;
    if (todoItem['vin'] == null) {
      if (todoItem['vehicles'] is List && todoItem['vehicles'].isNotEmpty) {
        vinToFind = todoItem['vehicles'][0]['vin'];
      }
    } else {
      vinToFind = todoItem['vin'];
    }

    final Map<String, dynamic>? vehicle = vinToFind != null
        ? vehicleList.firstWhere(
            (emp) => emp['vin'] == vinToFind,
            orElse: () => {}, // Return null if no match is found
          )
        : null;
    addressController.text = vehicle?['address'] ?? '';
    plateNumberController.text = vehicle?['vehicle_number'] ?? '';
    carNumberController.text = (vehicle?['car_number']?.toString()) ?? '';
    oilGradeController.text = vehicle?['oil_grade'] ?? '';
    frontTireController.text = vehicle?['front_tire'] ?? '';
    rearTireController.text = vehicle?['rear_tire'] ?? '';
    renewalDateController.text = vehicle?['registration_renewal_date'] ?? '';
    Bouncie = vehicle?['bouncie'] == 1;
    airTag = vehicle?['air_tag'] == 1;
    permanentPlate = vehicle?['permanent_plate'] == 1;
    spareTire = vehicle?['spare_tire'] == 1;
    tollTags=vehicle?['toll_tags']==1;
    spareKey=vehicle?['spare_key']==1;
    frontLicensePlate=vehicle?['front_license_plate']==1;
    imageFile = (vehicle?['images'] as List<dynamic>?)
            ?.where((image) => image['vehicle_image_type'] == 3)
            .toList() ??
        [];

    tireImageFile = (vehicle?['images'] as List<dynamic>?)
            ?.where((image) => image['vehicle_image_type'] == 2)
            .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Utils.getText(
            vehicle?['vehicle_name'] ?? '',
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
                    value: Bouncie,
                    onChanged: (bool? value) {
                      setState(() {
                        Bouncie = value ?? false;
                        vehicle?['bouncie'] = Bouncie ? 1 : 0;
                      });
                    },
                    label: 'Bouncie',
                  ),
                  checkBoxWithSingleText(
                    value: tollTags,
                    onChanged: (bool? value) {
                      setState(() {
                        tollTags = value ?? false;
                        vehicle?['toll_tags'] = tollTags ? 1 : 0;
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
                        vehicle?['air_tag'] = airTag ? 1 : 0;
                      });
                    },
                    label: 'AirTag',
                  ),
                  checkBoxWithSingleText(
                    value: spareTire,
                    onChanged: (bool? value) {
                      setState(() {
                        spareTire = value ?? false;
                        print("spareTire: $spareTire");
                        vehicle?['spare_tire'] = spareTire ? 1 : 0;
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
                      child:Utils.getBackgroundFilledTextFieldFirstLetterCaps('Enter the tag id', tollTagsController) ),
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
                  ),
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
                                    File(tireImageFile[index]['file']?.path ?? ''),
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
              child: Visibility(visible: spareTire,
                  child:Utils.getBackgroundFilledTextFieldFirstLetterCaps('e.g.,T165/70D18', spareTireController) ),
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
                  vehicle?['spare_key'] = spareKey ? 1 : 0;
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
                    vehicle?['permanent_plate'] = permanentPlate ? 1 : 0;
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
                        vehicle?['front_license_plate'] = frontLicensePlate ? 1 : 0;
                      });
                    },
                    label: 'Front license plate',
                  ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5,),
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
                            Radius.circular(Num.subradiusButton))),
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
                                    File(tireImageFile[index]['file']?.path ?? ''),
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
            SizedBox(width: 10,),
            Expanded(
              child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                  'Plate Number', plateNumberController,
                  hintTextColor: AppC.grey),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                  'Car Number', carNumberController,
                  hintTextColor: AppC.grey),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
              child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                  'Front tire', frontTireController,
                  hintTextColor: AppC.grey),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                       Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                                  initial: DateTime.parse("1970-01-01"))
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
                          imageFile.add({'file': value, 'path': ''});
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
        Visibility(
          visible: imageFile.isNotEmpty,
          child: SizedBox(
            height: 80, // Set a height for the ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageFile.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      (imageFile[index]['path'] ?? '').isNotEmpty
                          ? Utils.getOvalCachedImageNetworkDisplay(
                              context, imageFile[index]['path'] ?? '')
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                File(imageFile[index]['file']?.path ?? ''),
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
                            if ((imageFile[index]['path'] ?? '').isEmpty) {
                              imageFile.removeAt(index);
                            } else {
                              // vehicleDataBloc.add(
                              //   DeleteExpenseImage(id: images[index]['id']),
                              //);
                              imageFile.removeAt(index);
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
        Row(
          children: [
            Expanded(
              child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                'Insurance Agent',
                insuranceAgentController
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                imageFile.add({'file': value, 'path': ''});
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
          visible: imageFile.isNotEmpty,
          child: SizedBox(
            height: 80, // Set a height for the ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageFile.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      (imageFile[index]['path'] ?? '').isNotEmpty
                          ? Utils.getOvalCachedImageNetworkDisplay(
                          context, imageFile[index]['path'] ?? '')
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(
                          File(imageFile[index]['file']?.path ?? ''),
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
                            if ((imageFile[index]['path'] ?? '').isEmpty) {
                              imageFile.removeAt(index);
                            } else {
                              // vehicleDataBloc.add(
                              //   DeleteExpenseImage(id: images[index]['id']),
                              //);
                              imageFile.removeAt(index);
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
              child: Utils.getFilledButton(
                'Save',
                () {
                  // _save();
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
        
        // const Spacer(),
        // Visibility(
        //   visible: (availCar = checkCleanCarAvailEdit()) != 0,
        //   child: Row(
        //     children: [
        //       InkWell(
        //           onTap: () async {
        //             if (modifiedDateTime != null) {
        //               await doCreateEditTodo(
        //                   todoName: 'Clean Car',
        //                   time:
        //                       DateFormat("HH:mm:ss").format(modifiedDateTime!));
        //             }
        //           },
        //           child: Container(
        //               padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 3),
        //               decoration: Utils.getBoxDecoration(
        //                   borderColor: availCar == 2 ? AppC.red : AppC.green),
        //               child: const Icon(Icons.local_car_wash_sharp))),
        //       const SizedBox(
        //         width: 15,
        //       ),
        //       Container(
        //         width: 80,
        //         decoration: BoxDecoration(
        //             border: Border.all(
        //               color: AppC.fieldBase,
        //               width: Num.borderWidthField,
        //             ),
        //             borderRadius: const BorderRadius.all(
        //                 Radius.circular(Num.subradiusButton))),
        //         child: DropdownButton<CleanCarTimeValues>(
        //           hint: Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 0.0),
        //             child: Utils.getText('', color: AppC.grey),
        //           ),
        //           value: selectedCleanCarTime,
        //           isExpanded: true,
        //           icon: const Icon(Icons.arrow_drop_down),
        //           elevation: 0,
        //           underline: Container(
        //             height: 0,
        //             color: Colors.transparent,
        //           ),
        //           onChanged: (CleanCarTimeValues? value) {
        //             // This is called when the user selects an item.
        //             selectedCleanCarTime = value;
        //             modifiedDateTime = todoListRepo.chosenDateTime!.subtract(
        //                 Duration(minutes: selectedCleanCarTime!.minutes!));
        //             debugPrint('modifiedDateTime1: $modifiedDateTime');
        //             setState(() {});
        //           },
        //           items: cleanCarTimeValuesList
        //               .map<DropdownMenuItem<CleanCarTimeValues>>(
        //                   (CleanCarTimeValues value) {
        //             return DropdownMenuItem<CleanCarTimeValues>(
        //               value: value,
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
        //                 child: Utils.getText((value.minutes ?? 0).toString()),
        //               ),
        //             );
        //           }).toList(),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

//   Widget vehicleHistoryUIWithoutScaffold({outerTodos}) {
//     return Stack(
//       children: [
//         RefreshIndicator(
//           color: AppC().base,
//           onRefresh: () async {
//             vehicleDataBloc!.add(vdb.GetVehicleHistoryEvent(
//                 vin: createTodoParamForVHistory.vin,
//                 vehicleGroupId:
//                     createTodoParamForVHistory.vehicleGroupId != null
//                         ? int.parse(createTodoParamForVHistory.vehicleGroupId!)
//                         : null,
//                 needUI: true));
//           },
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 0.0),
//               child: Column(
//                 children: [
//                   Visibility(
//                     visible:
//                         todoListRepo.vehicleHistoryTempSearchList.isNotEmpty,
//                     child: Utils.getSearchBarUI(() {
//                       ///onTap
//                     }, (value) {
//                       //    onChange
//                       todoList.clear();
//                       if (value.isEmpty) {
//                         todoList
//                             .addAll(todoListRepo.vehicleHistoryTempSearchList);
//                       } else {
//                         for (Map<String, dynamic> data
//                             in todoListRepo.vehicleHistoryTempSearchList) {
//                           if (((data['title'] ?? '').toLowerCase())
//                               .contains(value.toLowerCase())) {
//                             todoList.add(data);
//                           }
//                         }
//                       }
//                       setState(() {});
//                     }, searchController, searchFocusNode),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Visibility(
//                     visible: todoList.isNotEmpty,
//                     replacement:
//                         Center(child: Utils.getEmptyTextWidget(topPadding: 30)),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                       child: ListView.builder(
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: todoList.length,
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                               onTap: () async {
//                                 bool? result = await Navigator.of(context)
//                                     .push(MaterialPageRoute(
//                                   builder: (context) => VehicleHistoryDetailUI(
//                                       outerTodos: outerTodos,
//                                       todos: todoList[index],
//                                       categoriesList: categoriesData),
//                                 ));
//                                 if (result != null) {
//                                   vehicleDataBloc!.add(
//                                       vdb.GetVehicleHistoryEvent(
//                                           vin: outerTodos!.vin,
//                                           vehicleGroupId:
//                                               outerTodos!.vehicleGroupId,
//                                           needUI: true));
//                                 }
//                               },
//                               child: listItem(todoList[index], index));
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
// /*
//         Visibility(
//             visible: state is VehicleDataLoading,
//             child: Center(child: Utils.getProgressIndicator(context)))
// */
//       ],
//     );
//   }

  // Color textColors = AppC.text;
  String lastEditedId = '';
  OverlayEntry? overlay;
  TextEditingController searchController = TextEditingController();

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
