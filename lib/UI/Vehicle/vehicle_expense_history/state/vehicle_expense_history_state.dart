
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class VehicleExpenseHistoryState extends Equatable{

  final TextEditingController searchController;
  final List<dynamic> apiResponse;
  final List<dynamic> filteredResponse;
  final List<dynamic> approvedList;
  final List<dynamic> expenseAttachments;
  final dynamic editResponse;
  final dynamic selectedCategory;
  final dynamic selectedSubCategory;
  final dynamic selectedPaymentMethod;
  final List<dynamic> categories;
  final List<dynamic> subCategories;
  final List<dynamic> paymentMethods;
  final List<dynamic> cohorts;
  final dynamic selectedCohorts;
  final DateTime? selectedDate;
  final List<Map<String,dynamic>> vehicle;
  final Map<String,dynamic> selectedVehicle;
  final String vin;
  final String vehicleName;
  final double? totalAmount;
  final bool isLoading;

  const VehicleExpenseHistoryState({
    required this.searchController,
    required this.apiResponse,
    required this.filteredResponse,
    required this.approvedList,
    required this.expenseAttachments,
    required this.editResponse,
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.selectedPaymentMethod,
    required this.categories,
    required this.subCategories,
    required this.paymentMethods,
    required this.cohorts,
    required this.selectedCohorts,
    required this.selectedDate,
    required this.vehicle,
    required this.selectedVehicle,
    required this.vin,
    required this.vehicleName,
    required this.totalAmount,
    required this.isLoading,
  });

  VehicleExpenseHistoryState copyWith({
    TextEditingController? searchController,
    List<dynamic>? apiResponse,
    List<dynamic>? filteredResponse,
    List<dynamic>? approvedList,
    List<dynamic>? expenseAttachments,
    dynamic selectedCategory,
    dynamic selectedSubCategory,
    dynamic selectedPaymentMethod,
    dynamic editResponse,
    List<dynamic>? categories,
    List<dynamic>? subCategories,
    List<dynamic>? paymentMethods,
    List<dynamic>? cohorts,
    dynamic selectedCohorts,
    DateTime? selectedDate,
    List<Map<String,dynamic>>? vehicle,
    Map<String,dynamic>? selectedVehicle,
    String? vin,
    String? vehicleName,
    double? totalAmount,
    bool? isLoading,
  }){
    return VehicleExpenseHistoryState(
      searchController: searchController ?? this.searchController,
      apiResponse:apiResponse ?? this.apiResponse,
      filteredResponse:filteredResponse ?? this.filteredResponse,
      approvedList: approvedList ?? this.approvedList,
      expenseAttachments: expenseAttachments ?? this.expenseAttachments,
      editResponse: editResponse ?? this.editResponse,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      cohorts: cohorts ?? this.cohorts,
      selectedCohorts: selectedCohorts ?? this.selectedCohorts,
      selectedDate: selectedDate ?? this.selectedDate,
      vehicle: vehicle ?? this.vehicle,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      vin: vin ?? this.vin,
      vehicleName: vehicleName ?? this.vehicleName,
      totalAmount: totalAmount ?? this.totalAmount,
      isLoading:  isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    searchController,
    apiResponse,
    filteredResponse,
    approvedList,
    expenseAttachments,
    editResponse,
    selectedCategory,
    selectedSubCategory,
    selectedPaymentMethod,
    categories,
    subCategories,
    paymentMethods,
    cohorts,
    selectedCohorts,
    selectedDate,
    vehicle,
    selectedVehicle,
    vin,
    vehicleName,
    totalAmount,
    isLoading,
    Random().nextDouble()
  ];

}