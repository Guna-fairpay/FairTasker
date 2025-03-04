import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Response/cohorts_response.dart';
import 'package:fairpytasker/Response/expense_summary_response.dart';
import 'package:fairpytasker/Response/payment_response.dart';
import 'package:fairpytasker/Response/task_response.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../event/todo_edit_expense_event.dart';
import '../repository/todo_edit_expense_repository.dart';
import '../state/todo_edit_expense_state.dart';

class TodoEditExpenseBloc extends Bloc<TodoEditExpenseEvent, TodoExpenseState> {
  final TodoEditExpenseRepository todoEditExpenseRepository =
      TodoEditExpenseRepository();
  dynamic expenseId = "";
  List<Map<String, dynamic>>? categories = [];
  List<dynamic>? ogAttachments = [];
  List<dynamic>? attachments = [];
  final TodoListRepo todoListRepo = TodoListRepo();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController partsCostController = TextEditingController();
  final TextEditingController labourCostController = TextEditingController();
  final TextEditingController subTotalController = TextEditingController();
  final TextEditingController saleTaxController = TextEditingController();
  final TextEditingController shippingController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();
  final TextEditingController percentageOrAmountController =
      TextEditingController();
  bool taxIsTapped = false;
  Map<String, dynamic>? invoiceData;
  List<dynamic>? selectedPaymentId;
  String? categoryId;
  String? subcategoryId;
  List<dynamic>? selectedCategory;
  List<dynamic>? selectedSubCategory;
  List<dynamic>? subCategories = [];
  dynamic todoItem;
  List<dynamic>? partsList;
  List<dynamic>? suppliesList;
  dynamic vendor;

  TodoEditExpenseBloc()
      : super(
      const TodoExpenseState(
        taskList: [],
        paymentMethods: [],
        mainCategories: [],
        subCategories: [],
        expenseAttachments: [],
        apiResponse: {},
        isLoading: false,
        selectedPayment: {},
        selectedMainCategory: {},
        selectedSubCategory: {},
        vehicleName: '',
        vehicleList: [],
        selectedVehicle: {},
        partsList: [],
        suppliesList: [],
        vendorList: {},

        )) {
    FBroadcast.instance().register("Parts", (value, callback) {
      partsList?.add(value);
      state.copyWith(partsList: partsList);
    });
    FBroadcast.instance().register("Supplies", (value, callback) {
      suppliesList = value;
    });
    FBroadcast.instance().register("Vendor", (value, callback) {
      vendor = value;
    });

    on<GetTodoExpenseInitialEvent>((event, emit) async {
      todoItem = event.todoItem;
      try {
        emit(state.copyWith(isLoading: true));
        expenseId = event.expenseId;
        var response = await Future.wait([
          _getTaskLists(),
          _getPaymentMethods(),
          _getExpenseCategories(),
          _getExpenseDetails(expenseId)
        ]);
        TaskExpenseResponse? taskExpenseResponse =
            (response[0] is TaskExpenseResponse)
                ? (response[0] as TaskExpenseResponse)
                : null;
        PaymentResponse? paymentResponse = (response[1] is PaymentResponse)
            ? (response[1] as PaymentResponse)
            : null;
        CohortsResponse? cohortsResponse = (response[2] is CohortsResponse)
            ? (response[2] as CohortsResponse)
            : null;
        ExpenseSummaryResponse? expenseDetailResponse =
            (response[3] is ExpenseSummaryResponse)
                ? (response[3] as ExpenseSummaryResponse)
                : null;

        partsCostController.addListener(_updateExpenseTotal);
        labourCostController.addListener(_updateExpenseTotal);
        saleTaxController.addListener(_updateExpenseTotal);
        shippingController.addListener(_updateExpenseTotal);
        percentageOrAmountController.addListener(_updateExpenseTotal);
        totalAmountController.addListener(_updateExpenseTotal);

        ogAttachments = expenseDetailResponse?.expense?['attachments'];
        saleTaxController.text =
            ((double.tryParse(partsCostController.text) ?? 0) +
                    (double.tryParse(labourCostController.text) ?? 0))
                .toString();

        attachments = ogAttachments
                ?.map((e) => e['path'].toString().toStorageURL)
                .toList() ??
            [];
        amountController.text =
            expenseDetailResponse?.expense?['expense_amount'].toString() ?? '';
        descriptionController.text =
            expenseDetailResponse?.expense?['expense_description'] ?? '';

        selectedPaymentId = paymentResponse?.data
            ?.where((e) =>
                e['id'] == expenseDetailResponse?.expense?['payment_method_id'])
            .toList();
        if (selectedPaymentId!.isEmpty) {
          selectedPaymentId = [paymentResponse?.data?.firstOrNull];
        }

        categoryId =
            expenseDetailResponse?.expense?['category_id'].toString() ?? '';
        subcategoryId =
            expenseDetailResponse?.expense?['subcategory_id'].toString() ?? '';

        if (categoryId!.isEmpty) {
          final Map<String, dynamic>? task =
              taskExpenseResponse?.data?.firstWhere(
            (element) =>
                element['id'] == todoItem['identifier_id'] ||
                element['task'] == todoItem['title'],
            orElse: () => {},
          );
          categoryId = task?['category_id'].toString();
          subcategoryId = task?['subcategory_id'].toString();
        }

        categories = cohortsResponse?.expenseData;
        subCategories = cohortsResponse?.expenseData
            ?.where((category) => category['id'].toString() == categoryId)
            .map((category) => category['sub_categories'] ?? [])
            .expand((subcategoryList) => subcategoryList)
            .toList();

        if (categoryId != null) {
          selectedCategory = categories
              ?.where((e) => e['id'].toString() == categoryId)
              .toList();
          selectedSubCategory = subCategories
              ?.where((e) => e['id'].toString() == subcategoryId)
              .toList();
        }

        dynamic vehicle = todoItem['vehicle_name']?? ((List.from(todoItem['vehicles'])).firstOrNull?['vehicle_name']??'');

        dynamic vehicleList = todoItem['vehicles']??[];

         log("${vendor}", name: 'vendor');
         log("$partsList", name: 'partList');
         log("$suppliesList", name: 'suppliesList');

        // log("${categoryId}", name: 'CategoryId');
        // log("${taskExpenseResponse?.data}", name: 'TaskExpenseResponse');
        // log("${subcategoryId}", name: 'SubcategoryId');
        // log("${subCategories}", name: 'SubCategories');
        // log("${selectedSubCategory}", name: 'SelectedSubCategory');

        emit(state.copyWith(
          isLoading: false,
          apiResponse: expenseDetailResponse?.expense,
          taskList: taskExpenseResponse?.data,
          paymentMethods: paymentResponse?.data,
          mainCategories: categories,
          expenseAttachments: attachments ?? [],
          selectedPayment: selectedPaymentId?.firstOrNull,
          selectedMainCategory: selectedCategory?.firstOrNull,
          selectedSubCategory: selectedSubCategory?.firstOrNull,
          subCategories: subCategories ?? [],
          vehicleName: vehicle,
          vehicleList: vehicleList,
          partsList:partsList ?? [],
          suppliesList:suppliesList ?? [],
          vendorList: vendor ?? {},
        ));
      } catch (e) {
        Utils.showMobileToast(e.toString());
        log("${e}", name: 'Error');
        emit(state.copyWith(isLoading: false));
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
        emit(state.copyWith(expenseAttachments: attachments));
      }
    });

    on<RemoveImageEvent>((event, emit) {
      if (event.data == null) return;
      if (event.data is File) {
        // LOCAL SELECTION REMOVE
        attachments?.remove(event.data);
      } else if (event.data is String) {
        // REMOTE SELECTION REMOVE
        var data = attachments?.firstWhereOrNull(
            (element) => element == event.data.toString().removeStorageUrl);
        var attachmentId = ogAttachments
            ?.where((element) => element['path'] == data)
            .map((e) => e['id'])
            .firstOrNull;
        // {API CALL HERE }// PASS INTO API TO DELETE ATTACHMENT
        // once success remove from attachments
        attachments?.remove(event.data);
      }
      emit(state.copyWith(expenseAttachments: attachments));
    });

    on<TaxIconEvent>((event, emit) {
      taxIsTapped = !taxIsTapped;
      emit(state.copyWith());
      _updateExpenseTotal();
    });

    on<InvoiceEvent>((event, emit) async {
      invoiceData = {
        'description': descriptionController.text,
        'part_name': partsCostController.text,
        'amount': totalAmountController.text,
        'odometer': odometerController.text,
        'tax': saleTaxController.text,
        'total': totalAmountController.text,
        'sub_total': subTotalController.text,
        'shipping': shippingController.text,
      };
      emit(state.copyWith());
    });

    on<CaptureImageEvent>((event, emit) async {
      var result = await _pickImages();
      if (result != null) {
        attachments?.add(result);
        emit(state.copyWith(expenseAttachments: attachments));
      }
    });

    on<SelectedVehicleEvent>((event, emit) {
      emit(state.copyWith(vehicleName: event.vehicleName));
    });

    on<TaskListEvent>(
        (event, emit) => emit(state.copyWith(taskList: event.taskList)));

    on<SelectedPaymentEvent>((event, emit) =>
        emit(state.copyWith(selectedPayment: event.paymentType)));

    on<CategoryListEvent>((event, emit) {
      if (event.mainCategory != null) {
        var subCategories = event.mainCategory?['sub_categories'];
        emit(state.copyWith(
            selectedMainCategory: event.mainCategory,
            subCategories: subCategories,
            selectedSubCategory: {}
        )
        );
      }
    });

    on<SubCategoryListEvent>((event, emit) =>
        emit(state.copyWith(selectedSubCategory: event.subCategory)));
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov']);
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

  Future<TaskExpenseResponse?> _getTaskLists() async {
    return await todoListRepo.getTaskExpense();
  }

  Future<PaymentResponse?> _getPaymentMethods() async {
    return await todoListRepo.getPayment();
  }

  Future<ExpenseSummaryResponse?> _getExpenseDetails(dynamic expenseId) async {
    return await todoEditExpenseRepository.getEditExpenseTodo(expenseId);
  }

  Future<CohortsResponse?> _getExpenseCategories() async {
    return await todoListRepo.getCohorts();
  }

  void _updateExpenseTotal() {
    double partsCost = double.tryParse(partsCostController.text) ?? 0;
    double labourCost = double.tryParse(labourCostController.text) ?? 0;
    double saleTax = double.tryParse(saleTaxController.text) ?? 0;
    double shippingCost = double.tryParse(shippingController.text) ?? 0;
    double percentageOrAmount =
        double.tryParse(percentageOrAmountController.text) ?? 0;
    double subTotal = partsCost + labourCost;
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

  /*@override
  Future<void> close() {
    partsCostController.dispose();
    labourCostController.dispose();
    subTotalController.dispose();
    saleTaxController.dispose();
    shippingController.dispose();
    totalAmountController.dispose();
    descriptionController.dispose();
    odometerController.dispose();
    percentageOrAmountController.dispose();
    return super.close();
  }*/
}
