import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TVSStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TVSLoadingState extends TVSStates {}
class TVSUpdatedState extends TVSStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TVSSuccessState extends TVSStates {
  final dynamic message;
  TVSSuccessState({required this.message});
  @override
  List<Object?> get props => [message];
}

class TVSErrorState extends TVSStates {
  final dynamic message;
  TVSErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}

