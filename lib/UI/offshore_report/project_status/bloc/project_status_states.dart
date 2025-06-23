part of 'project_status_bloc.dart';

abstract class ProjectStatusStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends ProjectStatusStates {}
class CommonState extends ProjectStatusStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends ProjectStatusStates {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends ProjectStatusStates {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}