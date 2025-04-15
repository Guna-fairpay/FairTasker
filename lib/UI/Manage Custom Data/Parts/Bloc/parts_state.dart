import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class PartsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PartsLoadingState extends PartsState {}

class PartsCommonState extends PartsState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class PartsErrorState extends PartsState {
  final dynamic message;
  PartsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class PartsSuccessState extends PartsState {
  final dynamic message;
  PartsSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}



