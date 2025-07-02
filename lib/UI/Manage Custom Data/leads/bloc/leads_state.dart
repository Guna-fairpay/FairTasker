part of 'leads_bloc.dart';

abstract class LeadsState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends LeadsState {}

class CommonState extends LeadsState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends LeadsState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, DateTime.now()];
}

class SuccessState extends LeadsState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, DateTime.now()];
}