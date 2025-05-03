

import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_event.dart';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_state.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Repository/vehicle_repository.dart';
import '../../../Response/create_vehicle_data.dart';
import '../../../Utilities/Str.dart';
import '../../../core/initializer/common_initializer.dart';

class setVehicleBloc extends Bloc<setVehicleEvent,setVehicleState>{

  VehicleDataRepo vehicleDataRepo = VehicleDataRepo();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController makeController  = TextEditingController();
  final TextEditingController modelController  = TextEditingController();
  final TextEditingController vehicleNumberController  = TextEditingController();
  final TextEditingController purchasePriceController  = TextEditingController();
  final TextEditingController purchaseDateController  = TextEditingController();
  final TextEditingController vinController  = TextEditingController();
  final TextEditingController vehicleIdController  = TextEditingController();
  final TextEditingController earningsController  = TextEditingController();
  final TextEditingController utilizationRateController  = TextEditingController();
  final TextEditingController platformController  = TextEditingController();
  final TextEditingController mileageController  = TextEditingController();
  final TextEditingController wholeSaleAmountController  = TextEditingController();
  final TextEditingController addressController  = TextEditingController();
  final TextEditingController carNumberController  = TextEditingController();
  final TextEditingController oilGradeController  = TextEditingController();
  final TextEditingController frontTireController  = TextEditingController();
  final TextEditingController rearTireController  = TextEditingController();
  final TextEditingController renewalDateController  = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController tollTagsIdController = TextEditingController();
  final TextEditingController spareTireController = TextEditingController();
  final TextEditingController insuranceCostController = TextEditingController();
  final TextEditingController insuranceAgentController = TextEditingController();
  final TextEditingController currentOdometerController = TextEditingController();
  final TextEditingController oilChangeOdometerController = TextEditingController();
  final TextEditingController maintenanceCheckController = TextEditingController();
  bool loading = false;
  bool showMore = false;
  bool isYearFieldEmpty = false;
  bool isMakeFieldEmpty = false;
  bool isModelFieldEmpty = false;
  bool isPurchaseFieldEmpty = false;
  bool isPurchaseDateFieldEmpty = false;
  bool categoriesDataIsSelected = false;
  bool bouncie = false;
  bool tollTags = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  DateTime? renewalDate;
  String? selectedVehicleStatus;
  String? vinNumber;
  int? vehicleId;
  int? cohortId;
  int? vehicleStatus;
  int? branchCode;
  int? employeeId;
  List<dynamic> vehicleImageFile = [];
  List<dynamic> receiptImageFile = [];
  List<dynamic> images = List.empty(growable: true);
  List<dynamic> tireImageFile = List.empty(growable: true);
  List<dynamic> tollImage = List.empty(growable: true);
  List<dynamic> uploadRegSticker = List.empty(growable: true);
  List<dynamic> insuranceImage = List.empty(growable: true);
  dynamic selectedCohortsData;
  dynamic selectedCategoriesData;
  dynamic newVehicle;
  List<Map<String, dynamic>> cohortsData = [];
  List<Map<String, dynamic>> categoriesData = [];
  List<String> vehicleStatusList = ['Active', 'InActive'];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  setVehicleBloc() : super(const setVehicleInitialState()){

    on<setVehicleInitialEvents>((event, emit) async {
      emit(const setVehicleLoading());
      try{
        final response = await getIt<CommonService>().getActiveVehicles(reset: true);

        if (response.isNotEmpty && event.vehicle != null) {
          vinNumber = event.vehicle?['vin'];
          vehicleId = event.vehicle?['id'];
          try {
            newVehicle = response.firstWhere(
                  (e) => e['vin']?.toString() == event.vehicle?['vin']?.toString(),
              orElse: () => {},
            );

            //initialize fields
            yearController.clear();
            makeController.clear();
            modelController.clear();
            vehicleNumberController.clear();
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
            plateNumberController.clear();
            tollTagsIdController.clear();
            spareTireController.clear();
            insuranceCostController.clear();
            insuranceAgentController.clear();
            currentOdometerController.clear();
            oilChangeOdometerController.clear();
            maintenanceCheckController.clear();

            yearController.text = newVehicle['year']?.toString() ?? '';
            makeController.text = newVehicle['make']?.toString() ?? '';
            modelController.text = newVehicle['model']?.toString() ?? '';
            vehicleNumberController.text = newVehicle['vehicle_number']?.toString() ?? '';
            purchasePriceController.text = newVehicle['wholesale_amount']?.toString() ?? '';
            purchaseDateController.text = newVehicle['created_at']?.toString() ?? '';
            vinController.text = newVehicle['vin']?.toString() ?? '';
            vehicleIdController.text = newVehicle['vehicle_id']?.toString() ?? '';
            earningsController.text = newVehicle['earnings']?.toString() ?? '';
            utilizationRateController.text = newVehicle['utilization_rate']?.toString() ?? '';
            platformController.text = newVehicle['platform']?.toString() ?? '';
            mileageController.text = newVehicle['mileage']?.toString() ?? '';
            wholeSaleAmountController.text = newVehicle['wholesale_amount']?.toString() ?? '';
            addressController.text = newVehicle['address']?.toString() ?? '';
            carNumberController.text = newVehicle['car_number']?.toString() ?? '';
            oilGradeController.text = newVehicle['oil_grade']?.toString() ?? '';
            frontTireController.text = newVehicle['front_tire']?.toString() ?? '';
            rearTireController.text = newVehicle['rear_tire']?.toString() ?? '';
            renewalDateController.text = newVehicle['renewal_date']?.toString() ?? '';
            plateNumberController.text = newVehicle['plate_number']?.toString() ?? '';
            tollTagsIdController.text = newVehicle['toll_tags_id']?.toString() ?? '';
            spareTireController.text = newVehicle['tire_size']?.toString() ?? '';
            insuranceCostController.text = newVehicle['insurance_cost']?.toString() ?? '';
            insuranceAgentController.text = newVehicle['insurance_agent']?.toString() ?? '';
            currentOdometerController.text = newVehicle['current_odometer']?.toString() ?? '';
            oilChangeOdometerController.text = newVehicle['oil_change_odometer']?.toString() ?? '';
            maintenanceCheckController.text = newVehicle['maintenance_check']?.toString() ?? '';
            renewalDate = (newVehicle['registration_renewal_date'] ?? '').toString().toDateTime(inputFormat: 'yyyy-MM-dd');
            employeeId = newVehicle['employee_id'];
            branchCode = newVehicle['branch_code'];
            vehicleStatus = newVehicle['vehicle_status'];
            cohortId = newVehicle['cohort_id'];

            for (Map<String, dynamic> c in cohortsData) {
              if (c['id'] == newVehicle['cohort_id']) {
                selectedCohortsData = c;
              }
            }
            for (Map<String, dynamic> c in categoriesData) {
              if (c['id'] == newVehicle['vehicle_status']) {
                selectedCategoriesData = c;
              }
            }
            selectedVehicleStatus =
            (newVehicle['active'] ?? vehicleStatusList[1]) == 1
                ? vehicleStatusList[0]
                : vehicleStatusList[1];
            bouncie = (newVehicle['bouncie'] == 1);
            airTag = (newVehicle['air_tag'] == 1);
            permanentPlate = (newVehicle['permanent_plate'] == 1);
            spareTire = (newVehicle['spare_tire'] == 1);
            spareKey = (newVehicle['spare_key'] == 1);
            permanentPlate = (newVehicle['permanent_plate'] == 1);
            frontLicensePlate = (newVehicle['front_license_plate'] == 1);
            tollTags = (newVehicle['toll_tags'] == 1);
            vehicleImageFile.clear();
            tireImageFile.clear();
            tollImage.clear();
            uploadRegSticker.clear();
            insuranceImage.clear();
            receiptImageFile.clear();

            images = (newVehicle['images'] as List<dynamic>?) ?? [];
            vehicleImageFile = (newVehicle['images'] as List<dynamic>?)
                ?.where((image) => image['vehicle_image_type'] == 1)
                .toList() ??
                [];
            var tireImages = (newVehicle['images'] as List<dynamic>?)
                ?.where((image) => image['vehicle_image_type'] == 2)
                .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
                .toList() ??
                [];
            tireImageFile.addAll(tireImages);
            var tollImages = (newVehicle['images'] as List<dynamic>?)
                ?.where((image) => image['vehicle_image_type'] == 5)
                .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
                .toList() ??
                [];
            tollImage.addAll(tollImages);
            var uploadRegStickers = (newVehicle['images'] as List<dynamic>?)
                ?.where((image) => image['vehicle_image_type'] == 3)
                .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
                .toList() ??
                [];
            uploadRegSticker.addAll(uploadRegStickers);
            var insuranceImages = (newVehicle['images'] as List<dynamic>?)
                ?.where((image) => image['vehicle_image_type'] == 4)
                .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
                .toList() ??
                [];
            insuranceImage.addAll(insuranceImages);
            receiptImageFile.addAll(newVehicle['expenses']?['attachments'] ?? []);
            emit(setVehicleCommonState());
          } catch (e) {
            log("Error finding vehicle: $e");
            newVehicle = {};
          }
        }

        emit(setVehicleCommonState());
      } catch (e){
        log("Error in initial event");
      }
    });

    int boolToInt(bool value) => value ? 1 : 0;

    on<setVehicleSaveEvent> ((event, emit) async{
      try{
        emit(const setVehicleLoading());
        final createVehicleData = CreateVehicleData()
          ..id = vehicleId//
          ..year = yearController.text//
          ..make = makeController.text//
          ..model = modelController.text//
          ..vin = vinController.text//
          ..vehicleId = vehicleIdController.text//
          ..earnings = earningsController.text//
          ..utilizationRate = utilizationRateController.text//
          ..platform = platformController.text//
          ..mileage = mileageController.text//
          ..wholesaleAmount = wholeSaleAmountController.text//
          ..purchaseDate = purchaseDateController.text//
          ..purchasePrice = purchasePriceController.text//
          ..address = addressController.text//
          ..vehicleNumber = vehicleNumberController.text//
          ..carNumber = carNumberController.text//
          ..oilGrade = oilGradeController.text//
          ..frontTire = frontTireController.text
          ..rearTire = rearTireController.text
          ..insuranceAgent = insuranceAgentController.text
          ..insuranceCost = insuranceCostController.text
          ..bouncie = boolToInt(bouncie)//
          ..airTag = boolToInt(airTag)//
          ..permanentPlate = boolToInt(permanentPlate)//
          ..spareTire = boolToInt(spareTire)//
          ..tollTag = boolToInt(tollTags)
          ..spareKey = spareKey == true ? 1 : 0//
          ..frontLicensePlate = boolToInt(frontLicensePlate)
          ..tireSize = spareTireController.text
          ..regStickerDate = renewalDate.toString()//registration sticker date
          ..currentOdometer = currentOdometerController.text
          ..oilChangeOdometer = oilChangeOdometerController.text
          ..maintenanceCheck = maintenanceCheckController.text
          ..tollTagsId = tollTagsIdController.text
          ..selectedVehicleStatus = int.tryParse(selectedVehicleStatus.toString())
          ..selectedCohort = selectedCohortsData?['id']
          ..isActive = selectedVehicleStatus == 'Active' ? 1 : 0
          ..employeeId = employeeId
          ..branchCode = branchCode
          ..vehicleStatus = vehicleStatus//
          ..cohortId = cohortId;

        createVehicleData.insuranceImage = insuranceImage.whereType<File>().toList();
        createVehicleData.tollImage = tollImage.whereType<File>().toList();
        createVehicleData.tireImage = tireImageFile.whereType<File>().toList();
        createVehicleData.uploadRegSticker = uploadRegSticker.whereType<File>().toList();

        final response = await vehicleDataRepo.createVehicle(createVehicleData);

        if (response != null) {
          emit(setVehicleCommonState());
          log("${response.message}");
        }
      } catch (e) {
        emit(setVehicleCommonState());
        log("Error in save event $e");
      }
    });
    on<DeleteVehicleImage>((event, emit) async {
      final response = await vehicleDataRepo.deleteVehicleImages(event.id);
      final response1 = await getIt<CommonService>().getActiveVehicles(reset: true);
      dynamic vehicle;
      if (vinNumber != '' && vinNumber != null) {
        try {
          vehicle = response1.firstWhere(
                (e) => e['vin']?.toString() == vinNumber,
            orElse: () => {},
          );
        } catch (e) {
          log("Error finding vehicle: $e");
          vehicle = {};
        }
      }
      log("${vehicle}", name: "VEHICLE_Image");
      emit(setVehicleCommonState());
      log("${response}", name: "VEHICLE_Image");
    });

    on<setVehicleBouncieEvent> ((event, emit) {
      bouncie = event.value;
      emit(setVehicleCommonState());
    });
    on<setVehicleAirTagEvent> ((event, emit) {
      airTag = event.value;
      emit(setVehicleCommonState());
    });

    on<setVehiclePermanentPlateEvent> ((event, emit) {
      permanentPlate = event.value;
      emit(setVehicleCommonState());
    });
    on<setVehicleSpareTireEvent> ((event, emit) {
      spareTire = event.value;
      emit(setVehicleCommonState());
    });

    on<setVehicleSpareKeyEvent> ((event, emit) {
      spareKey = event.value;
      emit(setVehicleCommonState());
    });
    on<setVehicleFLicensePlateEvent> ((event, emit) {
      frontLicensePlate = event.value;
      emit(setVehicleCommonState());
    });
    on<setVehicleTollTagsEvent> ((event, emit) {
      tollTags = event.value;
      emit(setVehicleCommonState());
    });

    on<setVehicleDatePickerEvent> ((event, emit) {
      renewalDate = event.value;
      emit(setVehicleCommonState());
    });

    // final createVehicleData = CreateVehicleData()
    //   ..id = vehicleId//
    //   ..year = yearController.text//
    //   ..make = makeController.text//
    //   ..model = modelController.text//
    //   ..vin = vinController.text//
    //   ..vehicleId = vehicleIdController.text//
    //   ..earnings = earningsController.text//
    //   ..utilizationRate = utilizationRateController.text//
    //   ..platform = platformController.text//
    //   ..mileage = mileageController.text//
    //   ..wholesaleAmount = wholeSaleAmountController.text//
    //   ..purchaseDate = purchaseDateController.text//
    //   ..purchasePrice = purchasePriceController.text//
    //   ..address = addressController.text//
    //   ..vehicleNumber = vehicleNumberController.text//
    //   ..carNumber = carNumberController.text//
    //   ..oilGrade = oilGradeController.text//
    //   ..frontTire = frontTireController.text
    //   ..rearTire = rearTireController.text
    //   ..insuranceAgent = insuranceAgentController.text
    //   ..insuranceCost = insuranceCostController.text
    //   ..bouncie = boolToInt(bouncie)//
    //   ..airTag = boolToInt(airTag)//
    //   ..permanentPlate = boolToInt(permanentPlate)//
    //   ..spareTire = boolToInt(spareTire)//
    //   ..tollTag = boolToInt(tollTags)
    //   ..spareKey = spareKey == true ? 1 : 0//
    //   ..frontLicensePlate = boolToInt(frontLicensePlate)
    //   ..tireSize = spareTireController.text
    //   ..regStickerDate = renewalDate.toString()//registration sticker date
    //   ..currentOdometer = currentOdometerController.text
    //   ..oilChangeOdometer = oilChangeOdometerController.text
    //   ..maintenanceCheck = maintenanceCheckController.text
    //   ..tollTagsId = tollTagsIdController.text
    //   ..selectedVehicleStatus = int.tryParse(selectedVehicleStatus.toString())
    //   ..selectedCohort = selectedCohortsData?['id']
    //   ..isActive = selectedVehicleStatus == 'Active' ? 1 : 0
    //   ..employeeId = employeeId
    //   ..branchCode = branchCode
    //   ..vehicleStatus = vehicleStatus//
    //   ..cohortId = cohortId;

  }
}
