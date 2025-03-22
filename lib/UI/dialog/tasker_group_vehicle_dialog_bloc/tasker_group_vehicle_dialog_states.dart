import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TGVDStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TGVDLoadingStates extends TGVDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TGVDSuccessStates extends TGVDStates {
  final dynamic message;
  TGVDSuccessStates(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class TGVDErrorStates extends TGVDStates {
  final dynamic message;
  TGVDErrorStates(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class TGVDCommonState extends TGVDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}