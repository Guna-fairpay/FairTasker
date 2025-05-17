import 'dart:async';

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
  List<Map<String, dynamic>>? selected = [];
  bool isAllSelected = false;
  int? branchId = Session.of.getInt(Str.branchIdPrefText);
  bool get isAdmin => getIt<CommonService>().isAdmin;
  TFRDBloc() : super(TFRDLoadingState()) {
    on<TFRDInitialEvent>(_onInitialEvent);
    on<TFRDSelectEvent>(_onSelectEvent);
    on<TFRDAllEvent>(_onAllEvent);
  }

  Future<List<Map<String, dynamic>>?> _fetchUsers() async => await getIt<CommonService>().getUsers();

  void _onInitialEvent(TFRDInitialEvent event, Emitter<TFRDStates> emit) async {
    try {
      emit(TFRDLoadingState());
      selected = event.selected;
      var response = (await _fetchUsers());
      users = List.from(response ?? []);
      var acceptDepartmentIds = [isAdmin ? "8" : "", "7"];
      acceptDepartmentIds.removeWhere((element) => element.isNullOrEmpty);
      users?.removeWhere((element) => (element['deleted_at'].toString().isNotNullOrEmpty) || (element['branch_id'].toString().isNullOrEmpty) || ((element['branch_id'] != branchId) && (!acceptDepartmentIds.contains(element['department'])) && (element['id'] != 3)));
      departments = users?.map((e) => Map<String, dynamic>.from(e['departments'])).map((e) => e..['name'] = (['Admin Manager', 'Operations'].contains(e['name'])) ? "Core" : e['name']).toSet().toList();
      departments?.sort((a, b) => a['id'].compareTo(b['id']));
      departments = departments.unique((element) => element['id']);
      departments = departments?.map((e) => e..['ids'] = (departments?.where((element) => element['name'] == e['name']).map((e) => e['id']).toList())).toList();
      departments = departments.unique((element) => element['name']);
      departments = departments?.map((e) => e..['users'] = (users?.where((element) => List.from(e['ids']).contains(element['departments']?['id'])).toList())).toList();
      departments?.sort((a, b) => a['name'].compareTo(b['name']));
      var offshore = departments?.firstWhereOrNull((element) => element['name'] == "OffShore");
      Console.of.log(offshore);
      if((offshore != null) && (offshore.isNotEmpty)) {
        departments?.removeWhere((element) => element['name'] == "OffShore");
        departments?.add(offshore ?? {});
      }
      isAllSelected = (selected?.length == users?.length);
      emit(TFRDCommonState());
    } catch (e) {
      Console.of.error(e);
      emit(TFRDErrorState(e));
    }
  }

  void _onSelectEvent(TFRDSelectEvent event, Emitter<TFRDStates> emit) {
    if (selected?.contains(event.model) ?? false) {
      selected?.remove(event.model);
    } else {
      selected?.add(event.model ?? {});
    }
    emit(TFRDSelectedState(selected ?? []));
  }

  void _onAllEvent(TFRDAllEvent event, Emitter<TFRDStates> emit) {
    isAllSelected = !isAllSelected;
    if (isAllSelected) {
      selected = users;
    } else {
      selected?.clear();
    }
    emit(TFRDSelectedState(selected ?? []));
  }
}