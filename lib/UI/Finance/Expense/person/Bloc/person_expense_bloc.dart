import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Response/expense_response.dart';
import 'package:fairpytasker/UI/Finance/Expense/Person/Bloc/person_expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Person/Bloc/persion_expense_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';


class PersonExpenseBloc extends Bloc<PersonExpenseEvent, PersonExpenseState> {
  final APiRepository apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;

  dynamic selectedCategory;
  dynamic selectedSubCategory;
  List<dynamic>? subCategories = [
    {'id': 100, 'name': 'Payroll Part Time'}
  ];
  List<Map<String, dynamic>>? categories = [
    {'id': 76, 'name': 'Admin'}
  ];
  List<dynamic>? cohorts = [
    {'id': 1, 'name': 'FairPy'},
    {'id': 2, 'name': 'Cohort'}
  ];
  List<dynamic>? approved = [
    {'id': 1, 'name': 'Yes'},
    {'id': 0, 'name': 'No'}
  ];
  dynamic selectedApproved;
  dynamic selectedPaymentId;
  List<dynamic>? attachments = [];
  List<dynamic>? ogAttachments = [];
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  dynamic selectedCohorts;
  String? minDate;
  String? maxDate;
  List<dynamic>? employeeList;
  dynamic selectedEmployee;
  DateTime now = DateTime.now();
  dynamic userId;
  dynamic approvedAmount = 0.0;
  final TextEditingController percentageOrAmountController =
      TextEditingController();
  bool taxIsTapped = false;
  List<Map<String, dynamic>> selectedParts = [];
  List<Map<String, dynamic>> selectedSupplies = [];
  String? resourceId;
  List<dynamic> splitSupplies = [];
  List<dynamic> splitParts = [];
  String? _initialRun;
  int pageId = 1;
  final FBroadcast _broadcast = FBroadcast.instance();

  PersonExpenseBloc()
      : super(PersonExpenseState(
          apiResponse: const [],
          filteredResponse: const [],
          expenseAttachments: const [],
          editResponse: const {},
          isLoading: false,
          selectedCategory: null,
          selectedSubCategory: null,
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
          selectedPerson: null,
          approved: const [],
          selectedApproved: null,
          personExpenseHistory: const [],
          totalAmount: 0.0,
          popEditPage: false,
          popAddPage: false,
        )) {
    Console.of.debug("$_initialRun", name: "PERSON_BLOC");
    _initialRun ??= "TEST-${m.Random().nextInt(9999)}";
    Console.of.debug("$_initialRun", name: "PERSON_BLOC");
    Utils.getStringPreference(Str.userIdPrefText).then((id) {
      resourceId = id;
    });
    _registerBroadcast();

    on<GetPersonExpenseData>((event, emit) async {
      try {
        // emit(state.copyWith(isLoading: true));
        pageId = event.pageId;
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
        var expenseAmountResponse = await _getPersonExpense(startDate, endDate);
        var response = await _getPersonExpense(minDate, maxDate);
        var apiResponse = response?.data;
        var amountResponse = expenseAmountResponse?.data;
        apiResponse = calculateApprovedAmounts(apiResponse ?? [], amountResponse ?? []);
        emit(state.copyWith(
          isLoading: false,
          apiResponse: apiResponse,
        ));*/
      } catch (e) {
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<GetPersonExpenseAddData>((event, emit) async {
      try {
        pageId = 2;
        emit(state.copyWith(isLoading: true));
        var employeeResponse = await _getEmployeeList();
        var paymentType = await _getPaymentType();
        employeeList = employeeResponse?['data'];
        // employeeList
        //     ?.removeWhere((element) => element['user_id'].toString() == '1');

        emit(state.copyWith(
          isLoading: false,
          persons: employeeList,
          paymentType: paymentType,
          approved: approved,
          categories: categories,
          popAddPage: false,
        ));
      } catch (e) {
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<GetPersonExpenseEditData>((event, emit) async {
      try {
        pageId = 3;
        emit(state.copyWith(isLoading: true));
        var response = await _editPersonExpense(event.id);
        var employeeResponse = await _getEmployeeList();
        var paymentType = await _getPaymentType();
        employeeList = employeeResponse?['data'];
        // employeeList
        //     ?.removeWhere((element) => element['user_id'].toString() == '1');
        descriptionController.text = response?['expense_description'] ?? '';

        amountController.text = "${response?['expense_amount'] ?? ''}";
        dateController.text = response?['expense_date'] ?? '';
        selectedCategory = categories?.firstWhereOrNull((category) =>
            category['id'].toString() == response?['category_id'].toString());
        selectedSubCategory = subCategories?.firstWhereOrNull((subCategory) =>
            subCategory['id'].toString() ==
            response?['subcategory_id'].toString());
        selectedPaymentId = paymentType?.firstWhereOrNull(
            (e) => e['id'] == response?['payment_method_id']);
        selectedApproved =
            approved?.firstWhereOrNull((e) => e['id'] == response?['approved']);
        ogAttachments = response?['attachments'];
        attachments?.clear();
        attachments?.addAll(ogAttachments
                ?.map((e) => e['path'].toString().toStorageURL)
                .toList() ??
            []);
        selectedCohorts = cohorts
            ?.firstWhereOrNull((e) => e['id'] == response?['expense_to']);
        selectedEmployee = employeeList?.firstWhereOrNull(
            (e) => e['id'].toString() == response?['employee_id'].toString());

        emit(state.copyWith(
          isLoading: false,
          persons: employeeList,
          paymentType: paymentType,
          approved: approved,
          categories: categories,
          subCategories: subCategories,
          cohorts: cohorts,
          selectedDate: response?['expense_date']
              .toString()
              .toDateTime(inputFormat: 'yyyy-MM-dd'),
          selectedCategory: selectedCategory,
          selectedSubCategory: selectedSubCategory,
          selectedPaymentType: selectedPaymentId,
          selectedApproved: selectedApproved,
          expenseAttachments: attachments,
          selectedPerson: selectedEmployee,
          selectedCohorts: selectedCohorts,
          popEditPage: false,
          popAddPage: false,
        ));
      } catch (e) {
        log("$e", name: "Error In Bloc Value");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<ChangeDateRangeEvent>((event, emit) {
      emit(state.copyWith(selectedDateRange: event.selectedRange));
    });



    on<PersonDropDownEvent>((event, emit) {
      emit(state.copyWith(selectedPerson: event.selectedPerson));
    });

    on<DateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedDate: event.selectedDate)));

    on<CategoryDropDownEvent>((event, emit) {
      if (event.selectedCategory != null) {
        emit(state.copyWith(
          selectedCategory: event.selectedCategory,
          subCategories: subCategories,
          selectedSubCategory: {},
          selectedCohorts: {},
        ));
      }
    });

    on<SubCategoryDropDownEvent>((event, emit) {
      if (event.selectedSubCategory != null) {
        emit(state.copyWith(
          selectedSubCategory: event.selectedSubCategory,
          cohorts: cohorts,
          selectedCohorts: cohorts?[0],
        ));
      }
    });

    on<CohortDropDownEvent>((event, emit) {
      emit(state.copyWith(selectedCohorts: event.selectedCohort));
    });

    on<PaymentDropDownEvent>((event, emit) {
      emit(state.copyWith(selectedPaymentType: event.paymentType));
    });

    on<ApprovedDropDownEvent>((event, emit) {
      emit(state.copyWith(selectedApproved: event.selectedApproved));
    });

    on<ApproveEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        var model = event.model;
        var existResponse = state.apiResponse.map((e) {
          if (e['id'] == model['id']) {
            return e
              ..['approved'] = (int.tryParse(event.approved.toString()) ?? 0);
          } else {
            return e;
          }
        }).toList();
        await apiRepository.approvePersonExpense(
            id: event.model['id'].toString(), approved: event.approved);
        //emit(state.copyWith(isLoading: false));
        //_resetAll();
        var totalAmount = existResponse.where((e) => (e['approved'] == 1),).map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;

        emit(state.copyWith(
          isLoading: false,
          apiResponse: existResponse,
          approvedAmount: totalAmount,
        ));
      } catch (e) {
        log("$e", name: "Error In ApproveEvent");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<DeletePersonExpenseEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
       var response = await apiRepository.deletePersonExpense(event.id);
       if(response?['message'] != null) {
         if (event.isEditPage == false) {
         List<dynamic> existResponse = state.apiResponse;
             existResponse.removeWhere((element) => element['id'].toString() == event.id.toString());
         emit(state.copyWith(
           isLoading: false,
           apiResponse: existResponse,
         ));
         }
         else {
           _broadcast.broadcast("expense_person_refresh");
           Toaster.showSuccess(response?['message']);
           emit(state.copyWith(popEditPage: true));
         }
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        log("$e", name: "Error In DeleteExpenseEvent");
      }
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

    on<RefreshEvent>((event, emit) async {
      _resetAll();
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
        await apiRepository.deletePersonExpenseImage(attachmentId);
        emit(state.copyWith(isLoading: false));
        // once success remove from attachments
        attachments?.remove(event.data);
      }
      emit(state.copyWith(expenseAttachments: attachments));
    });


    on<SavePersonExpenseEvent>((event, emit) async {
      autoValidateMode = AutovalidateMode.onUserInteraction;
      if (formKey.currentState?.validate() == false) return emit(state.copyWith());
      try {
        autoValidateMode = null;
        emit(state.copyWith(isLoading: true));
        Console.of.log("Entered");
        var response = await apiRepository.personExpenseAddOrUpdateApi(
         images: state.expenseAttachments.whereType<File>().toList(),
          body: _savePersonExpense(),
          expenseId: event.id,
        );
        if (response?.isNotEmpty ?? false) {
          Toaster.showSuccess(response?['message'] ?? "Success");
        }
        Console.of.log("Exited", name: "PersonExpenseBloc");
        emit(state.copyWith(isLoading: false, popAddPage: true, popEditPage: true));
        _broadcast.broadcast("expense_person_refresh");
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<GetPersonExpenseHistory>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        var startDate = DateTime.now()
            .subtract(const Duration(days: 31))
            .toFormat(format: 'yyyy-MM-dd');
        var endDate = DateTime.now().toFormat(format: 'yyyy-MM-dd');
        var response = await apiRepository.getPersonExpenseHistory(
            minDate: startDate, maxDate: endDate);
        var apiResponse = response?.data;
        var singlePersonExpense = apiResponse?.where(
                (element) => element['employee_id'].toString()==event.userId && element['approved']==1).toList();
        dynamic total = 0.0;
        total = (apiResponse?.where((element) => element['employee_id'].toString()==event.userId)
            .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum ?? 0.0);

        emit(state.copyWith(
            isLoading: false,
          personExpenseHistory: singlePersonExpense,
          totalAmount: double.tryParse(total.toStringAsFixed(2)) ?? 0.0,

        ));
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

  }

  Map<String, String> _savePersonExpense() {
    Map<String, String> baseBody = {};
    baseBody['approved'] = "${state.selectedApproved['id'] ?? ''}";
    baseBody['category_id'] = "${state.selectedCategory?['id'] ??''}";
    baseBody['employee_id'] = "${state.selectedPerson?['id'] ??''}";
    baseBody['expense_amount'] = amountController.text;
    baseBody['expense_date'] =  state.selectedDate.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['expense_description'] = descriptionController.text;
    baseBody['expense_to'] = "${state.selectedCohorts?['id'] ??''}";
    baseBody['payment_method_id'] = "${state.selectedPaymentType['id'] ?? ''}";
    baseBody['platform'] = "TaskerApp";
    baseBody['subcategory_id'] = "${state.selectedSubCategory?['id'] ?? ''}";
    baseBody['is_employee'] = "${1}";
    log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  void _registerBroadcast() {
    _broadcast.register("expense_person_refresh", (value, callback) {
      Console.of.log("expense_person_refresh $_initialRun $isClosed $pageId");
      if (pageId == 1) _resetAll();
    });
  }

  @override
  Future<void> close() {
    Console.of.log("Bloc Closed $pageId, $_initialRun");
    _broadcast.unregister("expense_person_refresh");
    return super.close();
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
      allowedExtensions: ['jpg','jpeg','png','pdf','doc','xls','xlsx','csv',]);
    return result?.paths
            .where((element) => (element?.isNotEmpty ?? false))
            .map((e) => File(e!))
            .toList() ??
        [];
  }

  /// API CALL: Expense Vehicle
  Future<Map<String, dynamic>?> _getPersonExpense(
      String? minDate, String? maxDate) async {
    return await apiRepository.getPersonExpense(
        minDate: minDate, maxDate: maxDate);
  }

  /// API CALL: Employee List
  Future<Map<String, dynamic>?> _getEmployeeList() async {
    return await apiRepository.getEmployeeList();
  }

  /// API CALL: PAYMENT TYPE
  Future<List<Map<String, dynamic>>?> _getPaymentType() async {
    return await getIt<CommonService>().getPaymentTypes();
  }

  /// API CALL: EDIT PERSON EXPENSE
  Future<Map<String, dynamic>?> _editPersonExpense(String? id) async {
    return await apiRepository.getEditPersonExpense(expenseId: id);
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

  List<Map<String, dynamic>> calculateApprovedAmounts(
      List<Map<String, dynamic>> apiResponse,
      List<Map<String, dynamic>> amountResponse) {
    return apiResponse.map((e) {
      var matchingAmounts = amountResponse
          .where((element) =>
              element['employee_id'] == e['employee_id'] &&
              element['approved'] == 1)
          .map((item) => num.tryParse(item['expense_amount'].toString()) ?? 0)
          .sum;
      e["approved_amount"] = matchingAmounts;
      return e;
    }).toList();
  }

  void _resetAll() async {
    try {
      Console.of.debug("Reset");
      if (state.isLoading || isClosed || (pageId != 1)) return;
      Console.of.debug("Running");
      if(!isClosed) emit(state.copyWith(isLoading: true));
      var startDate = DateTime.now()
          .subtract(const Duration(days: 31))
          .toFormat(format: 'yyyy-MM-dd');
      var endDate = DateTime.now().toFormat(format: 'yyyy-MM-dd');
      var expenseAmountResponse = await _getPersonExpense(startDate, endDate);
      var response = await _getPersonExpense(minDate, maxDate);
      var employeeResponse = await _getEmployeeList();
      employeeList = List.from(employeeResponse?['data']);
      List<Map<String, dynamic>> apiResponse = List.from(response?['data'] ?? []);
      List<Map<String, dynamic>> amountResponse = List.from(expenseAmountResponse?['data'] ?? []);
      apiResponse =
          calculateApprovedAmounts(apiResponse, amountResponse ?? []);
      approvedAmount = apiResponse
          .where((element) => element['approved'].toString() == "1")
          .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
          .sum;
      apiResponse.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
          .compareTo(DateTime.parse(a['created_at'] ?? '')));
     if(!isClosed){ emit(state.copyWith(
        isLoading: false,
        apiResponse: apiResponse,
        approvedAmount: approvedAmount,
        persons: employeeList,
       popAddPage: false,
       popEditPage: false,
      ));}
     else{
       emit(state.copyWith(
         isLoading: false,
         apiResponse: apiResponse,
         approvedAmount: approvedAmount,
         persons: employeeList,
         popAddPage: false,
         popEditPage: false,
       ));
      }
    } catch (e) {
      log("$e", name: "Error In Bloc Value");
      if(!isClosed) emit(state.copyWith(isLoading: false));
    }
  }
}


