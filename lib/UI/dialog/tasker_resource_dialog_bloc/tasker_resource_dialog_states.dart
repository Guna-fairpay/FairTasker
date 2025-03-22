import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TRSDStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TRSDLoadingState extends TRSDStates {}

class TRSDErrorState extends TRSDStates {
  final dynamic message;
  TRSDErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class TRSDSuccessState extends TRSDStates {
  final dynamic message;
  TRSDSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class TRSDCommonState extends TRSDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
