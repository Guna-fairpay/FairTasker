
import 'dart:math';
import 'package:equatable/equatable.dart';

class AddExpenseVehicleState extends Equatable{

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
  final bool popAddPagePop;

  const AddExpenseVehicleState({
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
    required this.popAddPagePop,
  });

  AddExpenseVehicleState copyWith({
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
    bool? popAddPagePop,

  }){
    return AddExpenseVehicleState(
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
      popAddPagePop: popAddPagePop ?? this.popAddPagePop,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
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
    popAddPagePop,
    Random().nextDouble()
  ];

}