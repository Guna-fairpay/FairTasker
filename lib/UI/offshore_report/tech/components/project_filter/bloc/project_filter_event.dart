part of 'project_filter_bloc.dart';

abstract class ProjectFilterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends ProjectFilterEvent {
  final List<Map<String, dynamic>>? model;
  InitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ProjectSearchEvent extends ProjectFilterEvent {
  final String query;
  ProjectSearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SelectAllEvent extends ProjectFilterEvent {}

class SelectProjectEvent extends ProjectFilterEvent {
   final dynamic model;
   SelectProjectEvent(this.model);
   @override
   List<Object?> get props => [model];
}