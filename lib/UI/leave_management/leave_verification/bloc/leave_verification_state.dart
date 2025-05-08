
import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class LeaveVerificationState extends Equatable{
  @override
  List<Object> get props => [];
}

class LeaveVerificationLoadingState extends LeaveVerificationState{}

class LeaveVerificationSuccessState extends LeaveVerificationState{
  @override
  List<Object> get props => [Random().nextDouble()];
}

class LeaveVerificationCommonState extends LeaveVerificationState{
  @override
  List<Object> get props => [Random().nextDouble()];
}

class LeaveVerificationErrorState extends LeaveVerificationState{
  final String message;
  LeaveVerificationErrorState(this.message);
  @override
  List<Object> get props => [message,Random().nextDouble()];
}
