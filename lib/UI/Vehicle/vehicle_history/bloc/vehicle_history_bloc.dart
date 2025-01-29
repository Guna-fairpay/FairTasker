
import 'package:fairpytasker/UI/Vehicle/vehicle_history/repository/vehicle_history_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../event/vehicle_history_event.dart';
import '../state/vehicle_history_state.dart';

class VehicleHistoryBloc extends Bloc<VehicleHistoryEvent, VehicleHistoryState> {
  final VehicleHistoryRepository vehicleHistoryRepository =
  VehicleHistoryRepository();
  VehicleHistoryBloc()
      : super(VehicleHistoryState(
    vin: '',
    vehicleName: '',
    searchController: TextEditingController(),
    apiResponse: [],
    vehicleDataList: [],
    filteredResponse: [],
    filterVehicleDataList: [],
    resourceList: [],
    userGroupList: [],
    title: '',
    isLoading: true,
  )) {
    on<LoadVehicleHistory>((event, emit) async {
     // emit(state.copyWith(isLoading: true, apiResponse: []));

      var response =
      await vehicleHistoryRepository.getVehicleHistoryList(event.pageNo,event.vin);


    });

    on<LoadVehicleHistory>(_onLoadVehicleHistory);
    on<UpdateVehicleName>(_onUpdateVehicleName);
  }

  void _onLoadVehicleHistory(
      LoadVehicleHistory event,
      Emitter<VehicleHistoryState> emit,
      ) {
   // emit(state.copyWith(vin: event.vin, apiResponse: [], vehicleDataList: [], filteredResponse: [], filterVehicleDataList: [], resourceList: [], userGroupList: [], scrollController: ScrollController(), title: ''));
  }

  void _onUpdateVehicleName(
      UpdateVehicleName event,
      Emitter<VehicleHistoryState> emit,
      ) {
   // emit(state.copyWith(vehicleName: event.vehicleName, apiResponse: [], vehicleDataList: [], filteredResponse: [], filterVehicleDataList: [], resourceList: [], userGroupList: [], scrollController: ScrollController(), title: ''));
  }
}
