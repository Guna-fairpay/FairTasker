import 'dart:math';

import 'package:equatable/equatable.dart';

class TodoExpenseState extends Equatable {
  final List<dynamic> taskList;
  final List<dynamic> paymentMethods; // FROM PAYMENT RESPONSE
  final Map<String, dynamic> apiResponse; // FROM EXPENSE RESPONSE
  final List<dynamic> mainCategories; // FROM COHORT RESPONSE
  final List<dynamic> subCategories; // FROM COHORT RESPONSE
  final List<dynamic> expenseAttachments; // FOR HOLDING AND HANDLING ATTACHMENTS FILE / IMAGE URL
  final dynamic selectedPayment;
  final dynamic selectedMainCategory;
  final dynamic selectedSubCategory;
  final bool isLoading;
  final String vehicleName;
  final List<dynamic> vehicleList;
  final dynamic selectedVehicle;
  final List<dynamic> partsList;
  final List<dynamic> suppliesList;
  final dynamic vendorList;

  const TodoExpenseState({
    required this.taskList,
    required this.paymentMethods,
    required this.mainCategories,
    required this.subCategories,
    required this.expenseAttachments,
    required this.apiResponse,
    required this.selectedPayment,
    required this.selectedMainCategory,
    required this.selectedSubCategory,
    required this.isLoading,
    required this.vehicleName,
    required this.vehicleList,
    required this.selectedVehicle,
    required this.partsList,
    required this.suppliesList,
    required this.vendorList,

  });

  TodoExpenseState copyWith({
    List<dynamic>? taskList,
    List<dynamic>? paymentMethods,
    List<dynamic>? mainCategories,
    List<dynamic>? subCategories,
    List<dynamic>? expenseAttachments,
    Map<String, dynamic>? apiResponse,
    dynamic selectedPayment,
    dynamic selectedMainCategory,
    dynamic selectedSubCategory,
    bool? isLoading,
    String? vehicleName,
    List<dynamic>? vehicleList,
    dynamic selectedVehicle,
    List<dynamic>? partsList,
    List<dynamic>? suppliesList,
    dynamic vendorList,

  }) => TodoExpenseState(
    taskList: taskList ?? this.taskList,
    paymentMethods: paymentMethods ?? this.paymentMethods,
    mainCategories: mainCategories ?? this.mainCategories,
    subCategories: subCategories ?? this.subCategories,
        expenseAttachments: expenseAttachments ?? this.expenseAttachments,
        apiResponse: apiResponse ?? this.apiResponse,
        selectedPayment: selectedPayment ?? this.selectedPayment,
        selectedMainCategory: selectedMainCategory ?? this.selectedMainCategory,
        selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
        isLoading: isLoading ?? this.isLoading,
        vehicleName: vehicleName ?? this.vehicleName,
        vehicleList: vehicleList ?? this.vehicleList,
        selectedVehicle: selectedVehicle ?? this.selectedVehicle,
        partsList: partsList ?? this.partsList,
        suppliesList: suppliesList ?? this.suppliesList,
        vendorList: vendorList ?? this.vendorList,
  );
  @override
  List<Object?> get props =>
      [
        taskList,
        paymentMethods,
        isLoading,
        apiResponse,
        mainCategories,
        subCategories,
        expenseAttachments,
        selectedPayment,
        selectedMainCategory,
        selectedSubCategory,
        vehicleName,
        vehicleList,
        selectedVehicle,
        Random().nextDouble(),
      ];
}
