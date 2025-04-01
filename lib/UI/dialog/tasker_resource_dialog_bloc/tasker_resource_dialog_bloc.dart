import 'dart:async';

import 'package:fairpytasker/UI/dialog/tasker_resource_dialog_bloc/tasker_resource_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_resource_dialog_bloc/tasker_resource_dialog_states.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TRSDBloc extends Bloc<TRSDEvents, TRSDStates> {
  Map<String, dynamic>? model;
  List<Map<String, dynamic>> selectedResourcesList = [];
  List<Map<String, dynamic>> apiResponse = [];
  TRSDBloc() : super(TRSDLoadingState()) {
    on<TRSDInitialEvent>(_onInitialEvent);
    on<TRSDSelectedEvent>(_onSelectedEvent);
  }

  Future<List<Map<String, dynamic>>> _getUsersList() async => await getIt<CommonService>().getResources();

  void _onInitialEvent(TRSDInitialEvent event, Emitter<TRSDStates> emit) async {
    try {
      model = event.model;
      emit(TRSDLoadingState());
      var response = await _getUsersList();
      response.removeWhere((element) => (element['deleted_at'].toString().isNotNullOrEmpty) || (element['id'] == 2) || (element['branch_id'] != Session.of.getInt(Str.branchIdPrefText)));
      apiResponse = response;
      selectedResourcesList = List<Map<String, dynamic>>.from(model?['display']?['resources'] ?? []);
      Console.of.log(selectedResourcesList);
      emit(TRSDCommonState());
    } catch (e) {
      emit(TRSDErrorState(e));
    }
  }

  void _onSelectedEvent(TRSDSelectedEvent event, Emitter<TRSDStates> emit) {
    if (event.isChecked) {
      selectedResourcesList.add(event.value);
    } else {
      selectedResourcesList.removeWhere((element) => element['id'] == event.value['id']);
    }
    emit(TRSDCommonState());
  }
}