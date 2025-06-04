part of 'category_dialog_bloc.dart';

abstract class CategoryDialogState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends CategoryDialogState{}

class CommonState extends CategoryDialogState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SuccessState extends CategoryDialogState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class ErrorState extends CategoryDialogState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
