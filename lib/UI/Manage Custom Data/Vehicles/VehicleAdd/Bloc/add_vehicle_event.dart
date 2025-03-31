import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class AddVehicleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddVehicleInitialEvent extends AddVehicleEvent {}

class DateChangeEvent extends AddVehicleEvent {
  final DateTime selectedDate;
  DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class RegStickerDateEvent extends AddVehicleEvent {
  final DateTime selectedDate;
  RegStickerDateEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class PurchaseReceiptImageEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleImageEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TollImageEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TireImageEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class UploadRegStickerImageEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class InsuranceImageEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemovePurchaseReceiptImageEvent extends AddVehicleEvent {
  final dynamic data;
  RemovePurchaseReceiptImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveVehicleImageEvent extends AddVehicleEvent {
  final dynamic data;
  RemoveVehicleImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveTollImageEvent extends AddVehicleEvent {
  final dynamic data;
  RemoveTollImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveTireImageEvent extends AddVehicleEvent {
  final dynamic data;
  RemoveTireImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveRegStickerImageEvent extends AddVehicleEvent {
  final dynamic data;
  RemoveRegStickerImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveInsuranceImageEvent extends AddVehicleEvent {
  final dynamic data;
  RemoveInsuranceImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class CohortDropDownEvent extends AddVehicleEvent {
  final dynamic selectedCohort;
  CohortDropDownEvent({required this.selectedCohort});
  @override
  List<Object?> get props => [selectedCohort, Random().nextDouble()];
}

class BranchDropDownEvent extends AddVehicleEvent {
  final dynamic selectedBranch;
  BranchDropDownEvent({required this.selectedBranch});
  @override
  List<Object?> get props => [selectedBranch, Random().nextDouble()];
}

class AddVehicleShowMoreEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class BouncieEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TollTagsEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AirTagEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class PermanentPlateEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SpareTireEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SpareKeyEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class FrontLicensePlateEvent extends AddVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SaveNewVehicleEvent extends AddVehicleEvent {}
