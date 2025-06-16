part of 'vendor_type_bloc.dart';

abstract class VendorTypeEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends VendorTypeEvent{}

class SearchEvent extends VendorTypeEvent{
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SaveEvent extends VendorTypeEvent{}

class DeleteEvent extends VendorTypeEvent{
  final dynamic data;
  DeleteEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class EditEvent extends VendorTypeEvent{
  final dynamic data;
  EditEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class PaginationEvent extends VendorTypeEvent{
  final int page;
  PaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class CancelEvent extends VendorTypeEvent{}