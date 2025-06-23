import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/Bloc/add_private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/Bloc/add_private_rental_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPrivateRentalBloc extends Bloc<AddPrivateRentalEvent, AddPrivateRentalState>{
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> customerList = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<dynamic> validation = [{'id': 1, 'status': 'Confirm'}, {'id': 0, 'status': 'Close'}];
  List<dynamic> attachment = [];
  dynamic selectedVehicle = {};
  dynamic selectedCustomer = {};
  dynamic selectedStatus = {};
  DateTime? selectedCheckInDate;
  DateTime? selectedCheckOutDate;
  String? get userId => Session.of.getString(Str.userIdPrefText);


  TextEditingController vehicleController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();
  TextEditingController checkInMileageController = TextEditingController();
  TextEditingController checkOutMileageController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FBroadcast _broadcast = FBroadcast.instance();

  AddPrivateRentalBloc() : super(AddPrivateRentalLoadingState()) {
    _broadcast.register("selected_pr_model", (value, callback) => add(InsertRentalDataEvent(rentalData: value)));
    on<AddPrivateRentalInitialEvent>((event, emit) async {
      emit(AddPrivateRentalLoadingState());
      var customerResponse = await _getPrivateRentalCustomer();
      var response = await _getPrivateRentalVehicle();

      customerList = customerResponse;
      customerList = customerName(customerList);
      vehicleList = response;
      if(event.rentalData != null) selectedVehicle = vehicleList.firstWhereOrNull((element) => element['vin'] == event.rentalData['vin'],);
      selectedStatus = validation.first;
      emit(AddPrivateRentalCommonState());
    });

    on<InsertRentalDataEvent>((event, emit) {
      if(event.rentalData != null) selectedVehicle = vehicleList.firstWhereOrNull((element) => element['vin'] == event.rentalData['vin'],);
      emit(AddPrivateRentalCommonState());
    });

    on<CheckInDateEvent>((event, emit) {
      selectedCheckInDate = event.selectedDate;
      emit(AddPrivateRentalCommonState());
    });

    on<CheckOutDateEvent>((event, emit) {
      selectedCheckOutDate = event.selectedDate;
      emit(AddPrivateRentalCommonState());
    });

    on<ImageUploadEvent>((event, emit) async {
      await _handleFileSelection(attachment, "receiptImageFile", emit);
      log("$attachment", name: "ImageUploadEvent");
    });

    on<RemoveImageEvent>((event, emit) async {
      _handleFileRemoval(attachment, event.data, emit);
    });


    on<VehicleSearchEvent>((event, emit) {
      selectedVehicle = event.selectedVehicle;
      emit(AddPrivateRentalCommonState());
    });

    on<CustomerSearchEvent>((event, emit) {
      selectedCustomer = event.selectedCustomer;
      emit(AddPrivateRentalCommonState());
    });

    on<ValidationDropDownEvent>((event, emit) {
      selectedStatus = event.validation;
      emit(AddPrivateRentalCommonState());
    });

    on<AddPrivateRentalSubmitEvent>((event, emit) async {
      try {
        emit(AddPrivateRentalLoadingState());
        var response = await _apiRepository.privateRentalAddOrUpdateApi(
          images: attachment.whereType<File>().toList(),
          body: _saveRental(),
        );
        if (response?['message']?.isNotEmpty ?? false) {
          Toaster.showSuccess(response?['message']);
          _clearAll();
          _broadcast.stickyBroadcast("PR_refresh", value: true);
        }else{
          Toaster.showError(response?['error']);
        }
        emit(AddPrivateRentalCompleteState());
      } catch (e) {
        Toaster.showError("$e");
        emit(AddPrivateRentalCompleteState());
      }
    });

  }

  void _clearAll() {
    selectedVehicle = {};
    selectedCustomer = {};
    selectedStatus = {};
    selectedCheckInDate = null;
    selectedCheckOutDate = null;
    vehicleController.clear();
    customerController.clear();
    checkInController.clear();
    checkOutController.clear();
    checkInMileageController.clear();
    checkOutMileageController.clear();
    attachment.clear();
  }

  Map<String, String> _saveRental() {
    Map<String, String> baseBody = {};
    baseBody['vin'] = "${selectedVehicle['vin'] ?? ''}";
    baseBody['customer_id'] = "${selectedCustomer?['id'] ??''}";
    baseBody['check_in_date'] = selectedCheckInDate?.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['check_out_date'] = selectedCheckOutDate?.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['check_in_mileage'] =  checkInMileageController.text;
    baseBody['check_out_mileage'] = checkOutMileageController.text;
    baseBody['platform'] = "tasker-app";
    baseBody['rental_status'] = "${selectedStatus['id'] ?? ''}";
    baseBody['created_by'] = "$userId";
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
      emit(AddPrivateRentalCommonState());
    }
  }

  void _handleFileRemoval(List<dynamic> fileList, dynamic data, Emitter emit) {
    if (data == null) return;
    if (data is File) {
      fileList.remove(data);
    }
    emit(AddPrivateRentalCommonState());
  }

  List<Map<String, dynamic>> customerName(List<Map<String, dynamic>> apiResponse) {
    return apiResponse.map((item) => item..['customer_name'] =
    "${item['first_name'] ?? ''} ${item['last_name'] ?? ''}".trim()).toList();
  }

  ///PRIVATE RENTAL VEHICLE API CALL
  Future<List<Map<String, dynamic>>> _getPrivateRentalVehicle() async =>
      await getIt<CommonService>().getPrivateRentalVehicleList();

  ///PRIVATE RENTAL CUSTOMER API CALL
  Future<List<Map<String, dynamic>>> _getPrivateRentalCustomer() async =>
      await getIt<CommonService>().getPrivateRentalCustomersList();

}
