part of 'tasker_meeting_bloc.dart';

abstract class TaskerMeetingState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends TaskerMeetingState{}

class CommonState extends TaskerMeetingState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends TaskerMeetingState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends TaskerMeetingState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}