//
// import 'package:equatable/equatable.dart';
//
// abstract class ExpenseState extends Equatable {
//   const ExpenseState();
//   @override
//   List<Object?> get props => [];
// }
//
// class ExpenseInitial extends ExpenseState {
//   @override
//   List<Object> get props => [];
// }
//
// class ExpenseLoading extends ExpenseState {}
//
// class ExpenseListLoaded extends ExpenseState {
//   final List<Map<String, dynamic>> data;
//
//   const ExpenseListLoaded(
//       {required this.data});
//
//   @override
//   List<Object?> get props => [data];
// }
//
// class ExpenseLoaded extends ExpenseState {
//   final String? message;
//   const ExpenseLoaded({required this.message,});
//   @override
//   List<Object?> get props => [message];
// }
//
//
// class ExpenseError extends ExpenseState {
//   final String message;
//
//   const ExpenseError(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
// class ExpenseCategoryLoaded extends ExpenseState {
//   final List<Map<String, dynamic>>? data;
//   final List<Map<String, dynamic>> expenseTo;
//
//   const ExpenseCategoryLoaded({required this.data,required this.expenseTo});
//
//   @override
//   List<Object?> get props => [data, expenseTo];
// }
//
// class ExpensePaymentLoaded extends ExpenseState {
//   final List<Map<String, dynamic>>? data;
//
//
//   const ExpensePaymentLoaded({required this.data});
//
//   @override
//   List<Object?> get props => [data];
// }
//
//
// class ExpenseOtherLoaded extends ExpenseState {
//   final List<Map<String, dynamic>> data;
//   final int? totalExpensesAmount;
//
//   const ExpenseOtherLoaded({required this.data,required this.totalExpensesAmount});
//
//   @override
//   List<Object?> get props => [data, totalExpensesAmount];
// }
// class ExpenseOtherLoading extends ExpenseState {}
// class ExpenseOtherError extends ExpenseState {
//   final String message;
//
//   const ExpenseOtherError({required this.message});
//
//   @override
//   List<Object?> get props => [message];
// }
//
//
// class ExpensePersonLoaded extends ExpenseState {
//   final List<Map<String, dynamic>> data;
//   final int? totalExpensesAmount;
//
//   const ExpensePersonLoaded({required this.data, this.totalExpensesAmount});
//
//   @override
//   List<Object?> get props => [data, totalExpensesAmount];
// }
//
// class ExpensePersonError extends ExpenseState {
//   final String message;
//
//   const ExpensePersonError({required this.message});
//
//   @override
//   List<Object?> get props => [message];
// }
//
//
