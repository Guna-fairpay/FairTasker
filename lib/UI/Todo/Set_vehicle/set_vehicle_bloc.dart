

import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_event.dart';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_state.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Repository/todo_list_repository.dart';
import '../../../Repository/vehicle_repository.dart';
import '../../../Response/create_vehicle_data.dart';
import '../../../Utilities/Str.dart';
import '../../../core/app/helper/console.dart';
import '../../../core/initializer/common_initializer.dart';
import '../create_sparekey_data.dart';

class setVehicleBloc extends Bloc<setVehicleEvent,setVehicleState>{

  VehicleDataRepo vehicleDataRepo = VehicleDataRepo();
  TodoListRepo todoListRepo = TodoListRepo();
  final FBroadcast _broadcast = FBroadcast.instance();
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
  dynamic oldVehicle;
  dynamic todoItem;
  List<Map<String, dynamic>> cohortsData = [];
  List<Map<String, dynamic>> categoriesData = [];
  List<String> vehicleStatusList = ['Active', 'InActive'];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  setVehicleBloc() : super(const setVehicleInitialState()){
    _broadcast.register("set_vehicle_refresh", (value,callback) => add(setVehicleInitialEvents(vehicle: value, todoItems: todoItem)));
    /*on<ResetAllEvent>((event, emit) async {

    });*/

    on<setVehicleInitialEvents>((event, emit) async {
      emit(setVehicleLoading());
      Console.of.debug('setVehicleInitialEvents');
      try{
        final response = await getIt<CommonService>().getActiveVehicles(reset: true);
        if (response.isNotEmpty && event.vehicle != null) {
          vinNumber = event.vehicle?['vin'];
          vehicleId = event.vehicle?['id'];
          oldVehicle = event.vehicle;
          todoItem = event.todoItems;
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
            purchasePriceController.text = newVehicle['purchase_price']?.toString() ?? '';
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


    on<setVehicleSaveEvent> ((event, emit) async{
      try{
        emit(setVehicleLoading());
        final createVehicleData = CreateVehicleData()
          ..id = vehicleId
          ..year = yearController.text
          ..make = makeController.text
          ..model = modelController.text
          ..vin = vinController.text
          ..vehicleId = vehicleIdController.text
          ..earnings = earningsController.text
          ..utilizationRate = utilizationRateController.text
          ..platform = platformController.text
          ..mileage = mileageController.text
          ..wholesaleAmount = wholeSaleAmountController.text
          ..purchaseDate = purchaseDateController.text
          ..purchasePrice = purchasePriceController.text
          ..address = addressController.text
          ..vehicleNumber = vehicleNumberController.text
          ..carNumber = carNumberController.text
          ..oilGrade = oilGradeController.text
          ..frontTire = frontTireController.text
          ..rearTire = rearTireController.text
          ..insuranceAgent = insuranceAgentController.text
          ..insuranceCost = insuranceCostController.text
          ..bouncie = boolToInt(bouncie)
          ..airTag = boolToInt(airTag)
          ..permanentPlate = boolToInt(permanentPlate)
          ..spareTire = boolToInt(spareTire)
          ..tollTag = boolToInt(tollTags)
          ..spareKey = spareKey == true ? 1 : 0
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
          ..vehicleStatus = vehicleStatus
          ..cohortId = cohortId;

        createVehicleData.insuranceImage = insuranceImage.whereType<File>().toList();
        createVehicleData.tollImage = tollImage.whereType<File>().toList();
        createVehicleData.tireImage = tireImageFile.whereType<File>().toList();
        createVehicleData.uploadRegSticker = uploadRegSticker.whereType<File>().toList();

        final response = await vehicleDataRepo.createVehicle(createVehicleData);

        if (response != null) {
          _broadcast.stickyBroadcast("todo_view", value: true);
          final response = await getIt<CommonService>().getActiveVehicles(reset: true);
          newVehicle = response.firstWhere(
                (e) => e['vin']?.toString() == vinNumber?.toString(),
            orElse: () => {},
          );
          images.clear();
          vehicleImageFile.clear();
          tireImageFile.clear();
          tollImage.clear();
          uploadRegSticker.clear();
          insuranceImage.clear();

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

          emit(setVehicleCommonState());
        } else {
          emit(setVehicleCommonState());
          log("Error in save event ${response}");
        }
      } catch (e) {
        emit(setVehicleCommonState());
        log("Error in save event $e");
      }
    });

    on<createSparekeyTask> ((event, emit) async {
      log("Creating spare key");
      add(setVehicleSaveEvent());
      CreateSpareKeyData spareKeyData = CreateSpareKeyData()
        ..title = "Spare Key"
        ..address = todoItem['address'] ?? ''
        ..branchId = todoItem['branch_id'] != null
            ? int.tryParse(todoItem['branch_id'].toString())
            : null
        ..cohortId = todoItem['cohort_id'] != null
            ? int.tryParse(todoItem['cohort_id'].toString())
            : null
        ..identifierId = 105
        ..location = todoItem?['location'] ?? ''
        ..locationId = todoItem?['location_id'] ?? ''
        ..notes = todoItem?['notes'] ?? ''
        ..startAt = todoItem?['todo_date'].toString() ?? ''
        ..timeSensitive = todoItem?['time_sensitive'].toString() ?? "0"
        ..todoTime = DateTime.now().toFormat(format: "HH:mm:ss") ?? ""
        ..todoUserType = todoItem['todo_user_type'] != null
            ? int.tryParse(todoItem['todo_user_type'].toString())
            : null
        ..userGroupId = todoItem['user_group_id'] != null
            ? int.tryParse(todoItem['user_group_id'].toString())
            : null
        ..userId = todoItem?['user_id'] ?? ''
        ..vehicleName = todoItem?['vehicle_name'] ?? ''
        ..vehicles = todoItem?['vehicles'] ?? []
        ..vendorId = todoItem['vendor_id'] != null
            ? int.tryParse(todoItem['vendor_id'].toString())
            : null
        ..vendorName = todoItem?['vendor_name'] ?? ''
        ..vehicleNumber = todoItem?['vehicle_number'] ?? ''
        ..vin = todoItem?['vin'] ?? '';
      try {
        final response = await todoListRepo.spareKeyTask(spareKeyData);
        log("${response}",name: "Create_SpareKey");
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(setVehicleLoaded(pop: true));
      } catch (e) {
        log("Error in save event $e");
        emit(setVehicleCommonState());
      }
    });


    on<setVehicleAddAttachmentEvent>((event, emit) async {
      log("${event.imageType}" , name: "VEHICLE_Image");
      switch (event.imageType) {
        case 2:
          var result = await _pickFiles();
          var attachments = List.from(tireImageFile);
          var existingAttachments = List.from(tireImageFile)
              .whereType<File>()
              .map((e) => (e.path))
              .toList();
          for (var element in result) {
            if (!existingAttachments.contains(element.path)) {
              attachments.add(element);
            }
          }
          tireImageFile = attachments;
          break;
        case 3:
          var result = await _pickFiles();
          var attachments = List.from(uploadRegSticker);
          var existingAttachments = List.from(uploadRegSticker)
              .whereType<File>()
              .map((e) => (e.path))
              .toList();
          for (var element in result) {
            if (!existingAttachments.contains(element.path)) {
              attachments.add(element);
            }
          }
          uploadRegSticker = attachments;
          break;
        case 4:
          var result = await _pickFiles();
          var attachments = List.from(insuranceImage);
          var existingAttachments = List.from(insuranceImage)
              .whereType<File>()
              .map((e) => (e.path))
              .toList();
          for (var element in result) {
            if (!existingAttachments.contains(element.path)) {
              attachments.add(element);
            }
          }
          insuranceImage = attachments;
          break;
        case 5:
          log("Adding image type 5");
          var result = await _pickFiles();
          var attachments = List.from(tollImage);
          var existingAttachments = List.from(tollImage)
              .whereType<File>()
              .map((e) => (e.path))
              .toList();
          for (var element in result) {
            if (!existingAttachments.contains(element.path)) {
              attachments.add(element);
            }
          }
          tollImage = attachments;
          break;
        default:
          Console.of.log("Image type not found");
          break;
      }
      emit(setVehicleCommonState());
    });

    on<setVehicleRemoveAttachmentEvent> ((event, emit) async {
      try{
        switch (event.imageType) {
          case 2:
            if(event.attachment is File){
              tireImageFile.remove(event.attachment);
              emit(setVehicleCommonState());
            } else {
              int? imageId = (images).firstWhere(
                      (image) =>
                  event.attachment.split('/').last ==
                      image['path'].split('/').last,
                  orElse: () => null)?['id'];

              if(imageId != null){
                final response = await vehicleDataRepo.deleteVehicleImages(imageId);
                if (response != null) tireImageFile.remove(event.attachment);
                emit(setVehicleCommonState());
                log("${response}", name: "VEHICLE_Image");
              } else {
                emit(setVehicleCommonState());
              }
            }
            emit(setVehicleCommonState());
            break;
          case 3:
            if(event.attachment is File){
              uploadRegSticker.remove(event.attachment);
              emit(setVehicleCommonState());
            } else {
              int? imageId = (images).firstWhere(
                      (image) =>
                  event.attachment.split('/').last ==
                      image['path'].split('/').last,
                  orElse: () => null)?['id'];
              emit(setVehicleCommonState());
              if(imageId != null){
                final response = await vehicleDataRepo.deleteVehicleImages(imageId);
                if (response != null) uploadRegSticker.remove(event.attachment);
                emit(setVehicleCommonState());
                log("${response}", name: "VEHICLE_Image");
              } else {
                emit(setVehicleCommonState());
              }
            }
            emit(setVehicleCommonState());
            break;
          case 4:
            if(event.attachment is File){
              insuranceImage.remove(event.attachment);
              emit(setVehicleCommonState());
            } else {
              int? imageId = (images).firstWhere(
                      (image) =>
                  event.attachment.split('/').last ==
                      image['path'].split('/').last,
                  orElse: () => null)?['id'];

              if(imageId != null){
                final response = await vehicleDataRepo.deleteVehicleImages(imageId);
                if (response != null) insuranceImage.remove(event.attachment);
                emit(setVehicleCommonState());
                log("${response}", name: "VEHICLE_Image");
              } else {
                emit(setVehicleCommonState());
              }
            }
            emit(setVehicleCommonState());
            break;
          case 5:
          if(event.attachment is File){
            tollImage.remove(event.attachment);
            emit(setVehicleCommonState());
          } else {
            int? imageId = (images).firstWhere(
                    (image) =>
                event.attachment.split('/').last ==
                    image['path'].split('/').last,
                orElse: () => null)?['id'];

            if(imageId != null){
              final response = await vehicleDataRepo.deleteVehicleImages(imageId);
              if (response != null) tollImage.remove(event.attachment);
              emit(setVehicleCommonState());
              log("${response}", name: "VEHICLE_Image");
            } else {
              emit(setVehicleCommonState());
            }
          }
          emit(setVehicleCommonState());
          break;
          default:
            log("Image type not found");
            break;
        }
        emit(setVehicleCommonState());
      } catch(e){
        Console.of.log("Error in remove attachment event ${e.toString()}");
        emit(setVehicleCommonState());
      }
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
  int boolToInt(bool value) => value ? 1 : 0;
  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov']
    );
    return result?.paths.where((element) => (element?.isNotEmpty ?? false)).map((e) => File(e!)).toList() ?? [];
  }
}
