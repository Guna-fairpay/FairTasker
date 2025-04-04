import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class HeaderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HeaderLoadingState extends HeaderState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class HeaderCommonState extends HeaderState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class HeaderErrorState extends HeaderState {
  final dynamic message;
  HeaderErrorState(this.message);
  @override
  List<Object?> get props => [Random().nextDouble()];
}