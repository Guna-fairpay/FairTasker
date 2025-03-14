


import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Vehicle%20Edit%20Page/vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Vehicle%20Edit%20Page/vehicle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class vehicleBloc extends Bloc<vehiclePageEvent, vehiclePageState> {
  vehicleBloc() : super(const vehiclePageState()) {
    on<vehicleInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
    });
}
}