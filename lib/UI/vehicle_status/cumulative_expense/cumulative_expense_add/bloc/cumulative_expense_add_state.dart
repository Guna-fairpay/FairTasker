import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class CumulativeExpenseAddState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CumulativeExpenseAddLoadingState extends CumulativeExpenseAddState {

}

class CumulativeExpenseAddSuccessState extends CumulativeExpenseAddState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class CumulativeExpenseAddCommonState extends CumulativeExpenseAddState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}



