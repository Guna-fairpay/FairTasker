
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

abstract class PersonExpenseEvent extends Equatable {
  const PersonExpenseEvent();
  @override
  List<Object?> get props => [];
}

class GetPersonExpenseData extends PersonExpenseEvent {
  final String? minDate;
  final String? maxDate;
  const GetPersonExpenseData({required this.minDate, required this.maxDate});
  @override
  List<Object?> get props => [minDate, maxDate];
}

class GetPersonExpenseAddData extends PersonExpenseEvent {

  const GetPersonExpenseAddData();
  @override
  List<Object?> get props => [];
}

class GetPersonExpenseEditData extends PersonExpenseEvent {
  final String? id;
  const GetPersonExpenseEditData({required this.id});
  @override
  List<Object?> get props => [id];
}

class DateRangeEvent extends PersonExpenseEvent {
  final String? minDate;
  final String? maxDate;
  const DateRangeEvent({required this.minDate, required this.maxDate});
  @override
  List<Object?> get props => [minDate, maxDate];
}

class ApproveEvent extends PersonExpenseEvent {
  final dynamic model;
  final dynamic approved;
  const ApproveEvent({required this.model, required this.approved});
  @override
  List<Object?> get props => [model, approved];
}

class DeletePersonExpenseEvent extends PersonExpenseEvent {
  final String? id;
  final bool? isEditPage;
  const DeletePersonExpenseEvent({required this.id,required this.isEditPage});
  @override
  List<Object?> get props => [id];
}

class CohortDropDownEvent extends PersonExpenseEvent {
  final dynamic selectedCohort;
  const CohortDropDownEvent({required this.selectedCohort});
  @override
  List<Object?> get props => [selectedCohort, Random().nextDouble()];
}

class CategoryDropDownEvent extends PersonExpenseEvent {
  final dynamic selectedCategory;
  const CategoryDropDownEvent({required this.selectedCategory});
  @override
  List<Object?> get props => [selectedCategory, Random().nextDouble()];
}

class SubCategoryDropDownEvent extends PersonExpenseEvent {
  final dynamic selectedSubCategory;
  const SubCategoryDropDownEvent({required this.selectedSubCategory});
  @override
  List<Object?> get props => [selectedSubCategory, Random().nextDouble()];
}

class PersonDropDownEvent extends PersonExpenseEvent {
  final dynamic selectedPerson;
  const PersonDropDownEvent({required this.selectedPerson});
  @override
  List<Object?> get props => [selectedPerson, Random().nextDouble()];
}

class ChangeDateRangeEvent extends PersonExpenseEvent {
  final DateRange selectedRange;
  const ChangeDateRangeEvent({required this.selectedRange});
  @override
  List<Object?> get props => [selectedRange];
}

class ApprovedExpenseEvent extends PersonExpenseEvent {
  final bool? isApproved;
  const ApprovedExpenseEvent({required this.isApproved});
  @override
  List<Object?> get props => [isApproved];
}

class PaymentDropDownEvent extends PersonExpenseEvent {
  final dynamic paymentType;
  const PaymentDropDownEvent({required this.paymentType});
  @override
  List<Object?> get props => [paymentType, Random().nextDouble()];
}

class ApprovedDropDownEvent extends PersonExpenseEvent {
  final dynamic selectedApproved;
  const ApprovedDropDownEvent({required this.selectedApproved});
  @override
  List<Object?> get props => [selectedApproved, Random().nextDouble()];
}

class PickImageEvent extends PersonExpenseEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemoveImageEvent extends PersonExpenseEvent {
  final dynamic data;
  const RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class DateChangeEvent extends PersonExpenseEvent {
  final DateTime selectedDate;
  const DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class SavePersonExpenseEvent extends PersonExpenseEvent {
  final String? id;
  const SavePersonExpenseEvent({this.id});
  @override
  List<Object?> get props => [id];
}

class UpdateExpenseEvent extends PersonExpenseEvent {
  const UpdateExpenseEvent();
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class GetPersonExpenseHistory extends PersonExpenseEvent {
  final String? userId;
  const GetPersonExpenseHistory({required this.userId});
  @override
  List<Object?> get props => [userId,];
}

class RefreshEvent extends PersonExpenseEvent {}
