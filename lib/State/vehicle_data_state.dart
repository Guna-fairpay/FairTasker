part of '../Bloc/vehicle_data_bloc.dart';

abstract class VehicleDataState extends Equatable {
  const VehicleDataState();


}

class VehicleDataInitial extends VehicleDataState {
  @override
  List<Object> get props => [];
}

class ExpenseTodoDataLoaded extends VehicleDataState {
  final List<Map<String,dynamic>>? expensesData;
  const ExpenseTodoDataLoaded({required this.expensesData});
  @override
  List<Object?> get props => [expensesData];
}

class VehicleStatusCategoryLoaded extends VehicleDataState {
  final List<Map<String,dynamic>>? vehicleStatusDataList;
  const VehicleStatusCategoryLoaded({required this.vehicleStatusDataList});
  @override
  List<Object?> get props => [vehicleStatusDataList];
}

class VehicleListLoaded extends VehicleDataState {
  final List<Map<String,dynamic>>? vehicleDataList;
  const VehicleListLoaded({required this.vehicleDataList});
  @override
  List<Object?> get props => [vehicleDataList];
}
//

class VehicleGroupListLoadedV extends VehicleDataState {
  final List<Map<String,dynamic>>? vehicleGroupDataList;
  const VehicleGroupListLoadedV({required this.vehicleGroupDataList});
  @override
  List<Object?> get props => [vehicleGroupDataList];
}

class VehicleGroupDataLoaded extends VehicleDataState {
  final List<Map<String,dynamic>>? vehicleGroupDataList;
  const VehicleGroupDataLoaded({required this.vehicleGroupDataList});
  @override
  List<Object?> get props => [vehicleGroupDataList];
}

class VehicleDataLoadedV extends VehicleDataState {
  final List<Map<String,dynamic>>? result;
  final int? categoryId;
  final String? vin;

  const VehicleDataLoadedV({required this.result, this.categoryId, this.vin});
  @override
  List<Object?> get props => [result, categoryId, vin];
}

class AddVehicleGroupDataLoaded extends VehicleDataState {
  final bool? result;
  const AddVehicleGroupDataLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class VehicleDataLoading extends VehicleDataState {
  const VehicleDataLoading();
  @override
  List<Object?> get props => [];
}

class DropdownVehicleDataLoaded extends VehicleDataState {
  final CreateExpenseFieldData? createExpenseFieldData;
  const DropdownVehicleDataLoaded({required this.createExpenseFieldData});
  @override
  List<Object?> get props => [createExpenseFieldData];
}

class VehicleHistoryListLoaded extends VehicleDataState {
  final List<Map<String, dynamic>>? todo;
  final List<Map<String, dynamic>>? data;
  const VehicleHistoryListLoaded({required this.todo,required this.data,});
  @override
  List<Object?> get props => [todo,data];
}

class VehicleHistoryLoaded extends VehicleDataState {
  final List<Map<String,dynamic>>? vehicleHistoryList;
  final bool? needUI;
  const VehicleHistoryLoaded({required this.vehicleHistoryList, required this.needUI});
  @override
  List<Object?> get props => [vehicleHistoryList, needUI];
}

class TodoItemCompletedVeh extends VehicleDataState {
  final bool? result;
  final String? todoId;
  final String? status;
  final String? vin;
  final int? vehicleGroupId;

  const TodoItemCompletedVeh({required this.result, required this.todoId, required this.status, this.vehicleGroupId, this.vin});
  @override
  List<Object?> get props => [result, todoId, status, vehicleGroupId, vin];
}

class PartsListLoaded extends VehicleDataState {
  final List<Map<String,dynamic>>? partsDataList;
  const PartsListLoaded({required this.partsDataList});
  @override
  List<Object?> get props => [partsDataList];
}

class PartsDataLoaded extends VehicleDataState {
  final bool? result;
  const PartsDataLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class CategoryListLoaded extends VehicleDataState {
  final List<Map<String,dynamic>>? categoryList;
  const CategoryListLoaded({required this.categoryList});
  @override
  List<Object?> get props => [categoryList];
}

class SubCategoryListLoaded extends VehicleDataState {
  final SubCategoriesResponse? categoriesResponse;
  const SubCategoryListLoaded({required this.categoriesResponse});
  @override
  List<Object?> get props => [categoriesResponse];
}

// class GetDepartmentsListLoaded extends VehicleDataState {
//   final List<Department>? departmentList;
//   const GetDepartmentsListLoaded({required this.departmentList});
//   @override
//   List<Object?> get props => [departmentList];
// }

class CategoryDataLoaded extends VehicleDataState {
  final bool? result;
  const CategoryDataLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class DepartmentDataLoaded extends VehicleDataState {
  final bool? result;
  const DepartmentDataLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class SupplyListLoaded extends VehicleDataState {
  final List<Map<String,dynamic>>? supplyDataList;
  const SupplyListLoaded({required this.supplyDataList});
  @override
  List<Object?> get props => [supplyDataList];
}

class SupplyDataLoaded extends VehicleDataState {
  final bool? result;
  const SupplyDataLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class DefaultVehicleConfigLoaded extends VehicleDataState {
  final bool? result;
  final String? vin;
  const DefaultVehicleConfigLoaded({required this.result, required this.vin});
  @override
  List<Object?> get props => [result, vin];
}

class VehicleStatusDataLoaded extends VehicleDataState {
  final bool? result;
  const VehicleStatusDataLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class VehicleNotesHistoryLoaded extends VehicleDataState {
  final List<Map<String,dynamic>>? data;
  const VehicleNotesHistoryLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}
class VehicleDataError extends VehicleDataState {
  final String errorMessage;
  const VehicleDataError({required this.errorMessage});
  @override
  List<Object?> get props => [];
}

class VehicleDataUpdatedState extends VehicleDataState {
  final dynamic updatedVehicle;
  const VehicleDataUpdatedState({required this.updatedVehicle});
  @override
  List<Object?> get props => [updatedVehicle];
}
