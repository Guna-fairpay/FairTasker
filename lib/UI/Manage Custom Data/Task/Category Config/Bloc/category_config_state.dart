import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class CategoryConfigState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryConfigLoadingState extends CategoryConfigState {}

class CategoryConfigCommonState extends CategoryConfigState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class CategoryConfigErrorState extends CategoryConfigState {
  final dynamic message;
  CategoryConfigErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class CategoryConfigSuccessState extends CategoryConfigState {
  final dynamic message;
  CategoryConfigSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}



