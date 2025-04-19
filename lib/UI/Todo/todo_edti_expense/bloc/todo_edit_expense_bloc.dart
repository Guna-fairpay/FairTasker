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
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../Repository/api_repository.dart';
import '../../../../Response/vehicle_list_response.dart';
import '../../../../Utilities/Str.dart';
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
  List<dynamic> partsList = [];
  List<dynamic> suppliesList = [];
  List<dynamic> vendor=[];
  List<dynamic> vinList = [];
  List<dynamic> vehicleList = [];
  List<dynamic> itemList = [];
  List<dynamic> splitSupplies = [];
  List<dynamic> splitParts = [];
  List<dynamic> selectedPart = [];
  List<dynamic> selectedSupplies = [];
  dynamic selectedVendor={};
  String? userId;


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
          odometerMessage: '',
        )) {

    Utils.getStringPreference(Str.userIdPrefText).then((id) {
        userId = id;
    });

    FBroadcast.instance().register("Parts", (value, callback) {
      if (value is List) {
        if (partsList.isEmpty) {
          partsList = List<Map<String, dynamic>>.from(value)
              .map((e) => e..["controller"] = TextEditingController())
              .toList();
        } else {
          List<Map<String, dynamic>>.from(value).forEach((element) {
            if (partsList.map((e) => e['id']).contains(element['id']) ==
                false) {
              partsList.add(element..["controller"] = TextEditingController());
            }
          });
        }
        var currentIds =
            List<Map<String, dynamic>>.from(value).map((e) => e['id']);
        partsList.removeWhere((element) => !currentIds.contains(element['id']));
      }

      _updateExpenseTotal();
      emit(state.copyWith(partsList: partsList));
    });

    FBroadcast.instance().register("Supplies", (value, callback) {
      if (value is List) {
        if (suppliesList.isEmpty) {
          suppliesList = List<Map<String, dynamic>>.from(value)
              .map((e) => e..["controller"] = TextEditingController()).toList();
        } else {
          List<Map<String, dynamic>>.from(value).forEach((element) {
            if (suppliesList.map((e) => e['id']).contains(element['id']) ==
                false) {
              suppliesList.add(
                  element..["controller"] = TextEditingController());
            }
          });
        }
        var suppliesIds = List<Map<String, dynamic>>.from(value).map((e) =>
            e['id']);
        suppliesList.removeWhere((element) =>
        !suppliesIds.contains(element['id']));
      }
      _updateExpenseTotal();
      emit(state.copyWith(suppliesList: suppliesList));
    });

    FBroadcast.instance().register("Vendor", (value, callback) {
      if (!vendor.contains(value['id'])) {
        vendor.clear();
        vendor.add(value);
      }
      emit(state.copyWith(vendorList: vendor.firstOrNull?['value']??[]));
       log("$vendor", name: 'Vendor1');
    });

    on<GetTodoExpenseInitialEvent>((event, emit) async {

      try {
        emit(state.copyWith(isLoading: true));
        expenseId = event.expenseId;
        todoItem = event.todoItem;
        selectedPart = event.selectedParts;
        selectedSupplies = event.selectedSupplies;
        selectedVendor = event.selectedVendor;

        var response = await apiRepository.getEditVehicleExpense(id:expenseId);

        var expenseDetailResponse = response?.expenses;

        var taskExpenseResponse = await getIt<CommonService>().getTaskExpenseData();

        var paymentResponse = await getIt<CommonService>().getPaymentTypes();

        var cohortsResponse = await getIt<CommonService>().getExpenseCategories();

        var vehicleResponse = await getIt<CommonService>().getActiveVehicles();

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

        ogAttachments = expenseDetailResponse?['attachments'];
        attachments?.clear();

        attachments?.addAll(ogAttachments
            ?.map((e) => e['path'].toString().toStorageURL)
            .toList() ?? []);

        amountController.text =
        "${expenseDetailResponse?['expense_amount'] ?? ''}";
        descriptionController.text = expenseDetailResponse?['expense_description'] ?? '';

        selectedPaymentId = paymentResponse
            .where((e) =>
                e['id'] == expenseDetailResponse?['payment_method_id'])
            .toList();
        if (selectedPaymentId!.isEmpty) {
          selectedPaymentId = [paymentResponse.firstOrNull];
        }

        categoryId = "${expenseDetailResponse?['category_id'] ?? ''}";
        subcategoryId = "${expenseDetailResponse?['subcategory_id']?? ''}";

        if (categoryId!.isEmpty) {
          final Map<String, dynamic> task =
              taskExpenseResponse.firstWhere(
            (element) =>
                element['id'] == todoItem['identifier_id'] ||
                element['task'] == todoItem['title'],
            orElse: () => {},
          );
          categoryId = task['category_id'].toString();
          subcategoryId = task['subcategory_id'].toString();
        }

        categories = cohortsResponse;
        subCategories = cohortsResponse
            .where((category) => category['id'].toString() == categoryId)
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
          vehicleList = vehicleResponse
              .where((element) => vinList.contains(element['vin'].toString()))
              .toList();
        }

        String laborAmount =
            (expenseDetailResponse?['split_expenses'] ?? [])
                    .firstWhere((element) => element['labour'] == 1,
                      orElse: () => null,)?['amount']
                    ?.toString() ?? "";

        labourCostController.text = laborAmount;

        taxIsTapped = expenseDetailResponse?['sales_tax_type'] == "\$"
            ? true
            : false;

        percentageOrAmountController.text = taxIsTapped
            ? "${expenseDetailResponse?['sales_tax']??''}"
            : "${expenseDetailResponse?['sales_tax_percentage'] ?? ''}";

        shippingController.text = "${expenseDetailResponse?['shipping_and_handling'] ?? ''}";

            if (partsList.isEmpty) {
              partsList = selectedPart
                  .map((e) => e..["controller"] = TextEditingController())
                  .toList();
              _updateExpenseTotal();
            } else {
              selectedPart.forEach((element) {
                if (partsList.map((e) => e['id']).contains(element['id']) ==
                    false) {
                  partsList.add(element..["controller"] = TextEditingController());
                }
              });
            }
            var currentIds =
            selectedPart.map((e) => e['id']);
            partsList.removeWhere((element) => !currentIds.contains(element['id']));

            if (suppliesList.isEmpty) {
              suppliesList = selectedSupplies
                  .map((e) => e..["controller"] = TextEditingController())
                  .toList();
            }else{
              selectedSupplies.forEach((element) {
                if (suppliesList.map((e) => e['id']).contains(element['id']) ==
                    false) {
                  suppliesList.add(
                      element..["controller"] = TextEditingController());
                }
              });
            }
            var suppliesIds = selectedSupplies.map((e) => e['id']);
            suppliesList.removeWhere((element) =>
            !suppliesIds.contains(element['id']));

            if(expenseDetailResponse?['split_expenses'] != null){
              var splitExpenses = expenseDetailResponse?['split_expenses'];
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
        if(vendor.isEmpty){
          if (selectedVendor != null && selectedVendor["type"]=="vendor") {
            if (!vendor.contains(selectedVendor['id'])) {
              vendor.clear();
              vendor.add(selectedVendor);
            }
          }
        }

        emit(state.copyWith(
          isLoading: false,
          apiResponse: expenseDetailResponse,
          taskList: taskExpenseResponse,
          paymentMethods: paymentResponse,
          mainCategories: categories,
          expenseAttachments: attachments ?? [],
          selectedPayment: selectedPaymentId?.firstOrNull,
          selectedMainCategory: selectedCategory?.firstOrNull,
          selectedSubCategory: selectedSubCategory?.firstOrNull,
          subCategories: subCategories ?? [],
          vehicleList: vehicleList,
          partsList: partsList,
          suppliesList: suppliesList,
          vendorList: vendor.firstOrNull?['value'] ?? [],
        ));
      } catch (e) {
        Utils.showMobileToast(e.toString());
        log("$e", name: 'Error');
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
        log("$attachments", name: "PickImageEvent");
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
        var data = attachments?.firstWhereOrNull(
                (element) => element == event.data.toString());

        var attachmentId = ogAttachments
            ?.where((element) => element['path'] == data.toString().removeStorageUrl)
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

    on<GetOdometerEvent>((event, emit) async {
      try {
        var response = await apiRepository.getOdometerValue(vin: event.vin);
        if (response?.isNotEmpty ?? false) {
          emit(state.copyWith(odometerMessage: response?['message']));
        }
      }catch(e){
        emit(state.copyWith(odometerMessage: e.toString()));
      }

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
        'title': state.vendorList['name']??'',
        'phone': state.vendorList['phone']??'',
        'address': state.vendorList['address']??'',
        'invoiceId': "INV${todoItem['id']??''}",
        'date': DateTime.now().format('MM-dd-yyyy').toString(),
        'plateNo': state.vehicleList.firstOrNull ? ['vehicle_number'] ??'',
        'vehicleName': state.vehicleList.firstOrNull ? ['vehicle_name'] ??'',
        'sales_tax_percentage': percentageOrAmountController.text,
        'itemList': [
          ...partsList
            ..forEach(
              (e) => (e as Map<String, dynamic>)..putIfAbsent("rate",
                  () => (e['controller'] as TextEditingController).text),
            ),
          ...suppliesList
            ..forEach((e) => (e as Map<String, dynamic>)..putIfAbsent(
                "rate", () => (e['controller'] as TextEditingController).text),),
        ],
      };
      emit(state.copyWith());
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
        log("${_invoiceData()}", name: 'INVOICE_DATA');
        await Permission.storage.request();
        var status = await Permission.manageExternalStorage.status;
        if (status.isGranted) {

          var response =
          await apiRepository.generateInvoice(body: _invoiceData());

          // if (response?.isNotEmpty ?? false)
          // Toaster.showSuccess(response?['message'] ?? "Success");
          if ((response != null) && (response['message'] != null)) {
            emit(state.copyWith(
              expenseAttachments: state.expenseAttachments
                ..add(File(response['message'])),
            ));
          }
          emit(state.copyWith(isLoading: false));
        }
        else if (status.isDenied) {
          await Permission.manageExternalStorage.request();
          emit(state.copyWith(isLoading: false));
        }
        emit(state.copyWith(isLoading: false));

      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<SaveExpenseEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        log("${state.expenseAttachments.whereType<File>().toList()}", name: 'EXPENSE_DATA');
        var response = await apiRepository.updateTodoExpense(
            expenseId: todoItem['expense_id'],
            images: state.expenseAttachments.whereType<File>().toList(),
            body: _expenseData());
        final int? newExpenseId =
            (response?['data'] as List?)?.firstOrNull?['id'];
        if (todoItem['expense_id'] == null && newExpenseId != null) {
          await apiRepository.updateToDoApi(
              images: [],
              body: _expenseData()
                ..putIfAbsent("expense_id", () => (newExpenseId.toString())),
              todoId: "${todoItem['id']}");
        }
        if (response?.isNotEmpty ?? false)
          Toaster.showSuccess(response?['message'] ?? "Success");
        emit(state.copyWith(isLoading: false));
        if (response?['status'] == 200) emit(state.copyWith());
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });
  }

  Map<String, String> _expenseData() {
    dynamic splitLabor = {
      "labour": 1,
      "amount": labourCostController.text,
    };
    splitParts = (partsList)
        .map((e) => {
              "parts_id": "${e['id']}",
              "amount": (e['controller'] as TextEditingController).text
            })
        .toList();
    splitSupplies = (suppliesList)
        .map((e) => {
              "supplies_id": "${e['id']}",
              "amount": (e['controller'] as TextEditingController).text
            })
        .toList();

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
    baseBody['category_name'] = "${state.selectedMainCategory?['name'] ?? ''}";
    baseBody['category_id'] = "${state.selectedMainCategory?['id'] ?? ''}";
    baseBody['subcategory_name'] =
        "${state.selectedSubCategory?['name'] ?? ''}";
    baseBody['subcategory_id'] = "${state.selectedSubCategory?['id'] ?? ''}";
    baseBody['payment_method_id'] = "${state.selectedPayment?['id'] ?? ''}";
    baseBody['expense_to'] =
        "${state.selectedSubCategory?['expense_to'] ?? ''}";
    baseBody['expense_amount'] = expenseAmount;
    baseBody['expense_description'] = descriptionController.text;
    baseBody['expense_date'] = DateTime.now().format('yyyy-MM-dd').toString();
    baseBody['cohort_id'] = "${todoItem["cohort_id"] ?? ''}";
    baseBody['vin'] = "${state.vehicleList.firstOrNull?['vin'] ?? ''}";
    if (odometerController.text.isNotEmpty && ((double.tryParse(odometerController.text) ?? 0) > 0)) baseBody['odometer'] = odometerController.text;
    baseBody['type'] = "inline";
    baseBody['platform'] = "TaskerApp";
    baseBody['sales_tax_percentage'] =
        taxIsTapped ? '' : percentageOrAmountController.text;
    baseBody['sales_tax'] = saleTaxController.text;
    baseBody['shipping_and_handling'] = shippingController.text;
    baseBody['sales_tax_type'] = taxIsTapped ? '\$' : '%';
    baseBody['employee_id'] = userId ?? '';
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

  Map<String, dynamic> _invoiceData() {
    Map<String, dynamic> baseBody = {};
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
        ? []
        : invoiceData?['itemList']?.map((e) => <String, dynamic>{
              "quantity": 1,
              "description": e['name'] ?? "",
              "rate": e['rate'] ?? 0,
              "total": e['rate'] ?? 0,
            }).toList();
    log("${jsonEncode(baseBody)}", name: "Invoice_body");
    return baseBody;
  }

  Future<List<File>> _pickFiles() async {

    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png','pdf']);
       // allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov',]);
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

  /// API CALL: ACTIVE-VEHICLES
  Future<VehicleListResponse?> _getVehicles() async =>
      await todoListRepo.fetchVehicleList();

  void calculateTotal() {
    _updateExpenseTotal();
  }

  void _updateExpenseTotal() {
    if(partsList.isEmpty && suppliesList.isEmpty){
      labourCostController.clear();
      saleTaxController.clear();
      shippingController.clear();
      percentageOrAmountController.clear();
      subTotalController.clear();
      totalAmountController.clear();
    }else{
    double totalSuppliesCost = 0;
    double totalParts = 0;
    totalParts = partsList.map((e) =>
    double.tryParse((e['controller'] as TextEditingController)
        .text.toString()) ?? 0.0).sum;

    totalSuppliesCost = suppliesList.map((e) =>
    double.tryParse((e['controller'] as TextEditingController)
        .text.toString()) ?? 0.0).sum;

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
}
