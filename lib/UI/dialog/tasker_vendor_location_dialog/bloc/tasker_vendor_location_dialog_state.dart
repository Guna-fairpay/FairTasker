import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TVLDState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TVLDLoadingState extends TVLDState {}
class TVLDCommonState extends TVLDState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TVLDSubmitState extends TVLDState {
  final Map<String, dynamic> data;
  TVLDSubmitState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}