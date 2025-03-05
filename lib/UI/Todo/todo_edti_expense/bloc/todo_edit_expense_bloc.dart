import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart';
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
import '../../../../Repository/api_repository.dart';
import '../../../../Response/vehicle_list_response.dart';
import '../../../../Response/vendor_response.dart';
import '../../../../core/app/helper/toaster.dart';
import '../event/todo_edit_expense_event.dart';
import '../repository/todo_edit_expense_repository.dart';
import '../state/todo_edit_expense_state.dart';

class TodoEditExpenseBloc extends Bloc<TodoEditExpenseEvent, TodoExpenseState> {
  final APiRepository apiRepository = APiRepository();
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
  List<dynamic>? partsList = [];
  List<dynamic>? suppliesList = [];
  dynamic vendor;
  Map<String, TextEditingController> partsCostControllers = {};
  Map<String, TextEditingController> suppliesCostControllers = {};
  List<dynamic> vinList = [];
  List<dynamic> vehicleList = [];
  List<dynamic> itemList = [];

  TodoEditExpenseBloc()
      : super(const TodoExpenseState(
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
          vehicleList: [],
          selectedVehicle: {},
          partsList: [],
          suppliesList: [],
          vendorList: {},
        )) {
    FBroadcast.instance().register("Parts", (value, callback) {
      if (value is List) {
        partsList = value;
      } else {
        partsList?.add(value);
      }
      partsList?.forEach((element) {
        if (!partsCostControllers.containsKey(element['id'].toString())) {
          partsCostControllers[element['id'].toString()] =
              TextEditingController();
        }
      });
      var partIds = partsList?.map((e) => e['id'].toString());
      partsCostControllers
          .removeWhere((key, value) => (partIds?.contains(key) == false));
      if (partsList?.isEmpty ?? true) partsCostControllers.clear();
      _updateExpenseTotal();
      emit(state.copyWith(partsList: partsList));
    });
    FBroadcast.instance().register("Supplies", (value, callback) {
      if (value is List) {
        suppliesList = value;
      } else {
        suppliesList?.add(value);
      }
      suppliesList?.forEach((element) {
        if (!suppliesCostControllers.containsKey(element['id'].toString())) {
          suppliesCostControllers[element['id'].toString()] =
              TextEditingController();
        }
      });
      var suppliesIds = suppliesList?.map((e) => e['id'].toString());
      suppliesCostControllers
          .removeWhere((key, value) => (suppliesIds?.contains(key) == false));
      if (suppliesList?.isEmpty ?? true) suppliesCostControllers.clear();
      _updateExpenseTotal();
      emit(state.copyWith(suppliesList: suppliesList));
    });
    FBroadcast.instance().register("Vendor", (value, callback) {
      vendor = value;
      // log("${vendor}", name: 'Vendor');
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
          _getExpenseDetails(expenseId),
          _getVendor(),
          _getVehicles(),
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
        VendorResponse? vendorResponse = (response[4] is VendorResponse)
            ? (response[4] as VendorResponse)
            : null;
        VehicleListResponse? vehicleResponse =
            ((response[5] is VehicleListResponse) ? response[5] : null)
                as VehicleListResponse?;

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

        if (todoItem?['vin'] != null) {
          vinList = [todoItem?['vin']];
        } else {
          List<dynamic>? vehicles = todoItem?['vehicles'];
          if (vehicles is List && vehicles.isNotEmpty) {
            vinList = vehicles
                .map((v) => v['vin'])
                .where((vin) => vin != null)
                .toList();
          }
        }
        if (vinList.isNotEmpty) {
          vehicleList = vehicleResponse!.data!
              .where((element) => vinList.contains(element['vin'].toString()))
              .toList();
        }

        List<dynamic>? vendorList = [];

        if (todoItem['vendor_id'] != null) {
          vendorList = vendorResponse?.data
              ?.where(
                (element) =>
                    element['id'].toString() ==
                    todoItem['vendor_id'].toString(),
              )
              .toList();
          // log("${vendorList}", name: 'Vendor1');
        } else if (vendor != null) {
          vendorList = vendorResponse?.data
              ?.where(
                (element) => element['id'].toString() == vendor['id'],
              )
              .toList();
          //  log("${vendorList}", name: 'Vendor2');
        } else {
          vendorList = [];
        }

        List<dynamic>? partsData = [];

        partsData.addAll(partsList ?? []);

        // log("${partsData}", name: 'partsData');
        // log("$partsList", name: 'partList');
        // log("$suppliesList", name: 'suppliesList');

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
          vehicleList: vehicleList,
          partsList: partsList ?? [],
          suppliesList: suppliesList ?? [],
          vendorList: vendorList?.firstOrNull ?? [],
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
        'amount': totalAmountController.text,
        'odometer': odometerController.text,
        'tax': saleTaxController.text,
        'total': totalAmountController.text,
        'sub_total': subTotalController.text,
        'shipping': shippingController.text,
        'title': state.vendorList['name'],
        'phone': state.vendorList['phone'],
        'address': state.vendorList['address'],
        'invoiceId': "INV${todoItem['id']}",
        'date': DateTime.now().format('MM-dd-yyyy').toString(),
        'plateNo': state.vehicleList.firstOrNull['vehicle_number'],
        'vehicleName': state.vehicleList.firstOrNull['vehicle_name'],
        'sales_tax_percentage': percentageOrAmountController.text,
        'itemList': [
          ...?partsList
            ?..forEach((e) => (e as Map<String, dynamic>).putIfAbsent(
                "rate", () => partsCostControllers[e['id'].toString()]?.text)),
        ],
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
      emit(state.copyWith(selectedVehicle: event.selectedVehicle));
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
            selectedSubCategory: {}));
      }
    });

    on<SubCategoryListEvent>((event, emit) =>
        emit(state.copyWith(selectedSubCategory: event.subCategory)));

    on<GenerateInvoiceEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        log(jsonEncode(_invoiceData()), name: 'INVOICE_DATA');
        /*emit(state.copyWith(isLoading: false));
        return;*/
        var response =
            await apiRepository.generateInvoice(body: _invoiceData());

        // if (response?.isNotEmpty ?? false)
          // Toaster.showSuccess(response?['message'] ?? "Success");
        emit(state.copyWith(
            isLoading: false,
            expenseAttachments: state.expenseAttachments..add(File(response?['message'] ?? '')),
        ));

      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });
  }

  Map<String, String> _invoiceData() {
    Map<String, String> baseBody = {};
    baseBody['car_plate'] = invoiceData?['plateNo'] ?? '';
    baseBody['company_address'] = "${invoiceData?['address'] ?? ''}";
    baseBody['company_name'] = invoiceData?['title'] ?? '';
    baseBody['company_phone'] = invoiceData?['phone'] ?? '';
    baseBody['expense_amount'] = invoiceData?['total'] ?? '';
    baseBody['invoice_date'] = invoiceData?['date'] ?? '';
    baseBody['invoice_no'] = invoiceData?['invoiceId'] ?? '';
    baseBody['sales_tax'] = invoiceData?['tax'] ?? '';
    baseBody['sales_tax_percentage'] =
        invoiceData?['sales_tax_percentage'] ?? '';
    baseBody['sales_tax_type'] = taxIsTapped ? '\$' : '%';
    baseBody['shipping_and_handling'] = invoiceData?['shipping'] ?? '';
    baseBody['to_address'] =
        "Hasanath Mohammed,\n FairPY INC, \n 4443 Zahir Ct, \n Irving TX, 75061";
    baseBody['to_phone'] = "5025921994";
    baseBody['items'] = invoiceData?['itemList']?.isEmpty ?? true
        ? ""
        : "${invoiceData?['itemList']
            ?.map((e) => {
              "quantity": "1",
              "description": e['name'] ?? "",
              "rate": e['rate'] ?? "0",
              "total": e['rate'] ?? "0",}).toList()}";
    log(jsonEncode(baseBody), name: "INVOICE_BODY");
    return baseBody;
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

  /// API CALL: TASK LIST
  Future<TaskExpenseResponse?> _getTaskLists() async {
    return await todoListRepo.getTaskExpense();
  }

  /// API CALL: PAYMENT METHODS
  Future<PaymentResponse?> _getPaymentMethods() async {
    return await todoListRepo.getPayment();
  }

  /// API CALL: EXPENSE DETAILS
  Future<ExpenseSummaryResponse?> _getExpenseDetails(dynamic expenseId) async {
    return await todoEditExpenseRepository.getEditExpenseTodo(expenseId);
  }

  /// API CALL: CATEGORIES
  Future<CohortsResponse?> _getExpenseCategories() async {
    return await todoListRepo.getCohorts();
  }

  /// API CALL: VENDOR
  Future<VendorResponse?> _getVendor() async {
    return await todoListRepo.getVendor();
  }

  /// API CALL: ACTIVE-VEHICLES
  Future<VehicleListResponse?> _getVehicles() async =>
      await todoListRepo.fetchVehicleList();

  void calculateTotal() {
    _updateExpenseTotal();
  }

  void _updateExpenseTotal() {
    double totalSuppliesCost = 0;
    double totalParts = 0;
    partsCostControllers.forEach((key, value) {
      if (partsList?.map((e) => e['id'].toString()).contains(key) ?? false) {
        totalParts += double.tryParse(value.text) ?? 0;
      }
    });

    suppliesCostControllers.forEach((key, value) {
      if (suppliesList?.map((e) => e['id'].toString()).contains(key) ?? false) {
        totalSuppliesCost += double.tryParse(value.text) ?? 0;
      }
    });

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
