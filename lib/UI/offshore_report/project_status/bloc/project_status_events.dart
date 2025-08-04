part of 'project_status_bloc.dart';

abstract class ProjectStatusEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends ProjectStatusEvents {}

class MilestoneEvent extends ProjectStatusEvents {}

class BackLogEvent extends ProjectStatusEvents {}

class RoadMapEvent extends ProjectStatusEvents {}

class FilterEvent extends ProjectStatusEvents {
  final String filter;
  FilterEvent(this.filter);
  @override
  List<Object?> get props => [filter];
}

class SearchEvent extends ProjectStatusEvents {
  final String search;
  SearchEvent(this.search);
  @override
  List<Object?> get props => [search];
}