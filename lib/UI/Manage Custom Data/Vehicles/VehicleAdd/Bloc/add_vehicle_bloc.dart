
import 'dart:developer';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_state.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVehicleBloc extends Bloc<AddVehicleEvent, AddVehicleState>{
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> cohort = [];
  List<Map<String, dynamic>> branch = [];
  List<Map<String, dynamic>> vehicleStatus = [];
  Map<int, bool> selectedVehicles = {};
  List<int> selectedIds = [];

  AddVehicleBloc() : super(AddVehicleLoadingState()){
    on<AddVehicleInitialEvent>((event, emit) async {
      emit(AddVehicleLoadingState());
      var response= await _getVehicle();
      cohort = response??[];
      branch = response??[];
      vehicleStatus = response??[];
      emit(AddVehicleLoadedState());
    });
  }

  Future<List<Map<String, dynamic>>?> _getVehicle() async {
    return await getIt<CommonService>().getActiveVehicles(reset: true);
  }

}
