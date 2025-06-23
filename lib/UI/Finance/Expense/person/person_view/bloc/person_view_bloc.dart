import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/Repository/api_repository.dart';

part 'person_view_event.dart';
part 'person_view_state.dart';

class PersonViewBloc extends Bloc<PersonViewEvent, PersonViewState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  DateRange selectedDateRange = DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  dynamic totalAmount = 0.00;
  List<dynamic> apiResponse = [];
  List<dynamic> monthResponse = [];
  List<dynamic> personList = [];

  Future<Map<String, dynamic>?> _getPersonExpense({String? startDate, String? endDate}) async => await _apiRepository.personExpenses(minDate: startDate, maxDate: endDate);
  Future<Map<String, dynamic>?> _approveExpense({dynamic id, dynamic approved}) async => await _apiRepository.approvePersonExpense(id: id, approved: approved);


  PersonViewBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<AddEditEvent>(_onAddEditEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<ApproveEvent>(_onApproveEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
    on<PersonExpenseDetailEvent>(_onPersonExpenseDetailEvent);
    on<RefreshEvent>(_onRefreshEvent);
    _broadcast.register('expense_person_refresh', (value, callback) => add(RefreshEvent()));

  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<PersonViewState> emit) async {
    try {
      emit(LoadingState());
      await fetchData();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<PersonViewState> emit) async{
    try {
      await fetchData();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onAddEditEvent(AddEditEvent event, Emitter<PersonViewState> emit) async {
    try {
      emit(AddEditPageState(model: event.model));
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<PersonViewState> emit) async {
    try {
      emit(LoadingState());
      var response = await _apiRepository.deletePersonExpense(event.model?['id'] ?? 0);
      final message = response?['message']?.toString() ?? '';
      if (message.contains('Expense deleted successfully.')) {
        final id = event.model?['id']?.toString();
        if (id != null) {
          apiResponse.removeWhere((element) => element['id']?.toString() == id);
          monthResponse.removeWhere((element) => element['id']?.toString() == id);
        }
        await reloadData();
        emit(SuccessState(message));
      } else {
        emit(ErrorState(message));
      }
     } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onApproveEvent(ApproveEvent event, Emitter<PersonViewState> emit) async {
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
      _error(e, emit);
    }
  }

  Future<void> _onDateRangeEvent(DateRangeEvent event, Emitter<PersonViewState> emit) async {
    try {
      emit(LoadingState());
      selectedDateRange = event.selectedDate;
      await fetchData();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onPersonExpenseDetailEvent(PersonExpenseDetailEvent event, Emitter<PersonViewState> emit) async {
    try {
      emit(PersonExpenseDetailState(model: event.model));
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> fetchData() async {
    var data =  await _getPersonExpense(
      startDate: selectedDateRange.start.toFormat(),
      endDate: selectedDateRange.end.toFormat(),
    );
    var oneMonthResponse = List.from(data?['monthlyData'] ?? []);
    var response = List.from(data?['requestData'] ?? []);
    monthResponse = oneMonthResponse;
    apiResponse = response;
    apiResponse.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
        .compareTo(DateTime.parse(a['created_at'] ?? '')));
    for (var element in apiResponse) {
      element['attachments_paths'] = element['attachments'].map((e) => e['path'].toString().toStorageURL).toList();
    }
    await reloadData();
  }

  Future<void> reloadData() async {
    totalAmount = apiResponse.where((e) => (e['approved'] == 1),).map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0).sum;
  }

  void _error(dynamic message, Emitter<PersonViewState> emit){
    Console.of.error(message);
    emit(ErrorState(message));
  }
}