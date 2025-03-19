
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleExpenseData extends ExpenseEvent {
   final String? minDate;
   final String? maxDate;
  const GetVehicleExpenseData({required this.minDate, required this.maxDate});
  @override
  List<Object?> get props => [minDate, maxDate];
}

class GetVehicleExpenseAddData extends ExpenseEvent {

  const GetVehicleExpenseAddData();
  @override
  List<Object?> get props => [];
}

class GetVehicleExpenseEditData extends ExpenseEvent {
  final String? id;
  const GetVehicleExpenseEditData({required this.id});
  @override
  List<Object?> get props => [id];
}

class DateRangeEvent extends ExpenseEvent {
  final String? minDate;
  final String? maxDate;
  const DateRangeEvent({required this.minDate, required this.maxDate});
  @override
  List<Object?> get props => [minDate, maxDate];
}

class ExpenseTapEvent extends ExpenseEvent {
  final dynamic selectedTap;
  const ExpenseTapEvent(this.selectedTap);
  @override
  List<Object?> get props => [selectedTap];
}

class ApproveEvent extends ExpenseEvent {
  final dynamic model;
  final dynamic approved;
  const ApproveEvent({required this.model, required this.approved});
  @override
  List<Object?> get props => [model, approved];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String? id;
  final bool? isEditPage;
  const DeleteExpenseEvent({required this.id,required this.isEditPage});
  @override
  List<Object?> get props => [id];
}

class CohortListEvent extends ExpenseEvent {
  final dynamic selectedCohort;
  const CohortListEvent({required this.selectedCohort});
  @override
  List<Object?> get props => [selectedCohort, Random().nextDouble()];
}

class CategoryListEvent extends ExpenseEvent {
  final dynamic selectedCategory;
  const CategoryListEvent({required this.selectedCategory});
  @override
  List<Object?> get props => [selectedCategory, Random().nextDouble()];
}

class SubCategoryListEvent extends ExpenseEvent {
  final dynamic selectedSubCategory;
  const SubCategoryListEvent({required this.selectedSubCategory});
  @override
  List<Object?> get props => [selectedSubCategory, Random().nextDouble()];
}

class CategoryDialogEvent extends ExpenseEvent {
  final dynamic data;
  const CategoryDialogEvent({required this.data});
  @override
  List<Object?> get props => [data];
}



class CohortDialogEvent extends ExpenseEvent {
  final dynamic data;
  const CohortDialogEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class UpdateDateRangeEvent extends ExpenseEvent {
  final DateRange selectedRange;
  const UpdateDateRangeEvent({required this.selectedRange});
  @override
  List<Object?> get props => [selectedRange];
}

class ApprovedExpenseEvent extends ExpenseEvent {
  final bool? isApproved;
  const ApprovedExpenseEvent({required this.isApproved});
  @override
  List<Object?> get props => [isApproved];
}

class SelectedPaymentEvent extends ExpenseEvent {
  final dynamic paymentType;
  const SelectedPaymentEvent({required this.paymentType});
  @override
  List<Object?> get props => [paymentType, Random().nextDouble()];
}

class PickImageEvent extends ExpenseEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class CaptureImageEvent extends ExpenseEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemoveImageEvent extends ExpenseEvent {
  final dynamic data;
  const RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class VehicleEvent extends ExpenseEvent {
  final dynamic selectedVehicle;
  const VehicleEvent({required this.selectedVehicle});
  @override
  List<Object?> get props => [selectedVehicle, Random().nextDouble()];
}

class DateChangeEvent extends ExpenseEvent {
  final DateTime selectedDate;
  const DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class DeleteExpenseVehicleEvent extends ExpenseEvent {
  final String? id;
  const DeleteExpenseVehicleEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class TaxIconEvent extends ExpenseEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SaveExpenseEvent extends ExpenseEvent {
  const SaveExpenseEvent();
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class UpdateExpenseEvent extends ExpenseEvent {
  const UpdateExpenseEvent();
  @override
  List<Object?> get props => [Random().nextDouble()];
}