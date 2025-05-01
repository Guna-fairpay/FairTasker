
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Repository/api_repository.dart';
import '../../../../Response/cohorts_response.dart';
import '../../../../Response/payment_response.dart';
import '../../../../Response/vehicle_list_response.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../core/app/helper/toaster.dart';
import '../../../Todo/add_todo/add_todo_const.dart';
import '../event/vehicle_expense_history_event.dart';
import '../response/vehicle_expense_history_response.dart';
import '../state/vehicle_expense_history_state.dart';

class VehicleExpenseHistoryBloc extends Bloc<VehicleExpenseHistoryEvent, VehicleExpenseHistoryState> {

  final APiRepository apiRepository = APiRepository();

  String? categoryId;
  String? subcategoryId;

  List<dynamic>? selectedCategory;
  List<dynamic>? selectedSubCategory;
  List<dynamic>? selectedCohorts;
  List<dynamic>? selectedPaymentId;
  List<dynamic>? selectedVehicle;

  List<dynamic>? filterList = [];
  List<dynamic>? approvedList=[];
  List<dynamic>? subCategories = [];
  List<dynamic>? attachments = [];
  List<dynamic>? ogAttachments = [];
  List<Map<String, dynamic>>? categories = [];

  TextEditingController vehicleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  VehicleExpenseHistoryBloc()
      : super(VehicleExpenseHistoryState(
          searchController: TextEditingController(),
          apiResponse: const [],
          filteredResponse: const [],
          approvedList: const [],
          expenseAttachments: const [],
          editResponse: const {},
          isLoading: true,
          selectedCategory: const {},
          selectedSubCategory: const {},
          selectedPaymentMethod: const {},
          categories: const [],
          subCategories: const [],
          paymentMethods: const [],
          cohorts: const [],
          selectedCohorts: const {},
          selectedDate: DateTime.now(),
          vehicle: const [],
          selectedVehicle: const {},
          vin: '',
          vehicleName: '',
          totalAmount: 0.0,
  )) {

    on<GetVehicleExpenseHistoryList>((event, emit) async {
      try{
        emit(state.copyWith(isLoading: true));
        var response = await apiRepository.getVehicleExpense(vin: event.vin);
        var apiResponse = response?.data;
        apiResponse?.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
            .compareTo(DateTime.parse(a['created_at'] ?? '')));

        DateTime startDate = DateTime.now().subtract(Duration(days: 30));
        DateTime endDate = DateTime.now();


        for (var data in apiResponse ?? []) {
          if (data['expense_date'] != null && data['expense_date'].toString().isNotEmpty) {
            DateTime apiDate = DateTime.parse(data['expense_date']);
            DateTime expenseDate = DateTime(apiDate.year, apiDate.month, apiDate.day);

            DateTime rangeStart = DateTime(startDate.year, startDate.month, startDate.day);
            DateTime rangeEnd = DateTime(endDate.year, endDate.month, endDate.day);

            if (!expenseDate.isBefore(rangeStart) && !expenseDate.isAfter(rangeEnd)) {
              filterList?.add(data);

            }
          }
        }

        for(var data in filterList??[]){
          if(data['approved'].toString() == "1"){
            approvedList?.add(data);
          }
        }

        double totalAmount = 0;

        for (var data in approvedList ?? []) {
          double expense = (data['expense_amount'] ?? 0).toDouble();
          totalAmount += expense;
        }
        totalAmount = 0;
        for (var data in filterList ?? []) {
          double expense = (data['expense_amount'] ?? 0).toDouble();
          totalAmount += expense;
        }
        totalAmount = double.parse(totalAmount.toStringAsFixed(2));
        log("Total Amount: $totalAmount", name: "Expense Calculation");

        emit(state.copyWith(
          isLoading: false,
          apiResponse: apiResponse,
          filteredResponse: apiResponse,
          approvedList: approvedList,
          totalAmount: totalAmount,
        ));
      }catch(e){
        Utils.showMobileToast(e.toString());
        log("$e", name: 'Error');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<GetEditVehicleExpenseHistory>((event, emit) async {
      try{
        emit(state.copyWith(isLoading: true));
        var vehicleExpenseHistoryResponse = await _getEditVehicleExpenseDetails(event.id);
        var paymentResponse = await _getPaymentMethods();
        var cohortsResponse = await _getExpenseCategories();
        var vehicleResponse = await _getVehicles();

        var apiResponse = vehicleExpenseHistoryResponse?['expenses'];

        categoryId=apiResponse?['category_id'].toString()??'';
        subcategoryId=apiResponse?['subcategory_id'].toString()??'';

        categories = cohortsResponse;
        subCategories = cohortsResponse
            .where((category) => category['id'].toString() == categoryId)
            .map((category) => category['sub_categories'] ?? [])
            .expand((subcategoryList) => subcategoryList)
            .toList();

        selectedCategory = categories
            ?.where((e) => e['id'].toString() == categoryId)
            .toList();
        selectedSubCategory = subCategories
            ?.where((e) => e['id'].toString() == subcategoryId)
            .toList();

        selectedPaymentId = paymentResponse.where(
              (e) => e['id'] == apiResponse?['payment_method_id'],).toList();

        ogAttachments = apiResponse?['attachments'];

        attachments?.clear();
        attachments?.addAll(ogAttachments
            ?.map((e) => e['path'].toString().toStorageURL)
            .toList() ?? []);

        if(apiResponse?['expense_to'] != null){
          selectedCohorts = AddToDoConfig.expenseTo
              .where((e) => e['id'] == apiResponse?['expense_to'])
              .toList();
        }

        descriptionController.text = apiResponse?['expense_description'] ?? '';
        amountController.text = "${apiResponse?['expense_amount'] ?? ''}";
        dateController.text = apiResponse?['expense_date'] ?? '';

        selectedVehicle = vehicleResponse.where(
                (e) => e['vin'] == apiResponse?['vin']).toList();
        vehicleController.text = selectedVehicle?.firstOrNull?['vehicle_name'] ?? '';

        emit(state.copyWith(
          isLoading: false,
          editResponse: apiResponse,
          expenseAttachments: attachments,
          selectedCategory:selectedCategory?.firstOrNull,
          selectedSubCategory:selectedSubCategory?.firstOrNull,
          selectedPaymentMethod: selectedPaymentId?.firstOrNull,
          categories: categories,
          subCategories: subCategories,
          paymentMethods: paymentResponse,
          cohorts: AddToDoConfig.expenseTo,
          selectedCohorts:selectedCohorts?.firstOrNull,
          selectedDate: apiResponse?['expense_date'].toString().toDateTime(inputFormat: 'yyyy-MM-dd'),
          vehicle: vehicleResponse,
          selectedVehicle: selectedVehicle?.firstOrNull,
          vin: selectedVehicle?.firstOrNull?['vin'] ?? '',
          vehicleName: selectedVehicle?.firstOrNull?['vehicle_name'] ?? '',
        ));
      }catch(e){
        Utils.showMobileToast(e.toString());
        log("$e", name: 'Error');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<SearchVehicleExpenseHistoryEvent>((event, emit) {
      if (event.query == null || event.query!.isEmpty) {
        emit(state.copyWith(filteredResponse: state.apiResponse));
      } else {
        var filteredResponse = state.apiResponse.where((element) {
          final description = (element['expense_description'] ?? '').toString().toLowerCase();
          final amount = (element['expense_amount'] ?? '').toString().toLowerCase();
          final date = (element['expense_date'] ?? '').toString().toLowerCase();

          return description.contains(event.query!.toLowerCase()) ||
              date.contains(event.query!.toLowerCase()) ||
              amount.contains(event.query!.toLowerCase());
        }).toList();

        emit(state.copyWith(filteredResponse: filteredResponse));
      }
    });

    on<RemoveImageEvent>((event, emit) async {
      if (event.data == null) return;
      if (event.data is File) {
        // LOCAL SELECTION REMOVE
        state.expenseAttachments.remove(event.data);
       attachments=state.expenseAttachments;
      } else if (event.data is String) {
        // REMOTE SELECTION REMOVE
        var data = attachments?.firstWhereOrNull(
                (element) => element == event.data.toString());

        var attachmentId = ogAttachments
            ?.where((element) => element['path'] == data.toString().removeStorageUrl)
            .map((e) => e['id'])
            .firstOrNull;
        emit(state.copyWith(isLoading: true));
        await apiRepository.deleteVehicleExpenseImage(attachmentId);
        emit(state.copyWith(isLoading: false));
        // once success remove from attachments
        attachments?.remove(event.data);
      }
      emit(state.copyWith(expenseAttachments: attachments));
    });

    on<PickImageEvent>((event, emit) async {
      var result = await _pickFiles();
      if (result.isNotEmpty) {
        var attachments = List.from(state.expenseAttachments);
        var existingAttachments = List.from(state.expenseAttachments)
            .whereType<File>()
            .map((e) => (e.path))
            .toList();
        for (var element in result) {
          if (!existingAttachments.contains(element.path)) {
            attachments.add(element);
          }
        }
        log("$attachments", name: "PickImageEvent");
        emit(state.copyWith(expenseAttachments: attachments));
      }
    });

    on<CaptureImageEvent>((event, emit) async {
      var result = await _pickImages();
      if (result != null) {
        var attachments = List.from(state.expenseAttachments);
        attachments.add(result);
        log("$attachments", name: "CaptureImageEvent");
        emit(state.copyWith(expenseAttachments: attachments));
      }
    });

    on<SelectedPaymentEvent>((event, emit) =>
        emit(state.copyWith(selectedPaymentMethod: event.paymentType)));

    on<CategoryListEvent>((event, emit) {
      if (event.category != null) {
        var subCategories = event.category?['sub_categories'];
        emit(state.copyWith(
            selectedCategory: event.category,
            subCategories: subCategories,
            selectedSubCategory: {}));
      }
    });

    on<SubCategoryListEvent>((event, emit) =>
        emit(state.copyWith(selectedSubCategory: event.subCategory)));

    on<DateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedDate: event.selectedDate)));

    on<DeleteVehicleExpenseHistoryEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await apiRepository.deleteVehicleExpense(event.id);
      await apiRepository.deleteExpenseTodo(event.id);
      emit(state.copyWith(isLoading: false));
    });

    on<VehicleEvent>((event, emit) =>
        emit(state.copyWith(selectedVehicle: event.selectedVehicle)));

    on<UpdateVehicleExpenseHistoryEvent>((event, emit) async {
     try {
        emit(state.copyWith(isLoading: true));
        await apiRepository.updateVehicleExpenseHistory(
          body: _expenseData(),
          expenseId: event.id,
          images: state.expenseAttachments.whereType<File>().toList(),
        );
        emit(state.copyWith(isLoading: false));
      } catch (e){
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

  }

  Map<String, String> _expenseData() {

    Map<String, String> baseBody = {};
    baseBody['expense_amount'] = amountController.text;
    baseBody['category_id'] = "${state.selectedCategory?['id'] ?? ''}";
    baseBody['subcategory_id'] = "${state.selectedSubCategory?['id'] ?? ''}";
    baseBody['payment_method_id'] = "${state.selectedPaymentMethod?['id'] ?? ''}";
    baseBody['expense_to'] =
    "${state.selectedSubCategory?['expense_to'] ?? ''}";
    baseBody['cohort_id'] = "${state.selectedCohorts?['id'] ?? ''}";
    baseBody['vin'] = "${state.selectedVehicle['vin'] ?? ''}";
    baseBody['expense_date'] = dateController.text;
    baseBody['expense_description'] = descriptionController.text;
    baseBody['platform'] = 'tasker-app';
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

  Future<File?> _pickImages() async {
    final XFile? pickedFiles =
    await ImagePicker().pickImage(source: ImageSource.camera);
    return (pickedFiles != null) ? File(pickedFiles.path) : null;
  }

  /// API CALL: PAYMENT METHODS
  Future<List<Map<String, dynamic>>> _getPaymentMethods() async =>
    await getIt<CommonService>().getPaymentTypes();

  /// API CALL: CATEGORIES
  Future<List<Map<String, dynamic>>> _getExpenseCategories() async =>
     await getIt<CommonService>().getExpenseCategories();

  /// API CALL: ACTIVE-VEHICLES
  Future<List<Map<String, dynamic>>> _getVehicles() async =>
      await getIt<CommonService>().getActiveVehicles();

  /// API CALL: EXPENSE DETAILS
  Future<Map<String, dynamic>?> _getEditVehicleExpenseDetails(dynamic expenseId) async =>
      await apiRepository.getEditVehicleExpense(id: expenseId);

}
