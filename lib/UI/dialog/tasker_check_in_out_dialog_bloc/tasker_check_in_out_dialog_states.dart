part of 'tasker_check_in_out_dialog_bloc.dart';

abstract class TCIODStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TCIODLoadingState extends TCIODStates {}
class TCIODSuccessState extends TCIODStates {
  final dynamic message;
  TCIODSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class TCIODErrorState extends TCIODStates {
  final dynamic message;
  TCIODErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class TCIODCommonState extends TCIODStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class NavigateYesterdayState extends TCIODStates {
  final DateTime date;
  NavigateYesterdayState(this.date);
  @override
  List<Object?> get props => [Random().nextDouble()];
}