
import 'dart:math';
import 'package:equatable/equatable.dart';

class EditExpenseVehicleState extends Equatable{

  final dynamic editResponse;
  final dynamic todoDetails;
  final List<dynamic> expenseAttachments;
  final dynamic selectedCategory;
  final dynamic selectedSubCategory;
  final List<dynamic> categories;
  final List<dynamic> subCategories;
  final List<dynamic> cohorts;
  final dynamic selectedCohorts;
  final bool isLoading;
  final List<Map<String,dynamic>> vehicleList;
  final Map<String,dynamic> selectedVehicle;
  final List<dynamic> paymentType;
  final dynamic selectedPaymentType;
  final DateTime? selectedDate;
  final bool popEditPage;
  final List<dynamic> userNames;
  final List<String>? todoVehicles;
  final List<dynamic> partsList;
  final List<dynamic> suppliesList;
  final List<dynamic> splitExpense;
  final String categoryName;
  final String subCategoryName;

  const EditExpenseVehicleState({
    required this.editResponse,
    required this.todoDetails,
    required this.expenseAttachments,
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.categories,
    required this.subCategories,
    required this.cohorts,
    required this.selectedCohorts,
    required this.isLoading,
    required this.vehicleList,
    required this.selectedVehicle,
    required this.paymentType,
    required this.selectedPaymentType,
    required this.selectedDate,
    required this.popEditPage,
    required this.userNames,
    required this.todoVehicles,
    required this.partsList,
    required this.suppliesList,
    required this.splitExpense,
    required this.categoryName,
    required this.subCategoryName,
  });

  EditExpenseVehicleState copyWith({
    dynamic editResponse,
    dynamic todoDetails,
    List<dynamic>? expenseAttachments,
    dynamic selectedCategory,
    dynamic selectedSubCategory,
    List<dynamic>? categories,
    List<dynamic>? subCategories,
    List<dynamic>? cohorts,
    dynamic selectedCohorts,
    bool? isLoading,
    List<Map<String, dynamic>>? vehicleList,
    Map<String,dynamic>? selectedVehicle,
    List<dynamic>? paymentType,
    dynamic selectedPaymentType,
    DateTime? selectedDate,
    bool? popEditPage,
    List<dynamic>? userNames,
    List<String>? todoVehicles,
    List<dynamic>? partsList,
    List<dynamic>? suppliesList,
    List<dynamic>? splitExpense,
    String? categoryName,
    String? subCategoryName,

  }){
    return EditExpenseVehicleState(
      editResponse: editResponse ?? this.editResponse,
      todoDetails: todoDetails ?? this.todoDetails,
      expenseAttachments: expenseAttachments ?? this.expenseAttachments,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      cohorts: cohorts ?? this.cohorts,
      selectedCohorts: selectedCohorts ?? this.selectedCohorts,
      vehicleList: vehicleList ?? this.vehicleList,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      paymentType: paymentType ?? this.paymentType,
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
      selectedDate: selectedDate ?? this.selectedDate,
      popEditPage: popEditPage ?? this.popEditPage,
      isLoading: isLoading ?? this.isLoading,
      userNames: userNames ?? this.userNames,
      todoVehicles: todoVehicles ?? this.todoVehicles,
      partsList: partsList ?? this.partsList,
      suppliesList: suppliesList ?? this.suppliesList,
      splitExpense: splitExpense ?? this.splitExpense,
      categoryName: categoryName ?? this.categoryName,
      subCategoryName: subCategoryName ?? this.subCategoryName,

    );
  }

  @override
  List<Object?> get props => [
    editResponse,
    todoDetails,
    expenseAttachments,
    selectedCategory,
    selectedSubCategory,
    categories,
    subCategories,
    cohorts,
    selectedCohorts,
    isLoading,
    vehicleList,
    selectedVehicle,
    paymentType,
    selectedPaymentType,
    selectedDate,
    popEditPage,
    userNames,
    todoVehicles,
    partsList,
    suppliesList,
    splitExpense,
    categoryName,
    subCategoryName,

    Random().nextDouble()
  ];

}