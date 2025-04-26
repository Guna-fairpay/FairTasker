import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TVPDStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TVPDLoadingState extends TVPDStates {}
class TVPDLoadedState extends TVPDStates {}
class TVPDErrorState extends TVPDStates {
  final dynamic message;
  TVPDErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}
class TVPDSuccessState extends TVPDStates {
  final dynamic message;
  TVPDSuccessState({required this.message});
  @override
  List<Object?> get props => [message];
}

class TVPDCommonState extends TVPDStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TVPDDeleteState extends TVPDStates {
  final dynamic model;
  TVPDDeleteState({required this.model});
  @override
  List<Object?> get props => [model];

}