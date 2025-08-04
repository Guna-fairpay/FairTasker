

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_notes_page/Bloc/vehicle_notes_event.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_notes_page/Bloc/vehicle_notes_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleNotesBloc extends Bloc<VehicleNotesEvent, VehicleNotesState> {

  final APiRepository _apiRepository = APiRepository();
  List<Map<String, dynamic>> notesData = [];
  List<Map<String, dynamic>> userList = [];
  TextEditingController notesController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  String? vin;
  String? userId;
  bool isEdit = false;
  String? editId;

  VehicleNotesBloc() : super(VehicleNotesLoadingState()) {

    Utils.getStringPreference(Str.userIdPrefText).then((id) {
      userId = id;
    });
    
    on<GetVehicleNotesData>((event, emit) async {
      try {
        vin = event.vin;
        reFitchData();
        // emit(VehicleNotesLoadingState());

        // var response = await _getVehicleNotes(vin: vin);
        // var usersList = await getIt<CommonService>().getUsers();
        // notesData = List.from(response?['data'] ?? []);
        // userList = usersList;
        // Map<String,dynamic> owner={'id':1,'first_name':'Product','last_name':'Owner'};
        // userList.add(owner);
        // notesData = notesData.map((e) => e..['user'] = usersList.firstWhereOrNull((element) => element['id'] == (e['updated_by'].toString().isNullOrEmpty ? e['created_by'] : e['updated_by']))).toList();
        // emit(VehicleNotesLoadedState());
      } catch (e) {
        emit(VehicleNotesLoadedState());
        Toaster.showError(e);
      }
    });

    on<DatePickEvent>((event, emit) {
      selectedDate = event.selectedDate;
      emit(VehicleNotesCommonState());
    });

    on<SaveNotesEvent>((event, emit) async {
      try {
        emit(VehicleNotesLoadingState());
        var response = await _apiRepository.saveVehicleNotes(
          vin: event.vin, body: body(),
        );
      if (response?['status'] == 1) {
        reFitchData();
        notesController.clear();
        dateController.clear();
        selectedDate = null;
        Toaster.showSuccess(response?['message'] ?? []);
       // emit(VehicleNotesCommonState());
      }else{
        Toaster.showError(response?['message'] ?? []);
        emit(VehicleNotesCommonState());
      }
    } catch (e) {
      Toaster.showError("$e");
      log(e.toString(), name: 'ERROR');
      emit(VehicleNotesCommonState());
    }
    });

    on<DeleteNotesEvent>((event, emit) async {
      try {
        emit(VehicleNotesLoadingState());
        var response = await _apiRepository.deleteNote(event.id,);
        if (response?['status'] == 1) {
          notesData.removeWhere((element) => element['id'].toString() == event.id);
          Toaster.showSuccess(response?['message'] ?? []);
          emit(VehicleNotesCommonState());
        }
        else{
          Toaster.showError(response?['message'] ?? []);
          emit(VehicleNotesCommonState());
        }
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(VehicleNotesCommonState());
      }
    });

    on<UpdateNotesEvent>((event, emit) async {
      try {
        emit(VehicleNotesLoadingState());
        Map<String, String> baseBody = body();
        baseBody.removeWhere((key, value) => key == 'created_by');
        var response = await _apiRepository.updateVehicleNotes(id: editId, body: body());
        if (response?['status'] == 1) {
          isEdit = false;
          reFitchData();
          notesController.clear();
          dateController.clear();
          selectedDate = null;
          Toaster.showSuccess(response?['message'] ?? []);
          emit(VehicleNotesCommonState());
         }
        else{
          Toaster.showError(response?['message'] ?? []);
          emit(VehicleNotesCommonState());
        }
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(VehicleNotesCommonState());
      }
    });

    on<UpdateNotesIsPressedEvent>(( event, emit) async {
      editId = event.editData['id'].toString();
      isEdit = true;
      notesController.text = event.editData['note'];
      dateController.text = event.editData['followup_date']??'';
      selectedDate = (event.editData['followup_date'] != null? (event.editData['followup_date']).toString().toDateTime(inputFormat: 'yyyy-MM-dd'):null) ;
      emit(VehicleNotesCommonState());
    });

    on<UpdateNotesIsCancelledEvent>((event, emit) async {
      isEdit = false;
      notesController.clear();
      dateController.clear();
      selectedDate = null;
      emit(VehicleNotesCommonState());
    });

  }

  Map<String, String> body() {
    Map<String, String> baseBody = {};
    baseBody['note'] = notesController.text;
    baseBody['followup_date'] = selectedDate?.toFormat(format: 'yyyy-MM-dd')??'';
    baseBody['updated_by'] = userId ?? '';
    baseBody['created_by'] = userId ?? '';
    return baseBody;
  }

  void reFitchData() async{
    emit(VehicleNotesLoadingState());
    var response = await _getVehicleNotes(vin: vin);
    var usersList = await getIt<CommonService>().getUsers();
    notesData = List.from(response?['data'] ?? []);
    userList = usersList;
    Map<String,dynamic> owner={'id':1,'first_name':'Product','last_name':'Owner'};
    userList.add(owner);
    notesData = notesData.map((e) => e..['user'] = usersList.firstWhereOrNull((element) => element['id'] == (e['updated_by'].toString().isNullOrEmpty ? e['created_by'] : e['updated_by']))).toList();
    emit(VehicleNotesCommonState());
  }

  ///EDIT VEHICLE NOTES API CALL
  Future<Map<String, dynamic>?> _getVehicleNotes({String? vin}) async => await _apiRepository.getVehicleNotes(vin: vin);

}
