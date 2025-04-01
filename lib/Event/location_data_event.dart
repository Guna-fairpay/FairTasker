part of '../Bloc/location_data_bloc.dart';

abstract class LocationDataEvent extends Equatable {
  const LocationDataEvent();
}

class AddLocationData extends LocationDataEvent {
  final String? name;
  final List<String>? address;
  final int? id;
  const AddLocationData({required this.name, required this.address, required this.id});
  @override
  List<Object?> get props => [name, address, id];
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
  final bool? isLocationAddress;
  const DeleteLocationEvent({required this.id, this.isLocationAddress});
  @override
  List<Object?> get props => [id, isLocationAddress];
}

