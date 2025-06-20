import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'set_vehicles_event.dart';
part 'set_vehicles_state.dart';

class SetVehiclesBloc extends Bloc<SetVehiclesEvent, SetVehiclesState> {

  final APiRepository _apiRepository = APiRepository();

  List<dynamic> tireImage = [];
  List<dynamic> tireImageList = [];
  List<dynamic> tollImage = [];
  List<dynamic> tollImageList = [];
  List<dynamic> uploadRegSticker = [];
  List<dynamic> uploadRegStickerList = [];
  List<dynamic> insuranceImage = [];
  List<dynamic> insuranceImageList = [];
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

  bool bouncie = false;
  bool tollTags = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  final FBroadcast _broadcast = FBroadcast.instance();

  dynamic todoItem;
  dynamic vehicle;
  dynamic selectedVehicle;

  DateTime? selectedRegStickerDate;

  Future<List<Map<String, dynamic>>> _getVehicleData() async => await getIt<CommonService>().getActiveVehicles();
  Future<Map<String, dynamic>?> _deleteVehicleImage(dynamic id) async => await _apiRepository.deleteVehicleImage(id);
  Future<Map<String, dynamic>?> _deleteVehicleExpenseImage(dynamic id) async => await _apiRepository.deleteVehicleExpenseImage(id);
  Future<Map<String, dynamic>?> _vehicleAddOrUpdateApi({required dynamic id, required List<Map<String, String?>> infusedFiles, required dynamic body}) async => await _apiRepository.vehicleAddOrUpdateApi(infusedFiles: infusedFiles, body: body, id: id,);
  Future<Map<String, dynamic>?> _addTodo({required dynamic body}) async => await _apiRepository.addToDo(body: body,);

  SetVehiclesBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<RefreshEvent>(_onRefreshEvent);
    on<BouncieEvent>(_onBouncieEvent);
    on<AirTagEvent>(_onAirTagEvent);
    on<TollTagsEvent>(_onTollTagsEvent);
    on<SpareTireEvent>(_onSpareTireEvent);
    on<SpareKeyEvent>(_onSpareKeyEvent);
    on<PermanentPlateEvent>(_onPermanentPlateEvent);
    on<FrontLicensePlateEvent>(_onFrontLicensePlateEvent);
    on<TollImageEvent>(_onTollImageEvent);
    on<RemoveTollImageEvent>(_onRemoveTollImageEvent);
    on<TireImageEvent>(_onTireImageEvent);
    on<RemoveTireImageEvent>(_onRemoveTireImageEvent);
    on<UploadRegStickerImageEvent>(_onUploadRegStickerImageEvent);
    on<RemoveRegStickerImageEvent>(_onRemoveRegStickerImageEvent);
    on<InsuranceImageEvent>(_onInsuranceImageEvent);
    on<RemoveInsuranceImageEvent>(_onRemoveInsuranceImageEvent);
    on<RegStickerDateEvent>(_onRegStickerDateEvent);
    on<SaveVehicle>(_onSaveVehicle);
    _broadcast.register("set_vehicle_refresh", (value,callback) => add(RefreshEvent(vehicle: value,)));
    _broadcast.register("set_vehicle_is_updated", (value,callback) => add(RefreshEvent(vehicle: vehicle,)));
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      emit(LoadingState());
      todoItem = event.todoItems;
      vehicle = event.vehicle;
      Console.of.log(vehicle);
      await _fetchData(vehicle);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      emit(LoadingState());
      vehicle = event.vehicle;
      await _fetchData(vehicle);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onBouncieEvent(BouncieEvent event, Emitter<SetVehiclesState> emit)  {
    try {
      bouncie = !bouncie;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onTollTagsEvent(TollTagsEvent event, Emitter<SetVehiclesState> emit)  {
    try {
      tollTags = !tollTags;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onAirTagEvent(AirTagEvent event, Emitter<SetVehiclesState> emit)  {
    try {
      airTag = !airTag;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onSpareTireEvent(SpareTireEvent event, Emitter<SetVehiclesState> emit)  {
    try {
      spareTire = !spareTire;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onSpareKeyEvent(SpareKeyEvent event, Emitter<SetVehiclesState> emit) {
    try {
      spareKey = !spareKey;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onPermanentPlateEvent(PermanentPlateEvent event, Emitter<SetVehiclesState> emit) {
    try {
      permanentPlate = !permanentPlate;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onFrontLicensePlateEvent(FrontLicensePlateEvent event, Emitter<SetVehiclesState> emit) {
    try {
      frontLicensePlate = !frontLicensePlate;
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onTollImageEvent(TollImageEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      tollImage = await _handleFileSelection(tollImage, "tollImageFile");
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onRemoveTollImageEvent(RemoveTollImageEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      emit(LoadingState());
      await _handleFileRemoval(fileList: tollImage, fullImageList:tollImageList,data:event.data);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onTireImageEvent(TireImageEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      tireImage = await _handleFileSelection(tireImage, "tireImageFile");
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onRemoveTireImageEvent(RemoveTireImageEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      emit(LoadingState());
      await _handleFileRemoval(fileList: tireImage, fullImageList:tireImageList,data:event.data);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onUploadRegStickerImageEvent(UploadRegStickerImageEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      uploadRegSticker = await _handleFileSelection(uploadRegSticker, "uploadRegStickerFile");
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onRemoveRegStickerImageEvent(RemoveRegStickerImageEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      emit(LoadingState());
      await _handleFileRemoval(fileList: uploadRegSticker, fullImageList:uploadRegStickerList,data:event.data);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onInsuranceImageEvent(InsuranceImageEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      insuranceImage = await _handleFileSelection(insuranceImage, "insuranceImageFile");
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onRemoveInsuranceImageEvent(RemoveInsuranceImageEvent event, Emitter<SetVehiclesState> emit) async {
    try {
      emit(LoadingState());
      await _handleFileRemoval(fileList: insuranceImage, fullImageList:insuranceImageList,data:event.data);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onRegStickerDateEvent(RegStickerDateEvent event, Emitter<SetVehiclesState> emit) {
    try {
      selectedRegStickerDate = event.selectedDate;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _fetchData(dynamic vehicle) async {
    var response = await _getVehicleData();
    selectedVehicle = response.firstWhereOrNull((element) => element['vin']== vehicle['vin']);
    if(selectedVehicle != null){
      addressController.text = "${selectedVehicle?['address'] ?? ''}";
      carNumberController.text = "${selectedVehicle?['car_number'] ?? ''}";
      oilGradeController.text = "${selectedVehicle?['oil_grade'] ?? ''}";
      frontTireController.text = "${selectedVehicle?['front_tire'] ?? ''}";
      rearTireController.text = "${selectedVehicle?['rear_tire'] ?? ''}";
      renewalDateController.text = "${selectedVehicle?['registration_renewal_date'] ?? ''}";
      numberPlateController.text = "${selectedVehicle?['vehicle_number'] ?? ''}";
      tollTagsController.text = "${selectedVehicle?['toll_tags_id'] ?? ''}";
      spareTireController.text = "${selectedVehicle?['tire_size'] ?? ''}";
      insuranceCostController.text = "${selectedVehicle?['insurance_cost'] ?? ''}";
      insuranceAgentController.text = "${selectedVehicle?['insurance_agent'] ?? ''}";

      bouncie = selectedVehicle?['bouncie'] == 1 ? true : false;
      tollTags = selectedVehicle?['toll_tags'] == 1 ? true : false;
      airTag = selectedVehicle?['air_tag'] == 1 ? true : false;
      spareTire = selectedVehicle?['spare_tire'] == 1 ? true : false;
      spareKey = selectedVehicle?['spare_key'] == 1 ? true : false;
      permanentPlate = selectedVehicle?['permanent_plate'] == 1 ? true : false;
      frontLicensePlate = selectedVehicle?['front_license_plate'] == 1 ? true : false;
      selectedRegStickerDate = selectedVehicle?['registration_renewal_date'].toString().toDateTime(inputFormat: 'yyyy-MM-dd');

      tollImageList=(selectedVehicle?['images']).where((element) => element['vehicle_image_type'] == 5).toList();
      tollImage=tollImageList.map((e) => e['path'].toString().toStorageURL).toList();

      tireImageList=(selectedVehicle?['images']).where((element) => element['vehicle_image_type'] == 2).toList();
      tireImage=tireImageList.map((e) => e['path'].toString().toStorageURL).toList();

      uploadRegStickerList=(selectedVehicle?['images']).where((element) => element['vehicle_image_type'] == 3).toList();
      uploadRegSticker=uploadRegStickerList.map((e) => e['path'].toString().toStorageURL).toList();

      insuranceImageList=(selectedVehicle?['images']).where((element) => element['vehicle_image_type'] == 4).toList();
      insuranceImage=insuranceImageList.map((e) => e['path'].toString().toStorageURL).toList();

    }
  }

  Future<List<dynamic>> _handleFileSelection(List<dynamic> fileList, String logName) async {
    var extensions = ['jpg', 'jpeg', 'png'];
    var result = await _pickFiles(type: FileType.custom, extensions: extensions);
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

      return fileList;
    } else {
      return [];
    }
  }

  Future<dynamic> _handleFileRemoval({required List<dynamic> fileList, required List<dynamic> fullImageList, required dynamic data}) async {
    if (data == null) return;
    if (data is File) {
      fileList.remove(data);
      return data;
    } else if(data is String){
      try {
        var path = fileList.firstWhereOrNull((element) => element == data.toString());
        var lastData = fullImageList.firstWhereOrNull((element) => element['path'] == path.toString().removeStorageUrl);
        var hasExpense = Map.from(lastData ?? {}).containsKey("expense_id");
        var imageId = fullImageList.firstWhereOrNull((element) => element['path'] == path.toString().removeStorageUrl)?['id'];
        var response =  await ((hasExpense) ? _deleteVehicleExpenseImage(imageId) : _deleteVehicleImage(imageId));
        Console.of.error(response, name: "RESPONSE_ERROR");
        if(response?['success'] != null){
          Toaster.showSuccess(response?['success'] ?? "Deleted! Success");
          fileList.remove(data);
          return data;
        } else {
          Toaster.showError(response?['error'] ?? "Something went wrong");
        }
      } catch (e) {
        Console.of.error("Error", error: e);
        Toaster.showError(e.toString());
      }
    }
  }

  Future<List<File>> _pickFiles({FileType type = FileType.custom, List<String>? extensions}) async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: type,
        allowedExtensions: extensions);
    return result?.paths
        .where((element) => (element?.isNotEmpty ?? false))
        .map((e) => File(e!))
        .toList() ??
        [];
  }

  Future<void> _onSaveVehicle(SaveVehicle event, Emitter<SetVehiclesState> emit) async {
    try {
      if(spareKey || (event.overRide != null) ){
        emit(LoadingState());
        List<Map<String, String?>> infusedFiles = [
          ...tireImage.whereType<File>().map((e) => {"tyre_images" : e.path}),
          ...tollImage.whereType<File>().map((e) => {"toll_images" : e.path}),
          ...uploadRegSticker.whereType<File>().map((e) => {"registration_documents" : e.path}),
          ...insuranceImage.whereType<File>().map((e) => {"insurance_agent_images" : e.path}),
        ];
        Console.of.log(infusedFiles, name: "infusedFiles");
        var response = await _vehicleAddOrUpdateApi(infusedFiles: infusedFiles, body: vehicleBody(), id:"${selectedVehicle['id']}",);
        Console.of.log(response, name: "response");
        getIt<CommonService>().getActiveVehicles(reset: true);
        if (event.overRide == true){
          await _addTodo(body: spareKeyTaskBody());
          // _broadcast.stickyBroadcast("todo_view", value: true);
          TaskerHelper.instance.refresh();
          emit(SuccessState("SpareKey Task Added"));
        } else { // TRIGGER ADD TODO
          emit(CommonState());
        }
      }else{
        emit(PopupState());
      }
    } catch (e) {
      _onError(e, emit);
    }
  }

  Map<String, dynamic> vehicleBody(){
    Map<String, dynamic> baseBody = {};
    baseBody['vehicle_id'] = selectedVehicle?['vehicle_id'];
    baseBody['vin'] = selectedVehicle?['vin'];
    baseBody['make'] = selectedVehicle?['make'];
    baseBody['model'] = selectedVehicle?['model'];
    baseBody['year'] =  selectedVehicle?['year'];
    baseBody['cohort_id'] = selectedVehicle?['cohort_id'];
    baseBody['earnings'] = selectedVehicle?['earnings'];
    baseBody['utilization_rate'] = selectedVehicle?['utilization_rate'];
    baseBody['platform'] = selectedVehicle?['platform'];
    baseBody['mileage'] = selectedVehicle?['mileage'];
    baseBody['wholesale_amount'] = selectedVehicle?['wholesale_amount'];
    baseBody['vehicle_status'] = selectedVehicle?['vehicle_status'];
    baseBody['active'] = selectedVehicle?['active'];
    baseBody['purchase_price'] = selectedVehicle?['purchase_price'];
    baseBody['purchase_date'] = selectedVehicle?['purchase_date'];
    baseBody['vehicle_number'] = numberPlateController.text;
    baseBody['address'] = addressController.text;
    baseBody['bouncie'] = bouncie ? "1" : "0";
    baseBody['air_tag'] = airTag ? "1" : "0";
    baseBody['spare_tire'] = spareTire ? "1" : "0";
    baseBody['spare_key'] = spareKey ? "1" : "0";
    baseBody['permanent_plate'] = permanentPlate ? "1" : "0";
    baseBody['car_number'] = carNumberController.text;
    baseBody['oil_grade'] = oilGradeController.text;
    baseBody['registration_renewal_date'] = selectedRegStickerDate?.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['toll_tags'] = tollTags ? "1" : "0";
    baseBody['toll_tags_id'] = tollTagsController.text;
    baseBody['front_license_plate'] = frontLicensePlate ? "1" : "0";
    baseBody['tire_size'] = spareTireController.text;
    baseBody['front_tire'] = frontTireController.text;
    baseBody['rear_tire'] = rearTireController.text;
    baseBody['insurance_agent'] = insuranceAgentController.text;
    baseBody['insurance_cost'] = insuranceCostController.text;
    baseBody['current_odometer'] = selectedVehicle?['current_odometer'];
    baseBody['oil_change_odometer'] = selectedVehicle?['oil_change_odometer'];
    baseBody['maintenance_check'] = selectedVehicle?['maintenance_check'];
    baseBody['platform_from'] = 'tasker-app';
    baseBody['employee_id'] = "${getIt<CommonService>().userId}";
    baseBody['branch_code'] = selectedVehicle?['branch_code'];
    Console.of.log(jsonEncode(baseBody), name: "vehicleBody");
    return baseBody;
  }

  Map<String, dynamic> spareKeyTaskBody(){
    Map<String, dynamic> baseBody = {};
    baseBody['address'] = todoItem?['address'];
    baseBody['branch_id'] = "${getIt<CommonService>().branchId}";
    baseBody['cohort_id'] = todoItem?['cohort_id'];
    baseBody['identifier_id'] = 105;
    baseBody['location'] = todoItem?['location'];
    baseBody['location_id'] = todoItem?['location_id'];
    baseBody['notes'] = '';
    baseBody['start_at'] = DateTime.now().toFormat();
    baseBody['time_sensitive'] = todoItem?['time_sensitive'];
    baseBody['title'] = 'SpareKey';
    baseBody['todo_time'] = DateTime.now().time.toHMS();
    baseBody['todo_user_type'] = todoItem?['todo_user_type'];
    baseBody['user_group_id'] = todoItem?['user_group_id'];
    baseBody['user_id'] = todoItem?['user_id'];
    baseBody['vehicle_name'] = todoItem?['vehicle_name'];
    baseBody['vehicles'] = List.from(todoItem?['vehicles'] ?? []).map((e) => jsonEncode(e)).toList();
    baseBody['vendor_id'] = todoItem?['vendor_id'];
    baseBody['vendor_name'] = todoItem?['vendor_name'];
    baseBody['vin'] = todoItem?['vin'];
    Console.of.log(jsonEncode(baseBody), name: "spareKeyTaskBody");
    return baseBody;
  }

  void _onError(dynamic error, Emitter<SetVehiclesState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }
}