
part of 'edit_vehicle_bloc.dart';

abstract class EditVehicleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditVehicleLoadingState extends EditVehicleState {}

class EditVehicleLoadedState extends EditVehicleState {}

class EditCompletedState extends EditVehicleState {}

class EditVehicleCommonState extends EditVehicleState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditVehicleErrorState extends EditVehicleState {
  final dynamic message;
  EditVehicleErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class EditVehicleSuccessState extends EditVehicleState {
  final dynamic message;
  EditVehicleSuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}
