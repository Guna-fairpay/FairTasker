
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleExpenseData extends ExpenseEvent {
   final dynamic minDate;
   final dynamic maxDate;
  const GetVehicleExpenseData({this.minDate, this.maxDate});
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
  const DeleteExpenseEvent({required this.id,});
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

class DateChangeEvent extends ExpenseEvent {
  final DateTime selectedDate;
  const DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class UpdateCategoryEvent extends ExpenseEvent {
  final dynamic expenseData;
  const UpdateCategoryEvent({required this.expenseData});
  @override
  List<Object?> get props => [expenseData,Random().nextDouble()];
}

class UpdateCohortEvent extends ExpenseEvent {
  final dynamic expenseData;
  const UpdateCohortEvent({required this.expenseData});
  @override
  List<Object?> get props => [expenseData,Random().nextDouble()];
}

class GetSubCategoryExpenseTo extends ExpenseEvent {
  const GetSubCategoryExpenseTo();
  @override
  List<Object?> get props => [];
}

class SubcategoryDropdownEvent extends ExpenseEvent {
  final dynamic selectedExpenseTo;
  const SubcategoryDropdownEvent({required this.selectedExpenseTo});
  @override
  List<Object?> get props => [selectedExpenseTo, Random().nextDouble()];
}

class SaveSubcategory extends ExpenseEvent {
  final String? name;
  final String? expenseToId;
  final String? categoryId;
  const SaveSubcategory({required this.name, required this.expenseToId, required this.categoryId});
  @override
  List<Object?> get props => [name, expenseToId, categoryId,Random().nextDouble()];
}

class RefreshEvent extends ExpenseEvent {}