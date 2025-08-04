
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/bloc/cumulative_expense_event.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/bloc/cumulative_expense_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CumulativeExpenseBloc extends Bloc<CumulativeExpenseEvent, CumulativeExpenseState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];

  int selectedTab = 0;
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  bool isEdit = false;

  dynamic selectedData;
  dynamic total;
  dynamic data;

  CumulativeExpenseBloc() : super(CumulativeExpenseLoadingState()){

    on<CumulativeExpenseInitialEvent>(_onCumulativeExpenseInitialEvent);
    on<CumulativeExpenseDeleteEvent>(_onCumulativeExpenseDeleteEvent);

    on<CumulativeExpensePaginationEvent>((event, emit) {
      currentIndex = event.page;
      filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(CumulativeExpenseCommonState());
    });
  }

  void _onCumulativeExpenseInitialEvent(CumulativeExpenseInitialEvent event, Emitter<CumulativeExpenseState> emit) async {
    try{
      emit(CumulativeExpenseLoadingState());
      var response = await _apiRepository.getCumulativeExpense(vin:event.data['vin']);
      data = event.data;
      apiResponse =List.from(response?['expenses']);
      apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
      total = apiResponse.map((e) => double.tryParse("${e['expense_amount']}") ?? 0).sum;
      filteredResponse.clear();
      filteredResponse = paginateList(
          data: apiResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      totalCount = apiResponse.length;
      emit(CumulativeExpenseCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      Console.of.log(e.toString());
      emit(CumulativeExpenseCommonState());
    }
  }

  void _onCumulativeExpenseDeleteEvent(CumulativeExpenseDeleteEvent event, Emitter<CumulativeExpenseState> emit) async {
    try{
      emit(CumulativeExpenseLoadingState());
      var response = await _apiRepository.deleteVehicleExpense(event.data['id']);
      if(response?['message']!=null){
        apiResponse.removeWhere((element) => element['id'] == event.data['id']);
        totalCount = apiResponse.length;
        filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
        Toaster.showSuccess(response?['message']);
       }
      emit(CumulativeExpenseCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(CumulativeExpenseCommonState());
    }
  }

}
