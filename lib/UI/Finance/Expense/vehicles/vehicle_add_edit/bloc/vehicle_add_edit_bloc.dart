import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/device_info_helper.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

part 'vehicle_add_edit_event.dart';
part 'vehicle_add_edit_state.dart';

class VehicleAddEditBloc extends Bloc<VehicleAddEditEvent, VehicleAddEditState> {

  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FBroadcast _broadcast = FBroadcast.instance();
  DateTime? selectedDate = DateTime.now();
  AutovalidateMode? autoValidateMode;

  TextEditingController vehicleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController partsCostController = TextEditingController();
  TextEditingController labourCostController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController saleTaxController = TextEditingController();
  TextEditingController shippingController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController percentageOrAmountController = TextEditingController();
  TextEditingController odometerController = TextEditingController();

  List<Map<String,dynamic>> vehicleList = [];
  Map<String, dynamic> selectedVehicle = {};

  List<Map<String, dynamic>>? usersList = [];
  List<Map<String, dynamic>> selectedSupplies = [];
  List<Map<String, dynamic>> selectedParts = [];

  List<dynamic> categoryList = [];
  List<dynamic> attachmentList = [];
  List<dynamic> subCategoryList = [];
  List<dynamic> paymentMethod = [];
  List<dynamic> splitExpense = [];
  List<Map<String, dynamic>> partsList = [];
  List<Map<String, dynamic>> suppliesList = [];
  List<dynamic> groupPerson = [];
  List<dynamic>? userNameList;
  List<dynamic> vinList = [];
  List<dynamic> vehicleNameList = [];
  List<dynamic> parts = [];
  List<dynamic> supplies = [];
  List<dynamic> splitSupplies = [];
  List<dynamic> splitParts = [];

  List<dynamic> expenseTo = [
    {"id" : 1, "name" : "FairPy"},
    {"id" : 4, "name" : "Cohort"},
  ];

  dynamic selectedCategory;
  dynamic editModel;
  dynamic selectedSubCategory;
  dynamic selectedExpenseTo;
  dynamic selectedPaymentMethod;
  dynamic todoItems;
  dynamic editResponse;
  dynamic bouncieMessage;
  dynamic categoryName;
  dynamic subCategoryName;
  dynamic addModel;
  dynamic invoiceData;

  bool isEdit = false;
  bool taxIsTapped = false;

  Future<List<Map<String, dynamic>>?> _getVehicleList() async => getIt<CommonService>().getActiveVehicles();
  Future<List<Map<String, dynamic>>?> _getExpenseCategory() async => await getIt<CommonService>().expenseCategory();
  Future<List<Map<String, dynamic>>?> _getPaymentType() async => await getIt<CommonService>().getPaymentTypes();
  Future<List<Map<String, dynamic>>?> _getUsers() async => await getIt<CommonService>().getUsers();
  Future<List<Map<String, dynamic>>?> _getGroupUsers() async => await getIt<CommonService>().getGroupPersons();
  Future<List<Map<String, dynamic>>?> _partsList() async => await getIt<CommonService>().getPartsList();
  Future<List<Map<String, dynamic>>?> _suppliesList() async => await getIt<CommonService>().getSuppliesList();
  Future<List<Map<String, dynamic>>> _getVendor() async => await getIt<CommonService>().getVendorsList();
  Future<Map<String, dynamic>?> _getTodoDetails(dynamic id) async => await _apiRepository.getTodoDetails(expenseId: id);
  Future<Map<String, dynamic>?> _getEditVehicleExpense(dynamic id) async => await _apiRepository.getEditVehicleExpense(id: id);
  Future<Map<String, dynamic>?> _saveVehicleExpense({dynamic body, dynamic id, List<File>? images}) async => await _apiRepository.expenseAddOrUpdateApi(body: body, expenseId: id, images: images);
  Future<Map<String, dynamic>?> _deleteVehicleExpenseImage({dynamic id}) async => await _apiRepository.deleteVehicleExpenseImage(id);
  Future<Map<String, dynamic>?> _deleteExpenseTodo({dynamic id}) async => await _apiRepository.deleteExpenseTodo(id);
  Future<Map<String, dynamic>?> _deleteVehicleExpense({dynamic id}) async => await _apiRepository.deleteVehicleExpense(id);
  Future<Map<String, dynamic>?> _getEditBillData({dynamic id}) async => await _apiRepository.getEditBillData(id: id);
  Future<Map<String, dynamic>?> _getOdometerValue({dynamic vin}) async => await _apiRepository.getOdometerValue(vin: vin);
  Future<Map<String, dynamic>?> _generateInvoice({dynamic body}) async => await _apiRepository.generateInvoice(body: body);

  VehicleAddEditBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<PickImageEvent>(_onPickImageEvent);
    on<CaptureImageEvent>(_onCaptureImageEvent);
    on<RemoveImageEvent>(_onRemoveImageEvent);
    on<SelectPaymentEvent>(_onSelectPaymentEvent);
    on<SelectVehicleEvent>(_onSelectVehicleEvent);
    on<SelectCategoryEvent>(_onSelectCategoryEvent);
    on<SelectSubCategoryEvent>(_onSelectSubCategoryEvent);
    on<SelectExpenseToEvent>(_onSelectExpenseToEvent);
    on<DatePickedEvent>(_onDatePickedEvent);
    on<SaveEvent>(_onSaveEvent);
    on<TodoDetailsEvent>(_onTodoDetailsEvent);
    on<TaxIconEvent>(_onTaxTappedEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<GetOdometerEvent>(_onOdometerEvent);
    on<InvoiceEvent>(_onInvoiceEvent);
    on<GenerateInvoiceEvent>(_onGenerateInvoiceEvent);
  }
  
  Future<void> _onInitialEvent(InitialEvent event, Emitter<VehicleAddEditState> emit) async {
    try {
      isEdit = event.editModel != null;
      emit(LoadingState());
      if(event.addModel != null){
        var response = await _getEditBillData(id: event.addModel['id']);
        addModel = response?['data'];
        attachmentList = List.from(addModel?['billimages'] ?? []).map((e) => e['path'].toString().toAttachmentURL).toList();
        amountController.text = addModel?['amount'] ?? '';
        descriptionController.text = addModel?['title'] ?? '';
      }
      var vehicleResponse = await _getVehicleList();
      var categoryResponse = await _getExpenseCategory();
      var paymentResponse = await _getPaymentType();
      vehicleList = vehicleResponse ?? [];
      categoryList = categoryResponse ?? [];
      paymentMethod = paymentResponse ?? [];
      if(event.editModel != null){
        editModel = event.editModel;
        var response = await _getEditVehicleExpense(editModel?['id']);
        var todoDetails = await _getTodoDetails(editModel?['id']);
        editResponse = response?['expenses'];
        attachmentList.addAll(List.from(editResponse?['attachments'] ?? []).map((e) => e['path'].toString().toStorageURL).toList());
        selectedVehicle = vehicleList.firstWhereOrNull((e) => e['vin'].toString() == editResponse?['vin'].toString()) ?? {};
        vehicleController.text = selectedVehicle['vehicle_name'] ?? '';
        selectedCategory = categoryList.firstWhereOrNull((e) => e['id'].toString() == editResponse?['category_id'].toString());
        categoryName = selectedCategory?['name'];
        subCategoryList = List.from(selectedCategory['subcategories'] ?? []);
        selectedSubCategory = subCategoryList.firstWhereOrNull((e) => e['id'].toString() == editResponse?['subcategory_id'].toString());
        subCategoryName = selectedSubCategory?['name'];
        selectedPaymentMethod = paymentMethod.firstWhereOrNull((e) => e['id'].toString() == editResponse?['payment_method_id'].toString());
        descriptionController.text = editResponse?['expense_description'] ?? '';
        selectedExpenseTo = expenseTo.firstWhereOrNull((e) => e['id'].toString() == editResponse?['expense_to'].toString());
        amountController.text = editResponse?['expense_amount'].toString() ?? '';
        selectedDate = DateTime.parse(editResponse?['expense_date']);
        splitExpense = List.from(response?['expenses']?['split_expenses'] ?? []);
        partsCostController.addListener(_updateExpenseTotal);
        labourCostController.addListener(_updateExpenseTotal);
        saleTaxController.addListener(_updateExpenseTotal);
        shippingController.addListener(_updateExpenseTotal);
        percentageOrAmountController.addListener(_updateExpenseTotal);
        totalAmountController.addListener(_updateExpenseTotal);
        saleTaxController.text = ((double.tryParse(partsCostController.text) ?? 0) + (double.tryParse(labourCostController.text) ?? 0)).toString();

        if(todoDetails != null){
          todoItems = todoDetails;
          var userResponse = await _getUsers();
          var groupResponse = await _getGroupUsers();
          var partsResponse = await _partsList();
          var suppliesResponse = await _suppliesList();
          usersList = userResponse ?? [];
          groupPerson = groupResponse ?? [];
          partsList = partsResponse ?? [];
          suppliesList = suppliesResponse ?? [];
        }
        dynamic userId;

        if (todoDetails?['user_id'] != null) {
          userId = todoDetails?['user_id'];
        }

        if (todoDetails?['user_group_id'] != null) {
          var user = groupPerson.where((element) => element['id'] == todoDetails?['user_group_id']).firstOrNull;
          userId = user?['userId'];
        }
        userNameList = getUserInitials(userId, usersList);

        if (todoDetails?['vin'] != null) {
          vinList = [todoDetails?['vin']];
        } else {
          List<dynamic>? vehicles = todoDetails?['vehicles'];
          if (vehicles is List && vehicles.isNotEmpty) {
            vinList = vehicles.map((v) => v['vin']).where((vin) => vin != null).toList();
          }
        }

        if (vinList.isNotEmpty) {
          List<Map<String, dynamic>> vehicleNames = vehicleList.where((element) => vinList.contains(element['vin'].toString())).toList();
          vehicleNameList = vehicleNames.map((vehicle) => vehicle["vehicle_name"].toString()).toList();
        }
        String laborAmount = (splitExpense).firstWhereOrNull((element) => element['labour'] == 1)?['amount']?.toString() ?? "";
        labourCostController.text = laborAmount;
        taxIsTapped = editResponse?['sales_tax_type'] == "\$" ? true : false;
        percentageOrAmountController.text = taxIsTapped ? "${editResponse?['sales_tax'] ?? ''}" : "${editResponse?['sales_tax_percentage'] ?? ''}";
        shippingController.text = "${editResponse?['shipping_and_handling'] ?? ''}";

        List<dynamic> partsIds = List.from(todoItems['parts']).where((e) => e["parts_id"] != null).map((e) => int.tryParse(e["parts_id"].toString())).toList();
        List<dynamic> suppliesIds = List.from(todoItems['supplies']).where((e) => e["supplies_id"] != null).map((e) => int.tryParse(e["supplies_id"].toString())).toList();

        if (partsIds.isNotEmpty) {
          selectedParts = partsList.where((element) => partsIds.contains(element['id'])).toList();
        }

        if (suppliesIds.isNotEmpty) {
          selectedSupplies = (suppliesList).where((element) => suppliesIds.contains(element['id'])).toList();
        }

        parts = selectedParts.map((e) => e..["controller"] = TextEditingController()).toList();
        supplies = selectedSupplies.map((e) => e..["controller"] = TextEditingController()).toList();
        Console.of.log(parts, name: "Parts");
        Console.of.log(supplies, name: "Supplies");

        if (splitExpense.isNotEmpty) {
          for (var expense in splitExpense) {
            if (expense['parts_id'] != null) {
              for (var element in parts) {
                if (element['id'].toString() == expense['parts_id'].toString()) {
                  element['controller'].text = "${expense['amount'] ?? 0.00}";
                }
              }
              _updateExpenseTotal();
            }
            if (expense['supplies_id'] != null) {
              for (var element in supplies) {
                if (element['id'].toString() == expense['supplies_id'].toString()) {
                  element['controller'].text = "${expense['amount'] ?? 0.00}";
                }
                _updateExpenseTotal();
              }
            }
          }
        }
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onTaxTappedEvent(TaxIconEvent event, Emitter<VehicleAddEditState> emit) {
     try {
       taxIsTapped = !taxIsTapped;
       _updateExpenseTotal();
       emit(CommonState());
     }catch(e){
       _onError(e, emit);
     }
  }
  
  Future<void> _onPickImageEvent(PickImageEvent event, Emitter<VehicleAddEditState> emit) async {
    try {
      var result = await _pickFiles();
      if (result.isNotEmpty) {
        var attachments = List.from(attachmentList);
        var existingAttachments = List.from(attachmentList)
            .whereType<File>()
            .map((e) => (e.path))
            .toList();
        for (var element in result) {
          if (!existingAttachments.contains(element.path)) {
            attachments.add(element);
          }
        }
        attachmentList = attachments;
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onCaptureImageEvent(CaptureImageEvent event, Emitter<VehicleAddEditState> emit) async {
    try {
      var result = await _pickImages();
      if (result != null) {
        var attachments = List.from(attachmentList);
        attachments.add(result);
       attachmentList = attachments;
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onRemoveImageEvent(RemoveImageEvent event, Emitter<VehicleAddEditState> emit) async {
    try {
      if (event.data == null) return;
      if (event.data is File) {
        attachmentList.remove(event.data);
      } else if (event.data is String) {
        var attachmentId = List.from(editResponse?['attachments'] ?? [])
            .where((element) => element['path'] == (event.data).toString().removeStorageUrl)
            .map((e) => e['id'])
            .firstOrNull;
        emit(LoadingState());
         await _deleteVehicleExpenseImage(id: attachmentId);
        _broadcast.broadcast("expense_vehicle_refresh", value: true);
        attachmentList.remove(event.data);
        emit(CommonState());
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onSelectPaymentEvent(SelectPaymentEvent event, Emitter<VehicleAddEditState> emit) {
     try {
       selectedPaymentMethod = event.data;
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onSelectVehicleEvent(SelectVehicleEvent event, Emitter<VehicleAddEditState> emit) {
     try {
       selectedVehicle = event.data;
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }
  
  void _onSelectCategoryEvent(SelectCategoryEvent event, Emitter<VehicleAddEditState> emit) {
     try {
       if(selectedCategory != event.data){
         selectedCategory = event.data;
         subCategoryList = List.from(selectedCategory['subcategories'] ?? []);
         selectedSubCategory = null;
         selectedExpenseTo = null;
       }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onSelectSubCategoryEvent(SelectSubCategoryEvent event, Emitter<VehicleAddEditState> emit) {
     try {
       if(selectedSubCategory != event.data){
         selectedSubCategory = event.data;
         selectedExpenseTo = expenseTo.firstWhereOrNull((e) => e['id'].toString() == selectedSubCategory['expense_to'].toString());
       }
       emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }
  
  void _onSelectExpenseToEvent(SelectExpenseToEvent event, Emitter<VehicleAddEditState> emit) {
     try {
       selectedExpenseTo = event.data;
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<VehicleAddEditState> emit) async {
     try {
       emit(LoadingState());
       await _deleteExpenseTodo(id: editResponse?['id']);
       var response =  await _deleteVehicleExpense(id: editResponse?['id']);
       if(response?['status'] == 200){
         _broadcast.broadcast("expense_vehicle_refresh", value: true);
         emit(SuccessState(response?['message']));
       }else{
         emit(ErrorState(response?['message']));
       }
     }catch(e){
       _onError(e, emit);
     }
  }
    
  void _onDatePickedEvent(DatePickedEvent event, Emitter<VehicleAddEditState> emit) {
     try {
       selectedDate = event.date;
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSaveEvent(SaveEvent event, Emitter<VehicleAddEditState> emit) async {
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if (formKey.currentState?.validate() == false) return emit(CommonState());
    try {
      autoValidateMode = null;
       emit(LoadingState());
       if(isEdit){
       var response = await _saveVehicleExpense(
           body: _updateExpenseData(),
           id: editModel?['id'], images: attachmentList.whereType<File>().toList());
        if(response?['data'] != null){
          _broadcast.broadcast("expense_vehicle_refresh", value: true);
          emit(SuccessState(response?['message']));
        }
       }else{
         var response = await _saveVehicleExpense(
             body: _saveExpenseData(),
             images: attachmentList.whereType<File>().toList());
         if(response?['data'] != null){
           _broadcast.broadcast("expense_vehicle_refresh", value: true);
           emit(SuccessState(response?['message']));
         }
         emit(CommonState());
       }
    }catch (e) {
      _onError(e, emit);
    }
  }
  
  void _onTodoDetailsEvent(TodoDetailsEvent event, Emitter<VehicleAddEditState> emit) {
     try {
       var editModel = {
         'title' : todoItems?['title'],
         'status' : todoItems?['status'],
         'date_time' : "${todoItems?['todo_date'].toString().toDateTime()?.toFormat(format: "MM-dd-yyyy") ?? ''}"
                        " ${todoItems['todo_time'].toString().toFormat(inputFormat: 'HH:mm:ss', format: 'hh:mm a') ?? ''}",
         'user' : (userNameList ?? []).join(', '),
         'vehicle' : (vehicleNameList).join(', '),
         'vendor' : todoItems?['vendor_name'],
         'notes' : todoItems?['notes'],
         'parts' : List.from(todoItems?['parts'] ?? []).map((e) => e['parts_name'].toString()).toList(),
         'supplies' : List.from(todoItems?['supplies'] ?? []).map((e) => e['supplies_name'].toString()).toList(),
         'odometer' : todoItems?['odometer'],
         'amount' : editResponse?['expense_amount'],
         'description' : editResponse?['expense_description'],
         'category' : categoryName,
         'sub_category' : subCategoryName,
         'attachment' : List.from(editResponse?['attachments'] ?? []).map((e) => e['path'].toString().toStorageURL).toList(),
       };
      emit(TodoTaskViewSate(editModel));
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onOdometerEvent(GetOdometerEvent event, Emitter<VehicleAddEditState> emit) async {
     try {
       bouncieMessage = null;
       if (selectedVehicle.isEmpty) return;
       emit(LoadingState());
       var response = await _getOdometerValue(vin: selectedVehicle['vin']);
       odometerController.text = response?['data']?['stats']?['odometer'].toString() ?? '';
       if(response?['status'] == 400){
         bouncieMessage = response?['message'];
       }
       emit(CommonState());
     }catch (e){
       _onError(e, emit);
     }
  }

  Future<void> _onInvoiceEvent(InvoiceEvent event, Emitter<VehicleAddEditState> emit) async {
     try {
       emit(LoadingState());
       var response = await _getVendor();
       var vendorList = response.firstWhereOrNull((element) => element['id'].toString() == todoItems?['vendor_id'].toString());
       var total = totalAmountController.text;
       var subTotal = subTotalController.text;
       if (parts.isEmpty && supplies.isEmpty) {
         total = amountController.text;
         subTotal = amountController.text;
       }
       invoiceData = {
         'amount': totalAmountController.text,
         'description': descriptionController.text,
         'odometer': odometerController.text,
         'tax': saleTaxController.text,
         'total': total,
         'sub_total': subTotal,
         'shipping': shippingController.text,
         'title': vendorList?['name'] ?? '',
         'phone':vendorList?['phone'] ?? '',
         'address': vendorList?['address'] ?? '',
         'invoiceId': "INV${todoItems?['id'] ?? ''}",
         'date': DateTime.now().format('MM-dd-yyyy').toString(),
         'plateNo': vehicleList.firstWhereOrNull((e) => e['vin'].toString() == editResponse?['vin'].toString())?['vehicle_number'],
         'vehicleName': vehicleList.firstWhereOrNull((e) => e['vin'].toString() == editResponse?['vin'].toString())?['vehicle_name'],
         'sales_tax_percentage': percentageOrAmountController.text,
         'itemList': [
           ...cleanList(parts),
           ...cleanList(supplies),
           if (labourCostController.text.isNotEmpty)
             {
               ...{
                 "id": "1",
                 "quantity": "1",
                 "name": "Labour",
                 "rate": labourCostController.text,
                 "total": labourCostController.text,
               }
             },
           if (parts.isEmpty && supplies.isEmpty)
             {
               ...{
                 "id": "1",
                 "quantity": "1",
                 "name": descriptionController.text.isEmpty
                     ? 'No description'
                     : descriptionController.text,
                 "rate": amountController.text,
                 "total": amountController.text,
               }
             }
         ],
       };
       Console.of.log(jsonEncode(invoiceData));
       emit(InvoiceState());
     }catch(e){
       _onError(e, emit);
     }
  }

  Future<void> _onGenerateInvoiceEvent(GenerateInvoiceEvent event, Emitter<VehicleAddEditState> emit) async {
     try {
       emit(LoadingState());
       var status = (await DeviceInfoHelper.of.isBelow13)
           ? await Permission.storage.request()
           : await Permission.manageExternalStorage.request();
       if (status.isGranted) {
         var response = await _generateInvoice(body: _invoiceData());
         if ((response != null) && (response['message'] != null)) {
           attachmentList.add(File(response['message']));
           emit(SuccessState("Invoice Generated Successfully"));
         }
       } else if (status.isDenied) {
         await Permission.manageExternalStorage.request();
         emit(ErrorState("Permission Denied"));
       }
       emit(CommonState());
     }catch(e) {
       _onError(e, emit);
     }
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

  List<String> getUserInitials(dynamic userIds, List<Map<String, dynamic>>? users) {
    if (userIds == null) {
      return [];
    } else if (userIds is String && userIds.startsWith("[") && userIds.endsWith("]")) {
      userIds = List<String>.from(jsonDecode(userIds).map((id) => id.toString()));
    } else if (userIds is String) {
      userIds = [userIds];
    } else if (userIds is! List) {
      return [];
    }
    return (users ?? []).where((user) => userIds.contains(user['id'].toString())).map((user) {
      String firstInitial = (user['first_name']?.isNotEmpty ?? false)
          ? user['first_name'][0].toUpperCase()
          : "";
      String lastInitial = (user['last_name']?.isNotEmpty ?? false)
          ? user['last_name'][0].toUpperCase()
          : "";
      return "$firstInitial$lastInitial";
    }).toList();
  }

  void  _updateExpenseTotal() {
    double totalSuppliesCost = 0;
    double totalParts = 0;
    totalParts = parts
        .map((e) =>
    double.tryParse((e['controller'] as TextEditingController).text.toString()) ?? 0.0).sum;

    totalSuppliesCost = supplies.map((e) =>
    double.tryParse((e['controller'] as TextEditingController).text.toString()) ?? 0.0).sum;

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

  Map<String, String> _saveExpenseData() {
    Map<String, String> baseBody = {};
    baseBody['category_id'] = "${selectedCategory?['id'] ?? ''}";
    baseBody['subcategory_id'] = "${selectedSubCategory?['id'] ?? ''}";
    baseBody['payment_method_id'] = "${selectedPaymentMethod?['id'] ?? ''}";
    baseBody['expense_to'] = "${selectedExpenseTo?['id'] ?? ''}";
    baseBody['expense_amount'] = amountController.text;
    baseBody['expense_description'] = descriptionController.text;
    baseBody['expense_date'] = selectedDate.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['cohort_id'] = "${selectedVehicle["cohort_id"] ?? ''}";
    baseBody['vin'] = "${selectedVehicle['vin'] ?? ''}";
    if (odometerController.text.isNotEmpty && ((double.tryParse(odometerController.text) ?? 0) > 0)) {
      baseBody['odometer'] = odometerController.text;
    }
    baseBody['platform'] = "TaskerApp";
    baseBody['employee_id'] = "${getIt<CommonService>().userId}";
    Console.of.log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  Map<String, dynamic> _updateExpenseData() {
    dynamic splitLabor = {
      "labour": 1,
      "amount": labourCostController.text,
    };
    splitParts = (parts)
        .map((e) => {
      "parts_id": "${e['id']}",
      "amount": (e['controller'] as TextEditingController).text
    }).toList();
    splitSupplies = (supplies)
        .map((e) => {
      "supplies_id": "${e['id']}",
      "amount": (e['controller'] as TextEditingController).text
    }).toList();

    List<Map<String, dynamic>> splits = [
      ...splitParts,
      ...splitSupplies,
      ...[splitLabor]
    ];
    final expenseAmount = splitExpense.isEmpty
        ? amountController.text
        : totalAmountController.text;
    Map<String, dynamic> baseBody = {};
    baseBody['sales_tax'] = saleTaxController.text;
    baseBody['shipping_and_handling'] = shippingController.text;
    baseBody['sales_tax_type'] = taxIsTapped ? '\$' : '%';
    baseBody['sales_tax_percentage'] = taxIsTapped ? '' : percentageOrAmountController.text;
    baseBody['expense_amount'] = expenseAmount;
    baseBody['category_id'] = "${selectedCategory?['id'] ?? ''}";
    baseBody['subcategory_id'] = "${selectedSubCategory?['id'] ?? ''}";
    baseBody['employee_id'] = "${getIt<CommonService>().userId}";
    baseBody['cohort_id'] = "${selectedVehicle["cohort_id"] ?? ''}";
    baseBody['vin'] = "${selectedVehicle['vin'] ?? ''}";
    baseBody['expense_date'] = selectedDate?.toFormat(format: 'yyyy-MM-dd')??'';
    if (splitParts.isNotEmpty || splitSupplies.isNotEmpty) {
      splits.forEachIndexed((index, element) {
        baseBody['split[$index][${element.keys.first}]'] = element[element.keys.first].toString();
        baseBody['split[$index][${element.keys.last}]'] = element[element.keys.last].toString();
      });
    }
    baseBody['expense_description'] = descriptionController.text;
    baseBody['expense_to'] = "${selectedExpenseTo?['id'] ?? ''}";
    baseBody['odometer'] = editResponse?['odometer'];
    baseBody['platform'] = "TaskerApp";
    baseBody['payment_method_id'] = "${selectedPaymentMethod?['id'] ?? ''}";
    baseBody['approved'] = editResponse?['approved'];
    Console.of.log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  void calculateTotal() {
    _updateExpenseTotal();
  }

  void _onError(dynamic error , Emitter<VehicleAddEditState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }

  List<Map<String, dynamic>> cleanList(List<dynamic> inputList) {
    return inputList.map((e) {
      final item = Map<String, dynamic>.from(e);
      final text = (item['controller'] as TextEditingController).text.trim();
      item.remove('controller');
      if (text.isNotEmpty) {
        item['rate'] = text;
      } else {
        item['rate'] = "0";
      }
      return item;
    }).toList();
  }

  Map<String, dynamic> _invoiceData() {
    Map<String, dynamic> baseBody = {};
    baseBody['car_plate'] = invoiceData?['plateNo'] ?? '';
    baseBody['company_address'] = "${invoiceData?['address'] ?? ''}";
    baseBody['company_name'] = invoiceData?['title'] ?? '';
    baseBody['company_phone'] = invoiceData?['phone'] ?? '';
    baseBody['expense_amount'] =
        invoiceData?['total'] ?? invoiceData?['amount'] ?? '';
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
        : invoiceData?['itemList']
        ?.map((e) => <String, dynamic>{
      "quantity": 1,
      "description": e['name'] ?? "No description",
      "rate": e['rate'] ?? 0,
      "total": e['rate'] ?? 0,
    })
        .toList();
    Console.of.log(jsonEncode(baseBody), name: "Invoice_body");
    return baseBody;
  }
  
}