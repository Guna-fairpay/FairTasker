part of 'expense_summery_bloc.dart';

abstract class ExpenseSummeryEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends ExpenseSummeryEvent{
  final List<dynamic>? model;
  InitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class VehicleListingEvent extends ExpenseSummeryEvent{
  final dynamic model;
  final bool? isCohort;
  final bool? isFairPY;
  VehicleListingEvent({this.model, this.isCohort, this.isFairPY});
  @override
  List<Object?> get props => [model, isCohort, isFairPY];
}

class CohortAndCategoryEvent extends ExpenseSummeryEvent{
  final dynamic model;
  CohortAndCategoryEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class CategoryEvent extends ExpenseSummeryEvent{
  final dynamic model;
  CategoryEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class SubCategoryEvent extends ExpenseSummeryEvent{
  final dynamic model;
  SubCategoryEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ExpenseToEvent extends ExpenseSummeryEvent{
  final dynamic model;
  ExpenseToEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class VehicleRefreshEvent extends ExpenseSummeryEvent{}

class SaveEvent extends ExpenseSummeryEvent{}

class ExpenseEditEvent extends ExpenseSummeryEvent{
  final dynamic model;
  ExpenseEditEvent(this.model);
  @override
  List<Object?> get props => [model];
}
