//
// import 'package:bloc/bloc.dart';
// import 'package:fairpytasker/Event/expense_event.dart';
// import 'package:fairpytasker/Repository/expense_repository.dart';
// import 'package:fairpytasker/Response/expense_other_categories.dart';
// import 'package:fairpytasker/State/expense_state.dart';
//
// class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
//
//   ExpenseBloc() : super(ExpenseInitial()) {
//     ExpenseRepository expenseRepository = ExpenseRepository();
//
//     on<GetExpenseData>((event, emit) async {
//       emit(ExpenseLoading());
//
//       await expenseRepository.getExpense(event.minDate,event.maxDate)
//           .then((value) {
//         if (value != null) {
//           emit(ExpenseListLoaded(
//             data: value.data ?? [],
//           ));
//         }
//       });
//     });
//
//     on<AddExpenseData>((event, emit) async {
//       emit(ExpenseLoading());
//
//       await expenseRepository.createExpenseData(
//           event.id,
//           event.vehicleId,
//           event.expenseAmount,
//           event.paymentMethodId,
//           event.expenseDescription,
//           event.categoryId,
//           event.subcategoryId,
//           event.expenseTo,
//           event.expenseDate,
//           event.odometer)
//           .then((value) {
//         if (value != null) {
//           emit(ExpenseLoaded(
//             message: value.message ?? [].toString(),
//           ));
//         }
//       });
//     });
//
//     on<DeleteExpense>((event, emit) async {
//       emit(ExpenseLoading());
//
//       await expenseRepository.deleteExpense(event.id)
//           .then((value) {
//         if (value != null) {
//           emit(ExpenseLoaded(
//             message: value.message ?? [].toString(),
//           ));
//         }
//       });
//     });
// //---------------------------------------------------
//
//     on<GetExpenseOtherData>((event, emit) async {
//       emit(ExpenseLoading());
//
//       await expenseRepository.getExpenseOtherData(event.minDate,event.maxDate)
//           .then((value) {
//         if (value != null) {
//           emit(ExpenseOtherLoaded(data:value.data??[], totalExpensesAmount:value.totalExpensesAmount??[]));
//         }
//       });
//     });
//
//     on<GetExpenseCategoriesData>((event, emit) async {
//       emit(ExpenseLoading());
//       await expenseRepository.getExpenseCategories().then((value){
//         if (value != null) {
//           emit(ExpenseCategoryLoaded(data: value.data??[], expenseTo: value.expenseTo??[]));
//         }
//       });
//     });
//
//     on<GetExpensePaymentsData>((event, emit) async {
//       emit(ExpenseLoading());
//       await expenseRepository.getExpensePayments().then((value){
//         if (value != null) {
//           emit(ExpensePaymentLoaded(data: value.data??[]));
//         }
//       });
//     });
//
//     on<AddOtherData>((event, emit) async {
//       emit(ExpenseOtherLoading());
//       await expenseRepository.createOtherData(
//           event.id,
//           event.approved,
//           event.expenseDate,
//           event.expenseAmount,
//           event.categoryId,
//           event.subcategoryId,
//           event.expenseDescription)
//           .then((value) {
//         if (value != null) {
//           emit(ExpenseLoaded(
//             message: value.message ?? [].toString(),
//           ));
//         }
//       });
//     });
//
//     on<GetExpensePersonData>((event, emit) async {
//       emit(ExpenseLoading());
//       await expenseRepository.getExpensePersonData(
//         event.minDate, event.maxDate,
//       ).then((value){
//         if (value != null) {
//           emit(ExpensePersonLoaded(data: value.data??[],totalExpensesAmount: value.totalExpensesAmount??[]));
//         }
//       });
//     });
//
//   }
// }
//
//
