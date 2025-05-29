part of 'operation_bloc.dart';

abstract class OperationState extends Equatable{
  @override
  List<Object?> get props => [];
}

class OperationLoadingState extends OperationState{}

class OperationCommonState extends OperationState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}