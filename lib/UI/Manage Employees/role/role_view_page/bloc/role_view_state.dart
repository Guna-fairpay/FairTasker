part of 'role_view_bloc.dart';

abstract class RoleViewState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends RoleViewState{}

class ErrorState extends RoleViewState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends RoleViewState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class AddEditState extends RoleViewState{
  final dynamic model;
  final bool isRoleEdit;
  final bool isUserEdit;
  AddEditState({this.model, required this.isRoleEdit, required this.isUserEdit});
  @override
  List<Object?> get props => [model, isRoleEdit, isUserEdit, Random().nextDouble()];
}

class CommonState extends RoleViewState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}