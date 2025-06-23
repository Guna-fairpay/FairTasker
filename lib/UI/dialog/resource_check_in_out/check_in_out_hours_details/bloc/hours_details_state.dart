part of 'hours_details_bloc.dart';

abstract class HourDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends HourDetailsState {}
class CommonState extends HourDetailsState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends HourDetailsState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends HourDetailsState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class ViewResourceDetailsState extends HourDetailsState {
  final dynamic model;
  ViewResourceDetailsState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}