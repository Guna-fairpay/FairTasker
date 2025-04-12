import 'package:equatable/equatable.dart';

abstract class SubCategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubCategoryInitialEvent extends SubCategoryEvent {}
class SubCategorySearchEvent extends SubCategoryEvent {
  final String query;
  SubCategorySearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}
class SubCategoryDeleteEvent extends SubCategoryEvent {
  final dynamic model;
  SubCategoryDeleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}
class SubCategoryDeleteTapEvent extends SubCategoryEvent {
  final dynamic model;
  SubCategoryDeleteTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}
class SubCategorySaveEvent extends SubCategoryEvent {}
class SubCategoryCancelEvent extends SubCategoryEvent {}
class SubCategoryEditEvent extends SubCategoryEvent {
  final dynamic model;
  SubCategoryEditEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class SubCategoryCategorySelectEvent extends SubCategoryEvent {
  final dynamic model;
  SubCategoryCategorySelectEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class SubCategorySubCategorySelectEvent extends SubCategoryEvent {
  final dynamic model;
  SubCategorySubCategorySelectEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class SubCategoryPageEvent extends SubCategoryEvent {
  final int page;
  SubCategoryPageEvent(this.page);
  @override
  List<Object?> get props => [page];
}
