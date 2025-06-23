
part of 'category_filter_bloc.dart';

abstract class CategoryFilterEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class CategoryFilterInitialEvent extends CategoryFilterEvent{
  final List<Map<String, dynamic>> expenseDetails;
  final dynamic idList;
  CategoryFilterInitialEvent(this.expenseDetails, {this.idList});
  @override
  List<Object?> get props => [expenseDetails, idList];
}

class CategoryFilterSelectAllEvent extends CategoryFilterEvent{
  @override
  List<Object?> get props => [];
}

class CategoryFilterSelectCategoryEvent extends CategoryFilterEvent{
  final dynamic model;
  final bool value;
  CategoryFilterSelectCategoryEvent(this.model, {this.value = true});
  @override
  List<Object?> get props => [model, value];
}

class CategoryFilterSelectSubCategoryEvent extends CategoryFilterEvent{
  final dynamic model;
  CategoryFilterSelectSubCategoryEvent(this.model);
  @override
    List<Object?> get props => [model];
}