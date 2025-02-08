import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Response/create_expense_field_data.dart';
import 'package:fairpytasker/Response/expense_summary_response.dart';
import 'package:fairpytasker/Response/vehicle_status_config_response.dart';
import 'package:fairpytasker/Response/working_history_count_response.dart';

abstract class TodoViewState extends Equatable {
  const TodoViewState();
}

class TodoViewInitial extends TodoViewState {
  @override
  List<Object> get props => [];
}

class DropdownDataLoaded extends TodoViewState {
  final CreateExpenseFieldData? createExpenseFieldData;
  const DropdownDataLoaded({required this.createExpenseFieldData});
  @override
  List<Object?> get props => [createExpenseFieldData];
}

class AddExpenseLoaded extends TodoViewState {
  const AddExpenseLoaded();
  @override
  List<Object?> get props => [];
}

class VehicleDataLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? vehicleData;
  const VehicleDataLoaded({required this.vehicleData});
  @override
  List<Object?> get props => [vehicleData];
}
//

class TodoListLoading extends TodoViewState {
  @override
  List<Object> get props => [];
}

class TodoListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? todoList;
  const TodoListLoaded({required this.todoList});
  @override
  List<Object?> get props => [todoList];
}

class TodoItemCompletedV extends TodoViewState {
  final bool? result;
  final String? status;
  final String? todoId;
  final String? taskName;
  const TodoItemCompletedV(
      {required this.result,
        required this.status,
        required this.todoId,
        this.taskName});
  @override
  List<Object?> get props => [result, status, todoId, taskName];
}

class DeleteTodoLoaded extends TodoViewState {
  final bool? result;
  const DeleteTodoLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class CreateTodoLoaded extends TodoViewState {
  final bool? result;
  final bool? exitTheScreen;
  const CreateTodoLoaded({required this.result, this.exitTheScreen});
  @override
  List<Object?> get props => [result, exitTheScreen];
}

class CreateExpenseLoaded extends TodoViewState {
  final bool? isVehicleGroup;
  final ExpenseSummaryResponse? expenseSummaryResponse;
  const CreateExpenseLoaded(
      {required this.expenseSummaryResponse, required this.isVehicleGroup});
  @override
  List<Object?> get props => [expenseSummaryResponse, isVehicleGroup];
}

class ExpenseTodoLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? expenseSummaryData;
  const ExpenseTodoLoaded({required this.expenseSummaryData});
  @override
  List<Object?> get props => [expenseSummaryData];
}

class AssignedToLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? resource;
  const AssignedToLoaded({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class PartsLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? partsList;
  const PartsLoaded({required this.partsList});
  @override
  List<Object?> get props => [partsList];
}

//-----
class WorkingHistoryLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? workingHistoryResponse;
  const WorkingHistoryLoaded({required this.workingHistoryResponse});
  @override
  List<Object?> get props => [workingHistoryResponse];
}

class TaskHistoryConfigurationLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? taskHistoryConfigurationList;
  const TaskHistoryConfigurationLoaded(
      {required this.taskHistoryConfigurationList});
  @override
  List<Object?> get props => [taskHistoryConfigurationList];
}

class GetWorkingTaskHistoryListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? employeeTaskHistoryResponse;
  const GetWorkingTaskHistoryListLoaded(
      {required this.employeeTaskHistoryResponse});
  @override
  List<Object?> get props => [employeeTaskHistoryResponse];
}

class WorkingHistoryCountLoaded extends TodoViewState {
  final WorkingHistoryCountResponse? workingHistoryCountResponse;
  const WorkingHistoryCountLoaded({required this.workingHistoryCountResponse});
  @override
  List<Object?> get props => [workingHistoryCountResponse];
}

class VehicleStatusListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? vehicleStatusListDataList;
  final List<Map<String, dynamic>>? vehiclesCount;
  const VehicleStatusListLoaded({required this.vehicleStatusListDataList,required this.vehiclesCount
  });
  @override
  List<Object?> get props => [vehicleStatusListDataList,vehiclesCount];
}

class GetVehicleStatusConfigListLoaded extends TodoViewState {
  final VehicleStatusConfigResponse? vehicleStatusConfigResponse;
  const GetVehicleStatusConfigListLoaded(
      {required this.vehicleStatusConfigResponse});
  @override
  List<Object?> get props => [vehicleStatusConfigResponse];
}

class ReorderVehicleStatusCheckListLoaded extends TodoViewState {
  final bool? result;
  const ReorderVehicleStatusCheckListLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class VehicleStatusCheckListCheckLoaded extends TodoViewState {
  final bool? result;
  const VehicleStatusCheckListCheckLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class GetVehicleActiveStatusLoaded extends TodoViewState {
  final bool? result;
  const GetVehicleActiveStatusLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class GetVehicleStatusCheckListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;
  final List<Map<String, dynamic>>? categories;
  final dynamic percentage;
  final int? categoryId;
  final int? checkListId;
  final Map<String, dynamic>? vehicleStatusListDataList;
  final String? categoryName;
  const GetVehicleStatusCheckListLoaded(
      {this.data,
        this.categories,
        this.percentage,
        this.categoryId,
        this.checkListId,
        this.vehicleStatusListDataList,
        this.categoryName});
  @override
  List<Object?> get props => [
    data,
    categories,
    percentage,
    categoryId,
    checkListId,
    vehicleStatusListDataList,
    categoryName
  ];
}

class UpdateVehicleStatusLoaded extends TodoViewState {
  final bool? result;
  const UpdateVehicleStatusLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class VehicleCreateStatusTodoLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? todo;
  final String? mentionedCategory;
  final int? index;
  final Map<String, dynamic>? vehicleStatusListDataList;
  const VehicleCreateStatusTodoLoaded(
      {required this.todo,
        required this.mentionedCategory,
        required this.index,
        required this.vehicleStatusListDataList});
  @override
  List<Object?> get props =>
      [todo, mentionedCategory, index, vehicleStatusListDataList];
}

class AddVehicleCreateTodoLoaded extends TodoViewState {
  final bool? result;
  const AddVehicleCreateTodoLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class VehicleStatusCreateTodoLoaded extends TodoViewState {
  final bool? result;
  final String? vin;
  final int? vehicleStatusCategory;
  const VehicleStatusCreateTodoLoaded(
      {required this.result,
        required this.vin,
        required this.vehicleStatusCategory});
  @override
  List<Object?> get props => [result, vin, vehicleStatusCategory];
}

class SelectedVehicleCategoriesLoaded extends TodoViewState {
  final bool? result;
  const SelectedVehicleCategoriesLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class CumulativeCostLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? cumulativeCostExpensesList;
  const CumulativeCostLoaded({required this.cumulativeCostExpensesList});
  @override
  List<Object?> get props => [cumulativeCostExpensesList];
}

class GetMiscellaneousVehiclesLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? vehiclesMiscellaneousList;
  const GetMiscellaneousVehiclesLoaded(
      {required this.vehiclesMiscellaneousList});
  @override
  List<Object?> get props => [vehiclesMiscellaneousList];
}

class SuppliesLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? suppliesList;
  const SuppliesLoaded({required this.suppliesList});
  @override
  List<Object?> get props => [suppliesList];
}

class TaskExpenseLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? resource;
  const TaskExpenseLoaded({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class VendorLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? resource;
  const VendorLoaded({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class ExpenseSummaryLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? expenseSummaryList;
  const ExpenseSummaryLoaded({required this.expenseSummaryList});
  @override
  List<Object?> get props => [expenseSummaryList];
}

class LocationLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? resource;
  const LocationLoaded({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class CohortsLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? resource;
  const CohortsLoaded({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class EditTodoLoaded extends TodoViewState {
  final bool? result;
  final String? todoId;
  final String? date;
  final bool? isDate;
  final String? oldDate;
  const EditTodoLoaded(
      {required this.result,
        this.todoId,
        this.date,
        this.isDate,
        this.oldDate});
  @override
  List<Object?> get props => [result, todoId, date, isDate, oldDate];
}

class DeletePartsOrSupplyLoaded extends TodoViewState {
  final bool? result;
  const DeletePartsOrSupplyLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class VehicleGroupLoaded extends TodoViewState {
  final bool? result;
  const VehicleGroupLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class UserGroupListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? userGroupDataList;
  const UserGroupListLoaded({required this.userGroupDataList});
  @override
  List<Object?> get props => [userGroupDataList];
}

class VehicleGroupListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? vehicleGroupDataList;
  const VehicleGroupListLoaded({required this.vehicleGroupDataList});
  @override
  List<Object?> get props => [vehicleGroupDataList];
}

class CreateCheckListTodoLoaded extends TodoViewState {
  final bool? result;
  const CreateCheckListTodoLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class ChatsLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? chatList;
  const ChatsLoaded({required this.chatList});
  @override
  List<Object?> get props => [chatList];
}

class ChatSendLoaded extends TodoViewState {
  final bool? result;
  const ChatSendLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class GetWorkingHourByUserLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? workingHoursGetResponse;
  const GetWorkingHourByUserLoaded({required this.workingHoursGetResponse});
  @override
  List<Object?> get props => [workingHoursGetResponse];
}

class SaveWorkingHoursLoaded extends TodoViewState {
  final bool? result;
  const SaveWorkingHoursLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class AddTaskConfigurationLoaded extends TodoViewState {
  final bool? result;
  const AddTaskConfigurationLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class DeleteTaskConfigurationLoaded extends TodoViewState {
  final bool? result;
  const DeleteTaskConfigurationLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class GetTaskDetailDataLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? todo;
  const GetTaskDetailDataLoaded({required this.todo});
  @override
  List<Object?> get props => [todo];
}

class CheckListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;
  const CheckListLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class MaintenanceCheckListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;
  const MaintenanceCheckListLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class BranchListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;
  const BranchListLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class ExpenseListLoaded extends TodoViewState {
  final List<Map<String, dynamic>> data;

  const ExpenseListLoaded(
      {required this.data});

  @override
  List<Object?> get props => [data];
}

class ExpenseLoaded extends TodoViewState {
  final String? message;
  const ExpenseLoaded({required this.message,});
  @override
  List<Object?> get props => [message];
}


class ExpenseError extends TodoViewState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object> get props => [message];
}
//---
class ExpenseCategoryLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;

  const ExpenseCategoryLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class ExpensePaymentLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;


  const ExpensePaymentLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

//---
class ExpenseOtherLoaded extends TodoViewState {
  final List<Map<String, dynamic>> data;
  final int? totalExpensesAmount;

  const ExpenseOtherLoaded({required this.data,required this.totalExpensesAmount});

  @override
  List<Object?> get props => [data, totalExpensesAmount];
}
//--
class ExpenseOtherError extends TodoViewState {
  final String message;

  const ExpenseOtherError({required this.message});

  @override
  List<Object?> get props => [message];
}
//--

class ExpensePersonLoaded extends TodoViewState {
  final List<Map<String, dynamic>> data;
  final int? totalExpensesAmount;

  const ExpensePersonLoaded({required this.data, this.totalExpensesAmount});

  @override
  List<Object?> get props => [data, totalExpensesAmount];
}
//--
class ExpensePersonError extends TodoViewState {
  final String message;

  const ExpensePersonError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CohortsListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? cohortData;
  final List<Map<String, dynamic>>? expenseData;

  const CohortsListLoaded({required this.expenseData,required this.cohortData});

  @override
  List<Object?> get props => [expenseData,cohortData];
}

class CohortsError extends TodoViewState {
  final String message;

  const CohortsError(this.message);

  @override
  List<Object> get props => [message];
}

class PaymentListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;
  const PaymentListLoaded(
      {required this.data});
  @override
  List<Object?> get props => [data];
}

class VoiceListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;
  const VoiceListLoaded(
      {required this.data});
  @override
  List<Object?> get props => [data];
}

class FinanceStatementLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? statementData;
  const FinanceStatementLoaded(
      {required this.statementData});
  @override
  List<Object?> get props => [statementData];
}

class WorkingHoursLoaded extends TodoViewState {
  final List<Map<String, dynamic>> data;

  const WorkingHoursLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetWorkingHistoryLoaded extends TodoViewState{
  final List<Map<String, dynamic>> history;
  const GetWorkingHistoryLoaded({required this.history});
  @override
  List<Object?> get props => [history];
}

class GetActiveHoursLoaded extends TodoViewState{
  final List<Map<String, dynamic>> data;
  const GetActiveHoursLoaded({required this.data});
  List<Object?> get props => [data];
}

class ExpenseOtherDeleteLoaded extends TodoViewState {
  final String? message;
  const ExpenseOtherDeleteLoaded({required this.message,});
  @override
  List<Object?> get props => [message];
}

class EmployeeNameLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? EmployeeData;
  const EmployeeNameLoaded(
      {required this.EmployeeData});
  @override
  List<Object?> get props => [EmployeeData];
}

class CategoryConfigListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;
  const CategoryConfigListLoaded(
      {required this.data});
  @override
  List<Object?> get props => [data];
}

class CategoryConfigLoaded extends TodoViewState {
  final String? message;
  const CategoryConfigLoaded({required this.message,});
  @override
  List<Object?> get props => [message];
}


class CategoryConfigError extends TodoViewState {
  final String message;

  const CategoryConfigError(this.message);

  @override
  List<Object> get props => [message];
}

class TaskListLoaded extends TodoViewState {
  final List<Map<String, dynamic>>? data;
  const TaskListLoaded(
      {required this.data});
  @override
  List<Object?> get props => [data];
}

class TaskLoaded extends TodoViewState {
  final String message;
  const TaskLoaded(
      {required this.message});
  @override
  List<Object> get props => [message];
}

class TaskError extends TodoViewState {
  final String message;
  const TaskError(this.message);
  @override
  List<Object> get props => [message];
}

class TaskCategoryGroupLoaded extends TodoViewState{
  final List<Map<String, dynamic>>? data;
  const TaskCategoryGroupLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class TaskMilesLoaded extends TodoViewState{
  final List<Map<String, dynamic>>? data;
  const TaskMilesLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class PreviousOdometerLoaded extends TodoViewState{
  final int? data;
  final Map<String, dynamic>? todoData;
  const PreviousOdometerLoaded({required this.data, this.todoData});
  @override
  List<Object?> get props => [data, todoData, Random().nextDouble()];
}
