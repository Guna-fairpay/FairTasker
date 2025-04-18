import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class BillState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BillLoadingState extends BillState {}

class BillLoadedState extends BillState {}

class BillCommonState extends BillState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}



