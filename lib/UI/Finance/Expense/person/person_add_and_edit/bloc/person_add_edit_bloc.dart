import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'person_add_edit_event.dart';
part 'person_add_edit_state.dart';

class PersonAddEditBloc extends Bloc<PersonAddEditEvent, PersonAddEditState> {

  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;
  DateTime? selectedDate = DateTime.now();
  TextEditingController dateController =  TextEditingController();
  TextEditingController amountController =  TextEditingController();
  TextEditingController descriptionController =  TextEditingController();
  final FBroadcast _broadcast = FBroadcast.instance();

  List<dynamic> persons = [];
  List<dynamic> categories = [];
  List<dynamic> subCategories = [];
  List<dynamic> paymentType = [];
  List<dynamic> approved = [{'id': 1, 'name': 'Yes'}, {'id': 0, 'name': 'No'},];
  List<dynamic> attachments = [];
  List<dynamic> expenseTo = [{'id': 1, 'name': 'FairPy'}, {'id': 2, 'name': 'Cohort'}];

  dynamic selectedPerson;
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  dynamic selectedPaymentType;
  dynamic selectedApproved;
  dynamic selectedExpenseTo;
  Map<String, dynamic>? model;
  bool isEdit = false;

  Future<Map<String, dynamic>?> _getExpense({dynamic id}) async => await _apiRepository.getEditPersonExpense(expenseId: id);
  Future<List<Map<String, dynamic>>?> _getExpenseCategory() async => await getIt<CommonService>().expenseCategory();
  Future<List<Map<String, dynamic>>?> _getPaymentType() async => await getIt<CommonService>().getPaymentTypes();
  Future<Map<String, dynamic>?> _getEmployeeList() async => await _apiRepository.getEmployeeList();


  PersonAddEditBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<SelectPersonEvent>(_onSelectPersonEvent);
    on<SelectCategoryEvent>(_onCategoryEvent);
    on<SelectSubCategoryEvent>(_onSubCategoryEvent);
    on<SelectPaymentEvent>(_onPaymentEvent);
    on<ApproveEvent>(_onApprovedEvent);
    on<SelectDateEvent>(_onDateChangeEvent);
    on<PickImageEvent>(_onPickImageEvent);
    on<RemoveImageEvent>(_onRemoveImageEvent);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<ExpenseToEvent>(_onExpenseToEvent);
  }
  Future<void> _onInitialEvent(InitialEvent event, Emitter<PersonAddEditState> emit) async {
    try {
      emit(LoadingState());
      model = event.model;
      isEdit = model != null;
      var employeeResponse = await _getEmployeeList();
      var categoryResponse = await _getExpenseCategory();
      var paymentResponse = await _getPaymentType();
      persons = employeeResponse?['data'] ?? [];
      categories = List.from(categoryResponse ?? []).where((g) => g['id'] == 76).toList();
      paymentType = paymentResponse ?? [];
      if(model != null){
        var response = await _getExpense(id: event.model['id']);
        var model = response;
        Console.of.log(response, name: "INITIAL EVENT");
        selectedCategory = categories.firstWhereOrNull((r)=> r['id'].toString() == model?['category_id'].toString());
        subCategories = List.from(selectedCategory?['subcategories'] ?? []);
        subCategories.removeWhere((g) => g['id'] != 100,);
        subCategories.sort((a, b) => a['id'].compareTo(b['id']));
        selectedSubCategory = subCategories.firstWhereOrNull((r)=> r['id'].toString() == model?['subcategory_id'].toString());
        selectedPaymentType = paymentType.firstWhereOrNull((r)=> r['id'] == model?['payment_method_id']);
        selectedApproved = approved.firstWhereOrNull((r)=> r['id'] == model?['approved']);
        dateController.text = model?['expense_date'];
        amountController.text = "${model?['expense_amount'] ?? ''}";
        descriptionController.text = model?['expense_description'] ?? "";
        attachments = List.from(model?['attachments'] ?? []).map((e) => e['path'].toString().toStorageURL).toList();
        selectedPerson = persons.firstWhereOrNull((e) => e['id'].toString() == response?['employee_id'].toString());
        selectedExpenseTo = expenseTo.firstWhereOrNull((e) => e['id'] == response?['expense_to']);
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onSelectPersonEvent(SelectPersonEvent event, Emitter<PersonAddEditState> emit) {
    try {
      selectedPerson = event.selectedPerson;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onCategoryEvent(SelectCategoryEvent event, Emitter<PersonAddEditState> emit) async {
    try {
      selectedCategory =  event.selectedCategory;
      subCategories = List.from(selectedCategory['subcategories'] ?? []);
      Console.of.log(subCategories);
      subCategories.removeWhere((g) => g['id'] != 100,);
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onSubCategoryEvent(SelectSubCategoryEvent event, Emitter<PersonAddEditState> emit) {
    try {
      selectedSubCategory = event.selectedSubCategory;
      selectedExpenseTo = expenseTo[0];
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onPaymentEvent(SelectPaymentEvent event, Emitter<PersonAddEditState> emit) {
    try {
      selectedPaymentType = event.paymentType;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onApprovedEvent(ApproveEvent event, Emitter<PersonAddEditState> emit) {
    try {
      selectedApproved = event.selectedApproved;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onDateChangeEvent(SelectDateEvent event, Emitter<PersonAddEditState> emit) {
    try {
      selectedDate = event.selectedDate;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onPickImageEvent(PickImageEvent event, Emitter<PersonAddEditState> emit) async {
    try {
      var result = await _pickFiles();
      if (result.isNotEmpty) {
        var pickedFile = List.from(attachments);
        var existingAttachments = List.from(attachments)
            .whereType<File>()
            .map((e) => (e.path))
            .toList();
        for (var element in result) {
          if (!existingAttachments.contains(element.path)) {
            pickedFile.add(element);
          }
        }
        attachments = pickedFile;
      }
      emit(CommonState());
    } catch (e) {

      _onError(e, emit);
    }
  }


  Future<void> _onRemoveImageEvent(RemoveImageEvent event, Emitter<PersonAddEditState> emit) async {
    try {
      if (event.data == null) return;
      if (event.data is File) {
        attachments.remove(event.data);
      } else if (event.data is String) {
        emit(LoadingState());
        var data = attachments.firstWhereOrNull((element) => element == event.data.toString());
        var attachmentId = List.from(model?['attachments']).where((element) =>
        element['path'] == data.toString().removeStorageUrl)
            .map((e) => e['id'])
            .firstOrNull;
        await _apiRepository.deletePersonExpenseImage(attachmentId);
        _broadcast.broadcast("expense_person_refresh");
        attachments.remove(event.data);
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSaveEvent(SaveEvent event, Emitter<PersonAddEditState> emit) async {
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if (formKey.currentState?.validate() == false) return emit(CommonState());
    try {
      autoValidateMode = null;
      emit(LoadingState());
      var response = await _apiRepository.personExpenseAddOrUpdateApi(
        expenseId: model?['id'].toString(),
        body: _savePersonExpense(),
        images: attachments.whereType<File>().toList(),
      );
      if(response?['data'] != null){
        _broadcast.broadcast("expense_person_refresh");
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response));
      }
    } catch (e) {
      _onError(e, emit);

    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<PersonAddEditState> emit) async {
    try {
      emit(LoadingState());
      var response = await _apiRepository.deletePersonExpense(model?['id']);
      if(response?['message'].contains('Expense deleted successfully.') == true) {
        _broadcast.broadcast("expense_person_refresh");
        emit(SuccessState(response?['message']));
      }else{
        emit(CommonState());
      }
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onExpenseToEvent(ExpenseToEvent event, Emitter<PersonAddEditState> emit) {
    try {
      selectedExpenseTo = event.selectedExpenseTo;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Map<String, String> _savePersonExpense() {
    Map<String, String> baseBody = {};
    baseBody['employee_id'] = "${selectedPerson?['id'] ??''}";
    baseBody['expense_date'] =  selectedDate?.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['approved'] = "${selectedApproved['id'] ?? ''}";
    baseBody['expense_amount'] = amountController.text;
    baseBody['category_id'] = "${selectedCategory?['id'] ??''}";
    baseBody['subcategory_id'] = "${selectedSubCategory?['id'] ?? ''}";
    baseBody['expense_description'] = descriptionController.text;
    baseBody['expense_to'] = "${selectedExpenseTo?['id'] ??''}";
    baseBody['payment_method_id'] = "${selectedPaymentType['id'] ?? ''}";
    baseBody['platform'] = "TaskerApp";
    baseBody['is_employee'] = "${1}";
    Console.of.log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc',]);
    return result?.paths
        .where((element) => (element?.isNotEmpty ?? false))
        .map((e) => File(e!))
        .toList() ?? [];
  }

  void _onError(dynamic error, Emitter<PersonAddEditState> emit) {
    emit(ErrorState(error));
    Console.of.error(error);
  }

}