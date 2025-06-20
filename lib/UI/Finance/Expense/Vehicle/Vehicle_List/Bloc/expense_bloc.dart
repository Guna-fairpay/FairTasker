
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Bloc/expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Bloc/expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final APiRepository apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
  dynamic minDate;
  dynamic maxDate;
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
  List<Map<String, dynamic>>? expenseCategories =[];
  List <dynamic> apiResponse =[];
  final FBroadcast _broadcast = FBroadcast.instance();
  int? get _branch =>  getIt<CommonService>().branchId;


  @override
  Future<void> close() {
    _broadcast.unregister("expense_vehicle_refresh");
    Console.of.log("ExpenseBloc Closed");
    return super.close();
  }

  /// API CALL: Expense Vehicle
  Future<Map<String, dynamic>?> _getExpense(String? minDate, String? maxDate) async => await apiRepository.getVehicleExpenseList(minDate: minDate, maxDate: maxDate);

  /// API CALL: SUB CATEGORY EXPENSE TO
  Future<Map<String,dynamic>?> _getSubCategoryExpenseTo() async => await apiRepository.getExpenseTo();

  /// API CALL: Expense Vehicle Local
 /// Future<Map<String, dynamic>?> _getExpenseLocal({String? minDate, String? maxDate}) async => await apiRepository.vehicleExpense(minDate: minDate, maxDate: maxDate);


  ExpenseBloc({bool listenBroadcast = true})
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
          vehicleList: const [],
          selectedVehicle: const {},
          paymentType: const [],
          selectedPaymentType: const {},
          selectedDate: DateTime.now(),
          todoDetails: const {},
          userNames: const [],
          todoVehicles: const [],
          partsList: const [],
          suppliesList: const [],
          splitExpense: const [],
          categoryName: '',
          subCategoryName: '',
          expenseTo: const [],
          selectedExpenseTo: const {},
          pop: false,
          categoriesPop: false,
          popAddPagePop: false,
          popEditPage: false,
        )) {
    // if (listenBroadcast)
      _registerBroadcast();
    // else _broadcast.unregister("expense_vehicle_refresh");
    Utils.getStringPreference(Str.userIdPrefText).then((id) {
      resourceId = id;
    });

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
        add(RefreshEvent());
      } catch (e) {
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<RefreshEvent>((event, emit) async {
      _resetAll();
    });

    on<ExpenseTapEvent>((event, emit) {
      emit(state.copyWith(selectedTap: event.selectedTap, isLoading: false));
    });

    on<ApproveEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
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
        add(RefreshEvent());
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        log("$e", name: "Error In ApproveEvent");
      }
    });

    on<DeleteExpenseEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        await apiRepository.deleteExpenseTodo(event.id);
        await apiRepository.deleteVehicleExpense(event.id);
        add(RefreshEvent());
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        log("$e", name: "Error In DeleteExpenseEvent");
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

    // on<SelectedPaymentEvent>((event, emit) =>
    //     emit(state.copyWith(selectedPaymentType: event.paymentType)));

    on<VehicleEvent>((event, emit) =>
        emit(state.copyWith(selectedVehicle: event.selectedVehicle)));

    on<SubcategoryDropdownEvent>((event, emit) =>
        emit(state.copyWith(selectedExpenseTo: event.selectedExpenseTo)));

    on<CohortListEvent>((event, emit) {
      emit(state.copyWith(selectedCohorts: event.selectedCohort));
    });

    on<CategoryDialogEvent>((event, emit) async {
     try {
       emit(state.copyWith(isLoading: true));
        var data = event.data;
        var expenseCategories = await getIt<CommonService>().getExpenseCategories();
        var categoryList = expenseCategories;
        var selectedCategory = categoryList.where(
              (element) => element['id'].toString() ==
                  data?['category_id'].toString(),).firstOrNull ?? {};
        List<dynamic> subCategories = selectedCategory['sub_categories'] ?? [];
        var selectedSubCategory = subCategories.where((element) =>
          element['id'].toString() == data?['subcategory_id'].toString(),
          ).firstOrNull ?? {};

        emit(state.copyWith(
          isLoading: false,
          categories: categoryList,
          selectedCategory: selectedCategory,
          selectedSubCategory: selectedSubCategory,
          subCategories: subCategories,
          pop:false,
          categoriesPop: false,
        ));
      }catch(e){
       log("$e", name: "Error In CategoryDialogEvent");
     }
    });

    on<CohortDialogEvent>((event, emit) {
      var data = event.data;
      log(data.toString(), name: 'data');
      List<dynamic> cohort = data['cohortList'] ?? [];
      var selectedCohort = cohort.where((element) =>
      element['id'].toString() == data['expense_to'].toString(),).firstOrNull ?? {};
      emit(state.copyWith(cohorts: cohort, selectedCohorts: selectedCohort));
    });

    on<UpdateDateRangeEvent>((event, emit) {
      emit(state.copyWith(selectedDateRange: event.selectedRange));
    });

    on<ApprovedExpenseEvent>((event, emit) {
      List<dynamic> filteredResponse =
          filterApprovedResponse(state.apiResponse, event.isApproved);
      approvedAmount = 0;
      unApprovedAmount = 0;

      if (event.isApproved == true) {
        approvedAmount = filteredResponse
            .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
            .sum;
      }
      if (event.isApproved == false) {
        unApprovedAmount = filteredResponse
            .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
            .sum;
      }

      emit(state.copyWith(
        isExpenseApproved: event.isApproved,
        filteredResponse: filteredResponse,
        approvedAmount: approvedAmount,
        unApprovedAmount: unApprovedAmount,
      ));
    });

    on<UpdateCategoryEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        await apiRepository.expenseAddOrUpdateApi(
            expenseId: "${event.expenseData?['id']}",
            body: _updateCategorys(event.expenseData));
        emit(state.copyWith(isLoading: false, categoriesPop: true));
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<UpdateCohortEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        await apiRepository.expenseAddOrUpdateApi(
            expenseId: "${event.expenseData?['id']}",
            body: _updateCategorys(event.expenseData));
        emit(state.copyWith(isLoading: false, categoriesPop: true));
        add(RefreshEvent());
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<SaveSubcategory>((event, emit) async {
      if (formKey.currentState?.validate() == false) return emit(state.copyWith());
      try {
        emit(state.copyWith(isLoading: true));
        await apiRepository.createSubCategory(
          name: event.name,
          expenseTo: event.expenseToId,
          parentId: event.categoryId,
        );
        var response = await getIt<CommonService>().getExpenseCategories(reset: true);
        var expenseCategories = response;
        var categoryList = expenseCategories;
        emit(state.copyWith(
          isLoading: false,
          pop: true,
          categories: categoryList,
        ));
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<GetSubCategoryExpenseTo>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        var response = await _getSubCategoryExpenseTo();
        var apiResponse = response?['expenseTo'];
        emit(state.copyWith(expenseTo: apiResponse, isLoading: false));
      }catch(e){
        log("$e", name: "Error In GetSubCategoryExpenseTo");
        emit(state.copyWith(isLoading: false));
      }
    });

  }

  void _registerBroadcast() {
    _broadcast.register("expense_vehicle_refresh", (value, callback) {
      Console.of.log("expense_vehicle_refresh");
      add(RefreshEvent());
    });

    getIt<CommonService>().branchUpdate(callback: () => add(RefreshEvent()));
    Console.of.log("Broadcast Registered");
  }

  Map<String, String> _updateCategorys(dynamic expense) {
    Map<String, String> baseBody = {};
    baseBody['approved'] ="${expense['approved']}";
    baseBody['category_id'] = "${state.selectedCategory?['id'] ?? expense['category_id']??''}";
    baseBody['cohort_id'] = "${expense["cohort_id"] ?? ''}";
    baseBody['employee_id'] = resourceId ?? '';
    baseBody['expense_amount'] = '${expense['expense_amount']??''}';
    baseBody['expense_date'] = '${expense['expense_date']??''}';
    baseBody['expense_description'] = '${expense['expense_description']??''}';
    baseBody['expense_to'] = "${state.selectedCohorts?['id'] ??expense['expense_to'] ?? ''}";
    baseBody['odometer'] = "${expense['odometer'] ?? ''}";
    baseBody['payment_method_id'] = "${expense['payment_method_id'] ?? ''}";
    baseBody['platform'] = "TaskerApp";
    baseBody['subcategory_id'] = "${state.selectedSubCategory?['id'] ?? expense['subcategory_id'] ?? ''}";
    baseBody['vin'] = "${expense['vin'] ?? ''}";
    log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
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

  List<Map<String, dynamic>> calculateApprovedAmounts(
      List<Map<String, dynamic>> apiResponse,
      List<Map<String, dynamic>> amountResponse) {
    return apiResponse.map((e) {
      var matchingAmounts = amountResponse
          .where((element) => element['vin'] == e['vin'] && element['approved'] == 1)
          .map((item) => num.tryParse(item['expense_amount'].toString()) ?? 0).sum;
      e["approved_amount"] = matchingAmounts;
      return e;
    }).toList();
  }

  List<Map<String, dynamic>> employeeNames(
      List<Map<String, dynamic>> apiResponse,
      List<Map<String, dynamic>> usersList
      ) {
    return  apiResponse = apiResponse.map((e) {
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
    }).toList();
  }

  List<Map<String, dynamic>> cohortList(List<Map<String, dynamic>> apiResponse,){
    return apiResponse = apiResponse
        .map((item) => item
      ..['cohortList'] = [
        {"id": "1", "name": "FairPy"},
        {"id": "4", "name": "${item['cohort']?['cohort'] ?? ''}"}
      ])
        .toList();
  }

  void _resetAll() async {
    try {
      if(!isClosed) emit(state.copyWith(isLoading: true));
      var startDate = DateTime.now()
          .subtract(const Duration(days: 31))
          .toFormat(format: 'yyyy-MM-dd');
      var endDate = DateTime.now().toFormat(format: 'yyyy-MM-dd');
      var expenseAmountResponse = await _getExpense(startDate, endDate);
      var response = await _getExpense(minDate, maxDate);
      // var local = await _getExpenseLocal(minDate: minDate, maxDate: maxDate);
      // Console.of.log(jsonEncode(local));
      var usersList = await getIt<CommonService>().getUsers();
      var categories = await getIt<CommonService>().getExpenseCategories();
      var apiResponse = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      var amountResponse = List<Map<String, dynamic>>.from(expenseAmountResponse?['data']);
      apiResponse.removeWhere((element) => element['vehicle'].toString().isNullOrEmpty);
      amountResponse.removeWhere((element) => element['vehicle'].toString().isNullOrEmpty);
      apiResponse.removeWhere((element) => element['vehicle']?['branch_code'] != Session.of.getInt(Str.branchIdPrefText));
      amountResponse.removeWhere((element) => element['vehicle']?['branch_code'] != Session.of.getInt(Str.branchIdPrefText));
      apiResponse = calculateApprovedAmounts(apiResponse, amountResponse);
      apiResponse = employeeNames(apiResponse, usersList);
      apiResponse = cohortList(apiResponse);
      apiResponse.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
          .compareTo(DateTime.parse(a['created_at'] ?? '')));
      List<dynamic> filteredResponse =
      filterApprovedResponse(apiResponse, state.isExpenseApproved);
      if (state.isExpenseApproved) {
        approvedAmount = filteredResponse
            .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
            .sum;
      }
      if (!state.isExpenseApproved) {
        unApprovedAmount = filteredResponse
            .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
            .sum;
      }
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          apiResponse: apiResponse,
          filteredResponse: filteredResponse,
          categories: categories,
          approvedAmount: approvedAmount,
          unApprovedAmount: unApprovedAmount,
        ));
      } else {
        state.copyWith(
          isLoading: false,
          apiResponse: apiResponse,
          filteredResponse: filteredResponse,
          categories: categories,
          approvedAmount: approvedAmount,
          unApprovedAmount: unApprovedAmount,
        );
      }
    } catch (e) {
      log("$e", name: "Error In Bloc Value");
     if (!isClosed) emit(state.copyWith(isLoading: false));
    }
  }

}
