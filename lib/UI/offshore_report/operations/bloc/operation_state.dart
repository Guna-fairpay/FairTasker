part of 'operation_bloc.dart';

abstract class OperationState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends OperationState{}

class CommonState extends OperationState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends OperationState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends OperationState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}