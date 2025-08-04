part of 'cost_bloc.dart';

abstract class CostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends CostState {}
class CommonState extends CostState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SuccessState extends CostState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class ErrorState extends CostState {
  final dynamic error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error, Random().nextDouble()];
}