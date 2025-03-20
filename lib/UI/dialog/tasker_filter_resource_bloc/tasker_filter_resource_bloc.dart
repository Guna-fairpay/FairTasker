import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_resource_bloc/tasker_filter_resource_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_resource_bloc/tasker_filter_resource_states.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TFRDBloc extends Bloc<TFRDEvents, TFRDStates> {

  List<Map<String, dynamic>>? users;
  List<Map<String, dynamic>>? departments;
  int? branchId = Session.of.getInt(Str.branchIdPrefText);
  TFRDBloc() : super(TFRDLoadingState()) {
    on<TFRDInitialEvent>(_onInitialEvent);
  }

  Future<List<Map<String, dynamic>>?> _fetchUsers() async => await getIt<CommonService>().getUsers();

  void _onInitialEvent(TFRDInitialEvent event, Emitter<TFRDStates> emit) async {
    try {
      emit(TFRDLoadingState());
      var response = (await _fetchUsers());
      users = List.from(response ?? []);
      Console.of.debug("Branch ID $branchId ${branchId.runtimeType}");
      users?.removeWhere((element) => (element['deleted_at'].toString().isNotNullOrEmpty) || (element['branch_id'].toString().isNullOrEmpty) || ((element['branch_id'] != branchId)));
      departments = users?.map((e) => Map<String, dynamic>.from(e['departments'])).map((e) => e..['name'] = (['Admin Manager', 'Operations'].contains(e['name'])) ? "Core" : e['name']).toSet().toList();
      departments?.sort((a, b) => a['id'].compareTo(b['id']));
      departments = departments.unique((element) => element['id']);
      departments = departments?.map((e) => e..['ids'] = (departments?.where((element) => element['name'] == e['name']).map((e) => e['id']).toList())).toList();
      departments = departments.unique((element) => element['name']);
      departments = departments?.map((e) => e..['users'] = (users?.where((element) => List.from(e['ids']).contains(element['departments']?['id'])).toList())).toList();
      departments?.sort((a, b) => a['name'].compareTo(b['name']));
      Console.of.debug(jsonEncode(departments));
      emit(TFRDCommonState());
    } catch (e) {
      emit(TFRDErrorState(e));
    }
  }
}