part of 'resource_check_in_out_bloc.dart';

abstract class ResourceCheckInOutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends ResourceCheckInOutState {}
class CommonState extends ResourceCheckInOutState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends ResourceCheckInOutState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends ResourceCheckInOutState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}