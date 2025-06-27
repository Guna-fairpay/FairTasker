part of 'leads_bloc.dart';

abstract class LeadsEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends LeadsEvent {}

class ShowMoreEvent extends LeadsEvent {}

class ActiveStatesEvent extends LeadsEvent{
  final dynamic status;
  ActiveStatesEvent(this.status);
  @override
  List<Object?> get props => [status];
}

class SearchEvent extends LeadsEvent{
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SaveEvent extends LeadsEvent{}

class CloseEvent extends LeadsEvent{}

class DeleteEvent extends LeadsEvent{}

class PaginationEvent extends LeadsEvent{}

