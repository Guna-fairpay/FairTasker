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
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'other_add_edit_event.dart';
part 'other_add_edit_state.dart';

class OtherAddEditBloc extends Bloc<OtherAddEditEvent, OtherAddEditState> {

  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;
  DateTime? selectedDate = DateTime.now();
  TextEditingController dateController =  TextEditingController();
  TextEditingController amountController =  TextEditingController();
  TextEditingController descriptionController =  TextEditingController();
  final FBroadcast _broadcast = FBroadcast.instance();

  List<dynamic> categories = [];
  List<dynamic> subCategories = [];
  List<dynamic> paymentType = [];
  List<dynamic> approved = [{'id': 1, 'name': 'Yes'}, {'id': 0, 'name': 'No'},];
  List<dynamic> attachments = [];

  dynamic selectedCategory;
  dynamic selectedSubCategory;
  dynamic selectedPaymentType;
  dynamic selectedApproved;
  Map<String, dynamic>? model;
  String? id;

  OtherAddEditBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<CategoryEvent>(_onCategoryEvent);
    on<SubCategoryEvent>(_onSubCategoryEvent);
    on<PaymentEvent>(_onPaymentEvent);
    on<ApprovedEvent>(_onApprovedEvent);
    on<DateChangeEvent>(_onDateChangeEvent);
    on<PickImageEvent>(_onPickImageEvent);
    on<RemoveImageEvent>(_onRemoveImageEvent);
    on<SaveOrUpdateEvent>(_onSaveOrUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<Map<String, dynamic>?> _getExpense({dynamic id}) async => await _apiRepository.getEditPersonExpense(expenseId: id);
  Future<List<Map<String, dynamic>>?> _getExpenseCategory() async => await getIt<CommonService>().expenseCategory();
  Future<List<Map<String, dynamic>>?> _getPaymentType() async => await getIt<CommonService>().getPaymentTypes();

  Future<void> _onInitialEvent(InitialEvent event, Emitter<OtherAddEditState> emit) async {
    try {
      emit(LoadingState());
      id = event.id.toString();
      var categoryResponse = await _getExpenseCategory();
      categories = List.from(categoryResponse ?? []).where((g) => g['id'] == 76).toList();
      var paymentResponse = await _getPaymentType();
      paymentType = paymentResponse ?? [];
      if(event.id != null){
        var response = await _getExpense(id: event.id);
        model = response;
        Console.of.log(response, name: "INITIAL EVENT");
        selectedCategory = categories.firstWhereOrNull((r)=> r['id'].toString() == model?['category_id'].toString());
        subCategories = List.from(selectedCategory?['subcategories'] ?? []);
        subCategories.removeWhere((g) => g['id'] == 100,);
        subCategories.sort((a, b) => a['id'].compareTo(b['id']));
        selectedSubCategory = subCategories.firstWhereOrNull((r)=> r['id'].toString() == model?['subcategory_id'].toString());
        selectedPaymentType = paymentType.firstWhereOrNull((r)=> r['id'] == model?['payment_method_id']);
        selectedApproved = approved.firstWhereOrNull((r)=> r['id'] == model?['approved']);
        dateController.text = model?['expense_date'];
        amountController.text = "${model?['expense_amount'] ?? ''}";
        descriptionController.text = model?['expense_description'] ?? "";
        attachments = List.from(model?['attachments'] ?? []).map((e) => e['path'].toString().toStorageURL).toList();
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<OtherAddEditState> emit) async{
    try {
      emit(LoadingState());
      var response = await _apiRepository.deletePersonExpense(id);
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

  Future<void> _onCategoryEvent(CategoryEvent event, Emitter<OtherAddEditState> emit) async {
    try {
      selectedCategory =  event.selectedCategory;
      subCategories = List.from(selectedCategory['subcategories'] ?? []);
      subCategories.removeWhere((g) => g['id'] == 100,);
      subCategories.sort((a, b) => a['id'].compareTo(b['id']));
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

    Future<void> _onSubCategoryEvent(SubCategoryEvent event, Emitter<OtherAddEditState> emit) async {
      try {
        selectedSubCategory = event.selectedSubCategory;
        emit(CommonState());
      } catch (e) {
        _onError(e, emit);
      }
  }

    Future<void> _onPaymentEvent(PaymentEvent event, Emitter<OtherAddEditState> emit) async {
      try {
        selectedPaymentType = event.paymentType;
        emit(CommonState());
      } catch (e) {
        _onError(e, emit);
      }
  }

      Future<void> _onApprovedEvent(ApprovedEvent event, Emitter<OtherAddEditState> emit) async {
        try {
          selectedApproved = event.selectedApproved;
          emit(CommonState());
        } catch (e) {
          _onError(e, emit);
        }
    }

    Future<void> _onDateChangeEvent(DateChangeEvent event, Emitter<OtherAddEditState> emit) async {
      try {
        emit(LoadingState());
        selectedDate = event.selectedDate;
        emit(CommonState());
      } catch (e) {
        _onError(e, emit);
      }
  }

  Future<void> _onPickImageEvent(PickImageEvent event, Emitter<OtherAddEditState> emit) async {
    try {
      emit(LoadingState());
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

  Future<void> _onRemoveImageEvent(RemoveImageEvent event, Emitter<OtherAddEditState> emit) async {
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
        attachments.remove(event.data);
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSaveOrUpdateEvent(SaveOrUpdateEvent event, Emitter<OtherAddEditState> emit) async {
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if (formKey.currentState?.validate() == false) return emit(CommonState());
    try {
      autoValidateMode = null;
      emit(LoadingState());
      var response = await _apiRepository.addOtherExpense(
        id: id,
        body: _savePersonExpense(),
        images: attachments.whereType<File>().toList(),
      );
      if(response?['data'] != null){
        _broadcast.broadcast("expense_person_refresh");
        emit(SuccessState(response?['message']));
      }else{
        emit(CommonState());
      }
    } catch (e) {
      _onError(e, emit);
    }
  }

  Map<String, String> _savePersonExpense() {
    Map<String, String> baseBody = {};
    baseBody['expense_date'] =  selectedDate?.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['approved'] = "${selectedApproved['id'] ?? ''}";
    baseBody['expense_amount'] = amountController.text;
    baseBody['category_id'] = "${selectedCategory?['id'] ??''}";
    baseBody['subcategory_id'] = "${selectedSubCategory?['id'] ??''}";
    baseBody['expense_description'] = descriptionController.text;
    baseBody['payment_method_id'] = "${selectedPaymentType['id'] ?? ''}";
    baseBody['expense_to'] = "${selectedSubCategory?['expense_to'] ??''}";
    baseBody['platform'] = "TaskerApp";
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

  void _onError(dynamic error, Emitter<OtherAddEditState> emit) {
    emit(ErrorState(error));
    Console.of.error(error);
  }
}
