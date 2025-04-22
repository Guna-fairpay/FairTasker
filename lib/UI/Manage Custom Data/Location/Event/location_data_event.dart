part of '../Bloc/location_data_bloc.dart';

abstract class LocationDataEvent extends Equatable {
  const LocationDataEvent();
  @override
  List<Object?> get props => [];
}

class AddLocationData extends LocationDataEvent {
  final String name;
  final List<dynamic>? address;
  final int? id;
  const AddLocationData({required this.name, required this.address, required this.id});
  @override
  List<Object?> get props => [name, address, id];
}

class LocationInitialEvent extends LocationDataEvent {
  final String? title;
  const LocationInitialEvent({this.title});
  @override
  List<Object?> get props => [];
}

class GetAddedLocationListData extends LocationDataEvent {
  const GetAddedLocationListData();
  @override
  List<Object?> get props => [];
}

class AddedLocationInitial extends LocationDataEvent {
  const AddedLocationInitial();
  @override
  List<Object?> get props => [];
}

class DeleteLocationEvent extends LocationDataEvent {
  final int? id;
  const DeleteLocationEvent({required this.id,});
  @override
  List<Object?> get props => [id];
}

class DeleteLocation extends LocationDataEvent {
  final int id;
  const DeleteLocation({required this.id});
  @override
  List<Object?> get props => [id];
}

class EnterEditModeEvent extends LocationDataEvent {
  dynamic location;

  EnterEditModeEvent({required this.location});

  @override
  List<Object?> get props => [ location];
}

class ExitEditModeEvent extends LocationDataEvent {}

class LocationPaginationEvent extends LocationDataEvent {
  final int page;
  LocationPaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class FilterLocationEvent extends LocationDataEvent {
  final String searchTerm;
  const FilterLocationEvent({required this.searchTerm});
}

class AddAddressEvent extends LocationDataEvent {
  final String address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class RemoveAddressEvent extends LocationDataEvent {
  final int index;
  const RemoveAddressEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class SelectAddressForEditEvent extends LocationDataEvent {
  final int index;
  const SelectAddressForEditEvent(this.index);
}

class UpdateAddressEvent extends LocationDataEvent {
  final String updatedAddress;
  const UpdateAddressEvent(this.updatedAddress);
}

