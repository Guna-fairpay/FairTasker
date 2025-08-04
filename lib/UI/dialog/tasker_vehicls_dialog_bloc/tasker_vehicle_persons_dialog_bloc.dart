import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicls_dialog_bloc/tasker_vehicles_persons_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicls_dialog_bloc/tasker_vehicles_persons_dialog_states.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVPDBloc extends Bloc<TVPDEvents, TVPDStates> {
  List<Map<String, dynamic>> _vehicles = [];
  List<Map<String, dynamic>> groupVehicles = [];
  List<Map<String, dynamic>> _persons = [];
  List<Map<String, dynamic>> selectedVehicles = [];
  Map<String, dynamic>? selectedModel;
  final TextEditingController controller = TextEditingController();
  int? get _branchId => Session.of.getInt(Str.branchIdPrefText);
  TVPDBloc() : super(TVPDLoadingState()) {
    on<TVPDInitialEvent>(_onInitialEvent);
    on<TVPDSelectedEvent>(_onSelectedEvent);
    on<TVPDDeleteEvent>(_onDeleteEvent);
  }

  List<Map<String, dynamic>> get persons {
    List<Map<String, dynamic>> resources = List.from(getIt<CommonService>().resourcesList);
    resources.removeWhere((resource) =>
    ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
        (resource['branch_id'] !=
            _branchId)) ||
        (resource['deleted_at'] != null));
    return resources;
  }

  List<Map<String, dynamic>> get vehicles => getIt<CommonService>().activeVehicleList.where((element) => element['branch_code'] == _branchId).toList();

  List<Map<String, dynamic>> get _selectedValues {
    var selectedVehicle = selectedModel?['display']?['vehicles'];
    var selectedPersons = (selectedModel?['display']?['personId'].toString().isNotNullOrEmpty ?? false) ? persons.where((element) => element['id'].toString() == selectedModel?['display']?['personId']).toList() : [];
    var selectedGroupVehicles = (selectedModel?['display']?['vehicleGroupId'].toString().isNotNullOrEmpty ?? false) ? groupVehicles.where((element) => element['id'] == selectedModel?['display']?['vehicleGroupId']).toList() : [];
    return CustomSearchDataConverter.convertVPerson(vehicles: selectedVehicle, groupVehicles: selectedGroupVehicles, persons: selectedPersons);
  }

  Map<String, dynamic>? _removeExisting(Map<String, dynamic>? model) {
    Console.of.log("Removing_Model $model");
    var _vehicles = selectedModel?['display']?['vehicles'];
    var _persons = (selectedModel?['display']?['personId'].toString().isNotNullOrEmpty ?? false) ? persons.where((element) => element['id'].toString() == selectedModel?['display']?['personId']).toList() : [];
    var _groupVehicles = (selectedModel?['display']?['vehicleGroupId'].toString().isNotNullOrEmpty ?? false) ? groupVehicles.where((element) => element['id'] == selectedModel?['display']?['vehicleGroupId']).toList() : [];
    if (model?['type'] == 'vehicles') {
      var vin = model?['value']?['vin'];
      _vehicles.removeWhere((element) => element['id'] == model?['id']);
      selectedModel?['display']?['vehicles'] = _vehicles;
      var result = List.from(selectedModel?['vehicles']).firstWhereOrNull((element) => element['vin'] == vin);
      List.from(selectedModel?['vehicles']).removeWhere((element) => element['vin'] == vin);
      return result;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> _fetchVehicles() async => await getIt<CommonService>().getActiveVehicles();
  Future<List<Map<String, dynamic>>> _fetchGroupVehicles() async => await getIt<CommonService>().groupVehicles();
  Future<List<Map<String, dynamic>>> _fetchPersons() async => await getIt<CommonService>().getResources();

  void _onInitialEvent(TVPDInitialEvent event, Emitter<TVPDStates> emit) async {
    Console.of.log("Initial Event");
    emit(TVPDLoadingState());
    selectedModel = event.data;
    Console.of.log(selectedModel);
    var response = await Future.wait([_fetchVehicles(), _fetchGroupVehicles(), _fetchPersons()]);
    _vehicles = response[0].where((element) => element['branch_code'] == _branchId).toList();
    groupVehicles = response[1];
    _persons = response[2].where((element) => element['branch_id'] == _branchId).toList();
    selectedVehicles = _selectedValues;
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
    Console.of.debug(model);
    var removedModel = _removeExisting(model);
    emit(TVPDDeleteState(model: removedModel));
  }
}