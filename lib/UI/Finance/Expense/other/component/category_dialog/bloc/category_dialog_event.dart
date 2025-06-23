part of 'category_dialog_bloc.dart';

abstract class CategoryDialogEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends CategoryDialogEvent{
  final dynamic model;
  InitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class CategoryEvent extends CategoryDialogEvent{
  final dynamic selectedCategory;
  CategoryEvent({required this.selectedCategory});
  @override
  List<Object?> get props => [selectedCategory];
}

class SubCategoryEvent extends CategoryDialogEvent {
  final dynamic selectedSubCategory;
  SubCategoryEvent({required this.selectedSubCategory});
  @override
  List<Object?> get props => [selectedSubCategory];
}

class UpdateEvent extends CategoryDialogEvent{
  @override
  List<Object?> get props => [];
}