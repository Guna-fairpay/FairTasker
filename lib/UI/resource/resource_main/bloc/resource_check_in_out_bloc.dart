import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;

part 'resource_check_in_out_event.dart';
part 'resource_check_in_out_state.dart';

class ResourceCheckInOutBloc extends Bloc<ResourceCheckInOutEvent, ResourceCheckInOutState> {
  final APiRepository _aPiRepository = APiRepository();
  DateRange? selectedDateRange = DateRange(DateTime.now(), DateTime.now());
  Map<String, dynamic>? selectedResource;
  List<Map<String, dynamic>> get resources {
    var list = [...getIt<CommonService>().resourcesList];
    list.removeWhere((element) => (element['id'] == 2) || (element['deleted_at'].toString().isNotNullOrEmpty) || (element['branch_id'] != getIt<CommonService>().branchId));
    var dummy = {...list.first};
    dummy['id'] = 0;
    dummy['hrm_id'] = 0;
    dummy['first_name'] = "All";
    dummy['last_name'] = "";
    list.insert(0, dummy);
    return list;
  }
  ResourceCheckInOutBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<DateRangeChangedEvent>(_onDateRangeChangedEvent);
    on<ResourceSelectEvent>(_onResourceSelectEvent);
  }

  Future<void> _getResources() async => await getIt<CommonService>().getResources();

  void _onInitialEvent(InitialEvent event, Emitter<ResourceCheckInOutState> emit) async {
    try {
      emit(LoadingState());
      await _getResources();
      selectedResource = resources.first;
      Console.of.log("Selected Resource $selectedResource", name: "ResourceCheckInOutBloc");
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onDateRangeChangedEvent(DateRangeChangedEvent event, Emitter<ResourceCheckInOutState> emit) {
    selectedDateRange = event.model;
    emit(CommonState());
  }

  void _onResourceSelectEvent(ResourceSelectEvent event, Emitter<ResourceCheckInOutState> emit) {
    selectedResource = event.model;
    emit(CommonState());
  }
}