
part of '../Bloc/location_data_bloc.dart';

abstract class LocationDataState extends Equatable {
  const LocationDataState();
}

class LocationDataInitial extends LocationDataState {
  @override
  List<Object> get props => [];
}


class LocationDataLoading extends LocationDataState {
  const LocationDataLoading();
  @override
  List<Object?> get props => [];
}

class LocationListLoaded extends LocationDataState {
  final List<Map<String, dynamic>>? resource;
  const LocationListLoaded({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class LocationDataLoaded extends LocationDataState {
  final String? message;
  const LocationDataLoaded({required this.message});
  @override
  List<Object?> get props => [message];
}

