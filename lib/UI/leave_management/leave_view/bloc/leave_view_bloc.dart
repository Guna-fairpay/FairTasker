
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_state.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveViewBloc extends Bloc<LeaveViewEvent,LeaveViewState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  List<dynamic> employeeList =[];
  List<dynamic> apiResponse =[];
  List<dynamic> filteredResponse =[];

  dynamic selectedEmployee = {};

  TextEditingController searchController = TextEditingController();

  LeaveViewBloc():super(LeaveViewLoadingState()){
    on<LeaveViewInitialEvent>(_onLeaveViewInitialEvent);
    on<SearchEvent>(_onSearchPartsEvent);
    on<EmployeeSelectedEvent>(_onEmployeeSelectedEvent);
    on<AddEditPageEvent>(_onAddEditPageEvent);
    on<VerificationPageEvent>(_onVerificationPageEvent);
    _broadcast.register('refreshLeaveList', (value, callback) => add(LeaveViewInitialEvent()));

  }

  void _onLeaveViewInitialEvent(LeaveViewInitialEvent event, Emitter<LeaveViewState> emit) async {
    try{
      emit(LeaveViewLoadingState());
      var response = await _apiRepository.getLeaveList();
      var employeeResponse = await _apiRepository.getEmployeeList();
       // await getIt<CommonService>().getLeaveListType();
      apiResponse = response?['data'];
      filteredResponse = apiResponse;
      employeeList = employeeResponse?['data'];
      employeeList.insert(0, {'id': -1, 'first_name': 'All'});
      selectedEmployee = employeeList.firstOrNull;
      await filter();
      emit(LeaveViewCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      Console.of.error(e.toString());
      emit(LeaveViewCommonState());
    }
  }

  void _onSearchPartsEvent(SearchEvent event, Emitter<LeaveViewState> emit) async {
    var query = searchController.text.toLowerCase();
    List<dynamic> filteredData = [];
    if (query.trim().isNotNullOrEmpty) {
      filteredData = apiResponse.where((element) {
        return [
          element?['user']?['name'],
          element?['leave_type']?['code'],
          element?['leave_type']?['name']
        ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
      filteredResponse = filteredData;
    } else {
      filteredResponse = apiResponse;
    }
    emit(LeaveViewCommonState());
  }

  void _onEmployeeSelectedEvent(EmployeeSelectedEvent event, Emitter<LeaveViewState> emit) async {
    selectedEmployee = event.employee;
    if(selectedEmployee['id'] == -1){
      filteredResponse = apiResponse;
    }else {
      filteredResponse = apiResponse.where((element) => (selectedEmployee['users']?['employee_id']) == (element['user']?['employee_id'])).toList();
    }
    emit(LeaveViewCommonState());
  }

  void _onAddEditPageEvent(AddEditPageEvent event, Emitter<LeaveViewState> emit) async {
    emit(AddEditPageState(leaveData: event.leaveData));
  }

  void _onVerificationPageEvent(VerificationPageEvent event, Emitter<LeaveViewState> emit) async {
    emit(VerificationPageState(leaveData: event.leaveData));
  }

  Future<void> filter() async{
    apiResponse.map((e) {
      DateTime startDate = DateTime.parse(e['start_date']);
      DateTime endDate = DateTime.parse(e['end_date']);
      Duration difference = endDate.difference(startDate);
      Duration extendedDuration = difference + const Duration(days: 1);
      e['difference'] = extendedDuration.inDays;
      return e;
    }).toList();
  }

}