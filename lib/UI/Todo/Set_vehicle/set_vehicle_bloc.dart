

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
  final TextEditingController vehicleNumberController  = TextEditingController();
  final TextEditingController vehicleIdController  = TextEditingController();
  final TextEditingController carNumberController  = TextEditingController();
  final TextEditingController oilGradeController  = TextEditingController();
  final TextEditingController frontTireController  = TextEditingController();
  final TextEditingController rearTireController  = TextEditingController();
  final TextEditingController renewalDateController  = TextEditingController();
  final TextEditingController tollTagsIdController = TextEditingController();
  final TextEditingController spareTireController = TextEditingController();
  final TextEditingController insuranceCostController = TextEditingController();
  final TextEditingController insuranceAgentController = TextEditingController();

  bool bouncie = false;
  bool tollTags = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  DateTime? renewalDate;
  String? vinNumber;
  int? vehicleId;
  List<dynamic> images = List.empty(growable: true);
  List<dynamic> tireImageFile = List.empty(growable: true);
  List<dynamic> tollImage = List.empty(growable: true);
  List<dynamic> uploadRegSticker = List.empty(growable: true);
  List<dynamic> insuranceImage = List.empty(growable: true);
  dynamic newVehicle;
  dynamic todoItem;
  List<Map<String, dynamic>> cohortsData = [];
  List<Map<String, dynamic>> categoriesData = [];
  List<String> vehicleStatusList = ['Active', 'InActive'];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  setVehicleBloc() : super(const setVehicleInitialState()){
    _broadcast.register("set_vehicle_refresh", (value,callback) => add(setVehicleInitialEvents(vehicle: value, todoItems: todoItem)));


    on<setVehicleInitialEvents>((event, emit) async {
      emit(setVehicleLoading());
      Console.of.debug('setVehicleInitialEvents');
      try{
        final response = await getIt<CommonService>().getActiveVehicles(reset: true);
        if (response.isNotEmpty && event.vehicle != null) {
          vinNumber = event.vehicle?['vin'];
          vehicleId = event.vehicle?['id'];
          todoItem = event.todoItems;
          try {
            newVehicle = response.firstWhere(
                  (e) => e['vin']?.toString() == event.vehicle?['vin']?.toString(),
              orElse: () => {},
            );

            vehicleNumberController.text = newVehicle['vehicle_number']?.toString() ?? '';
            vehicleIdController.text = newVehicle['vehicle_id']?.toString() ?? '';
            carNumberController.text = newVehicle['car_number']?.toString() ?? '';
            oilGradeController.text = newVehicle['oil_grade']?.toString() ?? '';
            frontTireController.text = newVehicle['front_tire']?.toString() ?? '';
            rearTireController.text = newVehicle['rear_tire']?.toString() ?? '';
            tollTagsIdController.text = newVehicle['toll_tags_id']?.toString() ?? '';
            spareTireController.text = newVehicle['tire_size']?.toString() ?? '';
            insuranceCostController.text = newVehicle['insurance_cost']?.toString() ?? '';
            insuranceAgentController.text = newVehicle['insurance_agent']?.toString() ?? '';
            renewalDate = (newVehicle['registration_renewal_date'] ?? '').toString().toDateTime(inputFormat: 'yyyy-MM-dd');

            bouncie = (newVehicle['bouncie'] == 1);
            airTag = (newVehicle['air_tag'] == 1);
            permanentPlate = (newVehicle['permanent_plate'] == 1);
            spareTire = (newVehicle['spare_tire'] == 1);
            spareKey = (newVehicle['spare_key'] == 1);
            permanentPlate = (newVehicle['permanent_plate'] == 1);
            frontLicensePlate = (newVehicle['front_license_plate'] == 1);
            tollTags = (newVehicle['toll_tags'] == 1);


            images = (newVehicle['images'] as List<dynamic>?) ?? [];
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
          ..year = newVehicle['year'].toString()
          ..make = newVehicle['make'].toString()
          ..model = newVehicle['model'].toString()
          ..vin = newVehicle['vin'].toString()
          ..vehicleId = newVehicle['vehicle_id'].toString()
          ..earnings = newVehicle['earnings'].toString()
          ..utilizationRate = newVehicle['utilization_rate'].toString()
          ..platform = newVehicle['platform'].toString()
          ..mileage = newVehicle['mileage'].toString()
          ..wholesaleAmount = newVehicle['wholesale_amount'].toString()
          ..purchaseDate = newVehicle['purchase_date'].toString()
          ..purchasePrice = newVehicle['purchase_price'].toString()
          ..address = newVehicle['address'].toString()
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
          ..currentOdometer = newVehicle['current_odometer'].toString()
          ..oilChangeOdometer = newVehicle['oil_change_controller'].toString()
          ..maintenanceCheck = newVehicle['maintenance_check'].toString()
          ..tollTagsId = tollTagsIdController.text
          ..branchCode = newVehicle['branch_code']
          ..vehicleStatus = newVehicle['vehicle_status']
          ..cohortId = newVehicle['vehicle_id'];

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
          tireImageFile.clear();
          tollImage.clear();
          uploadRegSticker.clear();
          insuranceImage.clear();

          images = (newVehicle['images'] as List<dynamic>?) ?? [];
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
              if(imageId != null){
                final response = await vehicleDataRepo.deleteVehicleImages(imageId);
                if (response != null) uploadRegSticker.remove(event.attachment);
                emit(setVehicleCommonState());
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
