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
  final QuillController enquiryController = QuillController.basic();

  final List<Map<String, dynamic>> selectedParts = [], selectedSupplies = [], selectedTaskManagers = [], selectedAddress = [];
  final List<dynamic> attachments = []; // SELECTED AND STORING FILE'S
  bool showParts = false, showSupplies = false, showCleanCar = false, isPlatformCheck = false, isTimeSensitive = false, showMore = false, isRecurringMonthOccurrence = false, isRecurringEndDate = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? selectedRecurringEndDate;
  dynamic recurringYearlySelectedMonth;
  Map<int, Map<String, dynamic>> selectedTaskIdentifier = {
    1 : {},
    2 : {},
    3 : {}
  };
  Map<String, dynamic> selectedRecurring = ToDoConfig.recurringOptions.first, selectedCustom = ToDoConfig.customOptions.first, selectedClearDuration = ToDoConfig.cleanCarDurations.first, selectedLead = {}, selectedMeetingMode = ToDoConfig.meetingMode.firstWhere((element) => element['id'] == 1);
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
  bool get showReservation => (selectedCustom.isNotEmpty) && (!isNextTask);
  bool get hasAddress => showMore && selectedTaskIdentifier[3]?['type'] == "location";
  bool get isVehicleRequired => isCleanCar || hasCleanCar || hasOilChange;

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
    var baseBody = _cleanCarBody();
    baseBody['title'] = taskNameController.text;
    baseBody['identifier_id'] = ((taskNameController.text.isNotEmpty) &&
        (selectedTaskIdentifier[1]?['name'] ==
            taskNameController.text))
        ? "${selectedTaskIdentifier[1]?['id'] ?? ""}"
        : "";
    baseBody['repeatPeriod'] =
        ((selectedRecurring['label'].toString().isDoesNotRepeat == false)
            ? (selectedRecurring['label'].toString().toLowerCase())
            : "");
    baseBody['repeatDay'] =
    (selectedRecurring['label'].toString().isDaily)
        ? recurringEveryDayWeekController.text
        : "";
    baseBody['repeatWeek'] =
    (selectedRecurring['label'].toString().isWeekly)
        ? recurringEveryDayWeekController.text
        : "";
    baseBody['weekDay'] =
    (selectedRecurring['label'].toString().isWeekly)
        ? "${selectedRecurringDays.map((e) => jsonEncode(e.toString().toLowerCase())).toList()}"
        : "";
    baseBody['recur_monthly_type'] = "$isRecurringMonthOccurrence";
    baseBody['repeatDateMonth'] = isRecurringMonthOccurrence
        ? recurringMonthDateController.text
        : "";
    baseBody['repeatMonth'] = !isRecurringMonthOccurrence
        ? recurringMonthDateController.text
        : "";
    baseBody['repeatDayMonth'] = !isRecurringMonthOccurrence
        ? recurringMonthMonthController.text
        : "";
    baseBody['repeatDateYear'] =
    (selectedRecurring['label'].toString().isYearly)
        ? recurringYearDateController.text
        : "";
    baseBody['repeatMonthYear'] =
        recurringYearlySelectedMonth?['month'].toString() ?? "";
    baseBody['end_type'] = "$isRecurringEndDate";
    baseBody['end_after'] = (!isRecurringEndDate)
        ? (recurringNoOccurrenceController.text)
        : "";
    baseBody['end_at'] = selectedRecurringEndDate.toFormat() ?? "";
    baseBody['todo_time'] = selectedTime.toHMS().toString();
    baseBody['platform_check'] = "${isPlatformCheck ? 1 : 0}";
    baseBody['todo_user_type'] = "0";
    baseBody['comments'] = "";
    baseBody['mileage'] = "";
    baseBody['resolution_notes'] = "";
    baseBody['custom_link_id'] = "${selectedCustom['id'] ?? ""}";
    baseBody['custom_link'] =
    (selectedCustom['id'] == 1) ? customLinkController.text : "";
    baseBody['reference_id'] =
    (selectedCustom['id'] != 1) ? customLinkController.text : "";
    if (baseBody['identifier_id'].toString().contains("358")) {
      if (enquiryController.document.toPlainText().trim().isNotNullOrEmpty) {
        baseBody['rental_enquiry'] = QuillDeltaToHtmlConverter(enquiryController.document.toDelta().toJson(), ConverterOptions.forEmail()).convert();
      }
    }
    return baseBody;
  }

  Map<String, String> _cleanCarBody() {
    var location = (selectedTaskIdentifier[3]?['type'] == "location")
        ? selectedTaskIdentifier[3]
        : null;
    var vendor = (selectedTaskIdentifier[3]?['type'] == "vendor")
        ? selectedTaskIdentifier[3]
        : null;
    var person = (selectedTaskIdentifier[2]?['type'] == "person")
        ? selectedTaskIdentifier[2]
        : null;
    var vehicleGroup =
    (selectedTaskIdentifier[2]?['type'] == "g_vehicles")
        ? selectedTaskIdentifier[2]
        : null;
    var isAdd = selectedTaskIdentifier[1]?['id'] == 210;
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

  void _onIdentifierEvent(IdentifierEvent event, Emitter<AddToDoState> emit) {
    if (event.identifier is Map) {
      selectedTaskIdentifier = event.identifier;
      for (var element in selectedTaskIdentifier.entries) {
        switch(element.key) {
          case 1: { taskNameController.text = element.value['name'] ?? ""; } break;
          case 2: {
            if (element.value.isNotEmpty ?? false) {
              selectedVPerson.add(element.value);
            }
            selectedVPerson = selectedVPerson.unique((element) => element['id']);
          } break;
        }
      }
    } else if (event.identifier is List) {
      selectedTaskIdentifiers = event.identifier;
      final result = selectedTaskIdentifiers.fold<Map<int, Map<String, dynamic>>>({}, (map, e) {
        if (e['type'] == 'task') {
          map[1] = e;
        } else if (['lead', "vehicle", "person", "group_vehicle"].contains(e['type'])) {
          map[(e['type'] == "lead") ? 2 : (isLeadTask) ? 3 : 2] = e;
        } else if (["vendor", "location"].contains(e['type'])) {
          map[3] = e;
        }
        return map;
      });
      selectedTaskIdentifier = selectedTaskIdentifiers.isEmpty ? {
        1 : {},
        2 : {},
        3 : {}
      } : {
        1 : result[1] ?? {},
        2 : result[2] ?? (selectedTaskIdentifier[2] ?? {}),
        3 : result[3] ?? (selectedTaskIdentifier[3] ?? {}),
      };
      for (var element in selectedTaskIdentifier.entries) {
        switch(element.key) {
          case 1: {
            taskType = switch(element.value['user_type_id']) {
              1 => TaskType.rental,
              2 => TaskType.rental,
              3 => TaskType.lead,
              4 => TaskType.nonRental,
              5 => TaskType.meeting,
              _ => TaskType.rental,
            };
            taskNameController.text = element.value['name'] ?? "";
          } break;
          case 2: {
            if (element.value.isEmpty) {
              selectedVPerson.clear();
              selectedLead.clear();
            }
            if ((element.value.isNotEmpty) && (element.value['type'] != "lead")) selectedVPerson.add(element.value);
            if (element.value['type'] == "lead") selectedLead = element.value?['value'];
            selectedVPerson = selectedVPerson.unique((element) => element['id']);
          } break;
          case 3: {
            if (element.value.isEmpty) {
              selectedTaskIdentifier[3] = {};
              if (isLeadTask) {
                selectedLead.clear();
                selectedVPerson.clear();
              }
            }
            if (["vehicle", "person", "group_vehicle"].contains(element.value['type'])) {
              selectedVPerson.add(element.value);
              selectedVPerson = selectedVPerson.unique((element) => element['id']);
            }
          } break;
        }
      }
    }
    if (isMeeting || isLeadTask) selectedTaskIdentifier.removeWhere((key, value) => [2,3].contains(key));
    if (isLeadTask) {
      if (selectedLead.isNotEmpty) {
        selectedTaskIdentifier[2] = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => element['id'] == selectedLead['id'] && element['type'] == "lead") ?? {};
      }
      if (selectedVPerson.isNotEmpty) {
        final last = selectedVPerson.lastOrNull;
        var result = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == last?['id']) && (["vehicle", "group_vehicle", "person", "lead"].contains(element['type'])));
        selectedTaskIdentifier[3] = result ?? {};
      }
    }
    emit(CommonState());
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
    selectedTaskIdentifier[3] = event.vendorLocation;
    var result = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == event.vendorLocation['id']) && (["vendor", "location"].contains(element['type'])));
    if (result != null) {
      if (selectedTaskIdentifiers.isEmpty) while (selectedTaskIdentifiers.length <= 2) { selectedTaskIdentifiers.add({}); }
      selectedTaskIdentifiers[0] = selectedTaskIdentifiers[0] ?? {};
      selectedTaskIdentifiers[1] = selectedTaskIdentifiers[1] ?? {};
      selectedTaskIdentifiers[2] = result;
    }
    emit(CommonState());
  }

  void _onVehiclePersonEvent(VehiclePersonEvent event, Emitter<AddToDoState> emit) {
    selectedVPerson = event.vehiclePerson;
    if (selectedVPerson.isNotEmpty) {
      final last = selectedVPerson.lastOrNull;
      Console.of.log(last?['id'], name: "LAST_V");
      var result = taskIdentifierList.expand((element) => element).firstWhereOrNull((element) => (element['id'] == last?['id']) && (["vehicle", "group_vehicle", "person"].contains(element['type'])));
      Console.of.log(last?['id'], name: "LAST_V");
      selectedTaskIdentifier[isLeadTask ? 3 : 2] = result ?? {};
    } else {
      selectedTaskIdentifier[isLeadTask ? 3 : 2] = {};
    }
    emit(CommonState());
  }

  void _onTimeSensitiveEvent(TimeSensitiveEvent event, Emitter<AddToDoState> emit) {
    isTimeSensitive = !isTimeSensitive;
    emit(CommonState());
  }

  void _onViewAttachmentEvent(ViewAttachmentEvent event, Emitter<AddToDoState> emit) {
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
}