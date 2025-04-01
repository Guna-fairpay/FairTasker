
import 'package:equatable/equatable.dart';

abstract class CategoryConfigState extends Equatable {
  const CategoryConfigState();

  @override
  List<Object?> get props => [];
}

class CategoryConfigInitial extends CategoryConfigState {
  @override
  List<Object> get props => [];
}

class CategoryConfigLoading extends CategoryConfigState {}

class CategoryConfigListLoaded extends CategoryConfigState {
  final List<Map<String, dynamic>>? data;

  const CategoryConfigListLoaded(
      {required this.data});

  @override
  List<Object?> get props => [data];
}

class CategoryConfigLoaded extends CategoryConfigState {
  final String? message;
  const CategoryConfigLoaded({required this.message,});
  @override
  List<Object?> get props => [message];
}


class CategoryConfigError extends CategoryConfigState {
  final String message;

  const CategoryConfigError(this.message);

  @override
  List<Object> get props => [message];
}

