

import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class EditVehicleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditVehicleInitialEvent extends EditVehicleEvent {}

class DateChangeEvent extends EditVehicleEvent {
  final DateTime selectedDate;
  DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class RegStickerDateEvent extends EditVehicleEvent {
  final DateTime selectedDate;
  RegStickerDateEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class PurchaseReceiptImageEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleImageEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TollImageEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TireImageEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class UploadRegStickerImageEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class InsuranceImageEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemovePurchaseReceiptImageEvent extends EditVehicleEvent {
  final dynamic data;
  RemovePurchaseReceiptImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveVehicleImageEvent extends EditVehicleEvent {
  final dynamic data;
  RemoveVehicleImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveTollImageEvent extends EditVehicleEvent {
  final dynamic data;
  RemoveTollImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveTireImageEvent extends EditVehicleEvent {
  final dynamic data;
  RemoveTireImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveRegStickerImageEvent extends EditVehicleEvent {
  final dynamic data;
  RemoveRegStickerImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveInsuranceImageEvent extends EditVehicleEvent {
  final dynamic data;
  RemoveInsuranceImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class CohortDropDownEvent extends EditVehicleEvent {
  final dynamic selectedCohort;
  CohortDropDownEvent({required this.selectedCohort});
  @override
  List<Object?> get props => [selectedCohort, Random().nextDouble()];
}

class BranchDropDownEvent extends EditVehicleEvent {
  final dynamic selectedBranch;
  BranchDropDownEvent({required this.selectedBranch});
  @override
  List<Object?> get props => [selectedBranch, Random().nextDouble()];
}

class AddVehicleShowMoreEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class BouncieEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TollTagsEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AirTagEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class PermanentPlateEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SpareTireEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SpareKeyEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class FrontLicensePlateEvent extends EditVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
