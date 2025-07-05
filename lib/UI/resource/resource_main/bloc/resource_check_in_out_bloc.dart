import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
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
  DateRange? selectedDateRange = DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  dynamic selectedResource;
  List<dynamic> get _allowedUserIds => [1,2,3,10,21,22,23];
  bool get isAllowed => _allowedUserIds.contains(getIt<CommonService>().userId);
  List<dynamic> get _currentBranchHrmIds => getIt<CommonService>().currentBranchHrmIds;

  List<Map<String, dynamic>> get resources {
    var list = [...getIt<CommonService>().resourcesList];
    list.removeWhere((element) =>
        (element['id'] == 2) ||
        (element['deleted_at'].toString().isNotNullOrEmpty) ||
        (element['branch_id'] != getIt<CommonService>().branchId));
    var dummy = {'id': -1, 'first_name': 'All', "last_name": ""};
    list.insert(0, dummy);
    return list;
  }

  List<Map<String, dynamic>>? workingHours = [];
  List<Map<String, dynamic>>? _employeeWorkHours = [];
  List<Map<String, dynamic>>? employeeWorkHours = [];

  ResourceCheckInOutBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<DateRangeChangedEvent>(_onDateRangeChangedEvent);
    on<ResourceSelectEvent>(_onResourceSelectEvent);
    on<ViewHoursDetailsEvent>(_onViewHoursDetailsEvent);
    on<TaskComponentEvent>(_onTaskComponentEvent);
    on<ViewTaskDetailsEvent>(_onViewTaskDetailsEvent);
    on<ViewTaskCountEvent>(_onViewTaskCountEvent);
  }

  Future<Map<String, dynamic>?> _checkInOut() async => await _aPiRepository.getCheckInOut(fromDate: selectedDateRange?.start, toDate: selectedDateRange?.end);

  void _processData() {
    selectedResource = resources.firstOrNull ?? {'id': -1, 'first_name': 'All', "last_name": ""};
    if (!isAllowed) selectedResource = resources.firstWhereOrNull((element) => element['id'] == getIt<CommonService>().userId);
    employeeWorkHours?.removeWhere((element) => !_currentBranchHrmIds.contains(element['id']));
    _employeeWorkHours = employeeWorkHours;
    workingHours?.removeWhere((element) => !_currentBranchHrmIds.contains(element['id']));
    if (getIt<CommonService>().freelancerHrmIds.isNotEmpty) workingHours?.removeWhere((element) => !getIt<CommonService>().freelancerHrmIds.contains(element['employee']?['id']));
  }

  void _onInitialEvent(InitialEvent event, Emitter<ResourceCheckInOutState> emit) async {
    try {
      emit(LoadingState());
      var data = await _checkInOut();
      employeeWorkHours = List.from(data?['employeeWorkHours'] ?? []);
      workingHours = List.from(data?['workingHours'] ?? []);
      _processData();
      if (!isAllowed) add(ResourceSelectEvent(selectedResource));
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onDateRangeChangedEvent(DateRangeChangedEvent event, Emitter<ResourceCheckInOutState> emit) async {
    try {
      selectedDateRange = event.model;
      _employeeWorkHours = [];
      employeeWorkHours = [];
      emit(LoadingState());
      var data = await _checkInOut();
      employeeWorkHours = List.from(data?['employeeWorkHours'] ?? []);
      workingHours = List.from(data?['workingHours'] ?? []);
      _processData();
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onResourceSelectEvent(ResourceSelectEvent event, Emitter<ResourceCheckInOutState> emit) {
    selectedResource = event.model;
    if (selectedResource?['id'] == -1) {
      employeeWorkHours = _employeeWorkHours;
    } else {
      employeeWorkHours = _employeeWorkHours?.where((element) => element['id'] == selectedResource?['hrm_id']).toList();
    }
    emit(CommonState());
  }

  void _onViewHoursDetailsEvent(ViewHoursDetailsEvent event, Emitter<ResourceCheckInOutState> emit) {
    emit(ViewHoursDetailsState(event.model, selectedDateRange));
  }

  void _onTaskComponentEvent(TaskComponentEvent event, Emitter<ResourceCheckInOutState> emit) {
    emit(TaskComponentState());
  }

  void _onViewTaskDetailsEvent(ViewTaskDetailsEvent event, Emitter<ResourceCheckInOutState> emit) {
    emit(ViewTaskDetailsState(event.model, dateRange: selectedDateRange));
  }

  void _onViewTaskCountEvent(ViewTaskCountEvent event, Emitter<ResourceCheckInOutState> emit) {
    emit(ViewTaskCountState(event.model, selectedDateRange));
  }
}
