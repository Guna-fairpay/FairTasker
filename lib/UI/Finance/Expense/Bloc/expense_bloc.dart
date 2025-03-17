import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/State/expense_state.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
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
  DateTime now = DateTime.now();
  dynamic approvedAmount = 0.0;
  dynamic unApprovedAmount = 0.0;

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
          selectedDateRange: DateRange(
            DateTime.now().subtract(const Duration(days: 7)),
            DateTime.now(),
          ),
          isApprove: false,
          isExpenseApproved: false,
          approvedAmount: 0.0,
          unApprovedAmount: 0.0,

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
              .toFormat(format: 'yyyy-MM-dd');
          maxDate = DateTime.now().toFormat(format: 'yyyy-MM-dd');
        }
        //Console.of.log(maxDate);
        var response = await _getExpense(minDate, maxDate);
        var usersList = await getIt<CommonService>().getUsers();
        var expenseCategories = await _getExpenseCategories();

        ExpenseResponse? expenseResponse = response;

        var apiResponse = expenseResponse?.data;

        apiResponse = apiResponse?.map((e) {
              e.putIfAbsent("employee_name", () {
                var user = usersList.firstWhere(
                  (element) => element['id'] == e['employee_id'],
                  orElse: () => {},
                );
                return List<String>.from(
                        [user['first_name'] ?? "", user['last_name'] ?? ""])
                    .toInitial;
              });
              return e;
            }).toList() ??
            [];

        apiResponse.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
            .compareTo(DateTime.parse(a['created_at'] ?? '')));

        apiResponse = apiResponse
            .map((item) => item
              ..['cohortList'] = [
                {"id": "1", "name": "FairPy"},
                {"id": "4", "name": "${item['cohort']['cohort']}"}
              ])
            .toList();

        List<dynamic> filteredResponse =
            filterApprovedResponse(apiResponse, state.isExpenseApproved);



        if(state.isExpenseApproved){
          approvedAmount = filteredResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
        }
        if(!state.isExpenseApproved){
          unApprovedAmount = filteredResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
        }

        emit(state.copyWith(
          isLoading: false,
          apiResponse: apiResponse,
          filteredResponse: filteredResponse,
          categories: expenseCategories,
          approvedAmount: approvedAmount,
          unApprovedAmount: unApprovedAmount,
        ));
      } catch (e) {
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
        var existResponse = state.filteredResponse.map((e) {
          if (e['id'] == model['id']) {
            return e
              ..['approved'] = (int.tryParse(event.approved.toString()) ?? 0);
          } else {
            return e;
          }
        }).toList();
        await apiRepository.expenseApprove(
            id: event.model['id'].toString(), approved: event.approved);

        List<dynamic> filteredResponse =
            filterApprovedResponse(existResponse, state.isExpenseApproved);

        approvedAmount=0;
        unApprovedAmount=0;

        if(state.isExpenseApproved){
          approvedAmount = filteredResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
        }
        if(!state.isExpenseApproved){
          unApprovedAmount = filteredResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
        }

        emit(state.copyWith(
            isLoading: false,
            filteredResponse: filteredResponse,
            approvedAmount: approvedAmount,
            unApprovedAmount: unApprovedAmount,
        ));
      } catch (e) {
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
        var existResponse = state.filteredResponse;
        existResponse.removeWhere((e) => e['id'].toString() == event.id);

        approvedAmount=0;
        unApprovedAmount=0;
        if(state.isExpenseApproved){
          approvedAmount = existResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
        }
        if(!state.isExpenseApproved){
          unApprovedAmount = existResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
        }

        emit(state.copyWith(
            isLoading: false,
            filteredResponse: existResponse,
            approvedAmount: approvedAmount,
            unApprovedAmount: unApprovedAmount,
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        log("$e", name: "Error In DeleteExpenseEvent");
      }
      emit(state.copyWith(isLoading: false));
    });

    on<CategoryListEvent>((event, emit) {
      if (event.selectedCategory != null) {
        var subCategories = event.selectedCategory?['sub_categories'];
        log(subCategories.toString(), name: 'subCategories');
        emit(state.copyWith(
            selectedCategory: event.selectedCategory,
            subCategories: subCategories,
            selectedSubCategory: {}));
      }
    });

    on<SubCategoryListEvent>((event, emit) =>
        emit(state.copyWith(selectedSubCategory: event.selectedSubCategory)));

    on<CohortListEvent>((event, emit) {
      emit(state.copyWith(selectedCohorts: event.selectedCohort));
    });

    on<CategoryDialogEvent>((event, emit) {
      var data = event.data;
      var selectedCategory = state.categories
              .where(
                (element) =>
                    element['id'].toString() == data?['category_id'].toString(),
              )
              .firstOrNull ??
          {};
      List<dynamic> subCategories = selectedCategory['sub_categories'] ?? [];
      var selectedSubCategory = subCategories
              .where(
                (element) =>
                    element['id'].toString() ==
                    data?['subcategory_id'].toString(),
              )
              .firstOrNull ??
          {};
      log(selectedSubCategory.toString(), name: 'selectedSubCategory');

      emit(state.copyWith(
        selectedCategory: selectedCategory,
        selectedSubCategory: selectedSubCategory,
        subCategories: subCategories,
      ));
    });

    on<CohortDialogEvent>((event, emit) {
      var data = event.data;
      List<dynamic> cohort = data['cohortList'] ?? [];
      var selectedCohort = cohort
              .where(
                (element) =>
                    element['id'].toString() == data['expense_to'].toString(),
              )
              .firstOrNull ??
          {};
      emit(state.copyWith(cohorts: cohort, selectedCohorts: selectedCohort));
    });

    on<UpdateDateRangeEvent>((event, emit) {
      emit(state.copyWith(selectedDateRange: event.selectedRange));
    });

    on<ApprovedExpenseEvent>((event, emit) {

      List<dynamic> filteredResponse =
          filterApprovedResponse(state.apiResponse, event.isApproved);
      approvedAmount=0;
      unApprovedAmount=0;

      if(event.isApproved == true){
        approvedAmount = filteredResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
      }
      if(event.isApproved == false){
        unApprovedAmount = filteredResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
      }
      log('check-${event.isApproved} \n approvedAmount-${approvedAmount}\n unApprovedAmount-${unApprovedAmount}',name: 'Amount');

      emit(state.copyWith(
        isExpenseApproved: event.isApproved,
        filteredResponse: filteredResponse,
        approvedAmount: approvedAmount,
        unApprovedAmount: unApprovedAmount,
      ));
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
    return await apiRepository.getVehicleExpenseList(
        minDate: minDate, maxDate: maxDate);
  }

  /// API CALL: CATEGORIES
  Future<List<Map<String, dynamic>>?> _getExpenseCategories() async {
    return await getIt<CommonService>().getExpenseCategories(reset: true);
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
}
