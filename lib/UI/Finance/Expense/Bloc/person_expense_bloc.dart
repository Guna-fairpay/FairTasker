
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/person_expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/State/expense_state.dart';
import 'package:fairpytasker/UI/Finance/Expense/State/persion_expense_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Repository/api_repository.dart';
import '../../../../Repository/todo_list_repository.dart';
import '../../../Todo/add_todo/add_todo_const.dart';
import '../../../Vehicle/vehicle_expense_history/response/vehicle_expense_history_response.dart';
import '../Response/expense_response.dart';

class PersonExpenseBloc extends Bloc<PersonExpenseEvent, PersonExpenseState>{
  final APiRepository apiRepository = APiRepository();
  final TodoListRepo todoListRepo = TodoListRepo();
  String? categoryId;
  String? subcategoryId;
  List<dynamic>? selectedCategory;
  List<dynamic>? selectedSubCategory;
  List<dynamic>? subCategories = [];
  List<Map<String, dynamic>>? categories = [];
  List<dynamic>? selectedPaymentId;
  List<dynamic>? attachments = [];
  List<dynamic>? ogAttachments = [];
  TextEditingController vehicleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController odometerController = TextEditingController();
  List<dynamic>? selectedCohorts;
  List<dynamic>? selectedVehicle;
  String? minDate;
  String? maxDate;
  List<dynamic>? employeeList;
  DateTime now = DateTime.now();
  dynamic approvedAmount = 0.0;
  dynamic unApprovedAmount = 0.0;
  List<dynamic>? usersName = [];
  dynamic userId;
  List<dynamic> vinList = [];
  List<String> vehicleNameList = [];
  List<dynamic> partsList = [];
  List<dynamic> suppliesList = [];
  final TextEditingController partsCostController = TextEditingController();
  final TextEditingController labourCostController = TextEditingController();
  final TextEditingController subTotalController = TextEditingController();
  final TextEditingController saleTaxController = TextEditingController();
  final TextEditingController shippingController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController percentageOrAmountController =
  TextEditingController();
  bool taxIsTapped = false;
  List<Map<String, dynamic>> selectedParts = [];
  List<Map<String, dynamic>> selectedSupplies = [];
  String? resourceId;
  List<dynamic> splitSupplies = [];
  List<dynamic> splitParts = [];

  PersonExpenseBloc()
      : super(PersonExpenseState(
    apiResponse: const [],
    filteredResponse: const [],
    expenseAttachments: const [],
    editResponse: const {},
    isLoading: true,
    selectedCategory: const {},
    selectedSubCategory: const {},
    categories: const [],
    subCategories: const [],
    cohorts: const [],
    selectedCohorts: const {},
    selectedDateRange: DateRange(
      DateTime.now().subtract(const Duration(days: 7)),
      DateTime.now(),
    ),
    isApprove: false,
    approvedAmount: 0.0,
    paymentType: const [],
    selectedPaymentType: const {},
    selectedDate: DateTime.now(),
    persons: const [],
    selectedPerson: const {},
  )) {
    Utils.getStringPreference(Str.userIdPrefText).then((id) {
      resourceId = id;
    });

    on<GetPersonExpenseData>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        if (event.minDate != null && event.maxDate != null) {
          minDate = event.minDate;
          maxDate = event.maxDate;
        } else {
          minDate = DateTime.now()
              .subtract(const Duration(days: 7))
              .toFormat(format: 'yyyy-MM-dd');
          maxDate = DateTime.now().toFormat(format: 'yyyy-MM-dd');
        }
        //Console.of.log(maxDate);
        var response = await _getPersonExpense(minDate, maxDate);
        var usersList = await getIt<CommonService>().getUsers();
        emit(state.copyWith(
          isLoading: false,
          apiResponse: response?.data ?? [],
        ));
      } catch (e) {
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<GetPersonExpenseAddData>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));

        var usersList = await getIt<CommonService>().getUsers();
        emit(state.copyWith(
          isLoading: false,

        ));
      } catch (e) {
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<GetPersonExpenseEditData>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));

        var usersList = await getIt<CommonService>().getUsers();
        emit(state.copyWith(
          isLoading: false,

        ));
      } catch (e) {
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });



    on<ChangeDateRangeEvent>((event, emit) {
      emit(state.copyWith(selectedDateRange: event.selectedRange));
    });

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

  /// API CALL: Expense Vehicle
  Future<ExpenseResponse?> _getPersonExpense(String? minDate, String? maxDate) async {
    return await apiRepository.getPersonExpense(
        minDate: minDate, maxDate: maxDate);
  }


  void calculateTotal() {
    _updateExpenseTotal();
  }

  List<dynamic> filterApprovedResponse(
      List<dynamic> existResponse, bool? isApproved) {
    if (isApproved == true) {
      return existResponse.where((item) => item['approved'] == 1).toList();
    } else if (isApproved == false) {
      return existResponse.where((item) => item['approved'] == 0).toList();
    }
    return existResponse;
  }

  List<String> getUserInitials(
      dynamic userIds, List<Map<String, dynamic>> users) {
    if (userIds == null) {
      return [];
    } else if (userIds is String &&
        userIds.startsWith("[") &&
        userIds.endsWith("]")) {
      userIds =
      List<String>.from(jsonDecode(userIds).map((id) => id.toString()));
    } else if (userIds is String) {
      userIds = [userIds];
    } else if (userIds is! List) {
      return [];
    }
    return users
        .where((user) => userIds.contains(user['id'].toString()))
        .map((user) {
      String firstInitial = (user['first_name']?.isNotEmpty ?? false)
          ? user['first_name'][0].toUpperCase()
          : "";
      String lastInitial = (user['last_name']?.isNotEmpty ?? false)
          ? user['last_name'][0].toUpperCase()
          : "";
      return "$firstInitial$lastInitial";
    }).toList();
  }

  void _updateExpenseTotal() {
    double totalSuppliesCost = 0;
    double totalParts = 0;
    totalParts = partsList
        .map((e) =>
    double.tryParse(
        (e['controller'] as TextEditingController).text.toString()) ??
        0.0)
        .sum;

    totalSuppliesCost = suppliesList
        .map((e) =>
    double.tryParse(
        (e['controller'] as TextEditingController).text.toString()) ??
        0.0)
        .sum;

    double labourCost = double.tryParse(labourCostController.text) ?? 0;
    double saleTax = double.tryParse(saleTaxController.text) ?? 0;
    double shippingCost = double.tryParse(shippingController.text) ?? 0;
    double percentageOrAmount =
        double.tryParse(percentageOrAmountController.text) ?? 0;
    double subTotal = totalParts + totalSuppliesCost + labourCost;
    subTotalController.text = subTotal.toStringAsFixed(2);

    if (taxIsTapped) {
      saleTaxController.text = (percentageOrAmount).toStringAsFixed(2);
    } else {
      saleTaxController.text =
          (subTotal * (percentageOrAmount / 100)).toStringAsFixed(2);
    }
    double totalAmount = subTotal + saleTax + shippingCost;
    totalAmountController.text = totalAmount.toStringAsFixed(2);
  }
}
