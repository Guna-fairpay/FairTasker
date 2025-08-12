part of 'tasker_meeting_bloc.dart';

abstract class TaskerMeetingEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends TaskerMeetingEvent{
  final dynamic model;
  InitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class SubmitEvent extends TaskerMeetingEvent{}
