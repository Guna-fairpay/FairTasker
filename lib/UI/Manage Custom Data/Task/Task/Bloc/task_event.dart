
import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitialEvent extends TaskEvent {
  final String? title;
  TaskInitialEvent({this.title});
  @override
  List<Object?> get props => [title];
}

class NoCategoryEvent extends TaskEvent {
  final dynamic value;

  NoCategoryEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class TaskPaginationEvent extends TaskEvent {
  final int page;
  TaskPaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class SearchTaskEvent extends TaskEvent {
  final String query;
  SearchTaskEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class EditTaskEvent extends TaskEvent {
  final dynamic data;
  EditTaskEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class CategoryDropDownEvent extends TaskEvent {
  final dynamic data;
  CategoryDropDownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class SubcategoryDropDownEvent extends TaskEvent {
  final dynamic data;
  SubcategoryDropDownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class UserTypeDropDownEvent extends TaskEvent {
  final dynamic data;
  UserTypeDropDownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class ListCategoryDropDownEvent extends TaskEvent {
  final dynamic data;
  ListCategoryDropDownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class ListSubcategoryDropDownEvent extends TaskEvent {
  final dynamic data;
  ListSubcategoryDropDownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class DeleteTaskEvent extends TaskEvent {
  final dynamic data;
  DeleteTaskEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class EditCloseState extends TaskEvent {}

class ListCategoryDropDownSelectionEvent extends TaskEvent {
  final dynamic dropDownData;
  final dynamic listModel;
  ListCategoryDropDownSelectionEvent({required this.dropDownData, required this.listModel});
  @override
  List<Object?> get props => [dropDownData, listModel];
}

class ListSubCategoryDropDownSelectionEvent extends TaskEvent {
  final dynamic dropDownData;
  final dynamic listModel;
  ListSubCategoryDropDownSelectionEvent({required this.dropDownData, required this.listModel});
  @override
  List<Object?> get props => [dropDownData, listModel];
}

class SaveTaskEvent extends TaskEvent {}

class TaskTabChangeEvent extends TaskEvent {
  final int tabIndex;
  TaskTabChangeEvent({required this.tabIndex});
  @override
  List<Object?> get props => [tabIndex];
}

