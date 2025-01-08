//
// import 'package:equatable/equatable.dart';
//
// abstract class CohortsState extends Equatable {
//   const CohortsState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class CohortsInitial extends CohortsState {
//   @override
//   List<Object> get props => [];
// }
//
// class CohortsLoading extends CohortsState {}
//
// class CohortsListLoaded extends CohortsState {
//   final List<Map<String, dynamic>>? cohortData;
//   final List<Map<String, dynamic>>? expenseData;
//
//   const CohortsListLoaded({required this.expenseData,required this.cohortData});
//
//   @override
//   List<Object?> get props => [expenseData,cohortData];
// }
//
// class CohortsError extends CohortsState {
//   final String message;
//
//   const CohortsError(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
//  class PaymentListLoaded extends CohortsState {
//    final List<Map<String, dynamic>>? data;
//   const PaymentListLoaded(
//       {required this.data});
//     @override
//   List<Object?> get props => [data];
//  }