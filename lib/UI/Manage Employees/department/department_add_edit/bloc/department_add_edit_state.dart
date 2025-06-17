part of'department_add_edit_bloc.dart';

abstract class DepartmentAddEditState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends DepartmentAddEditState{}

class ErrorState extends DepartmentAddEditState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends DepartmentAddEditState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends DepartmentAddEditState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}
