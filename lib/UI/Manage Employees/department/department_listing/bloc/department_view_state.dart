part of 'department_view_bloc.dart';

abstract class DepartmentViewState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends DepartmentViewState{}

class ErrorState extends DepartmentViewState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends DepartmentViewState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends DepartmentViewState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddEditState extends DepartmentViewState{
  final dynamic model;
  AddEditState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}
