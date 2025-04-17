
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/tasker_parts_supplies_dialog_bloc/tasker_parts_supplies_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_parts_supplies_dialog_bloc/tasker_parts_supplies_dialog_states.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TPSDBloc extends Bloc<TPSDEvents, TPSDStates> {
  bool? isParts;
  Map<String, dynamic>? model;
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> selectedPartsList = [];
  List<dynamic> modelIdsData = [];
  TextEditingController controller = TextEditingController();
  final APiRepository _apiRepository = APiRepository();
  TPSDBloc() : super(TPSDLoadingState()) {
    on<TPSDInitialEvent>(_onInitialEvent);
    on<TPSDSelectedEvent>(_onSelectedEvent);

  }

  Future<List<Map<String, dynamic>>> _fetchParts() async => await getIt<CommonService>().getPartsList();
  Future<List<Map<String, dynamic>>> _fetchSupplies() async => await getIt<CommonService>().getSuppliesList();
  Future<Map<String, dynamic>?> _deleteParts(dynamic id) async => await _apiRepository.deleteVehicleParts(id: id);
  Future<Map<String, dynamic>?> _deleteSupplies(dynamic id) async => await _apiRepository.deleteSupplies(id: id);

  List<dynamic> get modelIds {
    var modelParts = List<Map<String, dynamic>>.from(model?['parts'] ?? []).map((e) => e['parts_id']).toList();
    var modelSupplies = List<Map<String, dynamic>>.from(model?['supplies'] ?? []).map((e) => e['supplies_id']).toList();
    return (isParts ?? false) ? modelParts : modelSupplies;
  }

  dynamic _getSelectedId(dynamic id) {
    var modelParts = List<Map<String, dynamic>>.from(model?['parts'] ?? []).lastWhereOrNull((element) => element['parts_id'].toString() == id.toString());
    var modelSupplies = List<Map<String, dynamic>>.from(model?['supplies'] ?? []).lastWhereOrNull((e) => e['supplies_id'].toString() == id.toString());
    return ((isParts ?? false) ? modelParts : modelSupplies)?['id'];
  }

  void _onInitialEvent(TPSDInitialEvent event, Emitter<TPSDStates> emit) async {
    try {
      emit(TPSDLoadingState());
      isParts = event.isParts;
      model = event.model;
      apiResponse = (isParts ?? false) ? await _fetchParts() : await _fetchSupplies();
      var modelParts = List<Map<String, dynamic>>.from(model?['parts'] ?? []).map((e) => e['parts_id']).toList();
      var modelSupplies = List<Map<String, dynamic>>.from(model?['supplies'] ?? []).map((e) => e['supplies_id']).toList();
      modelIdsData = (isParts ?? false) ? modelParts : modelSupplies;
      if (isParts ?? false) {
        selectedPartsList = apiResponse.where((element) => modelParts.contains(element['id'].toString())).toList();
      } else {
        selectedPartsList = apiResponse.where((element) => modelSupplies.contains(element['id'].toString())).toList();
      }
      emit(TPSDCommonState());
    } on Exception catch (e) {
      emit(TPSDErrorState(e));
    }
  }

  void _onSelectedEvent(TPSDSelectedEvent event, Emitter<TPSDStates> emit) async {
    if (event.isChecked) {
      if (!selectedPartsList.contains(event.value)) selectedPartsList.add(event.value);
    } else {
      selectedPartsList.remove(event.value);
      bool isOld = modelIds.contains(event.value['id'].toString());
      if (isOld) {
        var id = _getSelectedId(event.value['id']);
        await ((isParts ?? false) ? _deleteParts(id) : _deleteSupplies(id));
      } else {
        Console.of.log("NEW_DATA_REMOVING");
      }
    }
    emit(TPSDCommonState());
  }
}