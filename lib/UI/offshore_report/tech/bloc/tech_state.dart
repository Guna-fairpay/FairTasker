part of 'tech_bloc.dart';

abstract class TechState extends Equatable{
  @override
  List<Object?> get props =>[];
}

class LoadingState extends TechState{}

class CommonState extends TechState{
  @override
  List<Object> get props => [Random().nextDouble()];
}

class ErrorState extends TechState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object> get props => [message, Random().nextDouble()];
}

class SuccessState extends TechState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object> get props => [message, Random().nextDouble()];
}

class ProjectFilterState extends TechState{
  final List<Map<String, dynamic>>? model;
  ProjectFilterState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class PriorityFilterState extends TechState{
  final List<dynamic>? model;
  PriorityFilterState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}