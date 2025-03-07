
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Repository/api_repository.dart';
import '../event/vehicle_expense_history_event.dart';
import '../state/vehicle_expense_history_state.dart';

class VehicleExpenseHistoryBloc
    extends Bloc<VehicleExpenseHistoryEvent, VehicleExpenseHistoryState> {
  final APiRepository apiRepository = APiRepository();

  VehicleExpenseHistoryBloc()
      : super(VehicleExpenseHistoryState(
          searchController: TextEditingController(),
          apiResponse: const [],
          filteredResponse: const [],
          attachments: const [],
          editResponse: const {},
          isLoading: true,
        )) {

    on<GetVehicleExpenseHistoryList>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      var response = await apiRepository.getVehicleExpense(vin: event.vin);
      var apiResponse = response?.data;
      apiResponse?.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
          .compareTo(DateTime.parse(a['created_at'] ?? '')));

      emit(state.copyWith(
        isLoading: false,
        apiResponse: apiResponse,
        filteredResponse: apiResponse,
        attachments: [],
      ));
    });

    on<GetEditVehicleExpenseHistory>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      var response = await apiRepository.getEditVehicleExpense(id: event.id);
      var apiResponse = response?.expenses;
      emit(state.copyWith(
        isLoading: false,
        editResponse: apiResponse,
        attachments: [],
      ));
    });

    on<SearchVehicleExpenseHistoryEvent>((event, emit) {
      if (event.query == null || event.query!.isEmpty) {
        emit(state.copyWith(filteredResponse: state.apiResponse));
      } else {
        var filteredResponse = state.apiResponse.where((element) {
          final description = (element['expense_description'] ?? '').toString().toLowerCase();
          final amount = (element['expense_amount'] ?? '').toString().toLowerCase();
          final date = (element['expense_date'] ?? '').toString().toLowerCase();

          return description.contains(event.query!.toLowerCase()) ||
              date.contains(event.query!.toLowerCase()) ||
              amount.contains(event.query!.toLowerCase());
        }).toList();

        emit(state.copyWith(filteredResponse: filteredResponse));
      }
    });

  }
}
