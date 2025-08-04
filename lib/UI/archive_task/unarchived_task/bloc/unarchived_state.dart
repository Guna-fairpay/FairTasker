part of 'unarchived_bloc.dart';

abstract class UnarchivedState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends UnarchivedState{}

class ErrorState extends UnarchivedState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends UnarchivedState{
  final dynamic data;
  SuccessState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class CommonState extends UnarchivedState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}