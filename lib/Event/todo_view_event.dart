import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Response/create_todo_params.dart';

import '../Response/create_fix_task_data.dart';

abstract class TodoViewEvent extends Equatable {
  const TodoViewEvent();
}

class TodoViewInitialEvent extends TodoViewEvent {
  const TodoViewInitialEvent();
  @override
  List<Object?> get props => [];
}

class GetDropdownData extends TodoViewEvent {
  const GetDropdownData();
  @override
  List<Object?> get props => [];
}

class GetVehicleListData extends TodoViewEvent {
  const GetVehicleListData();
  @override
  List<Object?> get props => [];
}
//

class DeleteTodoEvent extends TodoViewEvent {
  final String? todoId;
  const DeleteTodoEvent({this.todoId});
  @override
  List<Object?> get props => [todoId];
}

class CompleteTodoItem extends TodoViewEvent {
  final String? todoId;
  final String? status;
  final String? taskName;
  const CompleteTodoItem({this.todoId, required this.status, this.taskName});
  @override
  List<Object?> get props => [todoId, status, taskName];
}

class GetTodoList extends TodoViewEvent {
  final String? selectedDate;
  final String? status;
  final String? resourceId;
  final String? branchId;
  const GetTodoList(
      {required this.selectedDate,
        required this.status,
        required this.resourceId,
        required this.branchId,
      });
  @override
  List<Object?> get props => [selectedDate, status, resourceId,branchId];


}

class CreateTodoEvent extends TodoViewEvent {
  final CreateTodoParams? createTodoParams;
  final bool? exitTheScreen;
  const CreateTodoEvent({required this.createTodoParams, this.exitTheScreen});
  @override
  List<Object?> get props => [createTodoParams, exitTheScreen];
}

class GetExpenseToData extends TodoViewEvent {
  final String? expenseId;
  const GetExpenseToData({required this.expenseId});
  @override
  List<Object?> get props => [expenseId];
}

class GetTaskDetailData extends TodoViewEvent {
  final int? id;
  const GetTaskDetailData({required this.id});
  @override
  List<Object?> get props => [id];
}

class GetAssignedToList extends TodoViewEvent {
  const GetAssignedToList();
  @override
  List<Object> get props => [];
}

class GetWorkingHistoryList extends TodoViewEvent {
  final String? startDate;
  final String? endDate;
  const GetWorkingHistoryList({this.startDate, this.endDate});
  @override
  List<Object?> get props => [startDate, endDate];
}

class GetTaskHistoryConfiguration extends TodoViewEvent {
  const GetTaskHistoryConfiguration();
  @override
  List<Object?> get props => [];
}

class GetWorkingTaskHistoryList extends TodoViewEvent {
  final String? startDate;
  final String? endDate;
  final String? userId;
  const GetWorkingTaskHistoryList({this.startDate, this.endDate, this.userId});
  @override
  List<Object?> get props => [startDate, endDate, userId];
}

class GetWorkingHistoryCount extends TodoViewEvent {
  final String? startDate;
  final String? endDate;
  const GetWorkingHistoryCount({this.startDate, this.endDate});
  @override
  List<Object?> get props => [startDate, endDate];
}

class GetVehicleStatusList extends TodoViewEvent {
  const GetVehicleStatusList();
  @override
  List<Object?> get props => [];
}

class GetCumulativeList extends TodoViewEvent {
  final String vin;
  const GetCumulativeList({required this.vin});
  @override
  List<Object?> get props => [vin];
}

class GetMiscellaneousVehicles extends TodoViewEvent {
  const GetMiscellaneousVehicles();
  @override
  List<Object?> get props => [];
}

class GetVehicleStatusCheckList extends TodoViewEvent {
  final String? vinNumber;
  final int? categoryId;
  final int? checkListId;
  final Map<String, dynamic>? vehicleStatusListDataList;
  final String? categoryName;
  const GetVehicleStatusCheckList(
      {required this.vinNumber,
        this.categoryId,
        this.checkListId,
        this.vehicleStatusListDataList,
        required this.categoryName});
  @override
  List<Object?> get props => [
    vinNumber,
    categoryId,
    checkListId,
    vehicleStatusListDataList,
    categoryName
  ];
}

class UpdateVehicleStatus extends TodoViewEvent {
  final CreateTodoParams createTodoParams;
  const UpdateVehicleStatus({required this.createTodoParams});
  @override
  List<Object?> get props => [createTodoParams];
}

class SetVehicleActiveStatus extends TodoViewEvent {
  final String? vinNumber;
  final int? vehicleStatus;
  const SetVehicleActiveStatus({required this.vinNumber, this.vehicleStatus});
  @override
  List<Object?> get props => [vinNumber, vehicleStatus];
}

class VehicleStatusCreateTodo extends TodoViewEvent {
  final CreateTodoParams? createTodoParams;
  final bool? isCreate;
  final Map<String, dynamic>? vehicleStatusListDataList;
  const VehicleStatusCreateTodo(
      {required this.createTodoParams,
        required this.isCreate,
        required this.vehicleStatusListDataList});
  @override
  List<Object?> get props =>
      [createTodoParams, isCreate, vehicleStatusListDataList];
}

class AddVehicleCreateTodo extends TodoViewEvent {
  final int? checklistId;
  final int? categoryId;
  final int? cohortId;
  final String? status;
  final int? userId;
  final String? title;
  final String? vehName;
  final String? vinNumber;
  final String? todoTime;
  final String? startAt;
  final int? statusId;
  const AddVehicleCreateTodo(
      {required this.checklistId,
        required this.categoryId,
        required this.cohortId,
        required this.status,
        required this.userId,
        required this.title,
        required this.vehName,
        required this.vinNumber,
        required this.todoTime,
        required this.startAt,
        required this.statusId});
  @override
  List<Object?> get props => [
    checklistId,
    categoryId,
    cohortId,
    status,
    userId,
    title,
    vehName,
    vinNumber,
    todoTime,
    startAt,
    statusId
  ];
}

class VehicleCreateStatusTodo extends TodoViewEvent {
  final int? categoryId;
  final String? categoryName;
  final int? cohortId;
  final String? cohortName;
  final int? userId;
  final String? vehImage;
  final String? vehName;
  final String? vinNumber;
  final int? index;
  final Map<String, dynamic>? vehicleStatusListDataList;
  final bool? isCreate;
  final int? soldId;
  const VehicleCreateStatusTodo(
      {required this.categoryId,
        required this.cohortId,
        required this.cohortName,
        required this.userId,
        required this.vehImage,
        required this.vehName,
        required this.vinNumber,
        required this.categoryName,
        this.index,
        required this.vehicleStatusListDataList,
        required this.isCreate,
        this.soldId});
  @override
  List<Object?> get props => [
    categoryId,
    cohortId,
    cohortName,
    userId,
    vehImage,
    vehName,
    vinNumber,
    categoryName,
    index,
    isCreate,
    soldId
  ];
}

class VehicleStatusConfigSelectedCategories extends TodoViewEvent {
  final String? vinNumber;
  final int? categoryId;
  final int? checkboxValue;
  final int? isApi;
  final List<int>? categoryIds;
  const VehicleStatusConfigSelectedCategories(
      {required this.vinNumber,
        required this.categoryId,
        required this.checkboxValue,
        required this.isApi,
        required this.categoryIds});
  @override
  List<Object?> get props =>
      [vinNumber, categoryId, checkboxValue, isApi, categoryIds];
}

class GetVehicleStatusConfigList extends TodoViewEvent {
  final String? vinNumber;
  const GetVehicleStatusConfigList({required this.vinNumber});
  @override
  List<Object?> get props => [vinNumber];
}

/*class GetVehicleOrderCheckList extends TodoViewEvent {
  final String? vinNumber;
  const GetVehicleOrderCheckList({required this.vinNumber});
  @override
  List<Object?> get props => [vinNumber];
}*/

class ReorderVehicleStatusCheckList extends TodoViewEvent {
  final String? vinNumber;
  final int? categoryId;
  final List<dynamic>? orderCheckList;
  const ReorderVehicleStatusCheckList(
      {required this.vinNumber,
        required this.categoryId,
        required this.orderCheckList});
  @override
  List<Object?> get props => [vinNumber, categoryId, orderCheckList];
}

class VehicleStatusCheckListCheck extends TodoViewEvent {
  final String? vinNumber;
  final List<String>? categoryIds;
  final int? categoryId;
  final int? checkItemId;
  final bool? checked;
  final String? type;
  const VehicleStatusCheckListCheck(
      {required this.vinNumber,
        required this.categoryId,
        this.checkItemId,
        required this.checked,
        this.type,
        this.categoryIds});
  @override
  List<Object?> get props =>
      [vinNumber, categoryId, checkItemId, checked, type, categoryIds];
}

class GetPartsList extends TodoViewEvent {
  const GetPartsList();
  @override
  List<Object> get props => [];
}

class GetSuppliesList extends TodoViewEvent {
  const GetSuppliesList();
  @override
  List<Object> get props => [];
}

class GetTaskExpenseData extends TodoViewEvent {
  const GetTaskExpenseData();
  @override
  List<Object> get props => [];
}

class GetVendorData extends TodoViewEvent {
  const GetVendorData();
  @override
  List<Object> get props => [];
}

class GetLocationData extends TodoViewEvent {
  const GetLocationData();
  @override
  List<Object> get props => [];
}

class GetExpenseSummaryData extends TodoViewEvent {
  final String? vinNumber;
  const GetExpenseSummaryData({this.vinNumber});
  @override
  List<Object?> get props => [vinNumber];
}

class EditTodoDate extends TodoViewEvent {
  final String? editedNextDate;
  final String? editedTime;
  final bool? isDate;
  final String? todoId;
  // final String? oldDate;
  final List<String?>? resourceIdList;
  final int? resourceId;
  final String? notes;
  final String? expenseId;
  final List<int>? addresses;
  const EditTodoDate(
      this.editedTime,
      this.isDate,
      this.todoId,
      this.editedNextDate,
      this.resourceId,
      this.resourceIdList,
      this.notes,
      this.expenseId,
      this.addresses);
  @override
  List<Object?> get props => [
    todoId,
    editedNextDate,
    isDate,
    editedTime,
    resourceId,
    resourceIdList,
    notes,
    expenseId,
    addresses
  ];
}

/*/task-expenses-data - task name
/vendors and /locations - vendor/location
/getresources and /getCohortsData - Vehicle/person*/

class EditTodoVehiclePerson extends TodoViewEvent {
  final int? todoId;
  final List<dynamic> vehiclePersonData;
  final String? person;
  final String? personId;
  final String? vehicleGroupId;

  const EditTodoVehiclePerson({
    required this.todoId,
    required this.vehiclePersonData,
    required this.person,
    required this.personId,
    required this.vehicleGroupId,
  });
  @override
  List<Object?> get props => [todoId,vehiclePersonData,person,personId,vehicleGroupId];
}

/*class EditTodoVehiclePerson extends TodoViewEvent {
  final int? todoId;
  final int? todoUserId;
  final String? todoVehicleName;
  final int? selectedCohortId;
  final String? personName;
  final String? vehicleImage;
  final String? cohortName;
  final String? vin;
  final int? vehicleNumber;

  const EditTodoVehiclePerson({
      required this.todoId,
      required this.todoUserId,
      required this.todoVehicleName,
      required this.selectedCohortId,
      required this.vehicleImage,
      required this.cohortName,
      required this.personName,
      required this.vin,
      required this.vehicleNumber});
  @override
  List<Object?> get props => [
    todoId,
    todoUserId,
    todoVehicleName,
    selectedCohortId,
    vehicleImage,
    cohortName,
    personName,
    vin,
    vehicleNumber
  ];
}*/

class DeleteVehicle extends TodoViewEvent {
  final int? id;
  const DeleteVehicle({required this.id});
  @override
  List<Object?> get props => [id];
}

class EditTodoVendorLocation extends TodoViewEvent {
  final int? todoId;
  final String? todoVendorName;
  final int? todoVendorId;
  final int? locationId;
  final String? locationName;
  const EditTodoVendorLocation(this.todoId, this.todoVendorName,
      this.locationName, this.locationId, this.todoVendorId);
  @override
  List<Object?> get props =>
      [todoId, todoVendorName, locationName, locationId, todoVendorId];
}

class SwapTodo extends TodoViewEvent {
  final String? fromId;
  final String? toId;
  const SwapTodo(this.fromId, this.toId);
  @override
  List<Object?> get props => [fromId, toId];
}

class UpdateExpenseInTodo extends TodoViewEvent {
  final int? todoId;
  final int? categoryId;
  final int? subCategoryId;
  final int? expenseTo;
  final String? expenseAmount;
  final String? expenseDescription;
  final String? categoryName;
  final String? subCategoryName;
  const UpdateExpenseInTodo(
      this.todoId,
      this.categoryId,
      this.subCategoryId,
      this.expenseTo,
      this.expenseAmount,
      this.expenseDescription,
      this.categoryName,
      this.subCategoryName);
  @override
  List<Object?> get props => [
    categoryId,
    subCategoryId,
    expenseTo,
    expenseAmount,
    expenseDescription,
    categoryName,
    subCategoryName
  ];
}

class CreateExpenseTodo extends TodoViewEvent {
  final List<File>? files;
  final int? expenseId;
  final int? categoryId;
  final int? subCategoryId;
  final int? expenseTo;
  final int? paymentMethodId;
  final String? expenseAmount;
  final String? expenseDescription;
  final String? cohortId;
  final String? vin;
  final String? date;
  final String? odometer;
  final int? todoId;

  const CreateExpenseTodo({
      required this.expenseId,
      required this.files,
      required this.categoryId,
      required this.paymentMethodId,
      required this.subCategoryId,
      required this.expenseTo,
      required this.expenseAmount,
      required this.expenseDescription,
      required this.cohortId,
      required this.vin,
      required this.date,
      required this.todoId,
      required this.odometer,
      });
  @override
  List<Object?> get props => [
    files,
    categoryId,
    subCategoryId,
    paymentMethodId,
    expenseTo,
    expenseAmount,
    expenseDescription,
    cohortId,
    vin,
    date,
    odometer
  ];
}

class DeleteExpenseTodoImage extends TodoViewEvent {
  final int? id;
  const DeleteExpenseTodoImage({required this.id});
  @override
  List<Object?> get props => [id];
}

class GetPartsData extends TodoViewEvent {
  const GetPartsData();
  @override
  List<Object?> get props => [];
}

class UpdatePartsForItemEvent extends TodoViewEvent {
  final int? todoId;
  final List<dynamic> selectedPartsList;
  const UpdatePartsForItemEvent(
      {required this.todoId, required this.selectedPartsList});
  @override
  List<Object?> get props => [todoId, selectedPartsList];
}

class UpdateSuppliesForItemEvent extends TodoViewEvent {
  final int todoId;
  final List<dynamic> selectedSupplyList;
  const UpdateSuppliesForItemEvent(
      {required this.todoId, required this.selectedSupplyList});
  @override
  List<Object?> get props => [todoId, selectedSupplyList];
}

class UpdateVehicleGroupForItemEvent extends TodoViewEvent {
  final int? vehicleGroupId;
  final List<String>? selectedVinList;
  final String name;
  const UpdateVehicleGroupForItemEvent(
      {required this.vehicleGroupId,
        required this.selectedVinList,
        required this.name});
  @override
  List<Object?> get props => [vehicleGroupId, selectedVinList, name];
}

class GetVehicleGroupingList extends TodoViewEvent {
  const GetVehicleGroupingList();
  @override
  List<Object?> get props => [];
}

class GetUserGroupingList extends TodoViewEvent {
  const GetUserGroupingList();
  @override
  List<Object?> get props => [];
}

class GetChatMessagesList extends TodoViewEvent {
  final int? sender;
  final int? receiver;
  const GetChatMessagesList({required this.sender, required this.receiver});
  @override
  List<Object?> get props => [sender, receiver];
}

class SendChatMessage extends TodoViewEvent {
  final int? sender;
  final int? receiver;
  final String? createdAt;
  final String? message;
  const SendChatMessage(
      {required this.sender,
        required this.receiver,
        required this.createdAt,
        required this.message});

  @override
  List<Object?> get props => [sender, receiver, createdAt, message];
}

class CreateCheckListTodoEvent extends TodoViewEvent {
  final CreateTodoParams createTodoParams;
  const CreateCheckListTodoEvent({required this.createTodoParams});

  @override
  List<Object?> get props => [createTodoParams];
}

class GetWorkingHourByUserEvent extends TodoViewEvent {
  final int id;
  const GetWorkingHourByUserEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SaveWorkingHourEvent extends TodoViewEvent {
  final int? isBreak;
  final String? startDate;
  final String? startTime;
  final String? title;
  final int? userId;
  const SaveWorkingHourEvent(
      {required this.isBreak,
        required this.startDate,
        required this.startTime,
        required this.title,
        required this.userId});

  @override
  List<Object?> get props => [isBreak, startDate, startTime, title, userId];
}


class DeleteTaskConfigurationEvent extends TodoViewEvent {
  final int? id;
  const DeleteTaskConfigurationEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetCheckList extends TodoViewEvent {
  const GetCheckList();
  @override
  List<Object?> get props => [];
}

class GetMaintenanceCheckList extends TodoViewEvent {
  const GetMaintenanceCheckList();
  @override
  List<Object?> get props => [];
}

class GetBranchList extends TodoViewEvent {
  const GetBranchList();
  @override
  List<Object?> get props => [];
}

class ChangeBranch extends TodoViewEvent {
  final String branchId;
  const ChangeBranch(this.branchId);
  @override
  List<Object?> get props => [branchId];
}

class GetExpenseData extends TodoViewEvent {
  final String? minDate;
  final String? maxDate;

  const GetExpenseData(
      this.minDate,
      this.maxDate,
      );
  @override
  List<Object?> get props => [minDate,maxDate];
}

class GetExpenseCategoriesData extends TodoViewEvent{
  const GetExpenseCategoriesData();
  @override
  List<Object?> get props => [];
}

class GetExpensePaymentsData extends TodoViewEvent{
  const GetExpensePaymentsData();
  @override
  List<Object?> get props => [];
}

class GetExpenseOtherData extends TodoViewEvent {
  final String minDate;
  final String maxDate;

  const GetExpenseOtherData({required this.minDate, required this.maxDate});

  @override
  List<Object?> get props => [minDate, maxDate];
}

class GetExpensePersonData extends TodoViewEvent {
  final String minDate;
  final String maxDate;

  const GetExpensePersonData({required this.minDate, required this.maxDate});

  @override
  List<Object?> get props => [minDate, maxDate];
}

class AddOtherData extends TodoViewEvent {

  final int? id;
  final int? expenseTo;
  final int? paymentId;
  final String? expenseDate;
  final double? expenseAmount;
  final String? categoryId;
  final String? subcategoryId;
  final int? approved;
  final String? expenseDescription;


  const AddOtherData({
    required this.expenseDate,
    required this.expenseAmount,
    required this.categoryId,
    required this.subcategoryId,
    required this.approved,
    required this.expenseDescription,
    required this.expenseTo,
    required this.id,
    required this.paymentId,
  });
  @override
  List<Object?> get props => [
    expenseDate,expenseAmount,categoryId,subcategoryId,expenseDescription,approved,expenseTo,paymentId,
    id];
}
//-----------------------------------

class AddExpenseData extends TodoViewEvent {
  final String? vehicleId;
  final String? expenseAmount;
  final String? paymentMethodId;
  final String? expenseDescription;
  final String? categoryId;
  final String? subcategoryId;
  final String? expenseTo;
  final String? expenseDate;
  final String? odometer;
  final int? id;

  const AddExpenseData({
    required this.vehicleId,
    required this.expenseAmount,
    required this.paymentMethodId,
    required this.expenseDescription,
    required this.categoryId,
    required this.subcategoryId,
    required this.expenseTo,
    required this.expenseDate,
    required this.odometer,
    required this.id,});
  @override
  List<Object?> get props => [
    vehicleId,
    expenseAmount,
    paymentMethodId,
    expenseDescription,
    categoryId,
    subcategoryId,
    expenseTo,
    expenseDate,
    odometer,
    id];
}

class DeleteExpense extends TodoViewEvent {
  final String id;

  const DeleteExpense({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetCohortsData extends TodoViewEvent {
  const GetCohortsData();
  @override
  List<Object> get props => [];
}

class GetPaymentData extends TodoViewEvent {
  const GetPaymentData();
  @override
  List<Object> get props => [];
}


class DeleteVehicles extends TodoViewEvent {
  final int id;
  const DeleteVehicles({required this.id,});
  @override
  List<Object> get props => [id];
}


class DeletePartsEvent extends TodoViewEvent {
  final int partsId;

  const DeletePartsEvent({required this.partsId,});
  @override
  List<Object> get props => [partsId];
}

class DeleteSupplysEvent extends TodoViewEvent {
  final int? suppliesId;

  const DeleteSupplysEvent({required this.suppliesId});
  @override
  List<Object?> get props => [suppliesId];
}


class GetVoiceData extends TodoViewEvent {
  final String? from;
  final String? to;

  const GetVoiceData(
      this.from,
      this.to,
      );
  @override
  List<Object?> get props => [from,to];
}

// class DeleteOtherData extends TodoViewEvent {
//   final int id;
//
//   const DeleteOtherData({
//     required this.id,
//   });
//
//   @override
//   List<Object> get props => [id];
// }

class DeleteExpenseOtherEvent extends TodoViewEvent {
  final int? id;
  const DeleteExpenseOtherEvent({required this.id});

  @override
  List<Object?> get props => [id];
}



class GetWorkingHoursData extends TodoViewEvent {
  final String minDate;
  final String maxDate;
  const GetWorkingHoursData({required this.minDate, required this.maxDate});
  @override
  List<Object?> get props => [minDate, maxDate];
}

class GetActiveHoursData extends TodoViewEvent {
  final String minDate;
  final String maxDate;
  const GetActiveHoursData({required this.minDate, required this.maxDate});
  @override
  List<Object?> get props => [minDate, maxDate];
}

class AddConfigurationEvent extends TodoViewEvent {
  final int? id;
  final int? userId;
  final String? name;
  final String? amount;
  final String? task;
  const AddConfigurationEvent(
      {required this.id, required this.userId, required this.name, required this.amount, required this.task});

  @override
  List<Object?> get props => [name, amount, task];
}
//--
class GetEmployeeNameData extends TodoViewEvent {
  const GetEmployeeNameData();
  @override
  List<Object> get props => [];
}

class GetEmployeeStatementData extends TodoViewEvent {
  const GetEmployeeStatementData();
  @override
  List<Object> get props => [];
}

class GetCategoryConfigData extends TodoViewEvent {
  const GetCategoryConfigData();
  @override
  List<Object> get props => [];
}

class AddCategoryConfigData extends TodoViewEvent {

  final String name;
  final int? userType;
  final int? parentId;
  final int? id;

  const AddCategoryConfigData({
    required this.name,required this.userType,required this.parentId, required this.id,
  });
  @override
  List<Object?> get props => [name,userType,parentId,id];
}

class DeleteCategoryConfig extends TodoViewEvent {
  final int? id;

  const DeleteCategoryConfig({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class GetTaskData extends TodoViewEvent {
  const GetTaskData();
  @override
  List<Object> get props => [];
}

class GetTaskExpense extends TodoViewEvent {
  const GetTaskExpense();
  @override
  List<Object> get props => [];
}

class AddTaskData extends TodoViewEvent {


  final int? categoryId;
  final int? subCategoryId;
  final String? name;
  final String? timeTaken;
  final int? userType;
  final int? id;

  const AddTaskData({
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.timeTaken,
    required this.userType,
    required this.id,
  });
  @override
  List<Object?> get props => [categoryId, subCategoryId,name, timeTaken,userType, id];
}

class DeleteTaskData extends TodoViewEvent {
  final String id;

  const DeleteTaskData({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetTaskCategoryGroup extends TodoViewEvent {
  const GetTaskCategoryGroup();
  @override
  List<Object> get props => [];
}

class AddFixTask extends TodoViewEvent {
  final CreateFixTaskData? createFixTaskData;
  const AddFixTask({required this.createFixTaskData,});
  @override
  List<Object?> get props => [createFixTaskData];
}

class GetTaskMiles extends TodoViewEvent {
  const GetTaskMiles();
  @override
  List<Object> get props => [];
}

class GetPreviousOdometer extends TodoViewEvent {
  final String? todoDate;
  final String? vin;
  final int? identifierId;
  final Map<String, dynamic>? todoData;
  const GetPreviousOdometer({
    required this.todoDate,
    required this.vin,
    required this.identifierId,
    this.todoData,
  });
  @override
  List<Object?> get props => [todoDate,vin,identifierId, todoData, Random().nextDouble()];
}


//---