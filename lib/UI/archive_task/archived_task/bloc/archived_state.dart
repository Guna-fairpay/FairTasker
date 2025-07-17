part of 'archived_bloc.dart';

abstract class ArchivedState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends ArchivedState{}

class ErrorState extends ArchivedState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends ArchivedState{
  final dynamic data;
  SuccessState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class CommonState extends ArchivedState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}