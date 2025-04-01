import 'dart:math';

import 'package:equatable/equatable.dart';

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