

import 'dart:developer';

import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../Repository/api_repository.dart';
import '../../../Utilities/Str.dart';
import '../../../data/api_client.dart';
import 'odometer_event.dart';
import 'odometer_repository.dart';
import 'odometer_state.dart';

class OdometerBloc extends Bloc<OdometerEvent, OdometerState>{
  final OdometerRepo odometerRepo = OdometerRepo();
  ApiClient apiClient = ApiClient();
  final APiRepository _aPiRepository = APiRepository();
  TextEditingController oilChangeController = TextEditingController();
  TextEditingController nextMilesCheckController = TextEditingController(text: 5000.toString());
  TextEditingController nextOdometerController = TextEditingController(text: 5000.toString());


  dynamic odometerData;
  OdometerBloc() : super(const OdometerState(
      vehicle: {},
      todoItems: {},
      selectedVehicle: null))
  {
    oilChangeController.addListener(_updateNextOdometer);
    nextMilesCheckController.addListener(_updateNextOdometer);
    Future<Map<String, dynamic>?> _getToDoOdometer({required dynamic todoId}) async => await _aPiRepository.getTodoOdometer(toDoId: todoId);

    on<OdometerInitialEvent>((event, emit) async {
      try{
        emit(state.copyWith(isLoading: true));
        final response = await odometerRepo.getPreviousOdometer(
            event.todoItems['todo_date'].toString(),
          event.todoItems['identifier_id'],
          event.vehicle['vin'].toString()
        );
        var response1 = await _getToDoOdometer(todoId: event.todoItems['id']);
        log("response1: ${response1}", name: "odometer_data");
        log("response1: ${response1?['data']['current_odometer']}", name: "odometer_data");
        log("response1: ${response1?['data']['next_miles_check']}", name: "odometer_data");
        log("response1: ${response1?['data']['next_odometer']}", name: "odometer_data");

        if(response1 != null){
          oilChangeController.text = "${response1['data']['current_odometer']}";
          nextMilesCheckController.text = "${response1['data']['next_miles_check']}";
          nextOdometerController.text = "${response1['data']['next_odometer']}";
        }
        emit(state.copyWith(
          isLoading: false,
          odometerData: response?.data ?? [],
        ));
      }
      catch (e) {
        emit(state.copyWith(isLoading: false));
        log("OdometerInitialEvent.exception : ${e.toString()}");
      }
    });


    on<OdometerSaveEvent>((event, emit) async {
      try{
        emit(state.copyWith(isLoading: true));
        final response = await odometerRepo.addToDoOdometer(
          toDoId: event.toDoId,
          currentOdometer: event.currentOdometer,
          nextOdometer: event.nextOdometer,
          nextMilesCheck: event.nextMilesCheck,);
        emit(state.copyWith(isLoading: false));
      }
      catch (e) {
        emit(state.copyWith(isLoading: false));
        log("OdometerSaveEvent.exception : ${e.toString()}");
      }
    });



  }

  void _updateNextOdometer() {
    final oilChange = num.tryParse(oilChangeController.text) ?? 0;
    final nextMiles = num.tryParse(nextMilesCheckController.text) ?? 0;
    final nextOdometer = oilChange + nextMiles;

    nextOdometerController.text =
    nextOdometer > 0 ? nextOdometer.toString() : '';
  }



}



/* Future<PreviousOdometer?> getPreviousOdometer(String? todoDate, int? identifierId, String? vin) async {
    try {
      String apiUrl = "${Str.BASE_URL}getPreviousOdometer?todo_date=$todoDate&identifier_id=$identifierId&vin=$vin";
      debugPrint("getPreviousOdometer apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        debugPrint('getPreviousOdometer api.response.body: ${response.body}');
        debugPrint('getPreviousOdometer api.statusCode: ${response.statusCode}');
        PreviousOdometer previousOdometer = PreviousOdometer.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return previousOdometer;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getPreviousOdometer.exception : ${error.toString()}');
      return null;
    }
  }*/