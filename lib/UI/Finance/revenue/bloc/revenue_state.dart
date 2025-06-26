part of 'revenue_bloc.dart';

abstract class RevenueState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends RevenueState {}

class CommonState extends RevenueState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends RevenueState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class VehiclePageState extends RevenueState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}