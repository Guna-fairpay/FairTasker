
import 'package:equatable/equatable.dart';

abstract class CumulativeExpenseAddEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CumulativeExpenseAddInitialEvent extends CumulativeExpenseAddEvent {
  final dynamic data;
  CumulativeExpenseAddInitialEvent({this.data});
  @override
  List<Object?> get props => [data];
}

class CumulativeExpenseAddDatePickEvent extends CumulativeExpenseAddEvent {
  final DateTime selectedDate;
  CumulativeExpenseAddDatePickEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class CumulativeExpenseAddCohortEvent extends CumulativeExpenseAddEvent {
  final dynamic selectedCohort;
  CumulativeExpenseAddCohortEvent({required this.selectedCohort});
  @override
  List<Object?> get props => [selectedCohort];
}

class CumulativeExpenseAddCategoryEvent extends CumulativeExpenseAddEvent {
  final dynamic selectedCategory;
  CumulativeExpenseAddCategoryEvent({required this.selectedCategory});
  @override
  List<Object?> get props => [selectedCategory];
}

class CumulativeExpenseAddSubCategoryEvent extends CumulativeExpenseAddEvent {
  final dynamic selectedSubCategory;
  CumulativeExpenseAddSubCategoryEvent({required this.selectedSubCategory});
  @override
  List<Object?> get props => [selectedSubCategory];
}

class CumulativeExpenseAddVehicleEvent extends CumulativeExpenseAddEvent {
  final dynamic selectedVehicle;
  CumulativeExpenseAddVehicleEvent({required this.selectedVehicle});
  @override
  List<Object?> get props => [selectedVehicle];
}

class CumulativeExpenseAddReceiptEvent extends CumulativeExpenseAddEvent {
  final dynamic receiptImage;
  CumulativeExpenseAddReceiptEvent({this.receiptImage});
  @override
  List<Object?> get props => [receiptImage];
}

class CumulativeExpenseAddRemoveAttachmentEvent extends CumulativeExpenseAddEvent {
  final dynamic data;
  CumulativeExpenseAddRemoveAttachmentEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class CumulativeExpenseAddSaveEvent extends CumulativeExpenseAddEvent {}

