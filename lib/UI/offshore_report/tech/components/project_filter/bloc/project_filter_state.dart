part of 'project_filter_bloc.dart';

abstract class ProjectFilterState extends Equatable{
  @override
  List<Object?> get props => [];
}

class CommonState extends ProjectFilterState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends ProjectFilterState{
  final String error;
  ErrorState({required this.error});
  @override
  List<Object?> get props => [error,Random().nextDouble()];
}

class OnChangeState extends ProjectFilterState{
  final List<dynamic> value;
  OnChangeState({required this.value});
  @override
  List<Object?> get props => [value, Random().nextDouble()];
}