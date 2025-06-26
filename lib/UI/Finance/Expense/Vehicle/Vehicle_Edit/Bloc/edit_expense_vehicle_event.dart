
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class EditExpenseVehicleEvent extends Equatable {
  const EditExpenseVehicleEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleExpenseEditData extends EditExpenseVehicleEvent {
  final dynamic id;
  const GetVehicleExpenseEditData({required this.id});
  @override
  List<Object?> get props => [id];
}

class CohortListEvent extends EditExpenseVehicleEvent {
  final dynamic selectedCohort;
  const CohortListEvent({required this.selectedCohort});
  @override
  List<Object?> get props => [selectedCohort, Random().nextDouble()];
}

class CategoryListEvent extends EditExpenseVehicleEvent {
  final dynamic selectedCategory;
  const CategoryListEvent({required this.selectedCategory});
  @override
  List<Object?> get props => [selectedCategory, Random().nextDouble()];
}

class SubCategoryListEvent extends EditExpenseVehicleEvent {
  final dynamic selectedSubCategory;
  const SubCategoryListEvent({required this.selectedSubCategory});
  @override
  List<Object?> get props => [selectedSubCategory, Random().nextDouble()];
}

class SelectedPaymentEvent extends EditExpenseVehicleEvent {
  final dynamic paymentType;
  const SelectedPaymentEvent({required this.paymentType});
  @override
  List<Object?> get props => [paymentType, Random().nextDouble()];
}

class PickImageEvent extends EditExpenseVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class CaptureImageEvent extends EditExpenseVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemoveImageEvent extends EditExpenseVehicleEvent {
  final dynamic data;
  const RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class VehicleEvent extends EditExpenseVehicleEvent {
  final dynamic selectedVehicle;
  const VehicleEvent({required this.selectedVehicle});
  @override
  List<Object?> get props => [selectedVehicle, Random().nextDouble()];
}

class DateChangeEvent extends EditExpenseVehicleEvent {
  final DateTime selectedDate;
  const DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class UpdateExpenseEvent extends EditExpenseVehicleEvent {
  const UpdateExpenseEvent();
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class DeleteExpenseEvent extends EditExpenseVehicleEvent {
  final String? id;
  const DeleteExpenseEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class TaxIconEvent extends EditExpenseVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
