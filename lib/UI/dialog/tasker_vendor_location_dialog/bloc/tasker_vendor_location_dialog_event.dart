import 'package:equatable/equatable.dart';

abstract class TVLDEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TVLDInitialEvent extends TVLDEvent {
  final Map<String, dynamic>? model;
  TVLDInitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TVLDSelectEvent extends TVLDEvent {
  final dynamic value;
  TVLDSelectEvent(this.value);
  @override
  List<Object?> get props => [value];
}

class TVLDSubmitEvent extends TVLDEvent {}

class TVLDRefreshEvent extends TVLDEvent {}