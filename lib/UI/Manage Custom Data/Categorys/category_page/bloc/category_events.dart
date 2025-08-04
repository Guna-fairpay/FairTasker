import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitialEvent extends CategoryEvent {}
class CategoryPaginationEvent extends CategoryEvent {
  final int page;
  CategoryPaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}
class CategorySearchEvent extends CategoryEvent {
  final String query;
  CategorySearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}
class CategoryEditEvent extends CategoryEvent {
  final dynamic model;
  CategoryEditEvent(this.model);
  @override
  List<Object?> get props => [model];
}
class CategoryDeleteTapEvent extends CategoryEvent {
  final dynamic model;
  CategoryDeleteTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}
class CategoryDeleteEvent extends CategoryEvent {
  final dynamic model;
  CategoryDeleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}
class CategoryClearEvent extends CategoryEvent {}
class CategorySaveEvent extends CategoryEvent {}