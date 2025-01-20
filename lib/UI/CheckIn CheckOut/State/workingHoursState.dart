
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingHoursResponse.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingReasonResponse.dart';

import '../Response/checkInOutResponse.dart';


abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskErrorState extends TaskState {
  final String errorMessage;

  TaskErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class TaskLoadedState extends TaskState {
  final WorkingHoursResponse history;
  TaskLoadedState(this.history);
  @override
  List<Object?> get props => [history];
}

class CommentLoadedState extends TaskState
{
  final WorkingReasonResponse comment;
  CommentLoadedState(this.comment);
  @override
  List<Object?> get props => [comment];
}

class CheckInoutReasonLoadedState extends TaskState
{
  final CheckInOutReasonResponse data;
  CheckInoutReasonLoadedState(this.data);
  @override
  List<Object?> get props => [data];
}
