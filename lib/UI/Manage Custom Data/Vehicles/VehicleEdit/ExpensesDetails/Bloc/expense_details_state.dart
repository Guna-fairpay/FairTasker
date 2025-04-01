
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract  class ExpenseDetailsState extends Equatable{
   @override
  List<Object?> get props => [];
}

class ExpenseDetailsLoadingState extends ExpenseDetailsState{}

class ExpenseDetailsLoadedState extends ExpenseDetailsState{}

class ExpenseDetailsCommonState extends ExpenseDetailsState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ExpenseDetailsErrorState extends ExpenseDetailsState {
  final dynamic message;
  ExpenseDetailsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

