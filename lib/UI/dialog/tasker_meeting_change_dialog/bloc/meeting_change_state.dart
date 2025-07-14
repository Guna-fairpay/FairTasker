part of 'meeting_change_bloc.dart';

abstract class MeetingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommonState extends MeetingState {}

class CompleteState extends MeetingState {
  final Map<String, dynamic> model;
  CompleteState(this.model);
  @override
  List<Object?> get props => [model];
}

class CloseState extends MeetingState {}

class ErrorState extends MeetingState {
  final dynamic model;
  ErrorState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}