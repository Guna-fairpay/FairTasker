part of 'precheck_bloc.dart';

abstract class PrecheckState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends PrecheckState {}

class CommonState extends PrecheckState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SuccessState extends PrecheckState {
  final dynamic message;
  final bool pop;
  SuccessState({this.message, this.pop = false});
  @override
  List<Object?> get props => [message, pop, Random().nextDouble()];
}

class ErrorState extends PrecheckState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class TollAlertDialogState extends PrecheckState {
  final dynamic model;
  final bool showDialog;
  TollAlertDialogState({this.model, this.showDialog = false});
  @override
  List<Object?> get props => [model, showDialog, Random().nextDouble()];
}

class DeleteImageState extends PrecheckState {
  final dynamic model;
  DeleteImageState({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class DeleteOrCompleteState extends PrecheckState {
  final dynamic model;
  DeleteOrCompleteState({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}