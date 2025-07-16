import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lead_change_state.dart';

class LeadChangeBloc extends Cubit<LeadChangeState> {
  final TextEditingController controller = TextEditingController();
  Map<String, dynamic> selectedLead = {}, _model = {};
  List<Map<String, dynamic>> get leads => getIt<CommonService>().leads;
  LeadChangeBloc() : super(CommonState());

  bool get _isNewLead => (_model['lead_id'] != selectedLead['id']);

  void initialize({Map<String, dynamic>? model}) async {
    try {
      if (leads.isEmpty) {
        emit(LoadingState());
        await getIt<CommonService>().fetchLeads();
        emit(CommonState());
      }
      if (model != null) {
        _model = model;
        controller.text = _model['lead']?['customer_name'];
        selectedLead = _model['lead'] ?? {};
        emit(CommonState());
      }
    } catch (e) {
      _error(e);
    }
  }

  void _error(dynamic e) {
    Console.of.error("Error", error: e, name: "LeadChangeBloc");
    emit(ErrorState(e));
  }

  void onChanged(Map<String, dynamic> lead) {
    selectedLead = lead;
    Console.of.log("Updated");
    emit(CommonState());
  }

  void onSave() {
    var state = ((selectedLead.isNotEmpty && _isNewLead) ? CompleteState(selectedLead) : CloseState());
    return emit(state);
  }

  void onEmptyTap() {
    if (controller.text.isNotNullOrEmpty) return emit(EmptyLeadState(controller.text));
  }
}