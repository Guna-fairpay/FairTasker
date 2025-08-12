import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'vehicle_view_event.dart';
part 'vehicle_view_state.dart';

class VehicleExpenseViewBloc extends Bloc<VehicleViewEvent, VehicleExpenseViewState>{

  final APiRepository apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  List<dynamic> expenseResponse = [];
  List<dynamic> filterResponse = [];
  List<dynamic> categoryList = [];
  List<dynamic> subCategoryList = [];
  List<dynamic> cohortList = [];

  dynamic minDate;
  dynamic maxDate;
  dynamic approvedAmount = 0.0;
  dynamic unApprovedAmount = 0.0;
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  dynamic selectedCohort;

  bool isApproved = false;

  DateRange selectedDateRange = DateRange(
    DateTime.now().subtract(const Duration(days: 7)),
    DateTime.now(),
  );

  Future<Map<String, dynamic>?> _getExpense({String? minDate, String? maxDate}) async => await apiRepository.vehicleExpense(minDate: minDate, maxDate: maxDate);
  Future<List<Map<String, dynamic>>> _getUsers() async => await getIt<CommonService>().getUsers();
  Future<List<Map<String, dynamic>>> _getExpenseCategories() async => await getIt<CommonService>().getExpenseCategories();
  Future<Map<String, dynamic>?> _expenseApprove({dynamic id, dynamic approved}) async => await apiRepository.expenseApprove(id: id, approved: approved);
  Future<Map<String, dynamic>?> _deleteExpenseTodo({dynamic id}) async => await apiRepository.deleteExpenseTodo(id);
  Future<Map<String, dynamic>?> _deleteVehicleExpense({dynamic id}) async => await apiRepository.deleteVehicleExpense(id);

  VehicleExpenseViewBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<ApproveCheckEvent>(_onApproveCheckEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
    on<ApprovedEvent>(_onApprovedEvent);
    on<FairRentalEvent>(_onFairRentalEvent);
    on<CategoryEvent>(_onCategoryEvent);
    on<CohortEvent>(_onCohortEvent);
    on<DeleteExpenseEvent>(_onDeleteExpenseEvent);
    on<RefreshEvent>(_onRefreshEvent);
    _registerBroadcast();
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<VehicleExpenseViewState> emit) async {
    try {
      emit(LoadingState());
      minDate = selectedDateRange.start.toFormat(format: 'yyyy-MM-dd');
      maxDate = selectedDateRange.end.toFormat(format: 'yyyy-MM-dd');
      await refetch();
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onApproveCheckEvent(ApproveCheckEvent event, Emitter<VehicleExpenseViewState> emit) async {
    try{
      emit(LoadingState());
      await _expenseApprove(id: event.model['id'], approved: event.approved);
      await refetch();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onDateRangeEvent(DateRangeEvent event, Emitter<VehicleExpenseViewState> emit) async {
    try{
      selectedDateRange = event.selectedRange;
      minDate = selectedDateRange.start.toFormat(format: 'yyyy-MM-dd');
      maxDate = selectedDateRange.end.toFormat(format: 'yyyy-MM-dd');
      emit(LoadingState());
      await refetch();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onApprovedEvent(ApprovedEvent event, Emitter<VehicleExpenseViewState> emit){
    try{
      isApproved = !isApproved;
      filterResponse = filterApprovedResponse(expenseResponse, event.isApproved);
      approvedAmount = 0;
      unApprovedAmount = 0;
      if(isApproved){
        approvedAmount = filterResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
      }else{
        unApprovedAmount = filterResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
      }
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onFairRentalEvent(FairRentalEvent event, Emitter<VehicleExpenseViewState> emit) async {
    try{
      var url = event.id.toString().toFaiRentalReserveUrl;
      Utils.openURL(url);
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onCategoryEvent(CategoryEvent event, Emitter<VehicleExpenseViewState> emit) async {
    try {
      var data = event.category;
      emit(ShowCategoryState(data));
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onCohortEvent(CohortEvent event, Emitter<VehicleExpenseViewState> emit) async {
    try {
      var data = event.cohort;
      cohortList = data['cohortList'] ?? [];
      selectedCohort = cohortList.where((element) => element['id'].toString() == data['expense_to'].toString(),).firstOrNull ?? {};
      emit(ShowCohortState(data));
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteExpenseEvent(DeleteExpenseEvent event, Emitter<VehicleExpenseViewState> emit) async {
    try{
      emit(LoadingState());
      var response = await _deleteVehicleExpense(id: event.id);
      await _deleteExpenseTodo(id: event.id);
      if(response != null){
        await refetch();
        emit(SuccessState('Expense Deleted Successfully'));
      }else{
        emit(ErrorState(response?['message']));
      }
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<VehicleExpenseViewState> emit) async {
    try{
      emit(LoadingState());
      await refetch();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<VehicleExpenseViewState> emit){
    Toaster.showError(error);
    emit(ErrorState(error));
  }

  Future<void> refetch() async{
    var response = await _getExpense(minDate: minDate, maxDate: maxDate);
    if(response != null){
      var apiResponse = List<Map<String, dynamic>>.from(response['requestData'] ?? []);
      var monthlyResponse = List<Map<String, dynamic>>.from(response['monthlyData'] ?? []);
      var usersList = await _getUsers();
      var categories = await _getExpenseCategories();
      monthlyResponse.removeWhere(_shouldRemove);
      apiResponse.removeWhere(_shouldRemove);
      apiResponse = employeeNames(apiResponse, usersList);
      apiResponse = cohortListGenerator(apiResponse);
      apiResponse.sort((a, b) => DateTime.parse(b['created_at'] ?? '').compareTo(DateTime.parse(a['created_at'] ?? '')));
      expenseResponse = apiResponse;
      filterResponse = filterApprovedResponse(apiResponse, isApproved);
      categoryList = categories;
      if(isApproved){
        approvedAmount = filterResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
      }else{
        unApprovedAmount = filterResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
      }
    }
  }

  bool _shouldRemove(Map<String, dynamic> element) {
    final vehicle = element['vehicle'];
    if (vehicle == null || vehicle.toString().trim().isEmpty) return true;
    final branchCode = vehicle is Map ? vehicle['branch_code'] : null;
    return branchCode != Session.of.getInt(Str.branchIdPrefText);
  }

  List<Map<String, dynamic>> employeeNames(
      List<Map<String, dynamic>> expenseResponse,
      List<Map<String, dynamic>> usersList
      ) {
    return  expenseResponse = expenseResponse.map((e) {
      e.putIfAbsent("employee_name", () {
        var user = usersList.firstWhereOrNull((element) => element['id'] == e['employee_id'],);
        return List<String>.from([user?['first_name'] ?? "", user?['last_name'] ?? ""]).toInitial;
      });
      return e;
    }).toList();
  }

  List<Map<String, dynamic>> cohortListGenerator(List<Map<String, dynamic>> expenseResponse){
    return expenseResponse = expenseResponse.map((item) => item
      ..['cohortList'] = [
        {"id": "1", "name": "FairPy"},
        {"id": "4", "name": "${item['cohort']?['cohort'] ?? ''}"}
      ]).toList();
  }

  List<dynamic> filterApprovedResponse(
      List<dynamic> existResponse, bool? isApproved) {
    if (isApproved == true) {
      return existResponse.where((item) => item['approved'] == 1).toList();
    } else if (isApproved == false) {
      return existResponse.where((item) => item['approved'] == 0).toList();
    }
    return existResponse;
  }

  void _registerBroadcast() {
    _broadcast.register("expense_vehicle_refresh", (value, callback) {
      Console.of.log("expense_vehicle_refresh");
      add(RefreshEvent());
    });
    getIt<CommonService>().branchUpdate(callback: () => add(RefreshEvent()));
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Fair Returns LP LLC':
        return const Color(0xFF0000FF);
      case 'Fair Returns Prime LP':
        return const Color(0xFF09834A);
      case 'FairFund 2024':
        return Colors.purple;
      case 'Fair Returns Fall 2023':
        return Colors.black;
      case 'Personal Car':
        return Colors.brown;
      case 'Unassigned':
        return Colors.orange;
      default:
        return const Color.fromRGBO(9, 131, 74, 1);
    }
  }

}