part of '../Bloc/location_data_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object?> get props => [];
}

/*class SubmitEvent extends LocationEvent {
  final String name;
  final List<dynamic>? address;
  final int? id;
  const SubmitEvent({required this.name, required this.address, required this.id});
  @override
  List<Object?> get props => [name, address, id];
}*/

class SubmitEvent extends LocationEvent {}

class LocationInitialEvent extends LocationEvent {
  final String? title;
  const LocationInitialEvent({this.title});
  @override
  List<Object?> get props => [];
}

class GetAddedLocationListData extends LocationEvent {
  const GetAddedLocationListData();
  @override
  List<Object?> get props => [];
}

class DeleteLocationEvent extends LocationEvent {
  final dynamic model;
  const DeleteLocationEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class DeleteLocation extends LocationEvent {
  final int id;
  const DeleteLocation({required this.id});
  @override
  List<Object?> get props => [id];
}

class EnterEditModeEvent extends LocationEvent {
  final dynamic location;
  const EnterEditModeEvent({required this.location});

  @override
  List<Object?> get props => [ location];
}

class ExitEditModeEvent extends LocationEvent {}

class PaginationEvent extends LocationEvent {
  final int page;
  const PaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class SearchQueryEvent extends LocationEvent {
  final String searchTerm;
  const SearchQueryEvent(this.searchTerm);
  @override
  List<Object?> get props => [searchTerm];
}

class StoreAddressEvent extends LocationEvent {}

class DeleteAddressEvent extends LocationEvent {
  final dynamic model;
  const DeleteAddressEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class EditAddressEvent extends LocationEvent {
  final dynamic model;
  const EditAddressEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class UpdateAddressEvent extends LocationEvent {
  final String updatedAddress;
  const UpdateAddressEvent(this.updatedAddress);
}

class RefreshEvent extends LocationEvent {}

