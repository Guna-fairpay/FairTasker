
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class PersonExpenseState extends Equatable{

  final List<dynamic> apiResponse;
  final List<dynamic> filteredResponse;
  final DateRange? selectedDateRange;
  final List<dynamic> expenseAttachments;
  final dynamic editResponse;
  final dynamic selectedCategory;
  final dynamic selectedSubCategory;
  final dynamic selectedPerson;
  final dynamic selectedCohorts;
  final dynamic selectedPaymentType;
  final List<dynamic> categories;
  final List<dynamic> subCategories;
  final List<dynamic> persons;
  final List<dynamic> cohorts;
  final List<dynamic> paymentType;
  final bool isApprove;
  final bool isLoading;
  final dynamic approvedAmount;
  final DateTime? selectedDate;
  final List<dynamic> approved;
  final dynamic selectedApproved;
  final List<dynamic> personExpenseHistory;
  final double totalAmount;

  const PersonExpenseState({
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
    required this.isApprove,
    required this.isLoading,
    required this.selectedDateRange,
    required this.approvedAmount,
    required this.paymentType,
    required this.selectedPaymentType,
    required this.selectedDate,
    required this.persons,
    required this.selectedPerson,
    required this.approved,
    required this.selectedApproved,
    required this.personExpenseHistory,
    required this.totalAmount,

  });

  PersonExpenseState copyWith({
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
    bool? isApprove,
    bool? isLoading,
    DateRange? selectedDateRange,
    dynamic approvedAmount,
    List<dynamic>? paymentType,
    dynamic selectedPaymentType,
    DateTime? selectedDate,
    List<dynamic>? persons,
    dynamic selectedPerson,
    List<dynamic>? approved,
    dynamic selectedApproved,
    List<dynamic>? personExpenseHistory,
    double? totalAmount,
  }){
    return PersonExpenseState(
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
      isApprove: isApprove ?? this.isApprove,
      isLoading:  isLoading ?? this.isLoading,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      approvedAmount: approvedAmount ?? this.approvedAmount,
      paymentType: paymentType ?? this.paymentType,
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
      selectedDate: selectedDate ?? this.selectedDate,
      persons: persons ?? this.persons,
      selectedPerson: selectedPerson ?? this.selectedPerson,
      approved: approved ?? this.approved,
      selectedApproved: selectedApproved ?? this.selectedApproved,
      personExpenseHistory: personExpenseHistory ?? this.personExpenseHistory,
      totalAmount: totalAmount ?? this.totalAmount,

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
    isApprove,
    isLoading,
    selectedDateRange,
    approvedAmount,
    paymentType,
    selectedPaymentType,
    selectedDate,
    persons,
    selectedPerson,
    approved,
    selectedApproved,
    personExpenseHistory,
    totalAmount,
    Random().nextDouble()
  ];

}