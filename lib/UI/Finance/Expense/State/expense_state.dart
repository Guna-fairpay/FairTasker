
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
  final List<Map<String,dynamic>> vehicleList;
  final Map<String,dynamic> selectedVehicle;
  final List<dynamic> paymentType;
  final dynamic selectedPaymentType;
  final DateTime? selectedDate;
  final dynamic todoDetails;
  final List<dynamic> userNames;
  final List<String>? todoVehicles;
  final List<dynamic> partsList;
  final List<dynamic> suppliesList;
  final List<dynamic> splitExpense;
  final String categoryName;
  final String subCategoryName;
  final List<dynamic> expenseTo;
  final dynamic selectedExpenseTo;
  final bool pop;
  final bool categoriesPop;

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
    required this.vehicleList,
    required this.selectedVehicle,
    required this.paymentType,
    required this.selectedPaymentType,
    required this.selectedDate,
    required this.todoDetails,
    required this.userNames,
    required this.todoVehicles,
    required this.partsList,
    required this.suppliesList,
    required this.splitExpense,
    required this.categoryName,
    required this.subCategoryName,
    required this.expenseTo,
    required this.selectedExpenseTo,
    required this.pop,
    required this.categoriesPop,
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
    List<Map<String, dynamic>>? vehicleList,
    Map<String,dynamic>? selectedVehicle,
    List<dynamic>? paymentType,
    dynamic selectedPaymentType,
    DateTime? selectedDate,
    dynamic todoDetails,
    List<dynamic>? userNames,
    List<String>? todoVehicles,
    List<dynamic>? partsList,
    List<dynamic>? suppliesList,
    List<dynamic>? splitExpense,
    String? categoryName,
    String? subCategoryName,
    List<dynamic>? expenseTo,
    dynamic selectedExpenseTo,
    bool? pop,
    bool? categoriesPop,

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
      vehicleList: vehicleList ?? this.vehicleList,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      paymentType: paymentType ?? this.paymentType,
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
      selectedDate: selectedDate ?? this.selectedDate,
      todoDetails: todoDetails ?? this.todoDetails,
      userNames: userNames ?? this.userNames,
      todoVehicles: todoVehicles ?? this.todoVehicles,
      partsList: partsList ?? this.partsList,
      suppliesList: suppliesList ?? this.suppliesList,
      splitExpense: splitExpense ?? this.splitExpense,
      categoryName: categoryName ?? this.categoryName,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      expenseTo: expenseTo ?? this.expenseTo,
      selectedExpenseTo: selectedExpenseTo ?? this.selectedExpenseTo,
      pop: pop ?? this.pop,
      categoriesPop: categoriesPop ?? this.categoriesPop,

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
    vehicleList,
    selectedVehicle,
    paymentType,
    selectedPaymentType,
    selectedDate,
    todoDetails,
    userNames,
    todoVehicles,
    partsList,
    suppliesList,
    splitExpense,
    categoryName,
    subCategoryName,
    expenseTo,
    selectedExpenseTo,
    pop,
    categoriesPop,
    Random().nextDouble()
  ];

}