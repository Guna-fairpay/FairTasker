part of 'subcategory_dialog_bloc.dart';

abstract class SubcategoryDialogEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends SubcategoryDialogEvent{
  final dynamic data;
  InitialEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class ExpenseToDropdownEvent extends SubcategoryDialogEvent{
  final dynamic data;
  ExpenseToDropdownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class SaveSubcategoryEvent extends SubcategoryDialogEvent{}