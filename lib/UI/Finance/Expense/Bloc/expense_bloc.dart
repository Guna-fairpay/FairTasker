import 'dart:developer';
import 'dart:io';
import 'package:date_time/date_time.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/State/expense_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Repository/api_repository.dart';
import '../../../../Repository/todo_list_repository.dart';
import '../../../Todo/add_todo/add_todo_const.dart';
import '../Response/expense_response.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {

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
  List<dynamic>? selectedCohorts;
  List<dynamic>? selectedVehicle;
  String? minDate;
  String? maxDate;
  List<dynamic>? employeeList;

  ExpenseBloc()
      : super(ExpenseState(
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
          tapData: AddToDoConfig.expenseTaps,
          selectedTap: AddToDoConfig.expenseTaps.first,
        )) {
    on<GetVehicleExpenseData>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        if (event.minDate != null && event.maxDate != null) {
          minDate = event.minDate;
          maxDate = event.maxDate;
        } else {
          minDate = DateTime.now()
              .subtract(const Duration(days: 7))
              .format('yyyy-MM-dd')
              .toString();
          maxDate = DateTime.now().format('yyyy-MM-dd').toString();
        }
        var response = await _getExpense(minDate, maxDate);
        var usersList = await getIt<CommonService>().getUsers();
        log("${response?.data}", name: "API_RESPONSE");
        ExpenseResponse? expenseResponse = response;

        /*apiResponse = apiResponse?.map((e) => e..putIfAbsent("employee_name", () {
          var user = usersList.firstWhere((element) => element['id'] == e['employee_id']);
          return (List<String>.from([(user['first_name'] ?? ""), (user['last_name'] ?? "")]).toInitial);
        })).toList();*/

        var apiResponse = expenseResponse?.data;
        apiResponse = apiResponse?.map((e) {
          e.putIfAbsent("employee_name", () {
            var user = usersList.firstWhere(
                  (element) => element['id'] == e['employee_id'],
              orElse: () => {},
            );
            return List<String>.from([
              user['first_name'] ?? "",
              user['last_name'] ?? ""]).toInitial;
          });
          return e;
        }).toList() ?? [];

        apiResponse.sort((a, b) =>
            DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
        log("$apiResponse", name: "API_RESPONSE");
        emit(state.copyWith(
          isLoading: false,
          apiResponse: apiResponse,
          filteredResponse: apiResponse,
          expenseAttachments: [],
        ));
      }catch (e){
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<ExpenseTapEvent>((event, emit) {
      emit(state.copyWith(selectedTap: event.selectedTap, isLoading: false));
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

  /// API CALL: CATEGORIES
  Future<ExpenseResponse?> _getExpense(String? minDate, String? maxDate) async {
    return await apiRepository.getVehicleExpenseList(minDate: minDate,maxDate: maxDate);
  }

  /// API CALL: ACTIVE-VEHICLES
  Future<Map<String, dynamic>?> _getEmployees() async =>
      await apiRepository.getUsers();
}
