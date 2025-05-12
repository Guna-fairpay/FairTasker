import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class SubCategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubCategoryLoadingState extends SubCategoryState {}
class SubCategoryCommonState extends SubCategoryState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class SubCategorySuccessState extends SubCategoryState {
  final dynamic message;
  SubCategorySuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SubCategoryErrorState extends SubCategoryState {
  final dynamic message;
  SubCategoryErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SubCategoryShowDeleteDialogState extends SubCategoryState {
  final dynamic model;
  SubCategoryShowDeleteDialogState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}