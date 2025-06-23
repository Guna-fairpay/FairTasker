
part of 'category_filter_bloc.dart';

abstract class CategoryFilterState extends Equatable{
  @override
  List<Object?> get props => [];
}

class CategoryFilterCommonState extends CategoryFilterState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class OnchangeState extends CategoryFilterState {
  final List<dynamic> value;
  OnchangeState({required this.value});
  @override
  List<Object?> get props => [value, Random().nextDouble()];
}