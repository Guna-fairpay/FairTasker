import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class AddPrivateRentalEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddPrivateRentalInitialEvent extends AddPrivateRentalEvent {
  final dynamic rentalData;
  AddPrivateRentalInitialEvent({required this.rentalData});
  @override
  List<Object?> get props => [rentalData];
}

class CheckInDateEvent extends AddPrivateRentalEvent {
  final DateTime selectedDate;
  CheckInDateEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class CheckOutDateEvent extends AddPrivateRentalEvent {
  final DateTime selectedDate;
  CheckOutDateEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class ImageUploadEvent extends AddPrivateRentalEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemoveImageEvent extends AddPrivateRentalEvent {
  final dynamic data;
  RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class ValidationDropDownEvent extends AddPrivateRentalEvent {
  final dynamic validation;
  ValidationDropDownEvent({required this.validation});
  @override
  List<Object?> get props => [validation, Random().nextDouble()];
}

class VehicleSearchEvent extends AddPrivateRentalEvent {
  final dynamic selectedVehicle;
  VehicleSearchEvent({required this.selectedVehicle});
  @override
  List<Object?> get props => [selectedVehicle, Random().nextDouble()];
}

class CustomerSearchEvent extends AddPrivateRentalEvent {
  final dynamic selectedCustomer;
  CustomerSearchEvent({required this.selectedCustomer});
  @override
  List<Object?> get props => [selectedCustomer,Random().nextDouble()];
}

class AddPrivateRentalSubmitEvent extends AddPrivateRentalEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class InsertRentalDataEvent extends AddPrivateRentalEvent {
  final dynamic rentalData;
  InsertRentalDataEvent({required this.rentalData});
  @override
  List<Object?> get props => [rentalData];
}

