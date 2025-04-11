import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fairpytasker/Response/create_todo_params.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Repository/vehicle_repository.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TodoViewBloc extends Bloc<TodoViewEvent, TodoViewState> {
  TodoListRepo todoListRepo = TodoListRepo();
  VehicleDataRepo vehicleDataRepo = VehicleDataRepo();

  TodoViewBloc() : super(TodoViewInitial()) {
    on<TodoViewEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetDropdownData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.fetchDropdownValues().then((value) {
        emit(DropdownDataLoaded(createExpenseFieldData: value));
      });
    });

    on<GetVehicleListData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.fetchVehicleList().then((value) {
        emit(VehicleDataLoaded(vehicleData: value?.data ?? []));
      });
    });
    //

    on<GetVehicleGroupingList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.fetchVehicleGroupingList().then((value) {
        emit(VehicleGroupListLoaded(
            vehicleGroupDataList: value?.vehicleGroupData ?? []));
      });
    });

    on<GetUserGroupingList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.fetchUserGroupingList().then((value) {
        emit(UserGroupListLoaded(userGroupDataList: value?.data ?? []));
      });
    });

    on<GetTodoList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .callTodoListAPI(event.selectedDate, event.status, event.resourceId)
          .then((value) {
        emit(TodoListLoaded(todoList: value?.todos ?? []));
      });
    });

    on<CompleteTodoItem>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .completeATodo(event.todoId, event.status)
          .then((value) {
        emit(TodoItemCompletedV(
            result: value, status: event.status, todoId: event.todoId));
      });
    });

    on<DeleteTodoEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.deleteATodo(event.todoId ?? '').then((value) {
        emit(DeleteTodoLoaded(result: value));
      });
    });

    on<CreateTodoEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.createATodo(event.createTodoParams!).then((value) {
        emit(CreateTodoLoaded(
            result: value, exitTheScreen: event.exitTheScreen));
      });
    });

    on<GetExpenseToData>((event, emit) async {
      if (event.expenseId != null) {
        emit(TodoListLoading());
        await todoListRepo.getAExpenseTodo(event.expenseId!).then((value) {
          emit(ExpenseTodoLoaded(expenseSummaryData: value?.expense ?? {}));
        });
      }
    });


    on<GetAssignedToList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getAssignedTo().then((value) {
        emit(AssignedToLoaded(resource: value?.resource ?? []));
      });
    });

    on<GetWorkingHistoryList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getWorkingHistory(event.startDate ?? Utils.getStartOfMonth(),
          event.endDate ?? Utils.getEndOfMonth())
          .then((value) {
        emit(WorkingHistoryLoaded(workingHistoryResponse: value?.data ?? []));
      });
    });

    on<GetTaskHistoryConfiguration>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getTaskHistoryConfiguration().then((value) {
        emit(TaskHistoryConfigurationLoaded(
            taskHistoryConfigurationList: value?.data ?? []));
      });
    });

    on<GetWorkingTaskHistoryList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getWorkingTaskHistory(event.startDate ?? Utils.getStartOfMonth(),
          event.endDate ?? Utils.getEndOfMonth(), event.userId!)
          .then((value) {
        emit(GetWorkingTaskHistoryListLoaded(
            employeeTaskHistoryResponse: value?.history ?? []));
      });
    });



    on<GetVehicleStatusList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getVehicleStatus().then((value) {
        emit(VehicleStatusListLoaded(
          vehicleStatusListDataList: value?.data ?? [],
          vehiclesCount: value?.vehiclesCount ?? [],
        ));
      });
    });

    on<UpdateVehicleStatus>((event, emit) async {
      emit(TodoListLoading());
      // CreateTodoParams createTodoParams = CreateTodoParams(vin: event.vinNumber, vehicleStatusCategory: element.id);
      await todoListRepo
          .vehicleStatusUpdate(event.createTodoParams)
          .then((value) {
        emit(UpdateVehicleStatusLoaded(result: value));
      });
    });

    on<GetVehicleStatusCheckList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getVehicleStatusCheckList(event.vinNumber)
          .then((value) async {
        if (event.categoryName == 'PreSale') {
          for (var element in value!.categories!) {
            if (element['category_name'] == 'Sold') {
              CreateTodoParams createTodoParams = CreateTodoParams(
                  vin: event.vinNumber, vehicleStatusCategory: element['id']);
              await todoListRepo
                  .vehicleStatusUpdate(createTodoParams)
                  .then((value) {
                emit(GetVehicleStatusCheckListLoaded(
                    categoryName: event.categoryName, data: null));
              });
              return;
            }
          }
        } else if (event.vehicleStatusListDataList != null) {
          emit(GetVehicleStatusCheckListLoaded(
              data: value?.data ?? [],
              categoryName: event.categoryName,
              vehicleStatusListDataList: event.vehicleStatusListDataList));
        } else {
          emit(GetVehicleStatusCheckListLoaded(
              data: value?.data ?? [],
              categoryId: event.categoryId,
              checkListId: event.checkListId));
        }
      });
    });

    on<SetVehicleActiveStatus>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getVehicleActiveStatus(event.vinNumber, event.vehicleStatus)
          .then((value) {
        emit(GetVehicleActiveStatusLoaded(result: value));
      });
    });

    on<VehicleCreateStatusTodo>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getVehicleCreateStatusTodo(
          event.categoryId,
          event.cohortId,
          event.cohortName,
          event.userId,
          event.vehImage,
          event.vehName,
          event.vinNumber,
          event.isCreate,
          categoryName: event.categoryName,
          soldId: event.soldId)
          .then((value) {
        emit(VehicleCreateStatusTodoLoaded(
          todo: value?.todo ?? [],
          mentionedCategory: event.categoryName,
          index: event.index,
          vehicleStatusListDataList: event.vehicleStatusListDataList,
        ));
      });
    });

    on<AddVehicleCreateTodo>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .addVehicleCreateTodo(
          event.checklistId,
          event.categoryId,
          event.cohortId,
          event.status,
          event.userId,
          event.title,
          event.vehName,
          event.vinNumber,
          event.todoTime,
          event.startAt,
          event.statusId)
          .then((value) {
        emit(AddVehicleCreateTodoLoaded(result: value));
      });
    });

    on<VehicleStatusCreateTodo>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .createVehicleStatusTodo(event.createTodoParams!)
          .then((value) {
        emit(VehicleStatusCreateTodoLoaded(
            result: value,
            vin: event.createTodoParams!.vin,
            vehicleStatusCategory: event.createTodoParams!.vehicleStatus));
      });
    });

    on<GetCumulativeList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getCumulativeCostList(event.vin).then((value) {
        emit(CumulativeCostLoaded(
            cumulativeCostExpensesList: value?.data ?? []));
      });
    });

    on<VehicleStatusConfigSelectedCategories>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .selectedVehicleCategories(event.vinNumber, event.categoryId,
          event.checkboxValue, event.categoryIds, event.isApi)
          .then((value) {
        emit(SelectedVehicleCategoriesLoaded(result: value));
      });
    });

    on<GetVehicleStatusConfigList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getVehicleStatusConfigList(event.vinNumber)
          .then((value) {
        emit(GetVehicleStatusConfigListLoaded(
            vehicleStatusConfigResponse: value));
      });
    });

    on<ReorderVehicleStatusCheckList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .reorderVehicleStatusCheckList(
          event.vinNumber, event.categoryId, event.orderCheckList)
          .then((value) {
        emit(ReorderVehicleStatusCheckListLoaded(result: value));
      });
    });

    on<VehicleStatusCheckListCheck>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .vehicleStatusCheckListCheck(event.vinNumber, event.categoryId,
          event.checked, event.checkItemId, event.type, event.categoryIds)
          .then((value) {
        emit(VehicleStatusCheckListCheckLoaded(result: value));
      });
    });

    on<GetMiscellaneousVehicles>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getMiscellaneousVehiclesList().then((value) {
        emit(GetMiscellaneousVehiclesLoaded(
            vehiclesMiscellaneousList: value?.vehicles ?? []));
      });
    });

    on<GetPartsList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getParts().then((value) {
        emit(PartsLoaded(partsList: value?.data ?? []));
      });
    });

    on<GetSuppliesList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getSupplies().then((value) {
        emit(SuppliesLoaded(suppliesList: value?.data ?? []));
      });
    });

    on<GetTaskExpenseData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getTaskExpense().then((value) {
        emit(TaskExpenseLoaded(resource: value?.data ?? []));
      });
    });

    on<GetVendorData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getVendor().then((value) {
        emit(VendorLoaded(resource: value?.data ?? []));
      });
    });

    on<GetExpenseSummaryData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getExpenseSummary(event.vinNumber).then((value) {
        emit(ExpenseSummaryLoaded(expenseSummaryList: value?.expense ?? {}));
      });
    });

    on<GetLocationData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getLocation().then((value) {
        emit(LocationLoaded(resource: value?.data ?? []));
      });
    });

    on<EditTodoDate>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .editATodoDate(
          event.todoId!,
          event.editedNextDate,
          event.isDate,
          event.editedTime,
          event.resourceIdList,
          event.resourceId,
          event.notes,
          event.expenseId,
          event.addresses)
          .then((value) {
        if (event.isDate != null && event.isDate!) {
          emit(EditTodoLoaded(
              result: value,
              todoId: event.todoId,
              date: event.editedNextDate,
              isDate: event.isDate));
        } else {
          emit(EditTodoLoaded(result: value));
        }
      });
    });

    on<EditTodoVehiclePerson>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.editAVehiclePerson(
        event.todoId,
        event.vehiclePersonData,
        event.person,
        event.personId,
        event.vehicleGroupId,
      )
          .then((value) {
        emit(EditTodoLoaded(result: value));
      });
    });

/*    on<EditTodoVehiclePerson>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .editAVehiclePerson(
          event.todoId!,
          event.todoUserId,
          event.todoVehicleName,
          event.selectedCohortId,
          event.personName,
          event.cohortName,
          event.vin,
          event.vehicleImage,
          event.vehicleNumber)
          .then((value) {
        emit(EditTodoLoaded(result: value));
      });
    });*/

    on<DeleteVehicles>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.deleteVehicle(event.id).then((value) {
        emit(DeleteTodoLoaded(result: value));
      });
    });

    on<EditTodoVendorLocation>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .editAVendorLocation(event.todoId!, event.todoVendorName,
          event.locationName, event.todoVendorId, event.todoVendorId)
          .then((value) {
        emit(EditTodoLoaded(result: value));
      });
    });

    on<SwapTodo>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .swapTodo(event.fromId ?? '0', event.toId ?? '0')
          .then((value) {
        emit(EditTodoLoaded(result: value));
      });
    });

    on<DeleteExpenseTodoImage>((event, emit) async {
      emit(TodoListLoading());
      await vehicleDataRepo.deleteExpenseImages(event.id).then((value) {
        emit(TodoViewInitial());
      });
    });

/*
    on<CreateExpenseTodo>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .createExpense(
          event.expenseId,
          event.files,
          event.categoryId,
          event.subCategoryId,
          event.paymentMethodId,
          event.expenseTo,
          event.expenseAmount,
          event.expenseDescription,
          event.cohortId,
          event.vin,
          event.todoId,
          event.date,
          event.odometer)
          .then((expenseSummaryValue) async {
        if ( event.expenseId == null) {
          await todoListRepo
              .editExpenseTodo(
            event.expenseId,
            event.todoId,
            event.paymentMethodId,
            event.expenseAmount,
            event.expenseDescription,
            event.categoryId,
            event.subCategoryId,
            event.expenseTo,
            event.cohortId,
            event.vin,
            event.date,
          ).then((value) {
            emit(CreateTodoLoaded(result: value));
          });
        } else if (event.expenseId != null) {
          emit(const CreateTodoLoaded(result: true));
        }
      });
    });
*/


    on<CreateExpenseTodo>((event, emit) async {
      emit(TodoListLoading());
        final response = await todoListRepo.createExpense(
          event.expenseId,
          event.files,
          event.categoryId,
          event.subCategoryId,
          event.paymentMethodId,
          event.expenseTo,
          event.expenseAmount,
          event.expenseDescription,
          event.cohortId,
          event.vin,
          event.todoId,
          event.date,
          event.odometer,
        );
        final int? newExpenseId = (response?['data'] as List?)?.firstOrNull?['id'];
        if (event.expenseId == null && newExpenseId != null) {
          await todoListRepo.editExpenseTodo(
            newExpenseId,
            event.todoId,
            event.paymentMethodId,
            event.expenseAmount,
            event.expenseDescription,
            event.categoryId,
            event.subCategoryId,
            event.expenseTo,
            event.cohortId,
            event.vin,
            event.date,
          ).then((value) {
          emit(CreateTodoLoaded(result: value));});
        }else if (event.expenseId != null) {
          emit(const CreateTodoLoaded(result: true));
        }
    });

    on<UpdateExpenseInTodo>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .editAExpenseTodo(
          event.todoId,
          event.categoryId,
          event.subCategoryId,
          event.expenseTo,
          event.expenseAmount,
          event.expenseDescription,
          event.categoryName,
          event.subCategoryName)
          .then((value) {
        emit(TodoViewInitial());
      });
    });

    on<DeletePartsEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .deletePartsForItem(event.partsId)
          .then((value) {
        emit(DeletePartsOrSupplyLoaded(result: value));
      });
    });

    on<DeleteSupplysEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .deleteSuppliesForItem(event.suppliesId!)
          .then((value) {
        emit(DeletePartsOrSupplyLoaded(result: value));
      });
    });

    on<UpdatePartsForItemEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .updatePartsForItem(event.todoId!, event.selectedPartsList)
          .then((value) {
        emit(EditTodoLoaded(result: value));
      });
    });

    on<UpdateSuppliesForItemEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .updateSupplyForItem(event.todoId, event.selectedSupplyList)
          .then((value) {
        emit(EditTodoLoaded(result: value));
      });
    });

    on<UpdateVehicleGroupForItemEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .updateVehicleGroupForItem(
          event.vehicleGroupId!, event.selectedVinList!, event.name)
          .then((value) {
        emit(VehicleGroupLoaded(result: value));
      });
    });

    on<GetChatMessagesList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getChatsList(event.sender!, event.receiver!)
          .then((value) {
        emit(ChatsLoaded(chatList: value?.chats ?? []));
      });
    });

    on<CreateCheckListTodoEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .createCheckListTodo(event.createTodoParams)
          .then((value) {
        emit(CreateCheckListTodoLoaded(result: value));
      });
    });

    on<GetWorkingHourByUserEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getWorkingHourByUser(event.id).then((value) {
        emit(GetWorkingHourByUserLoaded(
            workingHoursGetResponse: value?.data ?? []));
      });
    });

    on<SaveWorkingHourEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .saveWorkingHour(event.userId, event.title, event.startDate,
          event.startTime, event.isBreak)
          .then((value) {
        emit(SaveWorkingHoursLoaded(result: value));
      });
    });

    on<GetTaskDetailData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getTaskDetailData(event.id).then((value) {
        emit(GetTaskDetailDataLoaded(todo: value?.todo ?? []));
      });
    });



    on<DeleteTaskConfigurationEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.deleteTaskConfiguration(event.id).then((value) {
        emit(DeleteTaskConfigurationLoaded(result: value));
      });
    });

    Stream<TodoViewState> mapEventToState(TodoViewEvent event) async* {
      if (event is SendChatMessage) {
        try {
          ApiClient apiClient = ApiClient();
          String apiUrl = "${Str.BASE_URL}send-message";
          String body = jsonEncode({
            "createdAt": event.createdAt,
            "message": event.message,
            "receiver": event.receiver,
            "sender": event.sender
          });
          debugPrint('mapEventToState.apiUrl: $apiUrl');
          debugPrint('mapEventToState.body: $body');
          final http.Response? response =
          await apiClient.callPostMethod(apiUrl, body: body);
          if (response != null &&
              (response.statusCode == 200 || response.statusCode == 201)) {
            final List<dynamic> data = json.decode(response.body);
            debugPrint('mapEventToState.data: $data');
            emit(const ChatSendLoaded(result: true));
          } else {
            emit(const ChatSendLoaded(result: false));
          }
        } catch (error) {
          emit(const ChatSendLoaded(result: false));
        }
      }
    }

    on<SendChatMessage>((event, emit) async {
      try {
        ApiClient apiClient = ApiClient();
        String apiUrl = "${Str.BASE_URL}send-message";
        String body = jsonEncode({
          "createdAt": event.createdAt,
          "message": event.message,
          "receiver": event.receiver,
          "sender": event.sender
        });
        debugPrint('mapEventToState.apiUrl: $apiUrl');
        debugPrint('mapEventToState.body: $body');
        final http.Response? response =
        await apiClient.callPostMethod(apiUrl, body: body);
        if (response != null &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          // final List<dynamic> data = json.decode(response.body);
          // debugPrint('mapEventToState.data: $data');
          emit(const ChatSendLoaded(result: true));
        } else {
          emit(const ChatSendLoaded(result: false));
        }
      } catch (error) {
        debugPrint('mapEventToState.error: $error');
        emit(const ChatSendLoaded(result: false));
      }
    });

    on<GetCheckList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getCheckList().then((value) {
        emit(CheckListLoaded(data: value?.data ?? []));
      });
    });

    on<GetMaintenanceCheckList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getMaintenanceCheckList().then((value) {
        emit(MaintenanceCheckListLoaded(
          data: value?.data ?? [],
        ));
      });
    });

    on<GetBranchList>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getBranchList().then((value) {
        emit(BranchListLoaded(
          data: value?.data ?? [],
        ));
      });
    });

    on<GetExpenseData>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.getExpense(event.minDate, event.maxDate).then((value) {
        if (value != null) {
          emit(ExpenseListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<AddExpenseData>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo
          .createExpenseData(
          event.id,
          event.vehicleId,
          event.expenseAmount,
          event.paymentMethodId,
          event.expenseDescription,
          event.categoryId,
          event.subcategoryId,
          event.expenseTo,
          event.expenseDate,
          event.odometer)
          .then((value) {
        if (value != null) {
          emit(ExpenseLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<DeleteExpense>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.deleteExpense(event.id).then((value) {
        if (value != null) {
          emit(ExpenseLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });
//---------------------------------------------------

    on<GetExpenseOtherData>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo
          .getExpenseOtherData(event.minDate, event.maxDate)
          .then((value) {
        if (value != null) {
          emit(ExpenseOtherLoaded(
              data: value.data ?? [],
              totalExpensesAmount: value.totalExpensesAmount ?? []));
        }
      });
    });

    on<GetExpenseCategoriesData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getExpenseCategories().then((value) {
        if (value != null) {
          emit(ExpenseCategoryLoaded(
              data: value.data ?? []));
        }
      });
    });

    on<GetExpensePaymentsData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getExpensePayments().then((value) {
        if (value != null) {
          emit(ExpensePaymentLoaded(data: value.data ?? []));
        }
      });
    });

    on<AddOtherData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .createOtherData(
          event.id,
          event.approved,
          event.expenseDate,
          event.expenseAmount,
          event.categoryId,
          event.subcategoryId,
          event.expenseDescription, event.paymentId, event.expenseTo)
          .then((value) {
        if (value != null) {
          emit(ExpenseLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<GetExpensePersonData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getExpensePersonData(
        event.minDate,
        event.maxDate,
      )
          .then((value) {
        if (value != null) {
          emit(ExpensePersonLoaded(
              data: value.data ?? [],
              totalExpensesAmount: value.totalExpensesAmount ?? []));
        }
      });
    });

    on<GetCohortsData>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.getCohorts().then((value) {
        if (value != null) {
          emit(CohortsListLoaded(
            cohortData: value.cohortData ?? [],
            expenseData: value.expenseData ?? [],
          ));
        }
      });
    });

    on<GetPaymentData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getPayment().then((value) {
        if (value != null) {
          emit(PaymentListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetVoiceData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getVoiceTextList(event.from, event.to).then((value) {
        if (value != null) {
          emit(VoiceListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetActiveHoursData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getActiveHoursResponse(event.minDate??Utils.getStartOfMonth(), event.maxDate??Utils.getEndOfMonth())
          .then((value) {
        emit(GetActiveHoursLoaded(data: value!.data ?? []));
      });
    });

    on<AddConfigurationEvent>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .addTaskConfiguration(event.id,event.userId ,event.name, event.amount, event.task)
          .then((value) {
        emit(AddTaskConfigurationLoaded(result: value));
      });
    });

    //--
    on<GetEmployeeStatementData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getFinanceStatement().then((value) {
        if (value != null) {
          emit(FinanceStatementLoaded(
            statementData: value.statementData ?? [],
          ));
        }
      });
    });

    on<GetWorkingHoursData>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getWorkingHoursData(
        event.minDate, event.maxDate,
      ).then((value){
        if (value != null) {
          emit(WorkingHoursLoaded(data: value.data??[]));
        }
      });
    });

    on<GetWorkingHistoryCount>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getWorkingHistoryCount(event.startDate??Utils.getStartOfMonth(), event.endDate??Utils.getEndOfMonth())
          .then((value) {
        emit(GetWorkingHistoryLoaded(history: value!.history ?? []));
      });
    });

    on<GetCategoryConfigData>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.getCategoryConfig()
          .then((value) {
        if (value != null) {
          emit(CategoryConfigListLoaded(
            data: (value.data ?? [])..sort((a, b) => DateTime.tryParse(b['created_at'])?.compareTo(DateTime.tryParse(a['created_at']) ?? DateTime.now()) ?? 0),
          ));
        }
      });
    });

    on<AddCategoryConfigData>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.createCategoryConfig(
          id: event.id,
          name: event.name,
          userType: event.userType,
          parentId: event.parentId
      ).then((value) {
        if (value != null) {
          emit(CategoryConfigLoaded(
            message: event.id != null ? "Category Updated Successfully" : "Category Added Successfully",
          ));
        }
      });
    });

    on<DeleteCategoryConfig>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.deleteCategoryConfig(event.id)
          .then((value) {
        if (value) {
          emit(const CategoryConfigLoaded(
            message: "Category Deleted Successfully",
          ));
        }
      });
    });

    on<GetTaskData>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.getTask()
          .then((value) {
        if (value != null) {
          emit( TaskListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetTaskExpense>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.getTaskExpense()
          .then((value) {
        if (value != null) {
          emit(TaskExpenseLoaded(
            resource: value.data ?? [],
          ));
        }
      });
    });

    on<AddTaskData>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.createTask(
        id:event.id,
        categoryId: event.categoryId,
        subCategoryId:  event.subCategoryId,
        task: event.name,
        timeTaken:  event.timeTaken,
        userType:  event.userType,
      )
          .then((value) {
        if (value != null) {
          emit(TaskLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<DeleteTaskData>((event, emit) async {
      emit(TodoListLoading());

      await todoListRepo.deleteTask(event.id)
          .then((value) {
        if (value != null) {
          emit(TaskLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<GetTaskCategoryGroup>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getTaskCategoryGroup()
          .then((value) {
        if (value != null) {
          emit(TaskCategoryGroupLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<AddFixTask>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.createFixTask(event.createFixTaskData!
      ).then((value) {
        emit(CreateTodoLoaded(
            result: value,));
      });
    });

    on<AddSpareKeyTask>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.spareKeyTask(event.createSpareKeyTaskData!
      ).then((value) {
        emit(CreateTodoLoaded(
          result: value,));
      });
    });

    on<GetTaskMiles>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo.getTaskMiles()
          .then((value) {
        if (value != null) {
          emit(TaskMilesLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetPreviousOdometer>((event, emit) async {
      emit(TodoListLoading());
      await todoListRepo
          .getPreviousOdometer(event.todoDate, event.identifierId,event.vin,)
          .then((value) {
        emit(PreviousOdometerLoaded(
          data: value?.data,
          todoData: event.todoData
        ));
      });
    });

    //---
  }
}
