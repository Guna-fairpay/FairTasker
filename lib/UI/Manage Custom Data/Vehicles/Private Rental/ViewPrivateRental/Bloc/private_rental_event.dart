
import 'package:equatable/equatable.dart';

abstract class PrivateRentalEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PrivateRentalInitialEvent extends PrivateRentalEvent {}

class SearchPrivateRentalEvent extends PrivateRentalEvent {
  final String? query;
  SearchPrivateRentalEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class DeletePrivateRentalEvent extends PrivateRentalEvent {
  final String vehicleId;
  DeletePrivateRentalEvent({required this.vehicleId});
  @override
  List<Object?> get props => [vehicleId];
}


class AddPrivateRentalEvent extends PrivateRentalEvent {
  final dynamic vehicleData;
  AddPrivateRentalEvent({this.vehicleData});
  @override
  List<Object?> get props => [vehicleData];
}

class EditPrivateRentalEvent extends PrivateRentalEvent {
  final dynamic rentalData;
  EditPrivateRentalEvent({required this.rentalData});
  @override
  List<Object?> get props => [rentalData];
}

class PrivateRentalPaginationEvent extends PrivateRentalEvent {
  final int page;
  PrivateRentalPaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class PrivateRentalClearEditEvent extends PrivateRentalEvent {}