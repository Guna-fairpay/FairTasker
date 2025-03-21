import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TFRDStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TFRDLoadingState extends TFRDStates {}
class TFRDCommonState extends TFRDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TFRDSuccessState extends TFRDStates {
  final dynamic message;
  TFRDSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class TFRDErrorState extends TFRDStates {
  final dynamic message;
  TFRDErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class TFRDSelectedState extends TFRDStates {
  final List<Map<String, dynamic>> selected;
  TFRDSelectedState(this.selected);
  @override
  List<Object?> get props => [selected, Random().nextDouble()];
}