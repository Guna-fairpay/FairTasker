part of 'vehicle_add_edit_bloc.dart';

abstract class VehicleAddEditState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends VehicleAddEditState {}

class CommonState extends VehicleAddEditState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends VehicleAddEditState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends VehicleAddEditState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class TodoTaskViewSate extends VehicleAddEditState {
  final dynamic model;
  TodoTaskViewSate(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class InvoiceState extends VehicleAddEditState {
  final dynamic model;
  InvoiceState({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class SaveState extends VehicleAddEditState {}