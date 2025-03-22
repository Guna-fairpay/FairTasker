import 'dart:async';

import 'package:fairpytasker/UI/dialog/tasker_vehicls_dialog_bloc/tasker_vehicles_persons_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicls_dialog_bloc/tasker_vehicles_persons_dialog_states.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVPDBloc extends Bloc<TVPDEvents, TVPDStates> {
  List<Map<String, dynamic>> vehicles = [];
  List<Map<String, dynamic>> groupVehicles = [];
  List<Map<String, dynamic>> persons = [];
  List<Map<String, dynamic>> selectedVehicles = [];
  Map<String, dynamic>? selectedModel;
  final TextEditingController controller = TextEditingController();
  TVPDBloc() : super(TVPDLoadingState()) {
    on<TVPDInitialEvent>(_onInitialEvent);
    on<TVPDSelectedEvent>(_onSelectedEvent);
    on<TVPDDeleteEvent>(_onDeleteEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchVehicles() async => await getIt<CommonService>().getActiveVehicles();
  Future<List<Map<String, dynamic>>> _fetchGroupVehicles() async => await getIt<CommonService>().groupVehicles();
  Future<List<Map<String, dynamic>>> _fetchPersons() async => await getIt<CommonService>().getUsers();

  void _onInitialEvent(TVPDInitialEvent event, Emitter<TVPDStates> emit) async {
    Console.of.log("Initial Event");
    selectedModel = event.data;
    var response = await Future.wait([_fetchVehicles(), _fetchGroupVehicles(), _fetchPersons()]);
    vehicles = response[0];
    groupVehicles = response[1];
    persons = response[2];
    selectedVehicles = CustomSearchDataConverter.convertVPerson(vehicles: selectedModel?['display']?['vehicles']);
    Console.of.log(selectedVehicles);
    emit(TVPDCommonState());
  }

  void _onSelectedEvent(TVPDSelectedEvent event, Emitter<TVPDStates> emit) {
    var model = event.data?.lastOrNull;
    var ids = [model?['id']];
    if ((model?['type'].toString() != "vehicles") || ((model?['type'] == "vehicles") && !(selectedVehicles.map((e) => e['type']).contains("vehicles")))) selectedVehicles.clear();
    if (!selectedVehicles.any((element) => ids.contains(element['id']))) selectedVehicles.add(model ?? {});
    emit(TVPDCommonState());
  }

  void _onDeleteEvent(TVPDDeleteEvent event, Emitter<TVPDStates> emit) {
    var model = event.data;
    if ((selectedVehicles.length == 1) && (selectedVehicles.contains(model))) selectedVehicles.clear();
    selectedVehicles.remove(model);
    Console.of.debug(selectedVehicles.length);
    emit(TVPDCommonState());
  }
}