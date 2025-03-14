
import 'dart:math';
import 'package:equatable/equatable.dart';

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
  final bool isLoading;

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
    required this.isLoading,
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
    bool? isLoading,
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
      isLoading:  isLoading ?? this.isLoading,
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
    isLoading,
    Random().nextDouble()
  ];

}