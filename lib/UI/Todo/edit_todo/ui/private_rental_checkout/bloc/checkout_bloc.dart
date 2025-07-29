import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState>{
  final APiRepository _apiRepository = APiRepository();

  final TextEditingController fileNameController = TextEditingController();

  List<dynamic> checkOutValues = [];
  List<dynamic> attachments = [];
  List<dynamic> attachmentPaths = [];
  List<dynamic> checkOtuAttachmentPaths = [];

  dynamic model;
  dynamic bookingDetails;

  String? token;

  Future<Map<String, dynamic>?> _checkOutValues({dynamic id}) async => await _apiRepository.checkOutValues(id: id, token: token);
  Future<Map<String, dynamic>?> _getToken() async => await _apiRepository.getRentalToken();
  Future<Map<String, dynamic>?> _saveCheckOut({required Map<String, dynamic> body, dynamic id, dynamic file}) async => await _apiRepository.saveCheckOut(body: body, token: token, id: id, images: file);

  CheckoutBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<ParentCheckEvent>(_onParentCheckEvent);
    on<ChildCheckEvent>(_onChildCheckEvent);
    on<YesNoEvent>(_onYesNoEvent);
    on<DropdownEvent>(_onDropdownEvent);
    on<FilePickerEvent>(_onFilePickerEvent);
    on<DeleteImageEvent>(_onDeleteImageEvent);
    on<ApproveAndCloseEvent>(_onApproveAndCloseEvent);
    on<SaveEvent>(_onSaveEvent);

  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<CheckoutState> emit) async {
    try {
      model = event.data;
      bookingDetails = model?['bookingDetails'];
      checkOtuAttachmentPaths = List.from(bookingDetails?['bookingattachments'] ?? [])
          .where((e) =>['fuel_level_photo', 'interior_photo', 'exterior_photo', 'damages'].contains(e['label']))
          .map((e) => e['file_url'],).toList();
      emit(LoadingState());
      var tokenResponse = await _getToken();
      if(tokenResponse?['status'] == 200){
        token = tokenResponse?['data'];
        var response = await _checkOutValues(id: model?['rental_booking_id']);
        if(response?['success'] == true){
          checkOutValues = response?['data'];
          for (var element in checkOutValues) {
            element['isCheck'] = element['value'] != null;
            element['controller'] = TextEditingController();
            (element['controller'] as TextEditingController).text = element?['value'].toString() ?? '';
            if(element['children'] != null){
              element['children'].forEach((e) {
                e['isCheck'] = e['value'] != null;
                e['controller'] = TextEditingController();
                if(e['type'] != 'file') (e['controller'] as TextEditingController).text = e?['value'] ?? '';
                if(e['type'] == 'file'){
                  attachments = List.from(e['value'] ?? []);
                  attachmentPaths = attachments.map((e) => e['file_url']).toList();
                  fileNameController.text = attachments.lastOrNull?['path'] ?? '';
                }
              });
            }
          }
        }
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onParentCheckEvent(ParentCheckEvent event, Emitter<CheckoutState> emit) async {
    try {
      checkOutValues.where((element) => element['id'] == event.data['id'])
          .forEach((e) {
        e['isCheck'] = !(event.data['isCheck'] == true);
      });
        emit(CommonState());
      }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onChildCheckEvent(ChildCheckEvent event, Emitter<CheckoutState> emit) async {
    try {
      checkOutValues.where((element) => element['children'] != null).forEach((element) {
        List.from(element['children']).where((e) => e['id'] == event.data['id']).forEach((e) {
          e['isCheck'] = !(event.data['isCheck'] == true);
        });
      });
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onYesNoEvent(YesNoEvent event, Emitter<CheckoutState> emit) async {
    try {
      checkOutValues.where((element) => element['children'] != null).forEach((element) {
        List.from(element['children']).where((e) => e['id'] == event.data['id']).forEach((e) {
          e['value'] = /*event.data?['value'] != null
              ? (event.data['value'] == "true" ? "false" : "true")
              :*/ event.isYes == true ? "true" : "false";
        });
      });
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onDropdownEvent(DropdownEvent event, Emitter<CheckoutState> emit) async {
    try{
      checkOutValues.where((element) => element['children'] != null).forEach((element) {
        List.from(element['children']).where((e) => e['id'] == event.data['id']).forEach((e) {
          e['value'] = "${event.selectedData}";
        });
      });
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onFilePickerEvent(FilePickerEvent event, Emitter<CheckoutState> emit) async {
    var result = await _pickFiles();
    if (result.isNotEmpty) {
      var attachments = List.from(attachmentPaths);
      var existingAttachments = List.from(attachmentPaths)
          .whereType<File>()
          .map((e) => (e.path))
          .toList();
      for (var element in result) {
        if (!existingAttachments.contains(element.path)) {
          attachments.add(element);
        }
      }
      Console.of.log("$attachmentPaths", name: "PickImageEvent");
      attachmentPaths = attachments;
      fileNameController.text = basename(attachmentPaths.lastOrNull?.path ?? "");
      emit(CommonState());
    }
  }

  void _onDeleteImageEvent(DeleteImageEvent event, Emitter<CheckoutState> emit) async {
    try{
      var attachments = List.from(attachmentPaths);
      attachments.remove(event.data);
      attachmentPaths = attachments;
      fileNameController.text = basename((attachmentPaths.lastOrNull is File) ? (attachmentPaths.lastOrNull?.path) : (attachmentPaths.lastOrNull) ?? "");
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onApproveAndCloseEvent(ApproveAndCloseEvent event, Emitter<CheckoutState> emit) async {
    try{
      emit(ApproveAndCloseState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onSaveEvent(SaveEvent event, Emitter<CheckoutState> emit) async {
    try{
      emit(LoadingState());
      checkOutData(closeRide: event.isApprove == true ? 1 : 0);
      var input = checkOutData(closeRide: event.isApprove == true ? 1 : 0);
      var response = await _saveCheckOut(
          body: input['data'],
          id: model?['rental_booking_id'],
          file: input['files'],
      );
      if(response?['success'] == true){
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onError(Object e, Emitter<CheckoutState> emit){
    Console.of.log(e, name: 'error');
    emit(ErrorState(e.toString()));
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

  Map<String, dynamic> checkOutData({dynamic closeRide}){
    Map<String, dynamic> data = {};
    List<dynamic> imageList = [];
    imageList.addAll(attachments.map((e) => e['name']));
    imageList.addAll(List.from(attachmentPaths));
    imageList.removeWhere((element) =>
        attachments.any((e) => e['file_url'] == element));

    data['previous_entry'] = bookingDetails?['status_name'] == 'completed' ? 1 : 0;
    data['closing_ride'] = closeRide;
    int fullIndex = 0;
    List<Map<String, String?>> imageFiles = [];
    for (var element in checkOutValues) {
      if (element['controller'].text != null && element['controller'].text.isNotEmpty) {
        data['values[$fullIndex][checkout_field_id]'] = element['id'].toString();
        data['values[$fullIndex][value]'] = element['controller'].text;
        fullIndex++;
      }
      final children = List.from(element['children'] ?? []);
      if (children.isNotEmpty) {
        for (var child in children) {
          if (['currency', 'number', 'text'].contains(child['type']) &&
              child['controller'].text != null &&
              child['controller'].text.isNotEmpty) {
            data['values[$fullIndex][checkout_field_id]'] = child['id'].toString();
            data['values[$fullIndex][value]'] = child['controller'].text;
            fullIndex++;
          } else if (child['type'] == 'file') {
            var images = [
              ...imageList.whereType<File>().map((e) => e.path).toList(),
            ];
            Console.of.log(images, name: "bookingDetails");

            if(images.isNotEmpty || attachments.isNotEmpty){
              int imageIndex = 0;
              data['values[$fullIndex][checkout_field_id]'] = child['id'].toString();
              if(attachments.isNotEmpty){
                attachments.asMap().forEach((k, path) {
                  data['values[$fullIndex][value][$imageIndex]'] = jsonEncode(path);
                  imageIndex++;
                });
              }
            if (images.isNotEmpty) {
              images.asMap().forEach((i, img) {
                imageFiles.add({
                  'values[$fullIndex][value][$imageIndex]' : img,
                });
                imageIndex++;
              });
            }
              fullIndex++;
            }
          } else {
            if (child['value'] != null) {
              data['values[$fullIndex][checkout_field_id]'] = child['id'].toString();
              data['values[$fullIndex][value]'] = child['value'];
              fullIndex++;
            }
          }
        }
      }
    }


    Console.of.log(data, name: "checkOutData");
    return {"data" : data, "files" : imageFiles};
  }

}