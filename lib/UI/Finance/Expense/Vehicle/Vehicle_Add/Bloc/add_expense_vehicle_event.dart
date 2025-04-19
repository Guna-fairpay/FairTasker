
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class AddExpenseVehicleEvent extends Equatable {
  const AddExpenseVehicleEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleExpenseAddData extends AddExpenseVehicleEvent {
  final dynamic model;
  const GetVehicleExpenseAddData({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CohortListEvent extends AddExpenseVehicleEvent {
  final dynamic selectedCohort;
  const CohortListEvent({required this.selectedCohort});
  @override
  List<Object?> get props => [selectedCohort, Random().nextDouble()];
}

class CategoryListEvent extends AddExpenseVehicleEvent {
  final dynamic selectedCategory;
  const CategoryListEvent({required this.selectedCategory});
  @override
  List<Object?> get props => [selectedCategory, Random().nextDouble()];
}

class SubCategoryListEvent extends AddExpenseVehicleEvent {
  final dynamic selectedSubCategory;
  const SubCategoryListEvent({required this.selectedSubCategory});
  @override
  List<Object?> get props => [selectedSubCategory, Random().nextDouble()];
}

class SelectedPaymentEvent extends AddExpenseVehicleEvent {
  final dynamic paymentType;
  const SelectedPaymentEvent({required this.paymentType});
  @override
  List<Object?> get props => [paymentType, Random().nextDouble()];
}

class PickImageEvent extends AddExpenseVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class CaptureImageEvent extends AddExpenseVehicleEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemoveImageEvent extends AddExpenseVehicleEvent {
  final dynamic data;
  const RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class VehicleEvent extends AddExpenseVehicleEvent {
  final dynamic selectedVehicle;
  const VehicleEvent({required this.selectedVehicle});
  @override
  List<Object?> get props => [selectedVehicle, Random().nextDouble()];
}

class DateChangeEvent extends AddExpenseVehicleEvent {
  final DateTime selectedDate;
  const DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class SaveExpenseEvent extends AddExpenseVehicleEvent {
  const SaveExpenseEvent();
  @override
  List<Object?> get props => [Random().nextDouble()];
}
