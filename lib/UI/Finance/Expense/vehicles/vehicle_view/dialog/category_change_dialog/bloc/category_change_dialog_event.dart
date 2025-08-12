part of 'category_change_dialog_bloc.dart';

abstract class CategoryDialogEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends CategoryDialogEvent{
  final dynamic data;
  InitialEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class CategoryDropdownEvent extends CategoryDialogEvent{
  final dynamic data;
  CategoryDropdownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class SubcategoryDropdownEvent extends CategoryDialogEvent{
  final dynamic data;
  SubcategoryDropdownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class NavigateSubcategoryEvent extends CategoryDialogEvent{
  final dynamic data;
  NavigateSubcategoryEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class UpdateCategoryEvent extends CategoryDialogEvent{}

class RefreshEvent extends CategoryDialogEvent{}