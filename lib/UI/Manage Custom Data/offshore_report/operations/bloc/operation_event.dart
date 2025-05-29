part of 'operation_bloc.dart';

abstract class OperationEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class OperationInitialEvent extends OperationEvent{}