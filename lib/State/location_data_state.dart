part of '../Bloc/location_data_bloc.dart';

abstract class LocationDataState extends Equatable {
  const LocationDataState();
}

class LocationDataInitial extends LocationDataState {
  @override
  List<Object> get props => [];
}

class LocationDataLoaded extends LocationDataState {
  final bool? result;
  final bool? isDelete;
  const LocationDataLoaded({required this.result, this.isDelete});
  @override
  List<Object?> get props => [result, isDelete];
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
