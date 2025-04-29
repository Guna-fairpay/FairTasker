
import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TCCDState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TCCDLoadingState extends TCCDState {}
class TCCDCommonState extends TCCDState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TCCDErrorState extends TCCDState {
  final String? message;
  TCCDErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class TCCDSuccessState extends TCCDState {
  final String? message;
  TCCDSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}