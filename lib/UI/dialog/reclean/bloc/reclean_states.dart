import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class RecleanState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecleanLoadingState extends RecleanState {}
class RecleanCommonState extends RecleanState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class RecleanCloseState extends RecleanState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class RecleanSubmitState extends RecleanState {
  final String reasonMessage;
  final List<dynamic> reasonFiles;
  RecleanSubmitState(this.reasonMessage, this.reasonFiles);
  @override
  List<Object?> get props => [reasonMessage, reasonFiles, Random().nextDouble()];
}