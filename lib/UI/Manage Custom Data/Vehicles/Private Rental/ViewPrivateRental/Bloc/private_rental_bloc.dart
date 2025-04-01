
import 'dart:developer';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_state.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivateRentalBloc extends Bloc<PrivateRentalEvent, PrivateRentalState>{
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  List<int> selectedIds = [];
  final FBroadcast _broadcast = FBroadcast.instance();

  PrivateRentalBloc() : super(PrivateRentalLoadingState()){

    _registerBroadcast();

    on<PrivateRentalInitialEvent>((event, emit) async {
      /*try{
        emit(PrivateRentalLoadingState());
        var response = await _getPrivateRentalVehicle();
        apiResponse =List.from(response?['vehicles'] ?? []);
        filteredResponse.clear();
        filteredResponse = apiResponse;
        emit(PrivateRentalLoadedState());
      }catch(e){
        Toaster.showError(e.toString());
        emit(PrivateRentalLoadedState());
        log(e.toString(), name: "PrivateRentalBloc");
      }*/
      reFitchData();
    });

    on<SearchPrivateRentalEvent>((event, emit) {
      var searchQuery = event.query;
      if (searchQuery.isNotNullOrEmpty) {
        var response = apiResponse.where((element) =>
            element['vehicle_name'].toString().toLowerCase().contains(
                searchQuery.toString().toLowerCase())).toList();
        filteredResponse = response;
        emit(PrivateRentalCommonState());

      }
      else {
        filteredResponse = apiResponse;
        emit(PrivateRentalLoadedState());
      }
    });

    on<DeletePrivateRentalEvent>((event, emit) async {
      emit(PrivateRentalLoadingState());
      var response = await _apiRepository.deleteActiveVehicle(event.vehicleId);
      if (response != null) {
        apiResponse.removeWhere((element) => element['id'] == event.vehicleId);
        filteredResponse = apiResponse;
        emit(PrivateRentalCommonState());
      }
      emit(PrivateRentalLoadedState());
    });

    on<AddPrivateRentalEvent>((event, emit) async {
      emit(AddPrivateRentalState(rentalData: event.vehicleData));
    });

    on<EditPrivateRentalEvent>((event, emit) async {
      emit(EditPrivateRentalState(rentalData: event.rentalData));
    });

  }

  ///PRIVATE RENTAL VEHICLE API CALL
  Future<Map<String, dynamic>?> _getPrivateRentalVehicle() async =>
      await _apiRepository.getPrivateRentalVehicleList();

  void reFitchData() async{
    try{
      emit(PrivateRentalLoadingState());
      var response = await _getPrivateRentalVehicle();
      apiResponse =List.from(response?['vehicles'] ?? []);
      filteredResponse.clear();
      filteredResponse = apiResponse;
      emit(PrivateRentalLoadedState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(PrivateRentalLoadedState());
      log(e.toString(), name: "PrivateRentalBloc");
    }
  }

  void _registerBroadcast() {
    _broadcast.register("PR_refresh", (value, callback) {
      Console.of.log("PR_refresh");
      reFitchData();
    });
  }

}
