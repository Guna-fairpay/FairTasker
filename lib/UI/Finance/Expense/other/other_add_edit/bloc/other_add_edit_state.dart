part of 'other_add_edit_bloc.dart';

abstract class OtherAddEditState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends OtherAddEditState{}

class ErrorState extends OtherAddEditState{
  final dynamic error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error, Random().nextDouble()];
}

class SuccessState extends OtherAddEditState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends OtherAddEditState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}