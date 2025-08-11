part of 'vehicle_view_bloc.dart';

abstract class VehicleExpenseViewState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends VehicleExpenseViewState{}

class CommonState extends VehicleExpenseViewState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends VehicleExpenseViewState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends VehicleExpenseViewState{
  final dynamic data;
  SuccessState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class ShowCohortState extends VehicleExpenseViewState{
  final dynamic data;
  ShowCohortState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class ShowCategoryState extends VehicleExpenseViewState{
  final dynamic data;
  ShowCategoryState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}