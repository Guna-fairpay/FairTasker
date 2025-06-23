import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class CumulativeExpenseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CumulativeExpenseLoadingState extends CumulativeExpenseState {}

class CumulativeExpenseCommonState extends CumulativeExpenseState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class PartsSuccessState extends CumulativeExpenseState {}



