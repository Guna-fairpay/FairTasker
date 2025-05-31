part of 'priority_filter_bloc.dart';

abstract class PriorityFilterEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialEvent extends PriorityFilterEvent{
  final List<dynamic> model;
  InitialEvent(this.model);
  @override
  List<Object> get props => [model];
}

class SelectAllEvent extends PriorityFilterEvent{
  @override
  List<Object> get props => [];
}

class SelectedPriorityEvent extends PriorityFilterEvent{
  final dynamic priority;
  SelectedPriorityEvent(this.priority);
  @override
  List<Object> get props => [priority];
}