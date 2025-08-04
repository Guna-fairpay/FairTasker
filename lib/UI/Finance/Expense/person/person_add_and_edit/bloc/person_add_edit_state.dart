part of 'person_add_edit_bloc.dart';

abstract class PersonAddEditState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends PersonAddEditState {}

class ErrorState extends PersonAddEditState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends PersonAddEditState {
  final dynamic success;
  SuccessState(this.success);
  @override
  List<Object?> get props => [success, Random().nextDouble()];
}

class CommonState extends PersonAddEditState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}