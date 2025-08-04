import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class EditPrivateRentalEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditPrivateRentalInitialEvent extends EditPrivateRentalEvent {
  final dynamic rentalData;
  EditPrivateRentalInitialEvent({required this.rentalData});
  @override
  List<Object?> get props => [rentalData];
}

class CheckInDateEvent extends EditPrivateRentalEvent {
  final DateTime selectedDate;
  CheckInDateEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class CheckOutDateEvent extends EditPrivateRentalEvent {
  final DateTime selectedDate;
  CheckOutDateEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class ImageUploadEvent extends EditPrivateRentalEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemoveImageEvent extends EditPrivateRentalEvent {
  final dynamic data;
  RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class ValidationDropDownEvent extends EditPrivateRentalEvent {
  final dynamic validation;
  ValidationDropDownEvent({required this.validation});
  @override
  List<Object?> get props => [validation, Random().nextDouble()];
}

class VehicleSearchEvent extends EditPrivateRentalEvent {
  final dynamic selectedVehicle;
  VehicleSearchEvent({required this.selectedVehicle});
  @override
  List<Object?> get props => [selectedVehicle, Random().nextDouble()];
}

class CustomerSearchEvent extends EditPrivateRentalEvent {
  final dynamic selectedCustomer;
  CustomerSearchEvent({required this.selectedCustomer});
  @override
  List<Object?> get props => [selectedCustomer,Random().nextDouble()];
}

class EditPrivateRentalSubmitEvent extends EditPrivateRentalEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

