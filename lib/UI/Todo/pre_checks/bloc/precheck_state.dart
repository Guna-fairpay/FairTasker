import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class PreCheckState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PreCheckLoadingState extends PreCheckState {}
class PreCheckCommonState extends PreCheckState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class PreCheckSuccessState extends PreCheckState {
  final dynamic message;
  PreCheckSuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class PreCheckErrorState extends PreCheckState {
  final dynamic message;
  PreCheckErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class PreCheckPopupState extends PreCheckState {
  final dynamic model;
  PreCheckPopupState({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class PreCheckCompleteState extends PreCheckState {}