import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'other_expense_details_event.dart';
part 'other_expense_details_state.dart';

class OtherExpenseDetailsBloc extends Bloc<OtherExpenseDetailsEvent, OtherExpenseDetailsState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  int selectedTab = 0;
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  dynamic totalAmount = 0.00;
  dynamic model;
  String? title;

  List<dynamic> apiResponse = [];
  List<dynamic> filteredResponse = [];

  @override
  Future<void> close() {
    _broadcast.unregister("expense_other_refresh");
    return super.close();
  }



  Future<Map<String, dynamic>?> _getOtherExpense({String? startDate, String? endDate}) async => await _apiRepository.getOtherExpense(startDate: startDate, endDate: endDate);

  OtherExpenseDetailsBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<PaginationEvent>(_onPaginationEvent);
    on<EditEvent>(_onEditEvent);
    on<RefreshEvent>(_onRefreshEvent);
    _broadcast.register('expense_other_refresh', (value, callback) => add(RefreshEvent()));
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<OtherExpenseDetailsState> emit)  async {
    try {
      emit(LoadingState());
      await fetchData();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }


  Future<void> _onInitialEvent(InitialEvent event, Emitter<OtherExpenseDetailsState> emit) async {
    try {
      emit(LoadingState());
      model = event.model;
      title = model?['subcategory']?['name'] ?? '';
      await fetchData();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onPaginationEvent(PaginationEvent event, Emitter<OtherExpenseDetailsState> emit) async {
    try {
      currentIndex = event.page;
      filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onEditEvent(EditEvent event, Emitter<OtherExpenseDetailsState> emit) async {
    try {
      emit(EditState(event.id));
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> fetchData() async {
    var oneMonthResponse = await _getOtherExpense(
        startDate: '${DateTime.now().subtractMonth(1).toFormat()}',
        endDate: '${DateTime.now().toFormat()}');
    apiResponse = oneMonthResponse?['data'] ?? [];
    apiResponse.removeWhere((e) => e['subcategory_id'].toString() != model['subcategory_id'].toString());
    totalAmount = apiResponse.map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
    apiResponse.removeWhere((e) => e['approved'] == 0);
    for (var element in apiResponse) {
      element['attachments_paths'] = element['attachments'].map((e) => e['path'].toString().toStorageURL).toList();
    }
    totalCount = apiResponse.length;
    filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);

  }

  void _error(dynamic error, Emitter<OtherExpenseDetailsState> emit){
    emit(ErrorState(error));
    Console.of.error(error);
  }

}