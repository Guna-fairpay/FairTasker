part of 'private_rental_customers_bloc.dart';

abstract class State extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends State {}
class CommonState extends State {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class ErrorState extends State {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}
class SuccessState extends State {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class DeleteState extends State {
  final dynamic model;
  DeleteState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class DeleteLicenseState extends State {
  final dynamic model;
  DeleteLicenseState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}
class DeleteInsuranceState extends State {
  final dynamic model;
  DeleteInsuranceState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}