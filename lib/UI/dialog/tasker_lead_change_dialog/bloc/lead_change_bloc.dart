import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lead_change_state.dart';

class LeadChangeBloc extends Cubit<LeadChangeState> {
  final TextEditingController controller = TextEditingController();
  Map<String, dynamic> selectedLead = {}, _model = {};
  List<Map<String, dynamic>> get _leads => getIt<CommonService>().leads;
  List<Map<String, dynamic>> get _channels => getIt<CommonService>().channels;
  LeadChangeBloc() : super(CommonState());

  bool get _isNewLead => (_model[hasLead ? 'lead_id' : 'channel_id'] != selectedLead['id']);

  bool get hasLead => _model['lead_id'].toString().isNotNullOrEmpty;
  bool get hasChannel => _model['channel_id'].toString().isNotNullOrEmpty;
  get _currentId => hasLead ? _model['lead_id'] : _model['channel_id'];
  List<Map<String, dynamic>> get leads => CustomSearchDataConverter.convertLeadChannel(leads: _leads, channels: _channels);

  void initialize({Map<String, dynamic>? model}) async {
    try {
      if (_leads.isEmpty || _channels.isEmpty) {
        emit(LoadingState());
        await getIt<CommonService>().fetchLeads();
        emit(CommonState());
      }
      if (model != null) {
        _model = model;
        selectedLead = leads.firstWhereOrNull((element) => (element['id'] == _currentId) && (element['type'] == (hasLead ? "lead" : "channel"))) ?? {};
        Console.of.log(selectedLead);
        controller.text = selectedLead['name'] ?? "";
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