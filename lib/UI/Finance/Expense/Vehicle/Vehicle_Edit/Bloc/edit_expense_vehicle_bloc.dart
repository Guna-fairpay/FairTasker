
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Edit/Bloc/edit_expense_vehicle_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Edit/Bloc/edit_expense_vehicle_state.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditExpenseVehicleBloc extends Bloc<EditExpenseVehicleEvent, EditExpenseVehicleState> {
  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;

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
  dynamic model;

  int? get _branch =>  getIt<CommonService>().branchId;

  final TextEditingController partsCostController = TextEditingController();
  final TextEditingController labourCostController = TextEditingController();
  final TextEditingController subTotalController = TextEditingController();
  final TextEditingController saleTaxController = TextEditingController();
  final TextEditingController shippingController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController percentageOrAmountController =
  TextEditingController();
  bool taxIsTapped = false;
  List<dynamic>? selectedPaymentId;
  List<dynamic>? selectedCategory;
  List<dynamic>? selectedSubCategory;
  List<Map<String, dynamic>> selectedParts = [];
  List<Map<String, dynamic>> selectedSupplies = [];
  List<dynamic> splitSupplies = [];
  List<dynamic> splitParts = [];
  List<Map<String, dynamic>>? expenseCategories =[];
  String? categoryId;
  String? subcategoryId;
  List<dynamic>? subCategories = [];
  List<Map<String, dynamic>>? categories = [];
  dynamic userId;
  List<dynamic>? usersName = [];
  List<dynamic> vinList = [];
  List<String> vehicleNameList = [];
  List<dynamic> partsList = [];
  List<dynamic> suppliesList = [];

  List<Map<String, dynamic>>? usersList;
  List<Map<String, dynamic>>? groupPerson;
  List<Map<String, dynamic>>? parts;
  List<Map<String, dynamic>>? supplies;


  EditExpenseVehicleBloc() : super(
      EditExpenseVehicleState(
        expenseAttachments: const [],
        isLoading: true,
        selectedCategory: null,
        selectedSubCategory: null,
        categories: const [],
        subCategories: const [],
        cohorts: const [],
        selectedCohorts: null,
        vehicleList: const [],
        selectedVehicle: const {},
        paymentType: const [],
        selectedPaymentType: const {},
        selectedDate: DateTime.now(),
        popEditPage: false,
        userNames: const [],
        todoVehicles: const [],
        partsList: const [],
        suppliesList: const [],
        splitExpense: const [],
        categoryName: '',
        subCategoryName: '',
        editResponse: const {},
        todoDetails: const {},
      ))
  {


    on<GetVehicleExpenseEditData>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        var response = await _getEditVehicleExpenseDetails(event.id);
        var vehicleList = await _getVehicleList();
        var paymentType = await _getPaymentType();
        var categoryList = await getIt<CommonService>().getExpenseCategories();
        var todoDetails = await _getTodoDetails(event.id);
        if(todoDetails != null){
          usersList = await getIt<CommonService>().getUsers();
          groupPerson = await _getGroupPerson();
          parts = await _getPartList();
          supplies = await _getSuppliesList();
        }

        var apiResponse = response?['expenses'];

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
        vehicleList?.removeWhere((element) => element['branch_code'] != _branch,);
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
                for (var element in partsList) {
                  if (element['id'] == expense['parts_id']) {
                    element['controller'].text = expense['amount'].toString();
                  }
                }
                _updateExpenseTotal();
              }
              if (expense['supplies_id'] != null) {
                for (var element in suppliesList) {
                  if (element['id'] == expense['supplies_id']) {
                    element['controller'].text = expense['amount'].toString();
                  }
                  _updateExpenseTotal();
                }
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
          editResponse: apiResponse,
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
          popEditPage: false,
        ));
      } catch (e) {
        log("$e", name: "Error In Expense Edit Bloc Value");
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

    on<DeleteExpenseEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        await _apiRepository.deleteExpenseTodo(event.id);
        await _apiRepository.deleteVehicleExpense(event.id);
        emit(state.copyWith(popEditPage: true));
        _broadcast.broadcast("expense_vehicle_refresh", value: true);
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        log("$e", name: "Error In DeleteExpenseEvent");
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
        await _apiRepository.deleteVehicleExpenseImage(attachmentId);
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

    on<UpdateExpenseEvent>((event, emit) async {
      autoValidateMode = AutovalidateMode.onUserInteraction;
      if (formKey.currentState?.validate() == false) return emit(state.copyWith());
      try {
        autoValidateMode = null;
        if(state.selectedVehicle.isEmpty) return Toaster.showError("Please select vehicle");
        if(amountController.text.isEmpty) return Toaster.showError("Please enter amount");
        if(state.selectedCategory.isEmpty) return Toaster.showError("Please select category");
        if(state.subCategories.isNotEmpty && state.selectedSubCategory.isEmpty) return Toaster.showError("Please select subCategory");
        if(state.selectedCohorts.isEmpty) return Toaster.showError("Please select subCategory");
        emit(state.copyWith(isLoading: true));
        var response = await _apiRepository.expenseAddOrUpdateApi(
            expenseId: "${state.editResponse?['id']}",
            images: state.expenseAttachments.whereType<File>().toList(),
            body: _updateExpenseData());
        if (response?.isNotEmpty ?? false) {
          Toaster.showSuccess(response?['message'] ?? "Success");
          emit(state.copyWith(popEditPage: true));
          _broadcast.broadcast("expense_vehicle_refresh", value: true);
        }
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
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
    baseBody['sales_tax'] = saleTaxController.text;
    baseBody['shipping_and_handling'] = shippingController.text;
    baseBody['sales_tax_type'] = taxIsTapped ? '\$' : '%';
    baseBody['sales_tax_percentage'] = taxIsTapped ? '' : percentageOrAmountController.text;
    baseBody['expense_amount'] = expenseAmount;
    baseBody['payment_method_id'] = "${state.selectedPaymentType?['id'] ?? ''}";
    baseBody['category_id'] = "${state.selectedCategory?['id'] ?? ''}";
    baseBody['subcategory_id'] = "${state.selectedSubCategory?['id'] ?? ''}";
    baseBody['employee_id'] = "${state.editResponse?['employee_id'] ?? ''}";
    baseBody['cohort_id'] = "${state.selectedVehicle["cohort_id"] ?? ''}";
    baseBody['vin'] = "${state.selectedVehicle['vin'] ?? ''}";
    baseBody['expense_date'] = state.selectedDate.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['expense_description'] = descriptionController.text;
    baseBody['expense_to'] = "${state.selectedCohorts?['id'] ?? ''}";
    if (odometerController.text.isNotEmpty && ((double.tryParse(odometerController.text) ?? 0) > 0)) baseBody['odometer'] = odometerController.text;
    baseBody['platform'] = "TaskerApp";
    baseBody['approved'] = "${state.editResponse?['approved'] ?? ''}";
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

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'xls', 'xlsx',]);
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

  /// API CALL: EDIT EXPENSE DETAILS
  Future<Map<String, dynamic>?> _getEditVehicleExpenseDetails(dynamic expenseId) async {
    return await _apiRepository.getEditVehicleExpense(id: expenseId);
  }

  /// API CALL: TODO DETAILS
  Future<Map<String, dynamic>?> _getTodoDetails(dynamic expenseId) async {
    return await _apiRepository.getTodoDetails(expenseId: expenseId);
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


  void calculateTotal() {
    _updateExpenseTotal();
  }

  void  _updateExpenseTotal() {
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

  List<String> getUserInitials(
      dynamic userIds, List<Map<String, dynamic>>? users) {
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
    return (users ?? [])
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


}
