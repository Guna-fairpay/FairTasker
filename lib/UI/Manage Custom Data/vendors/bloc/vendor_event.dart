part of 'vendor_bloc.dart';

abstract class VendorEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends VendorEvent {
  final dynamic title;
  InitialEvent(this.title);
  @override
  List<Object?> get props => [title];
}

class VendorTypeEvent extends VendorEvent {
  final dynamic title;
  VendorTypeEvent(this.title);
  @override
  List<Object?> get props => [title];
}

class SelectVendorTypeEvent extends VendorEvent {
  final dynamic data;
  SelectVendorTypeEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class AddressEvent extends VendorEvent {}

class PickImageEvent extends VendorEvent {}

class RemoveImageEvent extends VendorEvent {
  final dynamic data;
  RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class CancelEvent extends VendorEvent {}

class SaveEvent extends VendorEvent {}

class SearchEvent extends VendorEvent {
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class DeleteEvent extends VendorEvent {
  final dynamic data;
  DeleteEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class EditEvent extends VendorEvent {
  final dynamic data;
  EditEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class PaginationEvent extends VendorEvent {
  final int page;
  PaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class GetDirectionEvent extends VendorEvent {
  final dynamic data;
  GetDirectionEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class ClearLatLongEvent extends VendorEvent {}

class NavigationEvent extends VendorEvent {}

class RefreshEvent extends VendorEvent {}