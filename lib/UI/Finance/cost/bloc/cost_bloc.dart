import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cost_event.dart';
part 'cost_state.dart';

class CostBloc extends Bloc<CostEvent, CostState> {
  Map<String, dynamic>? _response;
  List<Map<String, dynamic>>? _apiResponse;
  List<Map<String, dynamic>>? filteredData;
  Map<String, dynamic>? _model;
  int currentPage = 1;
  int itemsPerPage = 10;

  final APiRepository _apiRepository = APiRepository();

  CostBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<PaginationEvent>(_onPaginationEvent);
  }

  int get totalPages => ((_apiResponse?.length ?? 0) / itemsPerPage).ceil();
  
  num? get totalAmount => _apiResponse?.map((e) => e['expense_amount'].toString().toNumeric).sum;

  Future<Map<String, dynamic>?> getCost() async => await _apiRepository.getCumulativeExpense(vin: _model?['vin']);

  void _onInitialEvent(InitialEvent event, Emitter<CostState> emit) async {
    try {
      _model = event.model;
      emit(LoadingState());
      _response = await getCost();
      _apiResponse = List.from(_response?['expenses'] ?? []);
      _apiResponse?.sort((a, b) => (b['expense_date'].toString().toDateTime()?.compareTo(a['expense_date'].toString().toDateTime() ?? DateTime.now())) ?? 0);
      _paginate();
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onPaginationEvent(PaginationEvent event, Emitter<CostState> emit) {
    currentPage = event.page;
    _paginate();
    emit(CommonState());
  }

  void _paginate() {
    filteredData = paginateList(data: _apiResponse ?? [], currentPage: currentPage, itemsPerPage: itemsPerPage);
  }
}