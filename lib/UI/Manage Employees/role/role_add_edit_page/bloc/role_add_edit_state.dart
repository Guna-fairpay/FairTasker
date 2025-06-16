part of 'role_add_edit_bloc.dart';

abstract class RoleAddEditState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends RoleAddEditState{}

class CommonState extends RoleAddEditState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends RoleAddEditState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends RoleAddEditState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

