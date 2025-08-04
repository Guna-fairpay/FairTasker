import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttendanceLoadingState extends AttendanceState {}
class AttendanceCommonState extends AttendanceState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class AttendanceErrorState extends AttendanceState {
  final dynamic message;
  AttendanceErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}