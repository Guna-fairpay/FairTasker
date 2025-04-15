import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class SuppliesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SuppliesLoadingState extends SuppliesState {}

class SuppliesCommonState extends SuppliesState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SuppliesErrorState extends SuppliesState {
  final dynamic message;
  SuppliesErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class SuppliesSuccessState extends SuppliesState {
  final dynamic message;
  SuppliesSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}



