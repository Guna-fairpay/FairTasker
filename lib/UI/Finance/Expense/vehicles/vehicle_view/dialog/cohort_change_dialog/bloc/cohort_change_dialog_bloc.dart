import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cohort_change_dialog_event.dart';
part 'cohort_change_dialog_state.dart';

class CohortChangeDialogBloc extends Bloc<CohortChangeDialogEvent, CohortChangeDialogState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  List<dynamic> cohort = [];

  dynamic model;
  dynamic selectedCohort;

  Future<Map<String, dynamic>?> _updateCategories({dynamic id, dynamic body}) async => await _apiRepository.expenseAddOrUpdateApi(body: body, expenseId: id);

  CohortChangeDialogBloc() : super(LoadingState()){
    on<InitialEvent>(_initialEvent);
    on<CohortDropdownEvent>(_cohortDropdownEvent);
    on<UpdateCohortEvent>(_updateCohortEvent);
  }

  void _initialEvent(InitialEvent event, Emitter<CohortChangeDialogState> emit){
    try {
      model = event.data;
      cohort = model?['cohortList'] ?? [];
      selectedCohort = cohort.firstWhereOrNull((element) => element['id'].toString() == model?['expense_to'].toString(),);
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _cohortDropdownEvent(CohortDropdownEvent event, Emitter<CohortChangeDialogState> emit){
    try {
      selectedCohort = event.data;
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _updateCohortEvent(UpdateCohortEvent event, Emitter<CohortChangeDialogState> emit) async {
    try {
      emit(LoadingState());
      var save = _updateCategorys(model);
      var response = await _updateCategories(body: save, id: model?['id']);
      if(response != null){
        _broadcast.broadcast("expense_vehicle_refresh");
        emit(SuccessState(data: response['message']));
      }else{
        emit(ErrorState(message: response?['message']));
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  void _error(dynamic error, Emitter<CohortChangeDialogState> emit){
    emit(ErrorState(message: error));
  }

  Map<String, String> _updateCategorys(dynamic expense) {
    Map<String, String> baseBody = {};
    baseBody['approved'] ="${expense['approved']}";
    baseBody['category_id'] = "${expense['category_id']??''}";
    baseBody['cohort_id'] = "${expense["cohort_id"] ?? ''}";
    baseBody['employee_id'] = "${getIt<CommonService>().userId}";
    baseBody['expense_amount'] = '${expense['expense_amount']??''}';
    baseBody['expense_date'] = '${expense['expense_date']??''}';
    baseBody['expense_description'] = '${expense['expense_description']??''}';
    baseBody['expense_to'] = "${selectedCohort?['id'] ?? expense['expense_to'] ?? ''}";
    baseBody['odometer'] = "${expense['odometer'] ?? ''}";
    baseBody['payment_method_id'] = "${expense['payment_method_id'] ?? ''}";
    baseBody['platform'] = "TaskerApp";
    baseBody['subcategory_id'] = "${expense['subcategory_id'] ?? ''}";
    baseBody['vin'] = "${expense['vin'] ?? ''}";

    return baseBody;
  }

}