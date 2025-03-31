
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Finance/Expense/UI/Vehicle/Event/add_expense_vehicle_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/UI/Vehicle/State/add_expense_vehicle_state.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddExpenseVehicleBloc extends Bloc<AddExpenseVehicleEvent, AddExpenseVehicleState> {
  final APiRepository apiRepository = APiRepository();

  List<dynamic>? attachments = [];
  List<dynamic>? ogAttachments = [];
  TextEditingController vehicleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController odometerController = TextEditingController();
  List<dynamic>? selectedCohorts;
  List<dynamic>? selectedVehicle;
  final FBroadcast _broadcast = FBroadcast.instance();
  String? resourceId;

  AddExpenseVehicleBloc() : super(
      AddExpenseVehicleState(
        expenseAttachments: const [],
        isLoading: true,
        selectedCategory: const {},
        selectedSubCategory: const {},
        categories: const [],
        subCategories: const [],
        cohorts: const [],
        selectedCohorts: const {},
        vehicleList: const [],
        selectedVehicle: const {},
        paymentType: const [],
        selectedPaymentType: const {},
        selectedDate: DateTime.now(),
        popAddPagePop: false,
      ))
  {

    Utils.getStringPreference(Str.userIdPrefText).then((id) {
      resourceId = id;
    });

    on<GetVehicleExpenseAddData>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        var vehicleList = await getIt<CommonService>().getActiveVehicles();
        var paymentType = await getIt<CommonService>().getPaymentTypes();
        var categories = await getIt<CommonService>().getExpenseCategories();

        emit(state.copyWith(
          isLoading: false,
          vehicleList: vehicleList,
          paymentType: paymentType,
          categories: categories,
          cohorts: AddToDoConfig.expenseTo,
          popAddPagePop: false,
        ));
      } catch (e) {
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<CategoryListEvent>((event, emit) {
      if (event.selectedCategory != null) {
        var subCategories = event.selectedCategory?['sub_categories'];
        emit(state.copyWith(
          selectedCategory: event.selectedCategory,
          subCategories: subCategories,
          selectedSubCategory: {},
          selectedCohorts: {},
        ));
      }
    });

    on<SubCategoryListEvent>((event, emit) {
      if(event.selectedSubCategory != null){
        var selectedCohorts = (AddToDoConfig.expenseTo)
            .firstWhereOrNull((e) => e['id']?.toString() == event.selectedSubCategory['expense_to']?.toString());
        emit(state.copyWith(
          selectedSubCategory: event.selectedSubCategory,
          selectedCohorts: selectedCohorts,
        ));
      }
    });

    on<SelectedPaymentEvent>((event, emit) =>
        emit(state.copyWith(selectedPaymentType: event.paymentType)));

    on<VehicleEvent>((event, emit) =>
        emit(state.copyWith(selectedVehicle: event.selectedVehicle)));

    on<CohortListEvent>((event, emit) {
      emit(state.copyWith(selectedCohorts: event.selectedCohort));
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

    on<RemoveImageEvent>((event, emit) async {
      if (event.data == null) return;
      if (event.data is File) {
        // LOCAL SELECTION REMOVE
        state.expenseAttachments.remove(event.data);
        attachments = state.expenseAttachments;
      } else if (event.data is String) {
        // REMOTE SELECTION REMOVE
        var data = attachments
            ?.firstWhereOrNull((element) => element == event.data.toString());

        var attachmentId = ogAttachments
            ?.where((element) =>
        element['path'] == data.toString().removeStorageUrl)
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

    on<DateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedDate: event.selectedDate)));

    on<SaveExpenseEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        log("${state.expenseAttachments.whereType<File>().toList()}",
            name: 'EXPENSE_DATA');
        var response = await apiRepository.expenseAddOrUpdateApi(
            images: state.expenseAttachments.whereType<File>().toList(),
            body: _saveExpenseData());
        if (response?.isNotEmpty ?? false) {
          Toaster.showSuccess(response?['message'] ?? "Success");
        }
        emit(state.copyWith(popAddPagePop: true));
        _broadcast.stickyBroadcast("expense_vehicle_refresh", value: true);
        if (response?['status'] == 200) emit(state.copyWith());
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

  }

  Map<String, String> _saveExpenseData() {
    Map<String, String> baseBody = {};
    baseBody['category_id'] = "${state.selectedCategory?['id'] ?? ''}";
    baseBody['subcategory_id'] = "${state.selectedSubCategory?['id'] ?? ''}";
    baseBody['payment_method_id'] = "${state.selectedPaymentType?['id'] ?? ''}";
    baseBody['expense_to'] = "${state.selectedCohorts?['id'] ?? ''}";
    baseBody['expense_amount'] = amountController.text;
    baseBody['expense_description'] = descriptionController.text;
    baseBody['expense_date'] = state.selectedDate.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['cohort_id'] = "${state.selectedVehicle["cohort_id"] ?? ''}";
    baseBody['vin'] = "${state.selectedVehicle['vin'] ?? ''}";
    if (odometerController.text.isNotEmpty &&
        ((double.tryParse(odometerController.text) ?? 0) > 0)) {
      baseBody['odometer'] = odometerController.text;
    }
    baseBody['platform'] = "TaskerApp";
    baseBody['employee_id'] = resourceId ?? '';

    log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'mp4',
          'mov',
        ]);
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

  /// API CALL: VEHICLES
  Future<List<Map<String, dynamic>>?> _getVehicleList() async {
    return await getIt<CommonService>().getActiveVehicles();
  }

  /// API CALL: PAYMENT TYPE
  Future<List<Map<String, dynamic>>?> _getPaymentType() async {
    return await getIt<CommonService>().getPaymentTypes();
  }


}
