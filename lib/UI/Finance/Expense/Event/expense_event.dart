
import 'package:equatable/equatable.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleExpenseData extends ExpenseEvent {
   final String? minDate;
   final String? maxDate;
  const GetVehicleExpenseData({required this.minDate, required this.maxDate});
  @override
  List<Object?> get props => [minDate, maxDate];
}

class DateRangeEvent extends ExpenseEvent {
  final String? minDate;
  final String? maxDate;
  const DateRangeEvent({required this.minDate, required this.maxDate});
  @override
  List<Object?> get props => [minDate, maxDate];
}

class ExpenseTapEvent extends ExpenseEvent {
  final dynamic selectedTap;
  const ExpenseTapEvent(this.selectedTap);
  @override
  List<Object?> get props => [selectedTap];
}
