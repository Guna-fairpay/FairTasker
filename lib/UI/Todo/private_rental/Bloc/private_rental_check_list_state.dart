
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class PrivateRentalCheckState extends Equatable{
  @override
  List<Object?> get props => [];
}

class PrivateRentalCheckLoadingState extends PrivateRentalCheckState {}

class PrivateRentalCheckCommonState extends PrivateRentalCheckState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class PrivateRentalCheckPopupState extends PrivateRentalCheckState {
  final dynamic model;
  PrivateRentalCheckPopupState({this.model});
  @override
  List<Object?> get props => [model,Random().nextDouble()];
}


class PrivateRentalCheckDialogState extends PrivateRentalCheckState {
  final dynamic model;
  PrivateRentalCheckDialogState({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class PrivateRentalCheckSuccessState extends PrivateRentalCheckState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}