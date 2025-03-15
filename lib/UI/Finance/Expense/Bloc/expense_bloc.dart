
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
  TextEditingController subCategoryController = TextEditingController();
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
          isApprove: false,
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
        ExpenseResponse? expenseResponse = response;

        var apiResponse = expenseResponse?.data;

        /*apiResponse = apiResponse?.map((e) => e..putIfAbsent("employee_name", () {
          var user = usersList.firstWhere((element) => element['id'] == e['employee_id']);
          return (List<String>.from([(user['first_name'] ?? ""), (user['last_name'] ?? "")]).toInitial);
        })).toList();*/

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

    on<ApproveEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        var model = event.model;
        var existResponse = state.apiResponse.map((e) {
          if (e['id'] == model['id']) {
            return e..['approved'] = (int.tryParse(event.approved.toString()) ?? 0);
          } else {
            return e;
          }
        }).toList();
        await apiRepository.expenseApprove(id:event.model['id'].toString(),approved:event.approved);
        emit(state.copyWith(isLoading: false,apiResponse: existResponse));
      } catch (e){
        emit(state.copyWith(isLoading: false));
        log("$e", name: "Error In ApproveEvent");
      }
      emit(state.copyWith(isLoading: false));
    });

    on<DeleteExpenseEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await apiRepository.deleteExpenseTodo(event.id);
        await apiRepository.deleteVehicleExpense(event.id);
        var existResponse = state.apiResponse;
        existResponse.removeWhere((e) => e['id'].toString() == event.id);
        emit(state.copyWith(isLoading: false, apiResponse: existResponse));
      } catch (e){
        emit(state.copyWith(isLoading: false));
        log("$e", name: "Error In DeleteExpenseEvent");
      }
      emit(state.copyWith(isLoading: false));
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
  Future<ExpenseResponse?> _getExpense(String? minDate, String? maxDate) async {
    return await apiRepository.getVehicleExpenseList(minDate: minDate,maxDate: maxDate);
  }

}
