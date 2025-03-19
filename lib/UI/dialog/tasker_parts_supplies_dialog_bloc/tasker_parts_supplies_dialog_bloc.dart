
import 'package:fairpytasker/UI/dialog/tasker_parts_supplies_dialog_bloc/tasker_parts_supplies_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_parts_supplies_dialog_bloc/tasker_parts_supplies_dialog_states.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TPSDBloc extends Bloc<TPSDEvents, TPSDStates> {
  bool? isParts;
  Map<String, dynamic>? model;
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> selectedPartsList = [];
  TextEditingController controller = TextEditingController();
  TPSDBloc() : super(TPSDLoadingState()) {
    on<TPSDInitialEvent>(_onInitialEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchParts() async => await getIt<CommonService>().getPartsList();
  Future<List<Map<String, dynamic>>> _fetchSupplies() async => await getIt<CommonService>().getSuppliesList();


  void _onInitialEvent(TPSDInitialEvent event, Emitter<TPSDStates> emit) async {
    try {
      emit(TPSDLoadingState());
      isParts = event.isParts;
      model = event.model;
      apiResponse = (isParts ?? false) ? await _fetchParts() : await _fetchSupplies();
      var modelParts = List<Map<String, dynamic>>.from(model?['parts'] ?? []).map((e) => e['parts_id']).toList();
      var modelSupplies = List<Map<String, dynamic>>.from(model?['supplies'] ?? []).map((e) => e['supplies_id']).toList();
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
}