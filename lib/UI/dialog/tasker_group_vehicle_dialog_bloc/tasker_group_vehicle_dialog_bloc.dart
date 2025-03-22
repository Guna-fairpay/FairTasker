import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/tasker_group_vehicle_dialog_bloc/tasker_group_vehicle_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_group_vehicle_dialog_bloc/tasker_group_vehicle_dialog_states.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TGVDBloc extends Bloc<TGVDEvents, TGVDStates> {
  Map<String, dynamic>? model;
  List<Map<String, dynamic>>? vehicles;
  List<Map<String, dynamic>>? groupVehicles;
  List<Map<String, dynamic>>? selectedVehicles;
  dynamic groupId;
  Map<String, dynamic>? selectedGroup;
  List<String> existingVins = [];
  final APiRepository _aPiRepository = APiRepository();
  TGVDBloc() : super(TGVDLoadingStates()) {
    on<TGVDInitialEvent>(_onInitialEvent);
    on<TGVDeleteVehicleEvent>(_onDeleteVehicle);
    on<TGVDAddVehicleEvent>(_onAddVehicle);
    on<TGVDSubmitEvent>(_onSubmitEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchGroupVehicles() async => await getIt<CommonService>().groupVehicles(reset: true);
  Future<List<Map<String, dynamic>>> _fetchVehicles() async => await getIt<CommonService>().getActiveVehicles();
  Future<Map<String, dynamic>?> _updateGroupVehicles(Map<String, dynamic> body) async => await _aPiRepository.updateGroupVehicle(groupId: groupId, body: body);

  void _onInitialEvent(TGVDInitialEvent event, Emitter<TGVDStates> emit) async {
    try {
      model = event.model;
      groupId = model?['vehicle_group_id'];
      emit(TGVDLoadingStates());
      await _fetchDatas();
      emit(TGVDCommonState());
    } catch (e) {
      emit(TGVDErrorStates(e));
    }
  }

  Future<void> _fetchDatas() async {
    var response = await Future.wait([
      _fetchGroupVehicles(),
      _fetchVehicles()
    ]);
    groupVehicles = response[0];
    vehicles = response[1];
    selectedGroup = groupVehicles?.firstWhereOrNull((element) => element['id'] == groupId);
    String? groupVins = groupVehicles?.firstWhereOrNull((element) => element['id'] == groupId)?['vin'];
    existingVins = List<String>.from(jsonDecode(groupVins ?? ""));
    existingVins = existingVins.toSet().toList();
    selectedVehicles = vehicles?.where((element) => existingVins.contains(element['vin'])).toList();
  }

  void _onAddVehicle(TGVDAddVehicleEvent event, Emitter<TGVDStates> emit) {
    if (selectedVehicles?.contains(event.model) == false) {
      selectedVehicles?.add(event.model ?? {});
      emit(TGVDCommonState());
    }
  }

  void _onDeleteVehicle(TGVDeleteVehicleEvent event, Emitter<TGVDStates> emit) {
    if (selectedVehicles?.contains(event.model) ?? false) {
      selectedVehicles?.remove(event.model ?? {});
      emit(TGVDCommonState());
    }
  }

  void _onSubmitEvent(TGVDSubmitEvent event, Emitter<TGVDStates> emit) async {
    try {
      emit(TGVDLoadingStates());
      Map<String, dynamic> body = {
        "name" : selectedGroup?['name'],
        "vin" : selectedVehicles?.map((e) => e['vin']).toList() ?? []
      };
      var response = await _updateGroupVehicles(body);
      if (response != null) await _fetchDatas();
      emit(TGVDCommonState());
    } catch (e) {
      emit(TGVDErrorStates(e));
    }
  }
}