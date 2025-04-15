
import 'package:equatable/equatable.dart';

abstract class SuppliesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SuppliesInitialEvent extends SuppliesEvent {}


class SuppliesPaginationEvent extends SuppliesEvent {
  final int page;
  SuppliesPaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class SearchSuppliesEvent extends SuppliesEvent {
  final String query;
  SearchSuppliesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class EditSuppliesEvent extends SuppliesEvent {
  final dynamic data;
  EditSuppliesEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class DeleteSuppliesEvent extends SuppliesEvent {
  final dynamic data;
  DeleteSuppliesEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class EditCloseEvent extends SuppliesEvent {}


class SaveSuppliesEvent extends SuppliesEvent {}

