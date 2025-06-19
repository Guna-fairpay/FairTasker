part of 'set_vehicles_bloc.dart';

abstract class SetVehiclesState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends SetVehiclesState {}

class CommonState extends SetVehiclesState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends SetVehiclesState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends SetVehiclesState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class PopupState extends SetVehiclesState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}