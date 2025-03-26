
import 'dart:developer';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Bloc/vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Bloc/vehicle_state.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState>{
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  Map<int, bool> selectedVehicles = {};
  List<int> selectedIds = [];


  VehicleBloc() : super(VehicleLoadingState()){

    on<VehicleInitialEvent>((event, emit) async {
      emit(VehicleLoadingState());
     var response= await _getVehicle();
     response?.sort((a, b) => b['created_at'].compareTo(a['created_at']));
     apiResponse = response??[];
     filteredResponse = apiResponse;
      emit(VehicleLoadedState());
    });

    on<SearchVehicleEvent>((event, emit) {
      var searchQuery = event.query;
      if (searchQuery.isNotNullOrEmpty) {
        var response = apiResponse.where((element) =>
            element['vehicle_name'].toString().toLowerCase().contains(
                searchQuery.toString().toLowerCase())).toList();
        filteredResponse = response;
        emit(VehicleCommonState());
      }
      else {
        filteredResponse = apiResponse;
        emit(VehicleLoadedState());
      }
    });

    on<SelectedVehicleEvent>((event, emit) {
      final updatedSelectedVehicles = Map<int, bool>.from(selectedVehicles);
      final updatedSelectedIds = List<int>.from(selectedIds);
      updatedSelectedVehicles[event.vehicleId] = event.isSelected;
      if (event.isSelected) {
        if (!updatedSelectedIds.contains(event.vehicleId)) {
          updatedSelectedIds.add(event.vehicleId);
        }
      } else {
        updatedSelectedIds.remove(event.vehicleId);
      }
      selectedVehicles = updatedSelectedVehicles;
      selectedIds = updatedSelectedIds;
      emit(VehicleCommonState());
    });

    on<VehicleDeleteEvent>((event, emit) async {
      emit(VehicleLoadingState());
      var response = await _apiRepository.deleteActiveVehicle(event.vehicleId);
      if (response != null) {
        apiResponse.removeWhere((element) => element['id'] == event.vehicleId);
        filteredResponse = apiResponse;
        emit(VehicleCommonState());
      }
      emit(VehicleLoadedState());
    });

    on<MoveToPrivateRentalEvent>((event, emit) async {
      try {
        emit(VehicleLoadingState());
        var response = await _apiRepository.moveVehicleToPrivateRental(
            rentalData: event.vehicleData);
        log(response.toString(), name: "VehicleBloc");
        if (response?['data'] != null) {
          var existResponse = filteredResponse.map((e) {
            if (e['id'] == event.vehicleData['id']) {
              return e
                ..['rental_status'] = (int.tryParse(
                    "${response?['data']['rental_status']}") ?? 0);
            } else {
              return e;
            }
          }).toList();
          filteredResponse = existResponse;
          emit(VehicleCommonState());
        }
        emit(VehicleLoadedState());
      } catch (e) {
        emit(VehicleLoadedState());
        log("$e", name: "VehicleBloc");
      }
    });


  }

  Future<List<Map<String, dynamic>>?> _getVehicle() async {
    return await getIt<CommonService>().getActiveVehicles(reset: true);
  }

}
