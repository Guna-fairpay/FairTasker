part of'permission_add_edit_bloc.dart';

abstract class PermissionAddEditState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends PermissionAddEditState{}

class ErrorState extends PermissionAddEditState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends PermissionAddEditState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends PermissionAddEditState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}
