
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class LeaveViewState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LeaveViewLoadingState extends LeaveViewState{}

class LeaveViewCommonState extends LeaveViewState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddEditPageState extends LeaveViewState{
  final dynamic leaveData;
  AddEditPageState({this.leaveData});
  @override
  List<Object?> get props => [leaveData,Random().nextDouble()];
}

class VerificationPageState extends LeaveViewState{
  final dynamic leaveData;
  VerificationPageState({this.leaveData});
  @override
  List<Object?> get props => [leaveData,Random().nextDouble()];
}
