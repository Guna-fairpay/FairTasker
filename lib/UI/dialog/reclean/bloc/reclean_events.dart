import 'package:equatable/equatable.dart';

abstract class RecleanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecleanInitialEvent extends RecleanEvent {
  final Map<String, dynamic>? model;
  RecleanInitialEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class RecleanTriggerEvent extends RecleanEvent {}
class RecleanPickFileEvent extends RecleanEvent {}
class RecleanDeleteFileEvent extends RecleanEvent {
  final dynamic model;
  RecleanDeleteFileEvent(this.model);
  @override
  List<Object?> get props => [model];
}
class RecleanSubmitEvent extends RecleanEvent {}
class RecleanCloseEvent extends RecleanEvent {}