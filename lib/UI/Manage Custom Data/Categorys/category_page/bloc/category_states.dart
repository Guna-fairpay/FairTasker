import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryLoadingState extends CategoryState {}
class CategoryCommonState extends CategoryState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class CategoryErrorState extends CategoryState {
  final dynamic message;
  CategoryErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CategorySuccessState extends CategoryState {
  final dynamic message;
  CategorySuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CategoryDeleteTapState extends CategoryState {
  final dynamic model;
  CategoryDeleteTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}