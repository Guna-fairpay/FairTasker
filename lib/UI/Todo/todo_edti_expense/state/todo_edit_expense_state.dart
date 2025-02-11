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
  }) {
    return TodoExpenseState(
        taskList: taskList ?? this.taskList,
        paymentMethods: paymentMethods ?? this.paymentMethods,
        mainCategories: mainCategories ?? this.mainCategories,
        subCategories: subCategories ?? this.subCategories,
        expenseAttachments: expenseAttachments ?? this.expenseAttachments,
        apiResponse: apiResponse ?? this.apiResponse,
        selectedPayment: selectedPayment ?? this.selectedPayment,
        selectedMainCategory: selectedMainCategory ?? this.selectedMainCategory,
        selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props =>
      [ taskList,
        paymentMethods,
        isLoading,
        apiResponse,
        mainCategories,
        subCategories,
        expenseAttachments,
        selectedPayment,
        selectedMainCategory,
        selectedSubCategory,
        Random().nextDouble()];
}
