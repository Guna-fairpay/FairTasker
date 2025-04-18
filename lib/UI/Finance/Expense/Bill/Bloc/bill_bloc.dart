
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:path/path.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_state.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class BillBloc extends Bloc<BillEvent, BillState>{

  final APiRepository _apiRepository = APiRepository();
  final TextEditingController filePickerController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<dynamic> files = [];
  List<dynamic> apiResponse = [];
  String? from,to;
  DateRange? selectedDateRange = DateRange(DateTime.now().subtract(
      const Duration(days: 7)), DateTime.now());
  bool isCheck = false;
  bool isEdit = false;

  BillBloc() : super(BillLoadingState()){
    on<BillInitialEvent>(_onInitialEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
    on<CheckBoxEvent>(_onCheckBoxEvent);
    on<FilePickerEvent>(_onFilePickerEvent);
    on<DeleteBillEvent>(_onDeleteEvent);
    on<AddBillEvent>(_onAddEvent);
    on<EditBillEvent>(_onEditEvent);
    on<LoadEditValueEvent>(_onLoadEditValueEvent);
    on<ClearAllEvent>(_clearAll);
  }

  void _onInitialEvent(BillInitialEvent event, Emitter<BillState> emit) async {
    try{
      emit(BillLoadingState());
      if (event.from != null && event.to != null) {
        from = event.from;
        to = event.to;
      } else {
        from = DateTime.now().subtract(const Duration(days: 7)).toFormat(format: 'yyyy-MM-dd');
        to = DateTime.now().toFormat(format: 'yyyy-MM-dd');
      }
      var response = await _apiRepository.getBillList(from: from, to: to);
      apiResponse=response?['data'];
      emit(BillCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(BillCommonState());
      log(e.toString(), name: "BillBloc");
    }
  }

  void _onDateRangeEvent(DateRangeEvent event, Emitter<BillState> emit) {
    selectedDateRange = event.selectedRange;
    from = selectedDateRange?.start.toFormat(format: 'yyyy-MM-dd');
    to = selectedDateRange?.end.toFormat(format: 'yyyy-MM-dd');
    add(BillInitialEvent(from: from, to: to));
  }

  void _onCheckBoxEvent(CheckBoxEvent event, Emitter<BillState> emit) {
    isCheck = !isCheck;
  }

  void _onDeleteEvent(DeleteBillEvent event, Emitter<BillState> emit) async {
    try{
      emit(BillLoadingState());
      var response =await _apiRepository.deleteBill(id: event.value['id']);
      if(response != null){
        apiResponse.remove(event.value);
        Toaster.showSuccess(response['message']);
        emit(BillCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      emit(BillCommonState());
      log(e.toString(), name: "DeleteEvent");
    }
  }

 void _onAddEvent(AddBillEvent event, Emitter<BillState> emit) async {
    try{
      if(files.isEmpty){
        Toaster.showError('Images Required');
        return;
      }
      emit(BillLoadingState());
      Map<String, String> body={
        'title': titleController.text,
        'amount': amountController.text,
        'description': descriptionController.text,
      };
      var response = await _apiRepository.billAddOrUpdate(
        body: body,
        images: files.whereType<File>().toList(),
       );
      if(response?['data'] != null){
        add(ClearAllEvent());
        apiResponse.add(response?['data']);
        apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
        Toaster.showSuccess('Bill Added Successfully');
      }
      emit(BillCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(BillCommonState());
      log(e.toString(), name: "AddEvent");
    }
  }

  void _onEditEvent(EditBillEvent event, Emitter<BillState> emit) async {
    try{
      if(files.isEmpty) {
        Toaster.showError('Please Select Images');
        return;
      }
      emit(BillLoadingState());
      Map<String, String> body={
        'title': titleController.text,
        'amount': amountController.text,
        'description': descriptionController.text,
        };
      var response = await _apiRepository.billAddOrUpdate(
        body: body,
        images: files.whereType<File>().toList(),
        id: event.value['id'],);
      if(response?['data'] != null){
        add(ClearAllEvent());
        apiResponse.remove(event.value);
        apiResponse.add(response?['data']);
        apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
        Toaster.showSuccess('Bill Updated Successfully');
      }
      emit(BillCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(BillCommonState());
      log(e.toString(), name: "EditEvent");
    }
  }

  void _onLoadEditValueEvent(LoadEditValueEvent event, Emitter<BillState> emit)async{
    try{
      isEdit = true;
      emit(BillLoadingState());
      var response = await _apiRepository.getEditBillData(id: event.value['id']);
      if(response?['data'] != null){
        titleController.text = response?['data']['title'];
        amountController.text = response?['data']['amount'];
        descriptionController.text = response?['data']['description'];
        List<dynamic> images = response?['data']['billimages'];
        files = images.map((e) => e['path'].toString().toAttachmentURL).toList();
        filePickerController.text = basename(files.lastOrNull?? "");
      }
      Console.of.debug(files);
      emit(BillCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(BillCommonState());
      log(e.toString(), name: "LoadEditValueEvent");
    }
  }

  void _onFilePickerEvent(FilePickerEvent event, Emitter<BillState> emit) async {
    var result = await _pickFiles();
    if (result.isNotEmpty) {
      var attachments = List.from(files);
      var existingAttachments = List.from(files)
          .whereType<File>()
          .map((e) => (e.path))
          .toList();
      for (var element in result) {
        if (!existingAttachments.contains(element.path)) {
          attachments.add(element);
        }
      }
      log("$attachments", name: "PickImageEvent");
      files = attachments;
      filePickerController.text = basename(files.lastOrNull?.path ?? "");
      emit(BillCommonState());
    }
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf',]);
    return result?.paths
        .where((element) => (element?.isNotEmpty ?? false))
        .map((e) => File(e!))
        .toList() ??
        [];
  }

  void _clearAll(ClearAllEvent event, Emitter<BillState> emit){
    isEdit=false;
    files.clear();
    titleController.clear();
    amountController.clear();
    descriptionController.clear();
    filePickerController.clear();
    emit(BillCommonState());
  }

}