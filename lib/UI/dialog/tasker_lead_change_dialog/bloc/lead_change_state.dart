part of 'lead_change_bloc.dart';

abstract class LeadChangeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommonState extends LeadChangeState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class LoadingState extends LeadChangeState {}

class ErrorState extends LeadChangeState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CompleteState extends LeadChangeState {
  final dynamic model;
  CompleteState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CloseState extends LeadChangeState {}

class EmptyLeadState extends LeadChangeState {
  final String message;
  EmptyLeadState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}