import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/tasker_rental_complete_dialog_bloc/tasker_rental_complete_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_rental_complete_dialog_bloc/tasker_rental_complete_dialog_states.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker;

class TRCDBloc extends Bloc<TRCDEvents, TRCDStates> {
  Map<String, dynamic>? model;
  bool isCheckOut = false;
  final APiRepository _aPiRepository = APiRepository();
  Map<String, dynamic>? previousOdometer;
  bool showAdditionalDistance = false, showOtherMaintenance = false, isMoveToRepair = false, isBlockCalendar = false;
  List<String> selectedCheckboxes = [];
  String? selectedCleaningNeed = "Light Clean";
  bool showPreviousOdometerValue = false;
  dynamic previousOdometerValue;
  TextEditingController odometerController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController additionalDistanceController = TextEditingController();
  TextEditingController otherMaintenanceController = TextEditingController();
  List<File> mileageAttachments = [], notesAttachments = [];
  TRCDBloc() : super(TRCDLoadingState()) {
    on<TRCDSubmitEvent>(_onSubmitEvent);
    on<TRCDInitialEvent>(_onTRCDInitialEvent);
    on<TRCDMoveToRepairEvent>(_onTRCDMoveToRepairEvent);
    on<TRCDBlockCalendarEvent>(_onTRCDBlockCalendarEvent);
    on<TRCDNotesImagePickEvent>(_onTRCDNotesImagePickEvent);
    on<TRCDMileageImagePickEvent>(_onTRCDMileageImagePickEvent);
    on<TRCDPostCheckOutCheckEvent>(_onTRCDPostCheckOutCheckEvent);
    on<TRCDNotesAttachmentViewEvent>(_onTRCDNotesAttachmentViewEvent);
    on<TRCDVehicleCleaningNeedEvent>(_onTRCDVehicleCleaningNeedEvent);
    on<TRCDMileageAttachmentViewEvent>(_onTRCDMileageAttachmentViewEvent);
    on<TRCDRemoveAttachmentEvent>(_onTRCDRemoveAttachmentEvent);
  }

  Future<Map<String, dynamic>?> _fetchPreviousOdometer({required String date, required dynamic vin, required dynamic identifierId}) async => await _aPiRepository.getPreviousOdometer(date: date, vin: vin, identifierId: identifierId);

  Future<Map<String, dynamic>?> _completeToDo({required dynamic todoId, required Map<String, dynamic> body, required List<Map<String, String?>> infusedFiles}) async => await _aPiRepository.completeTodoWithAttachments(todoId: todoId, body: body, infusedFiles: infusedFiles);


  void _onTRCDInitialEvent(TRCDInitialEvent event, Emitter<TRCDStates> emit) async {
    try {
      model = event.model;
      isCheckOut = event.isCheckOut;
      var vin = List<String>.from(model?['display']?['vins']).lastOrNull;
      var date = model?['todo_date'];
      var identifierId = model?['identifier_id'];
      emit(TRCDLoadingState());
      previousOdometer = await _fetchPreviousOdometer(date: date, vin: vin, identifierId: identifierId);
      previousOdometerValue = previousOdometer?['data'] ?? 0;
      showPreviousOdometerValue = (previousOdometerValue != 0);
      emit(TRCDCommonState());
    } catch (e) {
      emit(TRCDErrorState(message: e));
    }
  }

  void _onTRCDMoveToRepairEvent(TRCDMoveToRepairEvent event, Emitter<TRCDStates> emit) {
    isMoveToRepair = event.value;
    emit(TRCDCommonState());
  }

  void _onTRCDBlockCalendarEvent(TRCDBlockCalendarEvent event, Emitter<TRCDStates> emit) {
    isBlockCalendar = event.value;
    emit(TRCDCommonState());
  }

  void _onTRCDMileageImagePickEvent(TRCDMileageImagePickEvent event, Emitter<TRCDStates> emit) async {
    var files = await _pickFiles();
    if (files != null) {
      mileageAttachments.addAll(files);
      mileageAttachments = mileageAttachments.toUnique();
      emit(TRCDCommonState());
    }
  }

  void _onTRCDNotesImagePickEvent(TRCDNotesImagePickEvent event, Emitter<TRCDStates> emit) async {
    var files = await _pickFiles();
    if (files != null) {
      notesAttachments.addAll(files);
      notesAttachments = notesAttachments.toUnique();
      emit(TRCDCommonState());
    }
  }

  void _onTRCDPostCheckOutCheckEvent(TRCDPostCheckOutCheckEvent event, Emitter<TRCDStates> emit) {
    if (selectedCheckboxes.contains(event.selected)) {
      selectedCheckboxes.remove(event.selected);
    } else {
      selectedCheckboxes.add(event.selected);
    }
    showAdditionalDistance = selectedCheckboxes.contains("Additional Distance");
    showOtherMaintenance = selectedCheckboxes.contains("Other maintenance");
    emit(TRCDCommonState());
  }

  void _onTRCDVehicleCleaningNeedEvent(TRCDVehicleCleaningNeedEvent event, Emitter<TRCDStates> emit) {
    selectedCleaningNeed = event.selected;
    emit(TRCDCommonState());
  }

  Map<String, String> _completeTask() {

    Map<String, String> body = {
      "odour" : selectedCheckboxes.contains("Remove Smell") ? "Remove Smell" : "",
      "clean_required" : "$selectedCleaningNeed",
      "charge" : showAdditionalDistance ? additionalDistanceController.text : "",
      "otherNotes" : showOtherMaintenance ?  otherMaintenanceController.text : "",
      "cleanTaskStatus" : "0",
      "mileage" : odometerController.text,
      "comments" : notesController.text,
      "status" : "true",
      "complete_time_taken" : model?['complete_time_taken'] ?? "",
      "complete_time_approved" : "${model?['complete_time_approved'] ?? 1}",
      "postCheckout[maintanence]" : "${selectedCheckboxes.contains("Other maintenance")}",
      "postCheckout[refuel]" : "${selectedCheckboxes.contains("Refuel")}",
      "postCheckout[remove_strains]" : "${selectedCheckboxes.contains("Remove Strains")}",
      "postCheckout[additional_distance]" : "${selectedCheckboxes.contains("Additional Distance")}",
      "postCheckout[oil_change]" : "${selectedCheckboxes.contains("Oil Change required")}",
      "postCheckout[bad_brakes]" : "${selectedCheckboxes.contains("Bad Brakes")}",
      "postCheckout[check_engine_lights]" : "${selectedCheckboxes.contains("Check Engine light")}",
      "postCheckout[low_tire_pressure]" : "${selectedCheckboxes.contains("Low tire pressure")}",
    };
    if (isCheckOut) {
      body['postCheckout[block_calendar]'] = "$isBlockCalendar";
      body['postCheckout[MoveRepair]'] = "$isMoveToRepair";
    }

    return body;
  }

  Future<List<File>?> _pickFiles() async {
    var result = await ImagePicker().pickMultiImage();
    return result.map((e) => File(e.path)).toList();
  }

  void _onSubmitEvent(TRCDSubmitEvent event, Emitter<TRCDStates> emit) async {
    try {
      if (odometerController.text.trim().isEmpty || ((num.tryParse(odometerController.text) ?? 0) <= 0) || (num.tryParse(odometerController.text) ?? 0) < (previousOdometerValue ?? 0)) {
        emit(TRCDErrorState(message: "Please enter a valid mileage"));
      } else {
        var mapData = _completeTask();
        List<Map<String, String?>> infusedFiles = [
          ...mileageAttachments.map((e) => {"mileage_image" : e.path}),
          ...notesAttachments.map((e) => {"note_images" : e.path})
        ];
        emit(TRCDLoadingState());
        var response = await _completeToDo(todoId: model?['id'], body: mapData, infusedFiles: infusedFiles);
        if (response != null) {
          Console.of.log(response);
          emit(TRCDCompletedState());
        } else {
          Console.of.log(response);
          emit(TRCDErrorState(message: "Something went wrong"));
        }
      }
    } catch (e) {
      emit(TRCDErrorState(message: e));
    }
  }

  void _onTRCDNotesAttachmentViewEvent(TRCDNotesAttachmentViewEvent event, Emitter<TRCDStates> emit) {
    emit(TRCDShowAttachmentState(attachments: notesAttachments, type: "notes"));
  }

  void _onTRCDMileageAttachmentViewEvent(TRCDMileageAttachmentViewEvent event, Emitter<TRCDStates> emit) {
    emit(TRCDShowAttachmentState(attachments: mileageAttachments, type: "mileage"));
  }

  void _onTRCDRemoveAttachmentEvent(TRCDRemoveAttachmentEvent event, Emitter<TRCDStates> emit) {
    if (event.type == "notes") {
      notesAttachments.remove(event.attachment);
    } else {
      mileageAttachments.remove(event.attachment);
    }
    emit(TRCDCommonState());
  }
}