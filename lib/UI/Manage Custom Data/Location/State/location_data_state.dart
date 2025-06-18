
part of '../Bloc/location_data_bloc.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends LocationState {}

class LoadedState extends LocationState {
  final List<Map<String, dynamic>>? resource;
  LoadedState({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class LocationDataLoaded extends LocationState {
  final String? message;
  LocationDataLoaded({required this.message});
  @override
  List<Object?> get props => [message];
}

class CommonState extends LocationState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends LocationState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends LocationState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

