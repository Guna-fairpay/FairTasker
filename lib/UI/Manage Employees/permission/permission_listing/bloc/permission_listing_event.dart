part of 'permission_listing_bloc.dart';

abstract class PermissionListingEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends PermissionListingEvent {}

class DeleteEvent extends PermissionListingEvent {
  final dynamic data;
  DeleteEvent(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class AddEditEvent extends PermissionListingEvent {
  final dynamic data;
  AddEditEvent({this.data});
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class SearchEvent extends PermissionListingEvent {
  final dynamic data;
  SearchEvent(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class PaginationEvent extends PermissionListingEvent {
  final dynamic data;
  PaginationEvent(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class RefreshEvent extends PermissionListingEvent {}