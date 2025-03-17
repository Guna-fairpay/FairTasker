
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class ExpenseState extends Equatable{

  final List<dynamic> apiResponse;
  final List<dynamic> filteredResponse;
  final List<dynamic> expenseAttachments;
  final dynamic editResponse;
  final dynamic selectedCategory;
  final dynamic selectedSubCategory;
  final List<dynamic> categories;
  final List<dynamic> subCategories;
  final List<dynamic> cohorts;
  final dynamic selectedCohorts;
  final List<dynamic> tapData;
  final Map<String,dynamic> selectedTap;
  final bool isApprove;
  final bool isLoading;
  final DateRange? selectedDateRange;
  final bool isExpenseApproved;
  final dynamic approvedAmount;
  final dynamic unApprovedAmount;

  const ExpenseState({
    required this.apiResponse,
    required this.filteredResponse,
    required this.expenseAttachments,
    required this.editResponse,
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.categories,
    required this.subCategories,
    required this.cohorts,
    required this.selectedCohorts,
    required this.tapData,
    required this.selectedTap,
    required this.isApprove,
    required this.isLoading,
    required this.selectedDateRange,
    required this.isExpenseApproved,
    required this.approvedAmount,
    required this.unApprovedAmount,
  });

  ExpenseState copyWith({
    List<dynamic>? apiResponse,
    List<dynamic>? filteredResponse,
    List<dynamic>? expenseAttachments,
    dynamic selectedCategory,
    dynamic selectedSubCategory,
    dynamic editResponse,
    List<dynamic>? categories,
    List<dynamic>? subCategories,
    List<dynamic>? cohorts,
    dynamic selectedCohorts,
    List<dynamic>? tapData,
    Map<String,dynamic>? selectedTap,
    bool? isApprove,
    bool? isLoading,
    DateRange? selectedDateRange,
    bool? isExpenseApproved,
    dynamic approvedAmount,
    dynamic unApprovedAmount,
  }){
    return ExpenseState(
      apiResponse:apiResponse ?? this.apiResponse,
      filteredResponse:filteredResponse ?? this.filteredResponse,
      expenseAttachments: expenseAttachments ?? this.expenseAttachments,
      editResponse: editResponse ?? this.editResponse,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      cohorts: cohorts ?? this.cohorts,
      selectedCohorts: selectedCohorts ?? this.selectedCohorts,
      tapData: tapData ?? this.tapData,
      selectedTap: selectedTap ?? this.selectedTap,
      isApprove: isApprove ?? this.isApprove,
      isLoading:  isLoading ?? this.isLoading,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      isExpenseApproved: isExpenseApproved ?? this.isExpenseApproved,
      approvedAmount: approvedAmount ?? this.approvedAmount,
      unApprovedAmount: unApprovedAmount ?? this.unApprovedAmount,
    );
  }

  @override
  List<Object?> get props => [
    apiResponse,
    filteredResponse,
    expenseAttachments,
    editResponse,
    selectedCategory,
    selectedSubCategory,
    categories,
    subCategories,
    cohorts,
    selectedCohorts,
    tapData,
    selectedTap,
    isApprove,
    isLoading,
    selectedDateRange,
    isExpenseApproved,
    approvedAmount,
    unApprovedAmount,
    Random().nextDouble()
  ];

}