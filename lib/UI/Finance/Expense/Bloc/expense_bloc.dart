
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Response/cohorts_response.dart';
import 'package:fairpytasker/Response/subcategories_response.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/State/expense_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
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
  List<Map<String, dynamic>>? expenseCategories =[];
  List <dynamic> apiResponse =[];
  final FBroadcast _broadcast = FBroadcast.instance();

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
    _registerBroadcast();
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

        _resetAll();

       /*var startDate = DateTime.now()
            .subtract(const Duration(days: 31))
            .toFormat(format: 'yyyy-MM-dd');
       var endDate = DateTime.now().toFormat(format: 'yyyy-MM-dd');

        var expenseAmountResponse = await _getExpense(startDate, endDate);
        var response = await _getExpense(minDate, maxDate);
        var usersList = await getIt<CommonService>().getUsers();
        var expenseCategories = await _getExpenseCategories();

        ExpenseResponse? expenseResponse = response;
        ExpenseResponse? expenseAmount = expenseAmountResponse;

        var apiResponse = expenseResponse?.data;
        var amountResponse = expenseAmount?.data;

        apiResponse = calculateApprovedAmounts(apiResponse ?? [], amountResponse ?? []);

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

        emit(state.copyWith(
          isLoading: false,
          apiResponse: apiResponse,
          filteredResponse: filteredResponse,
          categories: expenseCategories,
          approvedAmount: approvedAmount,
          unApprovedAmount: unApprovedAmount,
        ));*/
      } catch (e) {
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<RefreshEvent>((event, emit) async {
      _resetAll();
    });

    // on<GetVehicleExpenseAddData>((event, emit) async {
    //   try {
    //     emit(state.copyWith(isLoading: true));
    //     var vehicleList = await _getVehicleList();
    //     var paymentType = await _getPaymentType();
    //     var categories = await getIt<CommonService>().getExpenseCategories();
    //     log(categories.toString(), name: 'categories');
    //
    //     emit(state.copyWith(
    //       isLoading: false,
    //       vehicleList: vehicleList,
    //       paymentType: paymentType,
    //       categories: categories,
    //       cohorts: AddToDoConfig.expenseTo,
    //       popAddPagePop: false,
    //     ));
    //   } catch (e) {
    //     log("$e", name: "Error In Bloc Value");
    //     emit(state.copyWith(isLoading: false));
    //   }
    // });

    on<GetVehicleExpenseEditData>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        var response = await _getEditVehicleExpenseDetails(event.id);
        var vehicleList = await _getVehicleList();
        var paymentType = await _getPaymentType();
        var categoryList = await getIt<CommonService>().getExpenseCategories();
        var todoDetails = await _getTodoDetails(event.id);
        var usersList = await getIt<CommonService>().getUsers();
        var groupPerson = await _getGroupPerson();
        var parts = await _getPartList();
        var supplies = await _getSuppliesList();

        var apiResponse = response?.expenses;

        partsCostController.addListener(_updateExpenseTotal);
        labourCostController.addListener(_updateExpenseTotal);
        saleTaxController.addListener(_updateExpenseTotal);
        shippingController.addListener(_updateExpenseTotal);
        percentageOrAmountController.addListener(_updateExpenseTotal);
        totalAmountController.addListener(_updateExpenseTotal);

        saleTaxController.text =
            ((double.tryParse(partsCostController.text) ?? 0) +
                    (double.tryParse(labourCostController.text) ?? 0))
                .toString();

        categoryId = apiResponse?['category_id'].toString() ?? '';
        subcategoryId = apiResponse?['subcategory_id'].toString() ?? '';

        categories = categoryList;
        subCategories = categories
            ?.where((category) => category['id'].toString() == categoryId)
            .map((category) => category['sub_categories'] ?? [])
            .expand((subcategoryList) => subcategoryList)
            .toList();

        selectedCategory =
            categories?.where((e) => e['id'].toString() == categoryId).toList();
        selectedSubCategory = subCategories
            ?.where((e) => e['id'].toString() == subcategoryId)
            .toList();

        var categoryName = selectedCategory?.firstOrNull?['name'] ?? '';
        var subCategoryName = selectedSubCategory?.firstOrNull?['name'] ?? '';

        selectedPaymentId = paymentType
            ?.where(
              (e) => e['id'] == apiResponse?['payment_method_id'],
            )
            .toList();

        ogAttachments = apiResponse?['attachments'];

        attachments?.clear();
        attachments?.addAll(ogAttachments
                ?.map((e) => e['path'].toString().toStorageURL)
                .toList() ??
            []);

        if (apiResponse?['expense_to'] != null) {
          selectedCohorts = AddToDoConfig.expenseTo
              .where((e) => e['id'] == apiResponse?['expense_to'])
              .toList();
        }

        descriptionController.text = apiResponse?['expense_description'] ?? '';
        amountController.text = "${apiResponse?['expense_amount'] ?? ''}";
        dateController.text = apiResponse?['expense_date'] ?? '';

        selectedVehicle =
            vehicleList?.where((e) => e['vin'] == apiResponse?['vin']).toList();
        vehicleController.text =
            selectedVehicle?.firstOrNull?['vehicle_name'] ?? '';

        if (todoDetails?['user_id'] != null) {
          userId = todoDetails?['user_id'];
        }
        if (todoDetails?['user_group_id'] != null) {
          var user = groupPerson
              ?.where(
                  (element) => element['id'] == todoDetails?['user_group_id'])
              .firstOrNull;
          userId = user?['userId'];
        }
        usersName = getUserInitials(userId, usersList);

        if (todoDetails?['vin'] != null) {
          vinList = [todoDetails?['vin']];
        } else {
          List<dynamic>? vehicles = todoDetails?['vehicles'];
          if (vehicles is List && vehicles.isNotEmpty) {
            vinList = vehicles
                .map((v) => v['vin'])
                .where((vin) => vin != null)
                .toList();
          }
        }
        if (vinList.isNotEmpty) {
          List<Map<String, dynamic>> vehicleNames = vehicleList!
              .where((element) => vinList.contains(element['vin'].toString()))
              .toList();
          vehicleNameList = vehicleNames
              .map((vehicle) => vehicle["vehicle_name"].toString())
              .toList();
        }

        String laborAmount = (apiResponse?['split_expenses'] ?? [])
                .firstWhere(
                  (element) => element['labour'] == 1,
                  orElse: () => null,
                )?['amount']
                ?.toString() ??
            "0";

        labourCostController.text = laborAmount;

        taxIsTapped = apiResponse?['sales_tax_type'] == "\$" ? true : false;

        percentageOrAmountController.text = taxIsTapped
            ? "${apiResponse?['sales_tax'] ?? ''}"
            : "${apiResponse?['sales_tax_percentage'] ?? ''}";

        shippingController.text =
            "${apiResponse?['shipping_and_handling'] ?? ''}";

        List<dynamic> partsIds = apiResponse?['split_expenses']
            .where((e) => e["parts_id"] != null)
            .map((e) => e["parts_id"] as int)
            .toList();

        List<dynamic> suppliesIds = apiResponse?['split_expenses']
            .where((e) => e["supplies_id"] != null)
            .map((e) => e["supplies_id"] as int)
            .toList();

        // List<Map<String, dynamic>> selectedParts=[];
        // List<Map<String, dynamic>> selectedSupplies =[];

        if (partsIds.isNotEmpty) {
          selectedParts = (parts ?? [])
              .where((element) => partsIds.contains(element['id']))
              .toList();
        }

        if (suppliesIds.isNotEmpty) {
          selectedSupplies = (supplies ?? [])
              .where((element) => suppliesIds.contains(element['id']))
              .toList();
        }

        partsList = selectedParts
            .map((e) => e..["controller"] = TextEditingController())
            .toList();

        suppliesList = selectedSupplies
            .map((e) => e..["controller"] = TextEditingController())
            .toList();

        if (apiResponse?['split_expenses'] != null) {
          var splitExpenses = apiResponse?['split_expenses'];
          if (splitExpenses is List) {
            for (var expense in splitExpenses) {
              if (expense['parts_id'] != null) {
                partsList.forEach((element) {
                  if (element['id'] == expense['parts_id']) {
                    element['controller'].text = expense['amount'].toString();
                  }
                });
                _updateExpenseTotal();
              }
              if (expense['supplies_id'] != null) {
                suppliesList.forEach((element) {
                  if (element['id'] == expense['supplies_id']) {
                    element['controller'].text = expense['amount'].toString();
                  }
                  _updateExpenseTotal();
                });
              }
            }
          }
        }

        emit(state.copyWith(
          isLoading: false,
          vehicleList: vehicleList,
          paymentType: paymentType,
          cohorts: AddToDoConfig.expenseTo,
          categories: categories,
          subCategories: subCategories,
          editResponse: response?.expenses,
          expenseAttachments: attachments,
          selectedCategory: selectedCategory?.firstOrNull,
          selectedSubCategory: selectedSubCategory?.firstOrNull,
          selectedPaymentType: selectedPaymentId?.firstOrNull,
          selectedCohorts: selectedCohorts?.firstOrNull,
          selectedDate: apiResponse?['expense_date']
              .toString()
              .toDateTime(inputFormat: 'yyyy-MM-dd'),
          selectedVehicle: selectedVehicle?.firstOrNull,
          todoDetails: todoDetails ?? {},
          userNames: usersName ?? [],
          todoVehicles: vehicleNameList,
          partsList: partsList,
          suppliesList: suppliesList,
          splitExpense: apiResponse?['split_expenses'],
          categoryName: categoryName,
          subCategoryName: subCategoryName,
        ));
      } catch (e) {
        log("$e", name: "Error In Expense Edit Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
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

        _resetAll();

        /*List<dynamic> filteredResponse =
            filterApprovedResponse(existResponse, state.isExpenseApproved);

        approvedAmount = 0;
        unApprovedAmount = 0;

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

        emit(state.copyWith(
          isLoading: false,
          filteredResponse: filteredResponse,
          approvedAmount: approvedAmount,
          unApprovedAmount: unApprovedAmount,
        ));*/
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
        if (event.isEditPage == false) {
          // var existResponse = state.filteredResponse;
          // existResponse.removeWhere((e) => e['id'].toString() == event.id);
          // approvedAmount = 0;
          // unApprovedAmount = 0;
          // if (state.isExpenseApproved) {
          //   approvedAmount = existResponse
          //       .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
          //       .sum;
          // }
          // if (!state.isExpenseApproved) {
          //   unApprovedAmount = existResponse
          //       .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
          //       .sum;
          // }
          //
          // emit(state.copyWith(
          //   isLoading: false,
          //   filteredResponse: existResponse,
          //   approvedAmount: approvedAmount,
          //   unApprovedAmount: unApprovedAmount,
          // ));
          _resetAll();
        } else {
          emit(state.copyWith(isLoading: false));
        }
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

    on<SelectedPaymentEvent>((event, emit) =>
        emit(state.copyWith(selectedPaymentType: event.paymentType)));

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
        var expenseCategories = await _getCategoryData();
        var categoryList = expenseCategories?.expenseData;
        var selectedCategory = categoryList?.where(
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

    on<TaxIconEvent>((event, emit) {
      taxIsTapped = !taxIsTapped;
      emit(state.copyWith());
      _updateExpenseTotal();
    });

    // on<SaveExpenseEvent>((event, emit) async {
    //   try {
    //     emit(state.copyWith(isLoading: true));
    //     log("${state.expenseAttachments.whereType<File>().toList()}",
    //         name: 'EXPENSE_DATA');
    //     var response = await apiRepository.expenseAddOrUpdateApi(
    //         images: state.expenseAttachments.whereType<File>().toList(),
    //         body: _saveExpenseData());
    //     if (response?.isNotEmpty ?? false) {
    //       Toaster.showSuccess(response?['message'] ?? "Success");
    //     }
    //     emit(state.copyWith(isLoading: false,popAddPagePop: true));
    //     if (response?['status'] == 200) emit(state.copyWith());
    //   } catch (e) {
    //     Toaster.showError("$e");
    //     log(e.toString(), name: 'ERROR');
    //     emit(state.copyWith(isLoading: false));
    //   }
    // });

    on<UpdateExpenseEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        log("${state.expenseAttachments.whereType<File>().toList()}",
            name: 'EXPENSE_DATA');
        var response = await apiRepository.expenseAddOrUpdateApi(
            expenseId: "${state.editResponse?['id']}",
            images: state.expenseAttachments.whereType<File>().toList(),
            body: _updateExpenseData());
        if (response?.isNotEmpty ?? false) {
          Toaster.showSuccess(response?['message'] ?? "Success");
        }
        emit(state.copyWith(isLoading: false));
        _broadcast.stickyBroadcast("expense_vehicle_refresh", value: true);
        if (response?['status'] == 200) {
          emit(state.copyWith());
        }
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
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

    on<SaveSubcategory>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        await apiRepository.createSubCategory(
          name: event.name,
          expenseTo: event.expenseToId,
          parentId: event.categoryId,
        );
        var expenseCategories = await _getCategoryData();
        var categoryList = expenseCategories?.expenseData;
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
        var apiResponse = response?.expenseTo;
        emit(state.copyWith(
            expenseTo: apiResponse,
            isLoading: false
        ));
      }catch(e){
        log("$e", name: "Error In GetSubCategoryExpenseTo");
        emit(state.copyWith(isLoading: false));
      }
    });

  }

  void _registerBroadcast() {
    _broadcast.register("expense_vehicle_refresh", (value, callback) {
      Console.of.log("expense_vehicle_refresh");
      _resetAll();
    });
  }

  Map<String, String> _updateExpenseData() {
    dynamic splitLabor = {
      "labour": 1,
      "amount": labourCostController.text,
    };
    splitParts = (partsList)
        .map((e) => {
      "parts_id": "${e['id']}",
      "amount": (e['controller'] as TextEditingController).text
    }).toList();
    splitSupplies = (suppliesList)
        .map((e) => {
      "supplies_id": "${e['id']}",
      "amount": (e['controller'] as TextEditingController).text
    }).toList();

    List<Map<String, dynamic>> splits = [
      ...splitParts,
      ...splitSupplies,
      ...[splitLabor]
    ];
    final expenseAmount = amountController.text.isNotEmpty
        ? amountController.text
        : totalAmountController.text;
    log(expenseAmount, name: "Expense_Amount");
    Map<String, String> baseBody = {};
    baseBody['category_id'] = "${state.selectedCategory?['id'] ?? ''}";
    baseBody['subcategory_id'] = "${state.selectedSubCategory?['id'] ?? ''}";
    baseBody['payment_method_id'] = "${state.selectedPaymentType?['id'] ?? ''}";
    baseBody['expense_to'] =
    "${state.selectedCohorts?['id'] ?? ''}";
    baseBody['expense_amount'] = expenseAmount;
    baseBody['expense_description'] = descriptionController.text;
    baseBody['expense_date'] = state.selectedDate.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['cohort_id'] = "${state.selectedVehicle["cohort_id"] ?? ''}";
    baseBody['vin'] = "${state.vehicleList.firstOrNull?['vin'] ?? ''}";
    if (odometerController.text.isNotEmpty && ((double.tryParse(odometerController.text) ?? 0) > 0)) baseBody['odometer'] = odometerController.text;
    baseBody['platform'] = "TaskerApp";
    baseBody['sales_tax_percentage'] =
    taxIsTapped ? '' : percentageOrAmountController.text;
    baseBody['sales_tax'] = saleTaxController.text;
    baseBody['shipping_and_handling'] = shippingController.text;
    baseBody['sales_tax_type'] = taxIsTapped ? '\$' : '%';
    baseBody['employee_id'] = resourceId ?? '';
    if (splitParts.isNotEmpty || splitSupplies.isNotEmpty) {
      splits.forEachIndexed((index, element) {
        baseBody['split[$index][${element.keys.first}]'] =
            element[element.keys.first].toString();
        baseBody['split[$index][${element.keys.last}]'] =
            element[element.keys.last].toString();
      });
    }
    log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
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
        ((double.tryParse(odometerController.text) ?? 0) > 0))
      baseBody['odometer'] = odometerController.text;
    baseBody['platform'] = "TaskerApp";
    baseBody['employee_id'] = resourceId ?? '';

    log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  Map<String, String> _updateCategorys(dynamic expense) {
    Map<String, String> baseBody = {};
    baseBody['approved'] ='';
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

  /// API CALL: VEHICLES
  Future<List<Map<String, dynamic>>?> _getVehicleList() async {
    return await getIt<CommonService>().getActiveVehicles(reset: true);
  }

  /// API CALL: PAYMENT TYPE
  Future<List<Map<String, dynamic>>?> _getPaymentType() async {
    return await getIt<CommonService>().getPaymentTypes();
  }

  /// API CALL: EDIT EXPENSE DETAILS
  Future<VehicleExpenseHistoryResponse?> _getEditVehicleExpenseDetails(dynamic expenseId) async {
    return await apiRepository.getEditVehicleExpense(id: expenseId);
  }

  /// API CALL: TODO DETAILS
  Future<Map<String, dynamic>?> _getTodoDetails(dynamic expenseId) async {
    return await apiRepository.getTodoDetails(expenseId: expenseId);
  }

  /// API CALL: GROUP PERSON
  Future<List<Map<String, dynamic>>?> _getGroupPerson() async {
    return await getIt<CommonService>().getGroupPersons();
  }

  /// API CALL: PARTS
  Future<List<Map<String, dynamic>>?> _getPartList() async {
    return await getIt<CommonService>().getPartsList();
  }

  /// API CALL: SUPPLIES
  Future<List<Map<String, dynamic>>?> _getSuppliesList() async {
    return await getIt<CommonService>().getSuppliesList();
  }

  /// API CALL: SUB CATEGORY EXPENSE TO
  Future<SubCategoriesResponse?> _getSubCategoryExpenseTo() async {
    return await apiRepository.getExpenseTo();
  }

  /// API CALL: SUB CATEGORY EXPENSE TO
  Future<CohortsResponse?> _getCategoryData() async {
    return await apiRepository.getExpenseCategories();
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

  List<Map<String, dynamic>> calculateApprovedAmounts(
      List<Map<String, dynamic>> apiResponse,
      List<Map<String, dynamic>> amountResponse) {
    return apiResponse.map((e) {
      var matchingAmounts = amountResponse
          .where((element) => element['vin'] == e['vin'] && element['approved'] == 1)
          .map((item) => num.tryParse(item['expense_amount'].toString()) ?? 0).sum;
      // num totalAmount = matchingAmounts.isNotEmpty
      //     ? matchingAmounts.map((item) => num.tryParse(item['expense_amount'].toString()) ?? 0)
      //     .fold(0, (a, b) => a + b)
      //     : 0;
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
        {"id": "4", "name": "${item['cohort']['cohort']}"}
      ])
        .toList();
  }

  void _resetAll() async {
    try {
      if(!isClosed) emit(state.copyWith(isLoading: true));
      Console.of.log("LOADING");
      var startDate = DateTime.now()
          .subtract(const Duration(days: 31))
          .toFormat(format: 'yyyy-MM-dd');
      var endDate = DateTime.now().toFormat(format: 'yyyy-MM-dd');

      var expenseAmountResponse = await _getExpense(startDate, endDate);
      var response = await _getExpense(minDate, maxDate);
      var usersList = await getIt<CommonService>().getUsers();
      var categories = await getIt<CommonService>().getExpenseCategories();
      //var categories = expenseCategories?.expenseData;

      ExpenseResponse? expenseResponse = response;
      ExpenseResponse? expenseAmount = expenseAmountResponse;

      var apiResponse = expenseResponse?.data;
      var amountResponse = expenseAmount?.data;

      apiResponse = calculateApprovedAmounts(apiResponse ?? [], amountResponse ?? []);

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
