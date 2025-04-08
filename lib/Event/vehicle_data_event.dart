part of '../Bloc/vehicle_data_bloc.dart';

abstract class VehicleDataEvent extends Equatable {
  const VehicleDataEvent();
}

class VehicleInitial extends VehicleDataEvent {
  const VehicleInitial();
  @override
  List<Object?> get props => [];
}
class GetDropdownVehicleData extends VehicleDataEvent {
  const GetDropdownVehicleData();
  @override
  List<Object?> get props => [];
}

class GetExpenseToDatas extends VehicleDataEvent {
  final String? expenseId;
  const GetExpenseToDatas({required this.expenseId});
  @override
  List<Object?> get props => [expenseId];
}

class VehicleStatusCategory extends VehicleDataEvent {
  const VehicleStatusCategory();
  @override
  List<Object?> get props => [];
}

class GetActiveVehicleData extends VehicleDataEvent {
  const GetActiveVehicleData();
  @override
  List<Object?> get props => [];
}

class GetVehicleHistoryListData extends VehicleDataEvent {
  final String? pageNo;
  final String? vin;
  const GetVehicleHistoryListData(
      this.pageNo,
      this.vin,);
  @override
  List<Object?> get props => [pageNo,vin];
}

class GetAddedVehicleListData extends VehicleDataEvent {
  const GetAddedVehicleListData();
  @override
  List<Object?> get props => [];
}

class GetVehicleGroupingListV extends VehicleDataEvent {
  const GetVehicleGroupingListV();
  @override
  List<Object?> get props => [];
}

class GetVehicleGroupData extends VehicleDataEvent {
  const GetVehicleGroupData();
  @override
  List<Object?> get props => [];
}


class AddVehicleDataEvent extends VehicleDataEvent {
  final CreateVehicleData? createVehicleData;
  const AddVehicleDataEvent({this.createVehicleData});
  @override
  List<Object?> get props => [createVehicleData];
}

//Set vehicle save event
class UpdateVehicleDataEvent extends VehicleDataEvent {
  final CreateVehicleData? createVehicleData;
  const UpdateVehicleDataEvent({this.createVehicleData});
  @override
  List<Object?> get props => [createVehicleData];
}

class MoveRentalData extends VehicleDataEvent {
  final dynamic rentalData;
  const MoveRentalData({
    required this.rentalData});
  @override
  List<Object?> get props => [rentalData];
}

//
class AddVehicleGroupingData extends VehicleDataEvent {
  final int? id;
  final String? name;
  final List<String>? selectedList;
  const AddVehicleGroupingData({this.id, this.name, this.selectedList});
  @override
  List<Object?> get props => [id, name, selectedList];
}

class DeleteVehicleGroupEvent extends VehicleDataEvent {
  final int? id;
  const DeleteVehicleGroupEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class DeleteVehicleImage extends VehicleDataEvent {
  final int? id;
  const DeleteVehicleImage({required this.id});
  @override
  List<Object?> get props => [id];
}

class DeleteExpenseImage extends VehicleDataEvent {
  final int? id;
  const DeleteExpenseImage({required this.id});
  @override
  List<Object?> get props => [id];
}

class DeleteExpense extends VehicleDataEvent {
  final String? id;
  const DeleteExpense({required this.id});
  @override
  List<Object?> get props => [id];
}

class DeleteVehicleEvent extends VehicleDataEvent {
  final int? id;
  const DeleteVehicleEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class GetVehicleHistoryEvent extends VehicleDataEvent {
  final String? vin;
  final int? vehicleGroupId;
  final bool? needUI;
  const GetVehicleHistoryEvent({required this.vin, required this.vehicleGroupId, this.needUI});
  @override
  List<Object?> get props => [vin, vehicleGroupId, needUI];
}

class CompleteTodoItemVeh extends VehicleDataEvent {
  final String? todoId;
  final String? status;
  final int? vehicleGroupId;

  const CompleteTodoItemVeh({this.todoId, required this.status, this.vehicleGroupId});
  @override
  List<Object?> get props => [todoId, status, vehicleGroupId];
}

class AddPartsData extends VehicleDataEvent {
  final String? name;
  final String? desc;
  final int? id;
  const AddPartsData({required this.name, required this.desc, required this.id});
  @override
  List<Object?> get props => [name, desc, id];
}

class GetPartsListV extends VehicleDataEvent {
  const GetPartsListV();
  @override
  List<Object?> get props => [];
}

class DeletePartEvent extends VehicleDataEvent {
  final int? id;
  const DeletePartEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class AddCategoryData extends VehicleDataEvent {
  final String? name;
  final int? id;
  const AddCategoryData({required this.name, required this.id});
  @override
  List<Object?> get props => [name, id];
}

class GetCategory extends VehicleDataEvent {
  const GetCategory();
  @override
  List<Object?> get props => [];
}

class GetSubCategory extends VehicleDataEvent {
  const GetSubCategory();
  @override
  List<Object?> get props => [];
}

class GetDepartments extends VehicleDataEvent {
  const GetDepartments();
  @override
  List<Object?> get props => [];
}

class DeleteCategory extends VehicleDataEvent {
  final int? id;
  const DeleteCategory({required this.id});
  @override
  List<Object?> get props => [id];
}

class AddSubCategoryData extends VehicleDataEvent {
  final String? name;
  final String? expenseTo;
  final String? parentId;
  final int? id;
  const AddSubCategoryData({required this.name, required this.id, required this.parentId, required this.expenseTo});
  @override
  List<Object?> get props => [name, id, expenseTo, parentId];
}

class AddDepartmentData extends VehicleDataEvent {
  final String? name;
  final int? head;
  final int? id;
  const AddDepartmentData({required this.name, required this.id, required this.head});
  @override
  List<Object?> get props => [name, id, head];
}

/*
class GetSubCategory extends AddVehicleData {
  const GetSubCategory();
  @override
  List<Object?> get props => [];
}

class DeleteSubCategory extends AddVehicleData {
  final int? id;
  const DeleteSubCategory({required this.id});
  @override
  List<Object?> get props => [id];
}*/

class AddSupplyData extends VehicleDataEvent {
  final String? name;
  final String? desc;
  final int? id;
  const AddSupplyData({required this.name, required this.desc, required this.id});
  @override
  List<Object?> get props => [name, desc, id];
}

class GetSuppliesListV extends VehicleDataEvent {
  const GetSuppliesListV();
  @override
  List<Object?> get props => [];
}

class DeleteSupplyEvent extends VehicleDataEvent {
  final int? id;
  const DeleteSupplyEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class SetDefaultVehicleConfig extends VehicleDataEvent {
  final String? vinNumber;
  const SetDefaultVehicleConfig({required this.vinNumber});
  @override
  List<Object?> get props => [vinNumber];
}

class AddVehicleStatusData extends VehicleDataEvent {
  final String? category_Id;
  final String? label;
  final String? task;
  final String? status;
  final int? id;
  const AddVehicleStatusData({required this.category_Id, required this.label,required this.task,required this.status, this.id});
  @override
  List<Object?> get props => [category_Id, label,task,status, id];
}

class GetVehicleNotesHistoryList extends VehicleDataEvent {
  final String? vin;
  const GetVehicleNotesHistoryList({required this.vin,});
  @override
  List<Object?> get props => [vin];

}

