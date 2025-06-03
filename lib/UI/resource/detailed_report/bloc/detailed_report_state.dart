part of 'detailed_report_bloc.dart';

abstract class DetailedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends DetailedState {}
class CommonState extends DetailedState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends DetailedState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends DetailedState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class ViewFilterState extends DetailedState {
  final dynamic model;
  ViewFilterState({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}