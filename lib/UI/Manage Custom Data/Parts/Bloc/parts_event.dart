
import 'package:equatable/equatable.dart';

abstract class PartsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PartsInitialEvent extends PartsEvent {}


class PartsPaginationEvent extends PartsEvent {
  final int page;
  PartsPaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class SearchPartsEvent extends PartsEvent {
  final String query;
  SearchPartsEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class EditPartsEvent extends PartsEvent {
  final dynamic data;
  EditPartsEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class DeletePartsEvent extends PartsEvent {
  final dynamic data;
  DeletePartsEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class EditCloseEvent extends PartsEvent {}


class SavePartsEvent extends PartsEvent {}

