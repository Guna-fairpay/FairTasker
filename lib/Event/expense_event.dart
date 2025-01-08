//
// import 'package:equatable/equatable.dart';
//
// abstract class ExpenseEvent extends Equatable {
//   const ExpenseEvent();
// }
//
// class ExpenseInitialEvent extends ExpenseEvent {
//   @override
//   List<Object?> get props => [];
// }
//
// class GetExpenseData extends ExpenseEvent {
//   final String? minDate;
//   final String? maxDate;
//
//   const GetExpenseData(
//       this.minDate,
//       this.maxDate,
//       );
//   @override
//   List<Object?> get props => [minDate,maxDate];
// }
//
// class GetExpenseCategoriesData extends ExpenseEvent{
//   const GetExpenseCategoriesData();
//   @override
//   List<Object?> get props => [];
// }
//
// class GetExpensePaymentsData extends ExpenseEvent{
//   const GetExpensePaymentsData();
//   @override
//   List<Object?> get props => [];
// }
//
// class GetExpenseOtherData extends ExpenseEvent {
//   final String minDate;
//   final String maxDate;
//
//   const GetExpenseOtherData({required this.minDate, required this.maxDate});
//
//   @override
//   List<Object?> get props => [minDate, maxDate];
// }
//
// class GetExpensePersonData extends ExpenseEvent {
//   final String minDate;
//   final String maxDate;
//
//   const GetExpensePersonData({required this.minDate, required this.maxDate});
//
//   @override
//   List<Object?> get props => [minDate, maxDate];
// }
//
// class AddOtherData extends ExpenseEvent {
//
//   final int? id;
//   final String? expenseDate;
//   final double? expenseAmount;
//   final String? categoryId;
//   final String? subcategoryId;
//   final int? approved;
//   final String? expenseDescription;
//
//
//   const AddOtherData({
//     required this.expenseDate,
//     required this.expenseAmount,
//     required this.categoryId,
//     required this.subcategoryId,
//     required this.approved,
//     required this.expenseDescription,
//     required this.id,});
//   @override
//   List<Object?> get props => [
//     expenseDate,expenseAmount,categoryId,subcategoryId,expenseDescription,approved,
//     id];
// }
// //-----------------------------------
//
// class AddExpenseData extends ExpenseEvent {
//   final String? vehicleId;
//   final String? expenseAmount;
//   final String? paymentMethodId;
//   final String? expenseDescription;
//   final String? categoryId;
//   final String? subcategoryId;
//   final String? expenseTo;
//   final String? expenseDate;
//   final String? odometer;
//   final int? id;
//
//    const AddExpenseData({
//       required this.vehicleId,
//       required this.expenseAmount,
//       required this.paymentMethodId,
//       required this.expenseDescription,
//       required this.categoryId,
//       required this.subcategoryId,
//       required this.expenseTo,
//       required this.expenseDate,
//       required this.odometer,
//       required this.id,});
//   @override
//   List<Object?> get props => [
//     vehicleId,
//     expenseAmount,
//     paymentMethodId,
//     expenseDescription,
//     categoryId,
//     subcategoryId,
//     expenseTo,
//     expenseDate,
//     odometer,
//     id];
// }
//
// class DeleteExpense extends ExpenseEvent {
//   final String id;
//
//   const DeleteExpense({
//     required this.id,
//   });
//
//   @override
//   List<Object> get props => [id];
// }
//
// //  class ExpenseOtherEvent extends ExpenseEvent {
// //   const ExpenseOtherEvent();
// //
// //   @override
// //   List<Object?> get props => [];
// // }
//
//
//
//
//
