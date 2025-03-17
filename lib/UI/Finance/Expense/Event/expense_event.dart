
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
  const DeleteExpenseEvent({required this.id});
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
