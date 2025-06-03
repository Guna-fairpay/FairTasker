import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'other_view_event.dart';
part 'other_view_state.dart';

class OtherViewBloc extends Bloc<OtherViewEvent, OtherViewState>{

  final APiRepository _apiRepository = APiRepository();
  DateRange selectedDateRange = DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  dynamic totalAmount = 0.00;
  List<dynamic> apiResponse = [];
  List<dynamic> monthResponse = [];
  List<dynamic>? otherAttachments;
  final FBroadcast _broadcast = FBroadcast.instance();

  Future<Map<String, dynamic>?> _getOtherExpense({String? startDate, String? endDate}) async => await _apiRepository.getOtherExpense(startDate: startDate, endDate: endDate);
  Future<Map<String, dynamic>?> _approveExpense({dynamic id, dynamic approved}) async => await _apiRepository.approvePersonExpense(id: id, approved: approved);

  OtherViewBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
    on<ApproveEvent>(_onApproveEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<AddEditEvent>(_onAddEditEvent);
    on<RefreshEvent>(_onRefreshEvent);
    on<CategoryDialogEvent>(_onCategoryDialogEvent);
    _broadcast.register('expense_person_refresh', (value, callback) => add(RefreshEvent()));
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<OtherViewState> emit) async{
    try {
      await fetchData();
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onCategoryDialogEvent(CategoryDialogEvent event, Emitter<OtherViewState> emit) async{
    try {
      emit(CategoryDialogState(event.model));
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<OtherViewState> emit) async{
    try {
      emit(LoadingState());
      await fetchData();
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onDateRangeEvent(DateRangeEvent event, Emitter<OtherViewState> emit) async{
    try {
      emit(LoadingState());
      selectedDateRange = event.dateRange;
      await fetchData();
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onApproveEvent(ApproveEvent event, Emitter<OtherViewState> emit) async{
    try {
      emit(LoadingState());
      var model = event.model;
      int approved = event.approved == true ? 1 : 0;
      var response = await _approveExpense(id: model['id'].toString(), approved: approved.toString());
      if(response?['data'] != null) {
        for (var e in apiResponse) {
          if (e['id'] == model['id']) {
            e['approved'] = approved;
          }
        }
        for (var e in monthResponse) {
          if (e['id'] == model['id']) {
            e['approved'] = approved;
          }
        }
        await reloadData();
      }
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<OtherViewState> emit) async{
    try {
      emit(LoadingState());
      var response = await _apiRepository.deletePersonExpense(event.id);
      if(response?['message'].contains('Expense deleted successfully.') == true) {
        apiResponse.removeWhere((element) => element['id'].toString() == event.id);
        monthResponse.removeWhere((element) => element['id'].toString() == event.id);
        await reloadData();
      }
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onAddEditEvent(AddEditEvent event, Emitter<OtherViewState> emit) async{
    try {
      emit(AddEditState(event.id));
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<OtherViewState> emit){
    emit(ErrorState(error));
    Console.of.error(error);
  }

  Future<void> fetchData() async {
    var oneMonthResponse = await _getOtherExpense(
      startDate: '${DateTime.now().subtractMonth(1).toFormat()}',
      endDate: '${DateTime.now().toFormat()}');
    var response = await _getOtherExpense(
      startDate: selectedDateRange.start.toFormat(),
      endDate: selectedDateRange.end.toFormat(),
    );
    monthResponse = oneMonthResponse?['data'] ?? [];
    apiResponse = response?['data'] ?? [];
    apiResponse.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
        .compareTo(DateTime.parse(a['created_at'] ?? '')));
    for (var element in apiResponse) {
      element['attachments_paths'] = element['attachments'].map((e) => e['path'].toString().toStorageURL).toList();
    }
    await reloadData();
  }

  Future<void> reloadData() async {
    var filterResponse =
    calculateApprovedAmounts(List.from(apiResponse), List.from(monthResponse));

    apiResponse = filterResponse;

    totalAmount = apiResponse.where((e) => (e['approved'] == 1),).map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
  }

  List<Map<String, dynamic>> calculateApprovedAmounts(
      List<Map<String, dynamic>> apiResponse,
      List<Map<String, dynamic>> amountResponse) {
    return apiResponse.map((e) {
      var matchingAmounts = amountResponse
          .where((element) => ((element['subcategory_id'] == e['subcategory_id']) && element['approved'] == 1))
          .map((item) => num.tryParse(item['expense_amount'].toString()) ?? 0)
          .sum;
      e["approved_amount"] = matchingAmounts;
      return e;
    }).toList();
  }

  Map<String, dynamic> get body => {
    "minDate": selectedDateRange.start.toFormat(),
    "maxDate": selectedDateRange.end.toFormat(),
    "platformCustom": "tasker-app"
  };



}