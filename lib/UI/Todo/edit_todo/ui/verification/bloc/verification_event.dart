part of 'verification_bloc.dart';

abstract class VerificationEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends VerificationEvent{
  final dynamic data;
  InitialEvent({this.data});
  @override
  List<Object?> get props => [data];
}

class TabChangeEvent extends VerificationEvent{
  final int value;
  TabChangeEvent(this.value);
  @override
  List<Object?> get props => [value];
}

class CheckListEvent extends VerificationEvent{
  final dynamic data;
  CheckListEvent(this.data);
  @override
  List<Object?> get props => [data];
}