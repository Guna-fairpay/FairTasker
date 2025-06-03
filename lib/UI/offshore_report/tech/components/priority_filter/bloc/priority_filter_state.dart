part of 'priority_filter_bloc.dart';

abstract class PriorityFilterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommonState extends PriorityFilterState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends PriorityFilterState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class OnChangeState extends PriorityFilterState {
  final List<dynamic> value;
  OnChangeState(this.value);
  @override
  List<Object?> get props => [value, Random().nextDouble()];
}
