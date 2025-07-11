part of 'add_todo_bloc.dart';

mixin AddToDoMixin {
  final APiRepository _apiRepository = APiRepository();

  final FBroadcast _broadcast = FBroadcast.instance();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController identifierController = TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController partsController = TextEditingController();
  final TextEditingController suppliesController = TextEditingController();
  final TextEditingController customLinkController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController recurringEveryDayWeekController = TextEditingController();
  final TextEditingController recurringMonthDateController = TextEditingController();
  final TextEditingController recurringMonthMonthController = TextEditingController();
  final TextEditingController recurringYearDateController = TextEditingController();
  final TextEditingController recurringNoOccurrenceController = TextEditingController();
  final TextEditingController recurringEndDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController leadController = TextEditingController();
  final TextEditingController meetingLinkController = TextEditingController();
  final QuillController enquiryController = QuillController.basic();

  final List<Map<String, dynamic>> selectedParts = [], selectedSupplies = [], selectedTaskManagers = [], selectedAddress = [];
  final List<dynamic> attachments = []; // SELECTED AND STORING FILE'S
  bool showParts = false, showSupplies = false, showCleanCar = false, isPlatformCheck = false, isTimeSensitive = false, showMore = false, isRecurringMonthOccurrence = false, isRecurringEndDate = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? selectedRecurringEndDate;
  dynamic recurringYearlySelectedMonth;
  Map<int, Map<String, dynamic>> selectedTaskIdentifier = {};
  Map<String, dynamic> selectedRecurring = ToDoConfig.recurringOptions.first, selectedCustom = ToDoConfig.customOptions.first, selectedClearDuration = ToDoConfig.cleanCarDurations.first, selectedLead = {}, selectedMeetingMode = ToDoConfig.meetingMode.firstWhere((element) => element['id'] == 1), selectedMeetingDuration = ToDoConfig.defaultMeetingDuration;
  List<String> selectedRecurringDays = [];
  List<Map<String, dynamic>> selectedVPerson = [];
  TaskType taskType = TaskType.rental;
  List<Map<String, dynamic>> selectedTaskIdentifiers = [];

  List<Map<String, dynamic>> get locations => getIt<CommonService>().locationsList;
  List<Map<String, dynamic>> get persons {
    List<Map<String, dynamic>> resources = List.from(getIt<CommonService>().resourcesList);
    resources.removeWhere((resource) =>
    ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
        (resource['branch_id'] !=
            Session.of.getInt(Str.branchIdPrefText))) ||
        (resource['deleted_at'] != null));
    return resources;
  }
  List<Map<String, dynamic>> get tasks => getIt<CommonService>().taskExpenseDataList;
  List<Map<String, dynamic>> get vehicles => getIt<CommonService>().activeVehicleList.where((element) => element['branch_code'] == branchId).toList();
  List<Map<String, dynamic>> get vendors => getIt<CommonService>().vendorsList;
  List<Map<String, dynamic>> get groupVehicleList => getIt<CommonService>().groupVehicleList;
  List<Map<String, dynamic>> get partsList => getIt<CommonService>().partsList;
  List<Map<String, dynamic>> get suppliesList => getIt<CommonService>().suppliesList;
  List<Map<String, dynamic>> get leads => getIt<CommonService>().leads;

  String? get taskName {
    var selectedTask = selectedTaskIdentifier[1];
    if ( (selectedTask != null) && ((selectedTask as Map?)?.isNotEmpty ?? false)) {
      return selectedTask['name'];
    } else {
      return null;
    }
  }

  Color reservationColor = AppC.appColor;

  int get userId => getIt<CommonService>().userId; /// CURRENT LOGGED IN USER ID
  int? get branchId => getIt<CommonService>().branchId; /// CURRENT LOGGED IN USER BRANCH ID
  int get departmentId => getIt<CommonService>().departmentId; /// CURRENT LOGGED IN USER DEPARTMENT ID

  dynamic existingRefId;

  Map<String, dynamic>? get _selectedVPerson => selectedVPerson.lastWhereOrNull((element) => ["vehicles", "g_vehicles", "vehicle", "group_vehicle"].contains(element['type']));

  bool isNextTask = false;

  bool get isCurrentDate => selectedDate.isToday;
  bool get isLeadTask => (taskType == TaskType.lead);
  bool get isCleanCar => selectedTaskIdentifier[1]?['id'] == 30;
  bool get isRentalTask => ([TaskType.rental, TaskType.nonRental].contains(taskType));
  bool get isRentalOnlyTask => ([TaskType.rental].contains(taskType));
  bool get isMeeting => (taskType == TaskType.meeting);
  bool get hasAttachments => attachments.isNotEmpty;
  bool get hasRecurring => selectedRecurring['id'] != 0;
  bool get hasEnquiry => selectedTaskIdentifier[1]?['id'] == 358;
  bool get hasPlatformCheck => Str.platFormCheckIds.contains(selectedTaskIdentifier[1]?['id'] ?? 0);
  bool get hasCleanCar => Str.cleanCarCheckIds.contains(selectedTaskIdentifier[1]?['id'] ?? 0);
  bool get hasOilChange => Str.oilChangeCheckIds.contains(selectedTaskIdentifier[1]?['id'] ?? 0);
  bool get hasVehicle => (_selectedVPerson?.isNotEmpty ?? false) && (["vehicles", "g_vehicles", "vehicle", "group_vehicle"].contains(_selectedVPerson?['type']));
  bool get hasPerson => (_selectedVPerson?.isNotEmpty ?? false) && (["person"].contains(_selectedVPerson?['type']));
  bool get showReservation => (selectedCustom.isNotEmpty) && (!isNextTask);
  bool get hasAddress => showMore && selectedTaskIdentifier[3]?['type'] == "location";
  bool get isVehicleRequired => isCleanCar || hasCleanCar || hasOilChange;
  bool get canShowParts => showParts && showMore && (!isNextTask);
  bool get canShowSupplies => showSupplies && showMore && (!isNextTask);

  List<Map<String, dynamic>> get addresses => List.from(selectedTaskIdentifier[3]?['value']?['addresses'] ?? []);

  String? get lasVehicleVin => (["vehicles", "vehicle"].contains(_selectedVPerson?['type'])) ? (_selectedVPerson?['value']?['vin']) : null;
  String? get lasVehicleGroupId => (["g_vehicles", "group_vehicle"].contains(_selectedVPerson?['type'])) ? (_selectedVPerson?['id']) : null;
  String? get lasVehicleName => _selectedVPerson?['name'];

  List<List<Map<String, dynamic>>> get taskIdentifierList => CustomSearchDataConverter.convertTaskIdentifier(
    taskExpense: tasks,
    leads: isLeadTask ? leads : null,
    vehicles: isMeeting ? null : vehicles,
    resources: isMeeting ? null : persons,
    groupVehicles: isMeeting ? null : groupVehicleList,
    vendors: isRentalTask ? vendors : null,
    locations: isRentalTask ? locations : null
  );

  // PICK MULTI IMAGES / FILES
  Future<List<File>?> _pickFiles() async {
    var result = await ImagePicker().pickMultiImage();
    return result.map((e) => File(e.path)).toList();
  }

  Map<String, String> _addTodoBody() {
    final taskName = taskNameController.text;
    final selectedName = selectedTaskIdentifier[1]?['name'];
    final selectedId = selectedTaskIdentifier[1]?['id'];
    final recurringLabel = selectedRecurring['label'].toString();
    final isEnquiryNotEmpty = enquiryController.document.toPlainText().trim().isNotNullOrEmpty;
    final hasLead = selectedTaskIdentifier[2]?['type'] == "lead";
    final hasMeetingMode = isMeeting;
    final task = selectedTaskIdentifier[1];
    final todoUserTypeId = task?['user_type_id'] ?? 0;
    final isUserType3 = todoUserTypeId == 3;
    final isUserType5 = todoUserTypeId == 5;
    var baseBody = _cleanCarBody();
    baseBody['title'] = taskNameController.text;
    baseBody['identifier_id'] = (taskName.isNotEmpty && selectedName == taskName) ? "$selectedId" : "";
    baseBody['repeatPeriod'] = ((recurringLabel.isDoesNotRepeat == false) ? recurringLabel.toLowerCase() : "");
    baseBody['repeatDay'] = (recurringLabel.isDaily) ? recurringEveryDayWeekController.text : "";
    baseBody['repeatWeek'] = (recurringLabel.isWeekly) ? recurringEveryDayWeekController.text : "";
    baseBody['weekDay'] = (recurringLabel.isWeekly) ? "${selectedRecurringDays.map((e) => jsonEncode(e.toString().toLowerCase())).toList()}" : "";
    baseBody['recur_monthly_type'] = "$isRecurringMonthOccurrence";
    baseBody['repeatDateMonth'] = isRecurringMonthOccurrence ? recurringMonthDateController.text : "";
    baseBody['repeatMonth'] = !isRecurringMonthOccurrence ? recurringMonthDateController.text : "";
    baseBody['repeatDayMonth'] = !isRecurringMonthOccurrence ? recurringMonthMonthController.text : "";
    baseBody['repeatDateYear'] = (recurringLabel.isYearly) ? recurringYearDateController.text : "";
    baseBody['repeatMonthYear'] = recurringYearlySelectedMonth?['month'].toString() ?? "";
    baseBody['end_type'] = "$isRecurringEndDate";
    baseBody['end_after'] = (!isRecurringEndDate) ? (recurringNoOccurrenceController.text) : "";
    baseBody['end_at'] = selectedRecurringEndDate.toFormat() ?? "";
    baseBody['todo_time'] = selectedTime.toHMS().toString();
    baseBody['platform_check'] = "${isPlatformCheck ? 1 : hasPlatformCheck ? 0 : ""}";
    baseBody['todo_user_type'] = "$todoUserTypeId";
    baseBody['comments'] = "";
    baseBody['mileage'] = "";
    baseBody['resolution_notes'] = "";
    baseBody['custom_link_id'] = "${selectedCustom['id'] ?? ""}";
    baseBody['custom_link'] = (selectedCustom['id'] == 1) ? customLinkController.text : "";
    baseBody['reference_id'] = (selectedCustom['id'] == 2) ? customLinkController.text : "";
    if (baseBody['identifier_id'].toString().contains("358") && isEnquiryNotEmpty) {
      baseBody['rental_enquiry'] = QuillDeltaToHtmlConverter(enquiryController.document.toDelta().toJson(), ConverterOptions.forEmail()).convert();
    }
    baseBody['lead_id'] = hasLead ? selectedLead['id'].toString() : "";
    baseBody['channel_id'] = "";
    baseBody['meeting_mode'] = hasMeetingMode ? selectedMeetingMode['name'].toString().toLowerCase() : "";
    baseBody['rental_booking_id'] = (selectedCustom['id'] == 3) ? customLinkController.text : "";
    baseBody['rental_booking_no'] = "";
    baseBody['meeting_link'] = hasMeetingMode ? meetingLinkController.text : "";
    baseBody['meeting_duration'] = hasMeetingMode ? selectedMeetingDuration['value'] : "";
    if (!isRentalOnlyTask) {
      baseBody['custom_link_id'] = "";
      baseBody['custom_link'] = "";
    }
    if (isUserType3 || isUserType5) {
      baseBody['address'] = "";
      baseBody['parts'] = "";
      baseBody['supplies'] = "";
      baseBody['custom_link_id'] = "";
      baseBody['custom_link'] = "";
      baseBody['reference_id'] = "";
      baseBody['rental_booking_id'] = "";
      baseBody['rental_booking_no'] = "";
    }
    if (!isUserType3) baseBody['lead_id'] = "";
    if ((!isUserType5) && !hasMeetingMode) {
      baseBody['meeting_mode'] = "";
      baseBody['meeting_link'] = "";
      baseBody['meeting_duration'] = "";
    }
    return baseBody;
  }

  Map<String, String> _cleanCarBody() {
    final type = selectedTaskIdentifier[3]?['type'];
    final isLocation = (type == "location");
    final isVendor = (type == "vendor");
    final isPerson = (type == "person");
    final isGroupVehicles = (type == "g_vehicles");
    final location = isLocation ? selectedTaskIdentifier[3] : null;
    final vendor = isVendor ? selectedTaskIdentifier[3] : null;
    final person = isPerson ? selectedTaskIdentifier[2] : null;
    final vehicleGroup = isGroupVehicles ? selectedTaskIdentifier[2] : null;
    final isAdd = selectedTaskIdentifier[1]?['id'] == 210;
    var date = selectedDate;
    var timeAt = selectedTime.toDateTime;
    var timeDay = selectedTime;
    if (timeAt != null) {
      date =
          DateTime(date.year, date.month, date.day, timeAt.hour, timeAt.minute);
      if (isAdd) {
        timeAt =
            date.add(Duration(minutes: selectedClearDuration['value']));
      } else {
        timeAt = date
            .subtract(Duration(minutes: selectedClearDuration['value']));
      }
      timeDay = TimeOfDay.fromDateTime(timeAt);
    }
    Map<String, String> jsonBody = {
      "title": "Clean Car",
      "identifier_id": "30",
      "location": location?['name'] ?? "",
      "location_id": "${location?['id'] ?? ""}",
      "cohort_id": "",
      "cohort_name": "",
      "vin": "",
      "vehicle_name": "",
      "vehicle_image": "",
      "vehicles":
      "${selectedVPerson.where((element) => element['type'] == "vehicles").map((e) => e['value']).map((e) => jsonEncode({
        "cohort_id": "${e['cohort']?['id'] ?? ""}",
        "cohort_name": "${e['cohort']?['cohort'] ?? ""}",
        "vin": e['vin'],
        "vehicle_name": e['vehicle_name'],
        "vehicle_image":
        (e['images'] as List?)?.firstOrNull?['path'],
        "vehicle_number": e['vehicle_number']
      })).toList()}",
      "start_at": "${date.toFormat(format: "yyyy-MM-dd")}",
      "person": "${person?['name'] ?? ""}",
      "person_id": "${person?['id'] ?? ""}",
      "vendor_id": "${vendor?['id'] ?? " "}",
      "vendor_name": "${vendor?['name'] ?? ""}",
      "notes":
      notesController.text.trim().isNullOrEmpty ? "" : notesController.text,
      "parts":
      "${selectedParts.isEmpty ? null : selectedParts.map((e) => jsonEncode({
        "parts_id": e['id'],
        "parts_name": e['name'],
      })).toList()}",
      "supplies":
      "${selectedSupplies.isEmpty ? null : selectedSupplies.map((e) => jsonEncode({
        "supplies_id": e['id'],
        "supplies_name": e['name'],
      })).toList()}",
      "vehicle_group_id": "${vehicleGroup?['id'] ?? ""}",
      "address": "${selectedAddress.map((e) => e['id']).toList()}",
      "assigned_to":
      "${selectedTaskManagers.map((e) => e['id']).toList()}",
      "todo_time": "${timeDay.toHMS()}",
      "reason": reasonController.text,
      "time_sensitive": "$isTimeSensitive",
      "branch_id": "$branchId",
    };
    return jsonBody;
  }

  Future<void> _fetchAllApis() async => await Future.wait([_getLeads(), _getTasks(), _getVendors(), _getLocations(), _getResources(), _getVehicles(), _getParts(), _getSupplies(), _getGroupVehicles()]);

  Future<List<Map<String, dynamic>>> _getLeads() async => await getIt<CommonService>().fetchLeads(); // API CALL: GET-GROUP-VEHICLES
  Future<List<Map<String, dynamic>>?> _getTasks() async => await getIt<CommonService>().getTaskExpenseData(); // API CALL: TASKS
  Future<List<Map<String, dynamic>>?> _getVendors() async => await getIt<CommonService>().getVendorsList(); // API CALL: VENDORS
  Future<List<Map<String, dynamic>>?> _getLocations() async => await getIt<CommonService>().getLocationsList(); // API CALL: LOCATIONS
  Future<List<Map<String, dynamic>>?> _getVehicles() async => await getIt<CommonService>().getActiveVehicles(); // API CALL: ACTIVE-VEHICLES
  Future<List<Map<String, dynamic>>?> _getResources() async => await getIt<CommonService>().getResources(); // API CALL: GET-RESOURCES
  Future<List<Map<String, dynamic>>?> _getParts() async => await getIt<CommonService>().getPartsList(); // API CALL: GET-PARTS
  Future<List<Map<String, dynamic>>?> _getSupplies() async => await getIt<CommonService>().getSuppliesList(); // API CALL: GET-PARTS
  Future<List<Map<String, dynamic>>> _getGroupVehicles() async => await getIt<CommonService>().groupVehicles(); // API CALL: GET-GROUP-VEHICLES
  Future<Map<String, dynamic>?> _deleteToDo({dynamic todoId}) async => await _apiRepository.deleteTodo(id: todoId, reason: "");
  Future<Map<String, dynamic>?> _findClearCarExist(dynamic vin) async => await _apiRepository.checkCleanCarTask(vin: vin);
  Future<Map<String, dynamic>?> _findReservation(dynamic vin) async => await getIt<CommonService>().findVehicleReservation(vin: vin);
  Future<Map<String, dynamic>?> _getOilChangeTask({required dynamic vin}) async => await getIt<CommonService>().getLatestOilChangeTask(vin: vin, dateTime: selectedDate);

  void _errorCatch(dynamic e, Emitter<AddToDoState> emit) {
    Console.of.error("Error", error: e, name: "ADD_TODO_BLOC");
    emit(ErrorState(e));
  }

  void _updateReservation(Emitter<AddToDoState> emit) async {
    try {
      if (hasVehicle && lasVehicleVin.isNotNullOrEmpty) {
        final response = await _findReservation(lasVehicleVin);
        existingRefId = response?['reference_id'] ?? "";
        if (existingRefId.toString().trim().isNotNullOrEmpty) customLinkController.text = "${existingRefId ?? ""}";
        reservationColor = Str.red.contains(response?['identifier_id'])
            ?AppC.redAccent
            :Str.green.contains(response?['identifier_id'])
            ?AppC.green
            :AppC.appColor;
        emit(CommonState());
      }
    } catch (e) {
      _errorCatch(e, emit);
    }
  }

  void _onIdentifierEvent(IdentifierEvent event, Emitter<AddToDoState> emit) {
    if (event.identifier is List) {
      selectedTaskIdentifiers = event.identifier;
      final result = selectedTaskIdentifiers.fold<Map<int, Map<String, dynamic>>>({}, (map, e) {
        if (e['type'] == 'task') {
          map[1] = e;
          taskType = e['user_type_id'].toString().toNumeric.toInt().type;
        } if (['lead'].contains(e['type'])) {
          map[2] = e;
        } if (["vehicles", "person", "g_vehicles"].contains(e['type'])) {
          map[3] = e;
        } if (["vendor", "location"].contains(e['type'])) {
          map[4] = e;
        }
        return map;
      });
      Map<int, Map<String, dynamic>> optional = {};
      Map<int, Map<String, dynamic>> optional2 = {
        1 : {},
        2 : {},
        3 : {}
      };
      if (!result.containsKey(1)) result[1] = {};
      if (!result.containsKey(2)) result[2] = {};
      if (!result.containsKey(3)) result[3] = {};
      if (!result.containsKey(4)) result[4] = {};
      for (var element in result.entries) {
        final key = element.key;
        final value = element.value;
        switch(key) {
          case 1: {
            optional[1] = value;
          } break;
          case 2: {
            final result = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == selectedLead['id']) && (["lead"].contains(element['type']))) ?? {};
            optional[2] = (value.isEmpty) ? result : value;
            if (value.isEmpty && result.isNotEmpty) {
              optional[2] = {};
              selectedLead.clear();
            }
          } break;
          case 3: {
            if (selectedVPerson.isNotEmpty) {
              final last = selectedVPerson.last;
              optional[3] = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == last['id']) && (["vehicles", "g_vehicles", "person"].contains(element['type']))) ?? {};
            } else {
              optional[3] = value;
            }
          } break;
          case 4: {
            final hasVendor = ["vendor", "location"].contains(selectedTaskIdentifier[3]?['type']);
            final vendorLoc = selectedTaskIdentifier[3];
            optional[4] = (value.isEmpty && hasVendor) ? (vendorLoc ?? {}) : value;
            if (value.isEmpty && (vendorLoc?.isNotEmpty ?? false)) {
              optional[4] = {};
            }
          } break;
        }
      }

      final task = optional[1];
      final lead = optional[2];
      final vehicle = optional[3];
      final vendorLoc = optional[4];

      final isUserType3 = task?['user_type_id'] == 3;
      final isUserType5 = task?['user_type_id'] == 5;

      optional2[1] = task ?? {};

      if (isUserType3) {
        optional2[2] = lead ?? {};
        optional2[3] = vehicle ?? {};
      } else {
        optional2[2] = vehicle ?? {};
        optional2[3] = vendorLoc ?? {};
      }

      selectedTaskIdentifier = optional2;

      if (isUserType3 || isUserType5) selectedTaskIdentifier.removeWhere((key, value) => [2, 3].contains(key));

      if (task != null) taskNameController.text = task['name'] ?? "";
      if (isUserType3) {
        if (lead?.isNotEmpty ?? false) selectedLead = lead?['value'] ?? {};
        if (vehicle != null && (vehicle.isNotEmpty)) selectedVPerson.add(vehicle);
        selectedTaskIdentifier[2] = lead ?? {};
        selectedTaskIdentifier[3] = vehicle ?? {};
      } else {
        selectedLead.clear();
        if ((vehicle != null) && (vehicle.isNotEmpty)) selectedVPerson.add(vehicle);
        selectedTaskIdentifier[2] = vehicle ?? {};
        selectedTaskIdentifier[3] = vendorLoc ?? {};
      }
      if (isUserType5) {
        selectedLead.clear();
        selectedVPerson.clear();
        selectedTaskIdentifier.removeWhere((key, value) => [2, 3].contains(key));
      }
      selectedVPerson = selectedVPerson.unique((element) => element['id']);

      if (isUserType3 || isUserType5) {
        partsList.clear();
        suppliesList.clear();
        selectedAddress.clear();
        showParts = showSupplies = false;
        selectedMeetingMode = ToDoConfig.meetingMode.first;
      }
      if (!isUserType5) {
        selectedMeetingMode = ToDoConfig.meetingMode.first;
        selectedMeetingDuration = ToDoConfig.defaultMeetingDuration;
        meetingLinkController.clear();
      }
    }
    emit(CommonState());
    _updateReservation(emit);
  }

  void _onRemoveIdentifierEvent(RemoveIdentifierEvent event, Emitter<AddToDoState> emit) {
    final model = event.identifier;
    final index = event.index;
    final isTask = model?['type'] == 'task';
    final isLead = model?['type'] == "lead";
    final isVehicle = ["vehicles", "person", "g_vehicles"].contains(model?['type']);
    final isVendor = ["vendor", "location"].contains(model?['type']);
    if (isTask) {
      taskNameController.clear();
      selectedTaskIdentifier[1] = {};
      if (isLeadTask) {
        selectedLead.clear();
        selectedTaskIdentifier[2] = selectedTaskIdentifier[3] ?? {};
        selectedTaskIdentifier[3] = {};
      }
      if (isMeeting) {
        selectedMeetingMode = ToDoConfig.meetingMode.first;
        selectedMeetingDuration = ToDoConfig.defaultMeetingDuration;
        meetingLinkController.clear();
      }
      taskType = TaskType.rental;
    }
    if (isLead) {
      selectedLead.clear();
      selectedTaskIdentifier[2] = {};
    }
    if (isVehicle) selectedTaskIdentifier[isLeadTask ? 3 : 2] = {};
    if (isVendor) selectedTaskIdentifier[3] = {};
    emit(CommonState());
    _updateReservation(emit);
  }

  void _onPartStatusEvent(PartStatusEvent event, Emitter<AddToDoState> emit) {
    showParts = !showParts;
    emit(CommonState());
  }

  void _onSupplyStatusEvent(SupplyStatusEvent event, Emitter<AddToDoState> emit) {
    showSupplies = !showSupplies;
    emit(CommonState());
  }

  void _onMoreEvent(MoreEvent event, Emitter<AddToDoState> emit) {
    showMore = !showMore;
    emit(CommonState());
  }

  void _onPlatformCheckEvent(PlatformCheckEvent event, Emitter<AddToDoState> emit) {
    isPlatformCheck = !isPlatformCheck;
    emit(CommonState());
  }

  void _onRecurringEvent(RecurringEvent event, Emitter<AddToDoState> emit) {
    selectedRecurring = event.recurring ?? {};
    emit(CommonState());
  }

  void _onTaskManagerEvent(TaskManagerEvent event, Emitter<AddToDoState> emit) {
    if (event.isChecked) {
      selectedTaskManagers.add(event.taskManager);
    } else {
      selectedTaskManagers.remove(event.taskManager);
    }
    emit(CommonState());
  }

  void _onDateSelectEvent(DateSelectEvent event, Emitter<AddToDoState> emit) {
    selectedDate = event.date;
    emit(CommonState());
  }

  void _onTimeSelectEvent(TimeSelectEvent event, Emitter<AddToDoState> emit) {
    selectedTime = event.time;
    emit(CommonState());
  }

  void _onCustomEvent(CustomEvent event, Emitter<AddToDoState> emit) {
    selectedCustom = event.custom ?? {};
    emit(CommonState());
  }

  void _onRecurringDaysEvent(RecurringDaysEvent event, Emitter<AddToDoState> emit) {
    if (selectedRecurringDays.contains(event.day)) {
      selectedRecurringDays.remove(event.day);
    } else {
      selectedRecurringDays.add(event.day);
    }
    emit(CommonState());
  }

  void _onRecurringMonthlyEvent(RecurringMonthlyEvent event, Emitter<AddToDoState> emit) {
    isRecurringMonthOccurrence = !isRecurringMonthOccurrence;
    emit(CommonState());
  }

  void _onRecurringYearlyEvent(RecurringYearlyEvent event, Emitter<AddToDoState> emit) {
    recurringYearlySelectedMonth = event.month;
    emit(CommonState());
  }

  void _onRecurringEndAfterEvent(RecurringEndAfterEvent event, Emitter<AddToDoState> emit) {
    isRecurringEndDate = event.isRecurringEndDate;
    emit(CommonState());
  }

  void _onRecurringEndDateEvent(RecurringEndDateEvent event, Emitter<AddToDoState> emit) {
    selectedRecurringEndDate = event.date;
    emit(CommonState());
  }

  void _onClearVLEvent(ClearVLEvent event, Emitter<AddToDoState> emit) {
    selectedTaskIdentifier.remove(3);
    emit(CommonState());
  }

  void _onVendorLocationEvent(VendorLocationEvent event, Emitter<AddToDoState> emit) {
    if (selectedTaskIdentifier.isEmpty) selectedTaskIdentifier = {1 : {}, 2: {}, 3: {}};
    selectedTaskIdentifier[3] = event.vendorLocation;
    final task = selectedTaskIdentifier[1];
    final isUserType5 = task?['user_type_id'] == 5; // MEETING
    if ((task != null) && isUserType5) {
      selectedTaskIdentifier.removeWhere((key, value) => [2, 3].contains(key));
      selectedVPerson.clear();
    }
    var result = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == event.vendorLocation['id']) && (["vendor", "location"].contains(element['type'])));
    selectedTaskIdentifier[3] = result ?? {};
    emit(CommonState());
  }

  void _onVehiclePersonEvent(VehiclePersonEvent event, Emitter<AddToDoState> emit) {
    if (selectedTaskIdentifier.isEmpty) selectedTaskIdentifier = {1 : {}, 2: {}, 3: {}};
    selectedVPerson = event.vehiclePerson;
    final task = selectedTaskIdentifier[1];
    final isUserType3 = task?['user_type_id'] == 3; // LEAD
    final isUserType5 = task?['user_type_id'] == 5; // MEETING
    if (task != null) {
      if (selectedVPerson.isEmpty) {
        if (isUserType3) {
          selectedTaskIdentifier[3]?.clear();
        } else {
          selectedTaskIdentifier[2]?.clear();
        }
      } else {
        final last = selectedVPerson.lastOrNull;
        var result = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == last?['id']) && (["vehicle", "group_vehicle", "person", "vehicles", "person"].contains(element['type'])));
        if (isUserType3) {
          selectedTaskIdentifier[3] = result ?? {};
        } else {
          selectedTaskIdentifier[2] = result ?? {};
        }
      }
      if (isUserType5) {
        selectedTaskIdentifier.removeWhere((key, value) => [2, 3].contains(key));
        selectedVPerson.clear();
      }
    } else {
      if (selectedVPerson.isEmpty) {
        selectedTaskIdentifier[2]?.clear();
      } else {
        final last = selectedVPerson.lastOrNull;
        var result = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == last?['id']) && (["vehicle", "group_vehicle", "person", "vehicles", "person"].contains(element['type'])));
        selectedTaskIdentifier[2] = result ?? {};
      }
    }
    emit(CommonState());
    _updateReservation(emit);
  }

  void _onTimeSensitiveEvent(TimeSensitiveEvent event, Emitter<AddToDoState> emit) {
    isTimeSensitive = !isTimeSensitive;
    emit(CommonState());
  }

  void _onViewAttachmentEvent(ViewAttachmentEvent event, Emitter<AddToDoState> emit) {
    if (attachments.isNotEmpty) return emit(ViewAttachmentState(attachments));
  }

  void _onAddAttachmentEvent(AddAttachmentEvent event, Emitter<AddToDoState> emit) async {
    try {
      var files = await _pickFiles();
      attachments.addAll(files ?? []);
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      rethrow;
    }
  }

  void _onCleanCarDurationEvent(CleanCarDurationEvent event, Emitter<AddToDoState> emit) {
    selectedClearDuration = event.duration;
    emit(CommonState());
  }

  void _onNewPartsEvent(NewPartsEvent event, Emitter<AddToDoState> emit) {
    emit(NewPartState(partsController.text));
  }

  void _onNewSuppliesEvent(NewSuppliesEvent event, Emitter<AddToDoState> emit) {
    emit(NewSupplyState(suppliesController.text));
  }

  void _onPartsEvent(PartsEvent event, Emitter<AddToDoState> emit) {
    if (event.isChecked) {
      selectedParts.add(event.part);
    } else {
      selectedParts.remove(event.part);
    }
    emit(CommonState());
  }

  void _onSuppliesEvent(SuppliesEvent event, Emitter<AddToDoState> emit) {
    if (event.isChecked) {
      selectedSupplies.add(event.supply);
    } else {
      selectedSupplies.remove(event.supply);
    }
    emit(CommonState());
  }

  void _onLeadEvent(LeadEvent event, Emitter<AddToDoState> emit) {
    selectedLead = event.lead;
    if (["vehicle", "group_vehicle", "person"].contains(selectedTaskIdentifier[2]?['type'])) {
      selectedTaskIdentifier[3] = selectedTaskIdentifier[2] ?? {};
    }
    selectedTaskIdentifier[2] = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => element['id'] == selectedLead['id'] && element['type'] == "lead") ?? {};
    emit(CommonState());
  }

  void _onMeetingEvent(MeetingEvent event, Emitter<AddToDoState> emit) {
    selectedMeetingMode = event.meetingMode;
    if (selectedMeetingMode['id'] != 1) {
      selectedMeetingDuration = ToDoConfig.defaultMeetingDuration;
      meetingLinkController.clear();
    } else {
      selectedMeetingDuration = ToDoConfig.defaultMeetingDuration;
    }
    emit(CommonState());
  }

  void _onOpenCustomLinkEvent(OpenCustomLinkEvent event, Emitter<AddToDoState> emit) {
    try {
      var url = selectedCustom['label'].toString().isCustomLink
          ? customLinkController.text
          : selectedCustom['label'].toString().isTuroReservation
          ? customLinkController.text.toTuroReserveUrl
          : customLinkController.text.toFaiRentalReserveUrl;
      emit(OpenLinkState(url));
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }

  void _onAddressEvent(AddressEvent event, Emitter<AddToDoState> emit) {
    if (event.isChecked) {
      selectedAddress.add(event.address);
    } else {
      selectedAddress.remove(event.address);
    }
    var addresses = [...selectedAddress.unique((element) => element['id'])];
    selectedAddress.clear();
    selectedAddress.addAll(addresses);
    emit(CommonState());
  }

  /// Validation rules:
  /// dept == 7 → platform check required
  /// task_name != null
  /// task_manager != empty
  void _validate(Emitter<AddToDoState> emit) {
    if (taskNameController.text.trim().isNullOrEmpty) return emit(ErrorState("Task name is required"));
    final isPlatformCheckRequired = hasPlatformCheck && departmentId == 7 && (!isPlatformCheck);
    if (isPlatformCheckRequired) return emit(ErrorState("Platform check is required"));
    if (selectedTaskManagers.isEmpty) return emit(ErrorState("Task manager is required"));
    final recurringLabel = selectedRecurring['label'].toString();
    final isRecurring = !selectedRecurring['label'].toString().isDoesNotRepeat;
    if (isRecurring) {
      if (isRecurringEndDate && selectedRecurringEndDate == null) return emit(ErrorState("End date is required"));
      if (!isRecurringEndDate && recurringNoOccurrenceController.text.trim().isNullOrEmpty) return emit(ErrorState("No of occurrences is required"));
      if (recurringLabel.isDailyOrWeekly && recurringEveryDayWeekController.text.trim().isNullOrEmpty) return emit(ErrorState("Occurring count is required"));
      if (recurringLabel.isWeekly && selectedRecurringDays.isEmpty) return emit(ErrorState("Please choose at least one day to recur"));
      if (recurringLabel.isMonthly) {
        if (recurringMonthDateController.text.trim().isNullOrEmpty) return emit(ErrorState("Occurrence Date is required"));
        if (!isRecurringMonthOccurrence && recurringMonthMonthController.text.trim().isNullOrEmpty) return emit(ErrorState("Occurrence Month is required"));
      }

      if (recurringLabel.isYearly) {
        if (recurringYearDateController.text.trim().isNullOrEmpty) return emit(ErrorState("Occurrence Date is required"));
        if (recurringYearlySelectedMonth == null) return emit(ErrorState("Occurrence Month is required"));
      }
    }
  }

  void _onDeleteAttachmentEvent(DeleteAttachmentEvent event, Emitter<AddToDoState> emit) {
    attachments.remove(event.attachment);
    emit(CommonState());
  }

  void _onMeetingDurationEvent(MeetingDurationEvent event, Emitter<AddToDoState> emit) {
    selectedMeetingDuration = event.meetingDuration;
    emit(CommonState());
  }
}