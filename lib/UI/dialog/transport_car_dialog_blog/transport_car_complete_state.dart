
import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TCCDState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TCCDLoadingState extends TCCDState {}
class TOCDCommonState extends TCCDState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TOCDErrorState extends TCCDState {
  final String? message;
  TOCDErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class TOCDSuccessState extends TCCDState {
  final String? message;
  TOCDSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}