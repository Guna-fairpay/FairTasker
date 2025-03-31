
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPrivateRentalBloc extends Bloc<EditPrivateRentalEvent, EditPrivateRentalState>{
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> customerList = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<dynamic> validation = [{'id': 1, 'status': 'Confirm'}, {'id': 0, 'status': 'Close'}];
  List<dynamic> imageList = [];
  List<dynamic> attachment = [];
  dynamic selectedVehicle = {};
  dynamic selectedCustomer = {};
  dynamic selectedStatus = {};
  dynamic rentalData = {};
  DateTime? selectedCheckInDate;
  DateTime? selectedCheckOutDate;
  String? userId;
  TextEditingController vehicleController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();
  TextEditingController checkInMileageController = TextEditingController();
  TextEditingController checkOutMileageController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditPrivateRentalBloc() : super(EditPrivateRentalLoadingState()) {

    Utils.getStringPreference(Str.userIdPrefText).then((id) {
      userId = id;
    });

    on<EditPrivateRentalInitialEvent>((event, emit) async {
      emit(EditPrivateRentalLoadingState());
      var customerResponse = await _getPrivateRentalCustomer();
      var response = await _getPrivateRentalVehicle();
      var editResponse = await _getEditPrivateRentalData(id: event.rentalData['id'].toString());

      customerList =List.from(customerResponse?['customers'] ??[]);
      customerList = customerName(customerList);
      vehicleList =List.from(response?['vehicles'] ?? []);
      rentalData = editResponse ?? {};

      selectedVehicle = vehicleList.firstWhereOrNull((element) => element['vin'] == rentalData['vin']);
      selectedCustomer =customerList.firstWhereOrNull((element) => element['id'] == rentalData?['customer_id']);
      selectedCheckInDate = rentalData?['check_in_date'].toString().toDateTime(inputFormat: 'yyyy-MM-dd');
      selectedCheckOutDate = rentalData?['check_out_date'].toString().toDateTime(inputFormat: 'yyyy-MM-dd');
      checkInController.text = "${rentalData?['check_in_date']??''}";
      checkOutController.text = "${rentalData?['check_out_date']??''}";
      checkInMileageController.text = "${rentalData?['check_in_mileage']??''}";
      checkOutMileageController.text = "${rentalData?['check_out_mileage']??''}";
      selectedStatus = validation.firstWhereOrNull((element) => element['id'] == rentalData?['rental_status']);
      imageList=rentalData['images']??[];
      attachment=imageList.map((e) => e['path'].toString().toStorageURL).toList();
      emit(EditPrivateRentalLoadedState());
    });

    on<CheckInDateEvent>((event, emit) {
      selectedCheckInDate = event.selectedDate;
      emit(EditPrivateRentalCommonState());
    });

    on<CheckOutDateEvent>((event, emit) {
      selectedCheckOutDate = event.selectedDate;
      emit(EditPrivateRentalCommonState());
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
      emit(EditPrivateRentalCommonState());
    });

    on<CustomerSearchEvent>((event, emit) {
      selectedCustomer = event.selectedCustomer;
      emit(EditPrivateRentalCommonState());
    });

    on<ValidationDropDownEvent>((event, emit) {
      selectedStatus = event.validation;
      emit(EditPrivateRentalCommonState());
    });

    on<EditPrivateRentalSubmitEvent>((event, emit) async {
      try {
        emit(EditPrivateRentalLoadingState());
        var response = await _apiRepository.privateRentalAddOrUpdateApi(
          images: attachment.whereType<File>().toList(),
          body: _saveRental(),
          id: rentalData['id'].toString(),
        );
        if (response?.isNotEmpty ?? false) {
          Toaster.showSuccess(response?['message'] ?? "Success");
        }
        // _broadcast.stickyBroadcast("expense_person_refresh", value: true);
        emit(EditPrivateRentalLoadedState());
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(EditPrivateRentalLoadedState());
      }
      emit(EditPrivateRentalCommonState());
    });

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
      emit(EditPrivateRentalCommonState());
    }
  }

  void _handleFileRemoval(List<dynamic> fileList, dynamic data, Emitter emit) {
    if (data == null) return;
    if (data is File) {
      fileList.remove(data);
    }
    emit(EditPrivateRentalCommonState());
  }

  List<Map<String, dynamic>> customerName(List<Map<String, dynamic>> apiResponse) {
    return apiResponse.map((item) => item..['customer_name'] =
    "${item['first_name'] ?? ''} ${item['last_name'] ?? ''}".trim()).toList();
  }

  ///PRIVATE RENTAL VEHICLE API CALL
  Future<Map<String, dynamic>?> _getPrivateRentalVehicle() async =>
      await _apiRepository.getPrivateRentalVehicleList();

  ///PRIVATE RENTAL CUSTOMER API CALL
  Future<Map<String, dynamic>?> _getPrivateRentalCustomer() async =>
      await _apiRepository.getPrivateRentalCustomersList();

  ///EDIT PRIVATE RENTAL DATA API CALL
  Future<Map<String, dynamic>?> _getEditPrivateRentalData({String? id}) async =>
      await _apiRepository.getEditPrivateRentalData(id: id);

}
