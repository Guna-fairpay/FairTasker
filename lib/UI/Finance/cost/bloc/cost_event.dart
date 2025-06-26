part of 'cost_bloc.dart';

abstract class CostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends CostEvent {
  final dynamic model;
  InitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class PaginationEvent extends CostEvent {
  final int page;
  PaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}