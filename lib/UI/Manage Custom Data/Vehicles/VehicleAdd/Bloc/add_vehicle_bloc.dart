
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_state.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVehicleBloc extends Bloc<AddVehicleEvent, AddVehicleState>{
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> cohort = [];
  List<Map<String, dynamic>> branch = [];
  List<dynamic> vehicleStatus = [];
  List<dynamic> activeStatus = [{'id': 1, 'category_name': 'Active'}, {'id': 0, 'category_name': 'Inactive'}];
  List<dynamic> vehicleImage = [];
  List<dynamic> receiptImage = [];
  List<dynamic> tireImage = [];
  List<dynamic> tollImage = [];
  List<dynamic> uploadRegSticker = [];
  List<dynamic> insuranceImage = [];

  dynamic selectedCohort = {};
  dynamic selectedBranch = {};
  dynamic selectedActiveStatus = {};
  dynamic selectedVehicleStatus = {};
  Map<int, bool> selectedVehicles = {};

  List<int> selectedIds = [];

  TextEditingController yearController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController purchaseDateController = TextEditingController();
  TextEditingController vinController = TextEditingController();
  TextEditingController vehicleIdController = TextEditingController();
  TextEditingController earningsController = TextEditingController();
  TextEditingController utilizationRateController = TextEditingController();
  TextEditingController platformController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController wholeSaleAmountController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController oilGradeController = TextEditingController();
  TextEditingController frontTireController = TextEditingController();
  TextEditingController rearTireController = TextEditingController();
  TextEditingController renewalDateController = TextEditingController();
  TextEditingController numberPlateController = TextEditingController();
  TextEditingController tollTagsController = TextEditingController();
  TextEditingController spareTireController = TextEditingController();
  TextEditingController insuranceCostController = TextEditingController();
  TextEditingController insuranceAgentController = TextEditingController();
  TextEditingController currentOdometerController = TextEditingController();
  TextEditingController oilChangeOdometerController = TextEditingController();
  TextEditingController maintenanceCheckController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? selectedPurchaseDate = DateTime.now();
  DateTime? selectedRegStickerDate = DateTime.now();
  int? get branchId => Session.of.getInt(Str.branchIdPrefText);

  bool showMore = false;
  bool bouncie = false;
  bool tollTags = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  final FBroadcast _broadcast = FBroadcast.instance();

  AddVehicleBloc() : super(AddVehicleLoadingState()) {


    on<AddVehicleInitialEvent>((event, emit) async {
      // emit(AddVehicleLoadingState());
      var response = await Future.wait([
        _getCohort(),
        _getBranch(),
        _getVehicleStatusCategories(),
      ]);
      var cohortResponse= response[0];
      var branchResponse= response[1];
      var vehicleStatusResponse= response[2];

      cohort = cohortResponse??[];
      branch = branchResponse??[];
      vehicleStatus = vehicleStatusResponse ?? [];
      selectedCohort = cohort.firstWhereOrNull((element) => element['id'].toString() == "13",);
      selectedBranch = branch.firstWhereOrNull((element) => element['id'].toString() == branchId.toString(),);
      selectedVehicleStatus = vehicleStatus.firstWhereOrNull((element) => element['id'].toString() == "1",);
      selectedActiveStatus = activeStatus.firstWhereOrNull((element) => element['id'].toString() == "1",);
      emit(AddVehicleLoadedState());
    });

    on<DateChangeEvent>((event, emit) {
      selectedPurchaseDate = event.selectedDate;
        emit(AddVehicleCommonState());
    });

    on<RegStickerDateEvent>((event, emit) {
      selectedRegStickerDate = event.selectedDate;
      emit(AddVehicleCommonState());
    });

    on<PurchaseReceiptImageEvent>((event, emit) async {
      await _handleFileSelection(receiptImage, "receiptImageFile", emit);
      log("$receiptImage", name: "PurchaseReceiptImageEvent");
    });

    on<VehicleImageEvent>((event, emit) async {
      await _handleFileSelection(vehicleImage, "vehicleImageFile", emit);
    });

    on<TollImageEvent>((event, emit) async {
      await _handleFileSelection(tollImage, "tollImageFile", emit);
    });

    on<TireImageEvent>((event, emit) async {
      await _handleFileSelection(tireImage, "tireImageFile", emit);
    });

    on<UploadRegStickerImageEvent>((event, emit) async {
      await _handleFileSelection(uploadRegSticker, "uploadRegStickerImageFile", emit);
    });

    on<InsuranceImageEvent>((event, emit) async {
      await _handleFileSelection(insuranceImage, "insuranceImageFile", emit);
    });

    on<RemovePurchaseReceiptImageEvent>((event, emit) async {
      _handleFileRemoval(receiptImage, event.data, emit);
    });

    on<RemoveVehicleImageEvent>((event, emit) async {
      _handleFileRemoval(vehicleImage, event.data, emit);
    });

    on<RemoveTollImageEvent>((event, emit) async {
      _handleFileRemoval(tollImage, event.data, emit);
    });

    on<RemoveTireImageEvent>((event, emit) async {
      _handleFileRemoval(tireImage, event.data, emit);
    });

    on<RemoveRegStickerImageEvent>((event, emit) async {
      _handleFileRemoval(uploadRegSticker, event.data, emit);
    });

    on<RemoveInsuranceImageEvent>((event, emit) async {
      _handleFileRemoval(insuranceImage, event.data, emit);
    });

    on<CohortDropDownEvent>((event, emit) {
      selectedCohort = event.selectedCohort;
      emit(AddVehicleCommonState());
    });

    on<BranchDropDownEvent>((event, emit) {
      selectedBranch = event.selectedBranch;
      emit(AddVehicleCommonState());
    });

    on<AddVehicleShowMoreEvent>((event, emit) {
      showMore = !showMore;
      emit(AddVehicleCommonState());
    });

    on<BouncieEvent>((event, emit) {
      bouncie = !bouncie;
      emit(AddVehicleCommonState());
    });

    on<TollTagsEvent>((event, emit) {
      tollTags = !tollTags;
      emit(AddVehicleCommonState());
    });

    on<AirTagEvent>((event, emit) {
      airTag= !airTag;
      emit(AddVehicleCommonState());
    });

    on<PermanentPlateEvent>((event, emit) {
      permanentPlate = !permanentPlate;
      emit(AddVehicleCommonState());
    });

    on<SpareTireEvent>((event, emit) {
      spareTire = !spareTire;
      emit(AddVehicleCommonState());
    });

    on<SpareKeyEvent>((event, emit) {
      spareKey = !spareKey;
      emit(AddVehicleCommonState());
    });

    on<FrontLicensePlateEvent>((event, emit) {
      frontLicensePlate = !frontLicensePlate;
      emit(AddVehicleCommonState());
    });

    on<SaveNewVehicleEvent>((event, emit) async {
      if (formKey.currentState?.validate() == false) return;
      try {
        emit(AddVehicleLoadingState());
        List<Map<String, String?>> infusedFiles = [
          ...vehicleImage.whereType<File>().map((e) => {"images" : e.path}),
          ...receiptImage.whereType<File>().map((e) => {"files" : e.path}),
          ...tireImage.whereType<File>().map((e) => {"tyre_images" : e.path}),
          ...tollImage.whereType<File>().map((e) => {"toll_images" : e.path}),
          ...uploadRegSticker.whereType<File>().map((e) => {"registration_documents" : e.path}),
          ...insuranceImage.whereType<File>().map((e) => {"insurance_agent_images" : e.path}),
        ];
        var response = await _apiRepository.vehicleAddOrUpdateApi(
          infusedFiles: infusedFiles,
          body: _save(),
        );
        (response?.containsKey("error") ?? false)
            ? Toaster.showError(response?['error'] ?? "")
            : Toaster.showSuccess(response?['message'] ?? "");
        if ((response?.isNotEmpty ?? false) && (response?.containsKey("message") ?? false)) {
         if(response?['data']?['vin']!=null) {
           Console.of.log(response?['data']);
           var data = response?['data'];
           Map<String, String> body = {
             'branch_id': '${data?['branch_code'] ?? ''}',
             'cohort_id': '${data?['cohort_id'] ?? ''}',
             'start_at': DateTime.now().toFormat(format: 'yyyy-MM-dd') ?? "",
             'status': 'In Progress',
             'title': 'Transport Car-Buy',
             'todo_time': DateTime.now().toFormat(format: 'HH:mm:ss') ?? "",
             'user_id': '${getIt<CommonService>().userId}',
             'vehicle_name': '${data?['year']}${data?['make']}${data?['model']}',
             'vehicle_status_category': '1',
             'vehicle_status_checklist': '1',
             'vin': '${data?['vin']}',
           };
           Console.of.log(body);
           await _apiRepository.setDefaultVehicleConfig(
               vin: body['vin'] ?? "");
           await _apiRepository.addToDo(body: body);
           _broadcast.broadcast("todo_view");
         }
          _broadcast.stickyBroadcast("vehicle_refresh", value: true);
          _broadcast.broadcast(Str.addToDoRefresh);
          _broadcast.broadcast(Str.editToDoRefresh);
          clearFields();
        }
        emit(AddCompletedState());
        // _broadcast.stickyBroadcast("expense_person_refresh", value: true);
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(AddCompletedState());
      }

    });

  }

  Map<String, String> _save() {
    Map<String, String> baseBody = {};
    baseBody['vin'] = vinController.text;
    baseBody['vehicle_id'] = vehicleIdController.text;
    baseBody['make'] = makeController.text;
    baseBody['model'] = modelController.text;
    baseBody['year'] =  yearController.text;
    baseBody['cohort_id'] = '${selectedCohort['id'] ?? ''}';
    baseBody['earnings'] = earningsController.text;
    baseBody['utilization_rate'] = utilizationRateController.text;
    baseBody['platform'] = platformController.text;
    baseBody['mileage'] = mileageController.text;
    baseBody['whole_sale_amount'] = wholeSaleAmountController.text;
    baseBody['vehicle_status'] = "${selectedVehicleStatus['id'] ?? ''}";
    baseBody['active'] = "${selectedActiveStatus['id'] ?? ''}";
    baseBody['purchase_price'] = purchasePriceController.text;
    baseBody['purchase_date'] = selectedPurchaseDate?.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['vehicle_number'] = numberPlateController.text;
    baseBody['address'] = addressController.text;
    baseBody['bouncie'] = bouncie ? "1" : "0";
    baseBody['air_tag'] = airTag ? "1" : "0";
    baseBody['spare_tire'] = spareTire ? "1" : "0";
    baseBody['spare_key'] = spareKey ? "1" : "0";
    baseBody['permanent_plate'] = permanentPlate ? "1" : "0";
    baseBody['car_number'] = carNumberController.text;
    baseBody['oil_grade'] = oilGradeController.text;
    baseBody['branch_code'] = '${selectedBranch['id'] ?? ''}';
    baseBody['registration_renewal_date'] = selectedRegStickerDate?.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['toll_tags'] = tollTags ? "1" : "0";
    baseBody['toll_tags_id'] = tollTagsController.text;
    baseBody['front_license_plate'] = frontLicensePlate ? "1" : "0";
    baseBody['tire_size'] = spareTireController.text;
    baseBody['front_tire'] = frontTireController.text;
    baseBody['rear_tire'] = rearTireController.text;
    baseBody['current_odometer'] = currentOdometerController.text;
    baseBody['oil_change_odometer'] = oilChangeOdometerController.text;
    baseBody['maintenance_check'] = maintenanceCheckController.text;
    baseBody['insurance_agent'] = insuranceAgentController.text;
    baseBody['insurance_cost'] = insuranceCostController.text;
    baseBody['platform_from'] = 'tasker-app';
    log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov',]);
    return result?.paths
        .where((element) => (element?.isNotEmpty ?? false))
        .map((e) => File(e!))
        .toList() ??
        [];
  }

  Future<void> _handleFileSelection(
      List<dynamic> fileList, String logName, Emitter emit) async {
    var result = await _pickFiles();
    if (result.isNotEmpty) {
      var existingAttachments =
      fileList.whereType<File>().map((e) => e.path).toList();

      List<File> newFiles = [];
      for (var element in result) {
        if (!existingAttachments.contains(element.path)) {
          newFiles.add(element);
        }
      }
      fileList.clear();
      fileList.addAll(existingAttachments.map((path) => File(path))); // Retain existing
      fileList.addAll(newFiles);

      log("$fileList", name: logName);
      emit(AddVehicleCommonState());
    }
  }

  void _handleFileRemoval(List<dynamic> fileList, dynamic data, Emitter emit) {
    if (data == null) return;
    if (data is File) {
      fileList.remove(data);
    }
    emit(AddVehicleCommonState());
  }

  ///COHORT API CALL
  Future<List<Map<String, dynamic>>?> _getCohort() async {
    return await getIt<CommonService>().getCohorts();
  }

  ///BRANCH API CALL
  Future<List<Map<String, dynamic>>?> _getBranch() async {
    return await getIt<CommonService>().getBranches();
  }

  /// VEHICLE STATUS API CALL
  Future<List<Map<String, dynamic>>?> _getVehicleStatusCategories() async =>
      await getIt<CommonService>().getActiveVehiclesCount();

  void clearFields() {
    yearController.clear();
    makeController.clear();
    modelController.clear();
    purchasePriceController.clear();
    purchaseDateController.clear();
    vinController.clear();
    vehicleIdController.clear();
    earningsController.clear();
    utilizationRateController.clear();
    platformController.clear();
    mileageController.clear();
    wholeSaleAmountController.clear();
    addressController.clear();
    carNumberController.clear();
    oilGradeController.clear();
    frontTireController.clear();
    rearTireController.clear();
    renewalDateController.clear();
    numberPlateController.clear();
    tollTagsController.clear();
    spareTireController.clear();
    insuranceCostController.clear();
    insuranceAgentController.clear();
    currentOdometerController.clear();
    oilChangeOdometerController.clear();
    maintenanceCheckController.clear();
    receiptImage.clear();
    vehicleImage.clear();
    tireImage.clear();
    tollImage.clear();
    uploadRegSticker.clear();
    insuranceImage.clear();
    selectedCohort = cohort.firstWhereOrNull((element) => element['id'].toString() == "13",);
    selectedBranch = branch.firstWhereOrNull((element) => element['id'].toString() == branchId.toString(),);
    selectedVehicleStatus = vehicleStatus.firstWhereOrNull((element) => element['id'].toString() == "1",);
    selectedActiveStatus = activeStatus.firstWhereOrNull((element) => element['id'].toString() == "1",);
    showMore = false;
    bouncie = false;
    tollTags = false;
    airTag = false;
    permanentPlate = false;
    spareTire = false;
    spareKey = false;
    frontLicensePlate = false;

  }

}
