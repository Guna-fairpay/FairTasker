part of 'permission_listing_bloc.dart';

abstract class PermissionListingState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends PermissionListingState {}

class ErrorState extends PermissionListingState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends PermissionListingState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends PermissionListingState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddEditState extends PermissionListingState{
  final dynamic model;
  AddEditState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}