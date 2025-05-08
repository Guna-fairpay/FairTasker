
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class LeaveAddEditState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LeaveAddEditLoadingState extends LeaveAddEditState{}

class LeaveAddEditCommonState extends LeaveAddEditState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class LeaveAddEditSuccessState extends LeaveAddEditState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class LeaveAddEditErrorState extends LeaveAddEditState {
  final dynamic error;
  LeaveAddEditErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
