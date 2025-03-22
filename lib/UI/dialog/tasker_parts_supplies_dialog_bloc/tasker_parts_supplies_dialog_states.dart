import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TPSDStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TPSDLoadingState extends TPSDStates {}
class TPSDCommonState extends TPSDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TPSDErrorState extends TPSDStates {
  final dynamic message;
  TPSDErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class TPSDSuccessState extends TPSDStates {
  final dynamic message;
  TPSDSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}