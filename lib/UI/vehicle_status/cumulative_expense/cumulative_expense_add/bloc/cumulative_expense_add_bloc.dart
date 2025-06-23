
import 'dart:convert';
import 'dart:io';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_add/bloc/cumulative_expense_add_event.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_add/bloc/cumulative_expense_add_state.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CumulativeExpenseAddBloc extends Bloc<CumulativeExpenseAddEvent, CumulativeExpenseAddState> {

  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;

  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> cohort = [];
  List<Map<String, dynamic>> filteredResponse = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> categoryList = [];
  List<Map<String, dynamic>> subCategoryList = [];
  List<dynamic> files = [];
  Map<String, dynamic>? selectedVehicle;
  Map<String, dynamic>? selectedCategory;
  Map<String, dynamic>? selectedSubCategory;
  Map<String, dynamic>? selectedCohort;
  DateTime? selectedDate;

  CumulativeExpenseAddBloc() : super(CumulativeExpenseAddLoadingState()) {
    on<CumulativeExpenseAddInitialEvent>(_onCumulativeExpenseAddInitialEvent);
    on<CumulativeExpenseAddDatePickEvent>(_onCumulativeExpenseAddDatePickEvent);
    on<CumulativeExpenseAddCohortEvent>(_onCumulativeExpenseAddCohortEvent);
    on<CumulativeExpenseAddCategoryEvent>(_onCumulativeExpenseAddCategoryEvent);
    on<CumulativeExpenseAddSubCategoryEvent>(
        _onCumulativeExpenseAddSubCategoryEvent);
    on<CumulativeExpenseAddVehicleEvent>(_onCumulativeExpenseAddVehicleEvent);
    on<CumulativeExpenseAddReceiptEvent>(_onCumulativeExpenseAddReceiptEvent);
    on<CumulativeExpenseAddRemoveAttachmentEvent>(_onCumulativeExpenseAddRemoveAttachmentEvent);
    on<CumulativeExpenseAddSaveEvent>(_onCumulativeExpenseAddSaveEvent);
  }

  void _onCumulativeExpenseAddInitialEvent(
      CumulativeExpenseAddInitialEvent event,
      Emitter<CumulativeExpenseAddState> emit) async {
    try {
      emit(CumulativeExpenseAddLoadingState());
      var response = await _apiRepository.getCohorts();
      cohort = List.from(response?['cohortsData']);
      categoryList = List.from(response?['expenseCategories']);
      selectedCohort = cohort
          .where((element) =>
      element['id'].toString() == event.data['cohort_id'].toString())
          .first;
      vehicleList = List.from(selectedCohort?['vehicles']);
      selectedVehicle = vehicleList
          .where((element) =>
      element['vin'].toString() == event.data['vin'].toString())
          .first;
      event.data['vehicle'];
      emit(CumulativeExpenseAddCommonState());
    } catch (e) {
      Toaster.showError(e.toString());
      emit(CumulativeExpenseAddCommonState());
    }
  }

  void _onCumulativeExpenseAddDatePickEvent(
      CumulativeExpenseAddDatePickEvent event,
      Emitter<CumulativeExpenseAddState> emit) async {
    try {
      selectedDate = event.selectedDate;
      emit(CumulativeExpenseAddCommonState());
    } catch (e) {
      Toaster.showError(e.toString());
      emit(CumulativeExpenseAddCommonState());
    }
  }

  void _onCumulativeExpenseAddCohortEvent(CumulativeExpenseAddCohortEvent event,
      Emitter<CumulativeExpenseAddState> emit) async {
    try {
      selectedCohort = event.selectedCohort;
      vehicleList = [];
      selectedVehicle = null;
      vehicleList = List.from(selectedCohort?['vehicles']);
      emit(CumulativeExpenseAddCommonState());
    } catch (e) {
      Toaster.showError(e.toString());
      emit(CumulativeExpenseAddCommonState());
    }
  }

  void _onCumulativeExpenseAddCategoryEvent(
      CumulativeExpenseAddCategoryEvent event,
      Emitter<CumulativeExpenseAddState> emit) async {
    try {
      selectedCategory = event.selectedCategory;
      subCategoryList = [];
      selectedSubCategory = null;
      subCategoryList = List.from(selectedCategory?['sub_categories'] ?? []);
      emit(CumulativeExpenseAddCommonState());
    } catch (e) {
      Toaster.showError(e.toString());
      emit(CumulativeExpenseAddCommonState());
    }
  }

  void _onCumulativeExpenseAddSubCategoryEvent(
      CumulativeExpenseAddSubCategoryEvent event,
      Emitter<CumulativeExpenseAddState> emit) async {
    try {
      selectedSubCategory = event.selectedSubCategory;
      emit(CumulativeExpenseAddCommonState());
    } catch (e) {
      Toaster.showError(e.toString());
      emit(CumulativeExpenseAddCommonState());
    }
  }

  void _onCumulativeExpenseAddVehicleEvent(
      CumulativeExpenseAddVehicleEvent event,
      Emitter<CumulativeExpenseAddState> emit) async {
    try {
      selectedVehicle = event.selectedVehicle;
      emit(CumulativeExpenseAddCommonState());
    } catch (e) {
      Toaster.showError(e.toString());
      emit(CumulativeExpenseAddCommonState());
    }
  }

  void _onCumulativeExpenseAddReceiptEvent(
      CumulativeExpenseAddReceiptEvent event,
      Emitter<CumulativeExpenseAddState> emit) async {
    try {
      var result = await _pickFiles();
      if (result.isNotEmpty) {
        var attachments = List.from(files);
        var existingAttachments = List.from(files)
            .whereType<File>()
            .map((e) => (e.path))
            .toList();
        for (var element in result) {
          if (!existingAttachments.contains(element.path)) {
            attachments.add(element);
          }
        }
        files = attachments;
      }
      emit(CumulativeExpenseAddCommonState());
    } catch (e) {
      Toaster.showError(e.toString());
      emit(CumulativeExpenseAddCommonState());
    }
  }

  void _onCumulativeExpenseAddRemoveAttachmentEvent(CumulativeExpenseAddRemoveAttachmentEvent event, Emitter<CumulativeExpenseAddState> emit){
    try{
      if(event.data == null) return;
      if(event.data != null){
        files.remove(event.data);
      }
      emit(CumulativeExpenseAddCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(CumulativeExpenseAddCommonState());
    }
  }

  Future<void> _onCumulativeExpenseAddSaveEvent(CumulativeExpenseAddSaveEvent event, Emitter<CumulativeExpenseAddState> emit) async {
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if(formKey.currentState?.validate() == false) return emit(CumulativeExpenseAddCommonState());
    try{
      autoValidateMode = null;
      emit(CumulativeExpenseAddLoadingState());
      var response = await _apiRepository.expenseAddOrUpdateApi(
         body:  _saveExpenseData(),
        images: files.whereType<File>().toList(),
      );
      if(response !=null){
        Toaster.showSuccess(response['message']);
      }
     Console.of.log(response, name: "Expense_Response");
      emit(CumulativeExpenseAddSuccessState());

    }catch(e){
      Toaster.showError(e.toString());
      emit(CumulativeExpenseAddCommonState());
    }
  }

  Map<String, String> _saveExpenseData() {
    Map<String, String> baseBody = {};
    baseBody['category_id'] = "${selectedCategory?['id'] ?? ''}";
    baseBody['subcategory_id'] = "${selectedSubCategory?['id'] ?? ''}";
    baseBody['expense_to'] = "${selectedSubCategory?['expense_to'] ?? ''}";
    baseBody['expense_amount'] = amountController.text;
    baseBody['expense_description'] = descriptionController.text;
    baseBody['expense_date'] = selectedDate.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['cohort_id'] = "${selectedVehicle?["cohort_id"] ?? ''}";
    baseBody['vin'] = "${selectedVehicle?['vin'] ?? ''}";
    baseBody['platform'] = "TaskerApp";

    Console.of.log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf',]);
    return result?.paths.where((element) => (element?.isNotEmpty ?? false))
        .map((e) => File(e!)).toList() ?? [];
  }

}
