
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_state.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditVehicleBloc extends Bloc<EditVehicleEvent, EditVehicleState>{
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> cohort = [];
  List<Map<String, dynamic>> branch = [];
  List<dynamic> vehicleStatus = [];
  List<dynamic> expenseDetails = [];
  List<dynamic> repairAndMaintenanceDetails = [];
  List<dynamic> activeStatus = [{'id': 1, 'category_name': 'Active'}, {'id': 0, 'category_name': 'Inactive'}];
  List<dynamic> vehicleImage = [];
  List<dynamic> vehicleImageList = [];
  List<dynamic> receiptImage = [];
  List<dynamic> receiptImageList = [];
  List<dynamic> tireImage = [];
  List<dynamic> tireImageList = [];
  List<dynamic> tollImage = [];
  List<dynamic> tollImageList = [];
  List<dynamic> uploadRegSticker = [];
  List<dynamic> uploadRegStickerList = [];
  List<dynamic> insuranceImage = [];
  List<dynamic> insuranceImageList = [];


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
  DateTime? selectedRegStickerDate;
  int? branchId;

  bool showMore = false;
  bool bouncie = false;
  bool tollTags = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  final FBroadcast _broadcast = FBroadcast.instance();

  EditVehicleBloc() : super(EditVehicleLoadingState()) {


    on<EditVehicleInitialEvent>((event, emit) async {
      try{
      emit(EditVehicleLoadingState());
      var cohortResponse= await _getCohort();
      var branchResponse= await _getBranch();
      var vehicleStatusResponse= await _getVehicleStatusCategories();
      var editVehicleExpenseDetailsResponse= await _getEditVehicleExpenseDetails(vin:"${event.vehicleData['vin']}");

      branchId = await Utils.getIntPreference(Str.branchIdPrefText);

      cohort = cohortResponse??[];
      branch = branchResponse??[];
      vehicleStatus = vehicleStatusResponse?['data']??[];
      expenseDetails = editVehicleExpenseDetailsResponse?['data']??[];
      repairAndMaintenanceDetails = editVehicleExpenseDetailsResponse?['repair_and_maintenance_details']??[];

      selectedCohort = cohort.firstWhereOrNull((element) => element['id'].toString() == event.vehicleData['cohort_id'].toString(),);
      selectedBranch = branch.firstWhereOrNull((element) => element['id'].toString() == event.vehicleData['branch_code'].toString(),);
      selectedVehicleStatus = vehicleStatus.firstWhereOrNull((element) => element['id'].toString() == event.vehicleData['vehicle_status'].toString(),);
      selectedActiveStatus = activeStatus.firstWhereOrNull((element) => element['id'].toString() == event.vehicleData['active'].toString(),);

      yearController.text = "${event.vehicleData['year'] ?? ''}";
      makeController.text = "${event.vehicleData['make'] ?? ''}";
      modelController.text = "${event.vehicleData['model']??''}";
      purchasePriceController.text = "${event.vehicleData['purchase_price'] ?? ''}";
      purchaseDateController.text = "${event.vehicleData['purchase_date'] ?? ''}";
      vinController.text = "${event.vehicleData['vin'] ?? ''}";
      vehicleIdController.text = "${event.vehicleData['vehicle_id'] ?? ''}";
      earningsController.text= "${event.vehicleData['earnings'] ?? ''}";
      utilizationRateController.text = "${event.vehicleData['utilization_rate']??''}";
      platformController.text = "${event.vehicleData['platform']??''}";
      mileageController.text = "${event.vehicleData['mileage'] ?? ''}";
      wholeSaleAmountController.text = "${event.vehicleData['wholesale_amount'] ?? ''}";
      addressController.text = "${event.vehicleData['address'] ?? ''}";
      carNumberController.text = "${event.vehicleData['car_number'] ?? ''}";
      oilGradeController.text = "${event.vehicleData['oil_grade'] ?? ''}";
      frontTireController.text = "${event.vehicleData['front_tire'] ?? ''}";
      rearTireController.text = "${event.vehicleData['rear_tire'] ?? ''}";
      renewalDateController.text = "${event.vehicleData['registration_renewal_date'] ?? ''}";
      numberPlateController.text = "${event.vehicleData['vehicle_number'] ?? ''}";
      tollTagsController.text = "${event.vehicleData['toll_tags_id'] ?? ''}";
      spareTireController.text = "${event.vehicleData['tire_size'] ?? ''}";
      insuranceCostController.text = "${event.vehicleData['insurance_cost'] ?? ''}";
      insuranceAgentController.text = "${event.vehicleData['insurance_agent'] ?? ''}";
      currentOdometerController.text = "${event.vehicleData['current_odometer'] ?? ''}";
      oilChangeOdometerController.text = "${event.vehicleData['oil_change_odometer'] ?? ''}";
      maintenanceCheckController.text = "${event.vehicleData['maintenance_check'] ?? ''}";

      bouncie = event.vehicleData['bouncie'] == 1 ? true : false;
      tollTags = event.vehicleData['toll_tags'] == 1 ? true : false;
      airTag = event.vehicleData['air_tag'] == 1 ? true : false;
      spareTire = event.vehicleData['spare_tire'] == 1 ? true : false;
      spareKey = event.vehicleData['spare_key'] == 1 ? true : false;
      permanentPlate = event.vehicleData['permanent_plate'] == 1 ? true : false;
      frontLicensePlate = event.vehicleData['front_license_plate'] == 1 ? true : false;
      selectedPurchaseDate = event.vehicleData?['purchase_date'].toString().toDateTime(inputFormat: 'yyyy-MM-dd');
      selectedRegStickerDate = event.vehicleData?['registration_renewal_date'].toString().toDateTime(inputFormat: 'yyyy-MM-dd');

      vehicleImageList=(event.vehicleData?['images']).where((element) => element['vehicle_image_type'] == 1).toList();
      vehicleImage=vehicleImageList.map((e) => e['path'].toString().toStorageURL).toList();

      tollImageList=(event.vehicleData?['images']).where((element) => element['vehicle_image_type'] == 5).toList();
      tollImage=tollImageList.map((e) => e['path'].toString().toStorageURL).toList();

      tireImageList=(event.vehicleData?['images']).where((element) => element['vehicle_image_type'] == 2).toList();
      tireImage=tireImageList.map((e) => e['path'].toString().toStorageURL).toList();

      uploadRegStickerList=(event.vehicleData?['images']).where((element) => element['vehicle_image_type'] == 3).toList();
      uploadRegSticker=uploadRegStickerList.map((e) => e['path'].toString().toStorageURL).toList();

      insuranceImageList=(event.vehicleData?['images']).where((element) => element['vehicle_image_type'] == 4).toList();
      insuranceImage=insuranceImageList.map((e) => e['path'].toString().toStorageURL).toList();

      receiptImageList=event.vehicleData?['expenses']?['attachments']??[];
      receiptImage=receiptImageList.map((e) => e['path'].toString().toStorageURL).toList();

      emit(EditVehicleLoadedState());
      }catch(e){
        Console.of.error("Error", error: e);
        emit(EditVehicleErrorState(e.toString()));
        log(e.toString(),name: "EditVehicleInitialEvent");
      }

    });

    // on<EditVehicleExpenseDetailsEvent>((event, emit) async {
    //   try{
    //     emit(EditVehicleLoadingState());
    //     var editVehicleExpenseDetailsResponse= await _getEditVehicleExpenseDetails(vin:"${event.vehicleData['vin']}");
    //     expenseDetails = editVehicleExpenseDetailsResponse?['data']??[];
    //     repairAndMaintenanceDetails = editVehicleExpenseDetailsResponse?['data']??[];
    //     emit(EditVehicleLoadedState());
    //   }catch(e){
    //     emit(EditVehicleErrorState(e.toString()));
    //     log(e.toString(),name: "EditVehicleExpenseDetailsEvent");
    //   }
    // });

    on<DateChangeEvent>((event, emit) {
      selectedPurchaseDate = event.selectedDate;
      emit(EditVehicleCommonState());
    });

    on<RegStickerDateEvent>((event, emit) {
      selectedRegStickerDate = event.selectedDate;
      emit(EditVehicleCommonState());
    });

    on<PurchaseReceiptImageEvent>((event, emit) async {
      receiptImage = await _handleFileSelection(receiptImage, "receiptImageFile");
      log("$receiptImage", name: "PurchaseReceiptImageEvent");
      emit(EditVehicleCommonState());
    });

    on<VehicleImageEvent>((event, emit) async {
      vehicleImage = await _handleFileSelection(vehicleImage, "vehicleImageFile");
      log("$vehicleImage", name: "VehicleImageEvent");

      emit(EditVehicleCommonState());
    });

    on<TollImageEvent>((event, emit) async {
      tollImage = await _handleFileSelection(tollImage, "tollImageFile");
      emit(EditVehicleCommonState());
    });

    on<TireImageEvent>((event, emit) async {
      tireImage = await _handleFileSelection(tireImage, "tireImageFile");
      emit(EditVehicleCommonState());
    });

    on<UploadRegStickerImageEvent>((event, emit) async {
      uploadRegSticker = await _handleFileSelection(uploadRegSticker, "uploadRegStickerImageFile");
      emit(EditVehicleCommonState());
    });

    on<InsuranceImageEvent>((event, emit) async {
      insuranceImage = await _handleFileSelection(insuranceImage, "insuranceImageFile");
      emit(EditVehicleCommonState());
    });

    on<RemovePurchaseReceiptImageEvent>((event, emit) async {

      var data = await _handleFileRemoval(fileList: receiptImage,fullImageList:receiptImageList,data:event.data);
      //receiptImage.remove(data);
      emit(EditVehicleCommonState());
    });

    on<RemoveVehicleImageEvent>((event, emit) async {
      var data = await _handleFileRemoval(fileList:  vehicleImage,fullImageList:vehicleImageList,data: event.data);
      emit(EditVehicleCommonState());
    });

    on<RemoveTollImageEvent>((event, emit) async {
      var data = await _handleFileRemoval(fileList: tollImage,fullImageList:tollImageList,data:event.data);
      emit(EditVehicleCommonState());
    });

    on<RemoveTireImageEvent>((event, emit) async {
      var data = await _handleFileRemoval(fileList: tireImage,fullImageList:tireImageList,data:event.data);
      emit(EditVehicleCommonState());
    });

    on<RemoveRegStickerImageEvent>((event, emit) async {
      var data = await _handleFileRemoval(fileList:  uploadRegSticker,fullImageList:uploadRegStickerList,data:event.data);
      emit(EditVehicleCommonState());
    });

    on<RemoveInsuranceImageEvent>((event, emit) async {
      var data = await _handleFileRemoval(fileList: insuranceImage,fullImageList:insuranceImageList,data:event.data);
      emit(EditVehicleCommonState());
    });

    on<CohortDropDownEvent>((event, emit) {
      selectedCohort = event.selectedCohort;
      emit(EditVehicleCommonState());
    });

    on<BranchDropDownEvent>((event, emit) {
      selectedBranch = event.selectedBranch;
      emit(EditVehicleCommonState());
    });

    on<AddVehicleShowMoreEvent>((event, emit) {
      showMore = !showMore;
      emit(EditVehicleCommonState());
    });

    on<BouncieEvent>((event, emit) {
      bouncie = !bouncie;
      emit(EditVehicleCommonState());
    });

    on<TollTagsEvent>((event, emit) {
      tollTags = !tollTags;
      emit(EditVehicleCommonState());
    });

    on<AirTagEvent>((event, emit) {
      airTag= !airTag;
      emit(EditVehicleCommonState());
    });

    on<PermanentPlateEvent>((event, emit) {
      permanentPlate = !permanentPlate;
      emit(EditVehicleCommonState());
    });

    on<SpareTireEvent>((event, emit) {
      spareTire = !spareTire;
      emit(EditVehicleCommonState());
    });

    on<SpareKeyEvent>((event, emit) {
      spareKey = !spareKey;
      emit(EditVehicleCommonState());
    });

    on<FrontLicensePlateEvent>((event, emit) {
      frontLicensePlate = !frontLicensePlate;
      emit(EditVehicleCommonState());
    });

    on<SaveUpdatedVehicle>((event, emit) async {
      if (formKey.currentState?.validate() == false) return;
      try {
        emit(EditVehicleLoadingState());
        List<Map<String, String?>> infusedFiles = [
          ...vehicleImage.whereType<File>().map((e) => {"images" : e.path}),
          ...receiptImage.whereType<File>().map((e) => {"files" : e.path}),
          ...tireImage.whereType<File>().map((e) => {"tyre_images" : e.path}),
          ...tollImage.whereType<File>().map((e) => {"toll_images" : e.path}),
          ...uploadRegSticker.whereType<File>().map((e) => {"registration_documents" : e.path}),
          ...insuranceImage.whereType<File>().map((e) => {"insurance_agent_images" : e.path}),
        ];
        Console.of.log(infusedFiles, name: "infusedFiles");
        var response = await _apiRepository.vehicleAddOrUpdateApi(
          infusedFiles: infusedFiles,
          body: _save(),
          id:"${event.data['id']}",
        );
        await getIt<CommonService>().getActiveVehicles(reset: true);
        if (response?['message']?.isNotEmpty ?? false) {
          Toaster.showSuccess(response?['message'] ?? []);
        } else {
          Toaster.showError(response?['error'] ?? []);
        }
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        _broadcast.stickyBroadcast("vehicle_refresh", value: true);
        _broadcast.broadcast("todo_view");
        emit(EditCompletedState());
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(EditVehicleCommonState());
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

  Future<List<dynamic>> _handleFileSelection(
      List<dynamic> fileList, String logName) async {
    var result = await _pickFiles();
    if (result.isNotEmpty) {
      var existingAttachments =
      fileList.whereType<File>().map((e) => e.path).toList();
      var existingAttachmentString =
      fileList.whereType<String>().map((e) => e).toList();

      List<dynamic> newFiles = [];
      for (var element in result) {
        if (!existingAttachments.contains(element.path)) {
          newFiles.add(element);
        }
      }
      Console.of.log(fileList);
      Console.of.debug(existingAttachments);
      Console.of.error(newFiles);
      fileList = [];
      List<dynamic> existing = existingAttachments.map((path) => File(path)).toList();
      fileList.addAll(existingAttachmentString);
      fileList.addAll(existing);
      fileList.addAll(newFiles);

      log("$fileList", name: logName);
      Console.of.warning(vehicleImage, name: "vehicleImage");
      return fileList;
      // emit(EditVehicleCommonState());
    } else {
      return [];
    }
  }

  Future<dynamic> _handleFileRemoval(
      {required List<dynamic> fileList,
      required List<dynamic> fullImageList,
      required dynamic data}) async {
    if (data == null) return;
    if (data is File) {
      fileList.remove(data);
      return data;
    } else if(data is String){
      log(data, name: "data");
      log(fileList.toString(), name: "fileList");
      log("$fullImageList", name: "fullImageList");
      var path = fileList.firstWhereOrNull((element) => element == data.toString());
      var imageId = fullImageList.firstWhereOrNull((element) => element['path'] == path.toString().removeStorageUrl)?['id'];
      var response =  await _apiRepository.deleteVehicleImage(imageId);
      if(response?['success'] != null){
        Toaster.showSuccess(response?['success'] ?? []);
        fileList.remove(data);
        _broadcast.stickyBroadcast("vehicle_refresh", value: true);
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        _broadcast.broadcast("todo_view");
        return data;
      }
    }
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
  Future<Map<String, dynamic>?> _getVehicleStatusCategories() async =>
      await _apiRepository.getVehicleCategories();

  ///EDIT VEHICLE EXPENSE DETAILS API CALL
  Future<Map<String, dynamic>?> _getEditVehicleExpenseDetails({String? vin}) async =>
      await _apiRepository.getEditVehicleExpenseDetails(vin:vin);

}

