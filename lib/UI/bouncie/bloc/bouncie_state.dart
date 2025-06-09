part of 'bouncie_bloc.dart';

abstract class BouncieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends BouncieState {}
class CommonState extends BouncieState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class ErrorState extends BouncieState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}
class SuccessState extends BouncieState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class ViewBouncie extends BouncieState {
  final dynamic model;
  ViewBouncie(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}
