part of 'other_view_bloc.dart';

abstract class OtherViewState extends Equatable{
 @override
 List<Object?> get props => [];
}

class LoadingState extends OtherViewState{}

class CommonState extends OtherViewState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends OtherViewState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends OtherViewState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}