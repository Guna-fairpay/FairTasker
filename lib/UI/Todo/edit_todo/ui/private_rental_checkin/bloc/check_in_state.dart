part of 'check_in_bloc.dart';

abstract class CheckInState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends CheckInState {}

class CommonState extends CheckInState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends CheckInState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends CheckInState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class ViewImageState extends CheckInState {
  final List<dynamic> data;
  ViewImageState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class AddOnPictureDialogState extends CheckInState {
  final List<dynamic> data;
  final String title;
  AddOnPictureDialogState({required this.data, required this.title});
  @override
  List<Object?> get props => [data, title, Random().nextDouble()];
}