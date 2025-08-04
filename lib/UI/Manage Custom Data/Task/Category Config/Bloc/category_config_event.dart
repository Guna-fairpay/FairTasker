
import 'package:equatable/equatable.dart';

abstract class CategoryConfigEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryConfigInitialEvent extends CategoryConfigEvent {}


class CategoryConfigPaginationEvent extends CategoryConfigEvent {
  final int page;
  CategoryConfigPaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class SearchCategoryConfigEvent extends CategoryConfigEvent {
  final String query;
  SearchCategoryConfigEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class EditCategoryConfigEvent extends CategoryConfigEvent {
  final dynamic data;
  EditCategoryConfigEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class CategoryDropDownEvent extends CategoryConfigEvent {
  final dynamic data;
  CategoryDropDownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class UserTypeDropDownEvent extends CategoryConfigEvent {
  final dynamic data;
  UserTypeDropDownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class DeleteCategoryConfigEvent extends CategoryConfigEvent {
  final dynamic data;
  DeleteCategoryConfigEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class EditCloseEvent extends CategoryConfigEvent {}

class SaveCategoryConfigEvent extends CategoryConfigEvent {}

