
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
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
  TextEditingController vehicleNoController = TextEditingController();
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
  DateTime? selectedDate = DateTime.now();
  DateTime? selectedRegStickerDate = DateTime.now();
  int? branchId;

  bool showMore = false;
  bool bouncie = false;
  bool tollTags = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool spareKey = false;
  bool frontLicensePlate = false;

  AddVehicleBloc() : super(AddVehicleLoadingState()) {


    on<AddVehicleInitialEvent>((event, emit) async {
      emit(AddVehicleLoadingState());
      var cohortResponse= await _getCohort();
      var branchResponse= await _getBranch();
      var vehicleStatusResponse= await _getVehicleStatusCategories();

      branchId = await Utils.getIntPreference(Str.branchIdPrefText);

      cohort = cohortResponse??[];
      branch = branchResponse??[];
      vehicleStatus = vehicleStatusResponse?['data']??[];
      selectedCohort = cohort.firstWhereOrNull((element) => element['id'].toString() == "13",);
      selectedBranch = branch.firstWhereOrNull((element) => element['id'].toString() == branchId.toString(),);
      selectedVehicleStatus = vehicleStatus.firstWhereOrNull((element) => element['id'].toString() == "1",);
      selectedActiveStatus = activeStatus.firstWhereOrNull((element) => element['id'].toString() == "1",);
      emit(AddVehicleLoadedState());
    });

    on<DateChangeEvent>((event, emit) {
      selectedDate = event.selectedDate;
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
  Future<Map<String, dynamic>?> _getVehicleStatusCategories() async =>
      await _apiRepository.getVehicleCategories();

}
