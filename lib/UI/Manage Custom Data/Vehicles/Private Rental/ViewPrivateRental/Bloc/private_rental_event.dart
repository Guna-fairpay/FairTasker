
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


class AddPrivateRentalEvent extends PrivateRentalEvent {}

class EditPrivateRentalEvent extends PrivateRentalEvent {
  final dynamic vehicleData;
  EditPrivateRentalEvent({required this.vehicleData});
  @override
  List<Object?> get props => [vehicleData];
}