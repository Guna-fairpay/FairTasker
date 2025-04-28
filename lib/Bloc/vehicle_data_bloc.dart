
import 'dart:developer' as d;
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Response/create_expense_field_data.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Response/subcategories_response.dart';
import 'package:fairpytasker/Repository/vehicle_repository.dart';
import 'package:fairpytasker/Response/create_vehicle_data.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';

import '../Utilities/Str.dart';
part '../Event/vehicle_data_event.dart';
part '../State/vehicle_data_state.dart';

class VehicleDataBloc extends Bloc<VehicleDataEvent, VehicleDataState> {
  VehicleDataRepo vehicleDataRepo = VehicleDataRepo();
  TodoListRepo todoListRepo = TodoListRepo();
  final FBroadcast _broadcast = FBroadcast.instance();
  dynamic selectedVehicle;

  VehicleDataBloc() : super(VehicleDataInitial()) {
    on<VehicleDataEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetExpenseToDatas>((event, emit) async {
      if(event.expenseId != null) {
        emit(const VehicleDataLoading());
        await todoListRepo.getAExpenseDetailTodo(event.expenseId!).then((value) {
          emit(ExpenseTodoDataLoaded(expensesData: value?.expenses??[]));
        });
      }
    });

    on<GetVehicleHistoryListData>((event, emit) async {
      emit(const VehicleDataLoading());

      await vehicleDataRepo.getVehicleHistoryList(event.pageNo, event.vin)
          .then((value) {
        if (value != null) {
          emit(VehicleHistoryListLoaded(
            todo: value.todo ?? [],
            data: value.data??[],
          ));
        }
      });
    });

    on<VehicleStatusCategory>((event, emit) async {
      emit(const VehicleDataLoading());
      await todoListRepo
          .fetchVehicleStatusCategoryList()
          .then((value) {
        emit(VehicleStatusCategoryLoaded(vehicleStatusDataList: value?.data??[]));
      });
    });

    on<GetDropdownVehicleData>((event, emit) async {
      emit(const VehicleDataLoading());
      await todoListRepo.fetchDropdownValues().then((value) {
        emit(DropdownVehicleDataLoaded(createExpenseFieldData: value));
      });
    });

    // on<DeleteVehicleEvent>((event, emit) async {
    //   emit(const VehicleDataLoading());
    //   await vehicleDataRepo.deleteVehicle(event.id!).then((value) {
    //     emit(VehicleDataLoadedV(result: VehicleData()));
    //   });
    // });

    on<AddVehicleDataEvent>((event, emit) async {
      if (event.createVehicleData != null) {
        emit(const VehicleDataLoading()); // Start loading state
        try {
          final response = await vehicleDataRepo.createVehicle(event.createVehicleData!);
          print("Bloc Triggered");
          emit(VehicleDataLoadedV(
            result: response?.data ?? [],
            vin: event.createVehicleData!.vin,
            categoryId: event.createVehicleData!.categoryId,
          ));
        } catch (error) {
          emit(const VehicleDataError( errorMessage: ''));
        }
      }
    });

//Set vehicle save Bloc
    on<UpdateVehicleDataEvent>((event, emit) async {
      if (event.createVehicleData != null) {
        emit(const VehicleDataLoading());
        try {
          final response = await vehicleDataRepo.createVehicle(event.createVehicleData!);
          d.log("${response}", name: "UPDATE_DATA");
          _broadcast.stickyBroadcast("todo_view", value: true);
          // add(event)
          emit(const setVehicleLoader());
        } catch (error) {
          emit(const VehicleDataError( errorMessage: ''));
        }
      }
    });

    on<setVehicleInitialEvent>((event, emit) async {
      Console.of.log(event.vehicle, name: "VEHICLE_DATA");
      d.log("${event.vehicle}" ,name: "event_vehicle");
      emit(const VehicleDataLoading());
      final response = await getIt<CommonService>().getActiveVehicles(reset: true);
      dynamic vehicle = event.vehicle != null ? {} : null;
      if (response.isNotEmpty && event.vehicle != null) {
        try {
          vehicle = response.firstWhere(
                (e) => e['vin']?.toString() == event.vehicle?['vin']?.toString(),
            orElse: () => {},
          );
        } catch (e) {
          d.log("Error finding vehicle: $e");
          vehicle = {};
        }
      }
      emit(setVehicleLoaded(currentVehicle: vehicle));
    });

    on<DeleteSetVehicleImage>((event, emit) async {
      emit(const VehicleDataLoading());
      Console.of.debug("VIN ${event.vin} // ID: ${event.id}", name: "DELETE_IMAGE_EVENT");
      d.log('${event.vin} ${event.id}', name: "delete_image");
      final response = await vehicleDataRepo.deleteVehicleImages(event.id);
      final response1 = await getIt<CommonService>().getActiveVehicles(reset: true);
      dynamic vehicle;
      if (event.vin != '' && event.vin != null) {
        try {
          vehicle = response1.firstWhere(
                (e) => e['vin']?.toString() == event.vin,
            orElse: () => {},
          );
        } catch (e) {
          d.log("Error finding vehicle: $e");
          vehicle = {};
        }
      }
      emit(setVehicleLoaded(currentVehicle: vehicle));
      d.log("${response}", name: "VEHICLE_Image");
    });

    on<MoveRentalData>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo
          .moveRental(
         rentalData: event.rentalData)
          .then((value) {
        emit(MoveRentalDataLoaded(result: value));
      });
    });

    on<DeleteVehicleImage>((event, emit) async {
        emit(const VehicleDataLoading());
        await vehicleDataRepo
            .deleteVehicleImages(event.id)
            .then((value) {
          emit(VehicleDataInitial());
        });
    });

    on<DeleteExpenseImage>((event, emit) async {
        emit(const VehicleDataLoading());
        await vehicleDataRepo
            .deleteExpenseImages(event.id)
            .then((value) {
          emit(VehicleDataInitial());
        });
    });

    on<DeleteExpense>((event, emit) async {
        emit(const VehicleDataLoading());
        await vehicleDataRepo
            .deleteExpense(event.id)
            .then((value) {
          emit(VehicleDataInitial());
        });
    });

     on<AddVehicleGroupingData>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.createVehicleGroup(event.name, event.selectedList, event.id).then((value) {
        emit(AddVehicleGroupDataLoaded(result: value));
      });
    });

    on<GetAddedVehicleListData>((event, emit) async {
      emit(const VehicleDataLoading());
      await todoListRepo.fetchVehicleList().then((value) {
        emit(VehicleListLoaded(vehicleDataList: value?.data??[]));
      });
    });

    on<GetVehicleGroupingListV>((event, emit) async {
      emit(const VehicleDataLoading());
      await todoListRepo.fetchVehicleGroupingList().then((value) {
        emit(VehicleGroupListLoadedV(vehicleGroupDataList: value?.vehicleGroupData??[]));
      });
    });

    on<GetVehicleGroupData>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.getVehicleGroupData().then((value) {
        emit(VehicleGroupDataLoaded(vehicleGroupDataList: value?.vehicleGroupData??[]));
      });
    });

    on<DeleteVehicleGroupEvent>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.deleteVehicleGroup(event.id).then((value) {
        emit(VehicleGroupLoaded(result: value));
      });
    });

    on<GetVehicleHistoryEvent>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.getVehicleHistory(event.vin, event.vehicleGroupId).then((value) {
        emit(VehicleHistoryLoaded(vehicleHistoryList: value?.todos??[], needUI: event.needUI));
      });
    });

    on<CompleteTodoItemVeh>((event, emit) async {
      emit(const VehicleDataLoading());
      await todoListRepo
          .completeATodo(event.todoId, event.status)
          .then((value) {
        emit(TodoItemCompletedVeh(result: value, todoId: event.todoId, status: event.status, vehicleGroupId: event.vehicleGroupId));
      });
    });

    on<GetPartsListV>((event, emit) async {
      emit(const VehicleDataLoading());
      await todoListRepo.getParts().then((value) {
        emit(PartsListLoaded(partsDataList: value?.data??[]));
      });
    });

    on<AddPartsData>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.createPartsData(event.name, event.desc??'', event.id).then((value) {
        emit(PartsDataLoaded(result: value));
      });
    });

    on<DeletePartEvent>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.deleteParts(event.id).then((value) {
        emit(PartsDataLoaded(result: value));
      });
    });

    on<GetCategory>((event, emit) async {
      emit(const VehicleDataLoading());
      await todoListRepo.getCategories().then((value) {
        emit(CategoryListLoaded(categoryList: value?.data??[]));
      });
    });

    on<GetSubCategory>((event, emit) async {
      emit(const VehicleDataLoading());
      await todoListRepo.getSubCategories().then((value) {
        emit(SubCategoryListLoaded(categoriesResponse: value));
      });
    });

    // on<GetDepartments>((event, emit) async {
    //   emit(const VehicleDataLoading());
    //   await todoListRepo.getDepartments().then((value) {
    //     emit(GetDepartmentsListLoaded(departmentList: value));
    //   });
    // });

    on<AddCategoryData>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.createCategoryData(event.name, event.id).then((value) {
        emit(CategoryDataLoaded(result: value));
      });
    });

    on<AddDepartmentData>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.createDepartmentData(event.name, event.head, event.id).then((value) {
        emit(DepartmentDataLoaded(result: value));
      });
    });

    on<AddSubCategoryData>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.createSubCategoryData(event.name, event.expenseTo, event.parentId, event.id).then((value) {
        emit(CategoryDataLoaded(result: value));
      });
    });

    on<DeleteCategory>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.deleteCategory(event.id).then((value) {
        emit(CategoryDataLoaded(result: value));
      });
    });

    on<GetSuppliesListV>((event, emit) async {
      emit(const VehicleDataLoading());
      await todoListRepo.getSupplies().then((value) {
        emit(SupplyListLoaded(supplyDataList: value?.data??[]));
      });
    });

    on<AddSupplyData>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.createSupplyData(event.name, event.desc??'', event.id).then((value) {
        emit(SupplyDataLoaded(result: value));
      });
    });

    on<DeleteSupplyEvent>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.deleteSupply(event.id).then((value) {
        emit(SupplyDataLoaded(result: value));
      });
    });

    on<SetDefaultVehicleConfig>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.setDefaultVehicleStatusConfig(event.vinNumber).then((value) {
        emit(DefaultVehicleConfigLoaded(result: value, vin: event.vinNumber));
      });
    });

    on<AddVehicleStatusData>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.createVehicleStatus(event.category_Id??'', event.label??'',event.task??'',event.status??'',event.id ).then((value) {
        emit(VehicleStatusDataLoaded(result: value));
      });
    });

    on<GetVehicleNotesHistoryList>((event, emit) async {
      emit(const VehicleDataLoading());
      await vehicleDataRepo.getVehicleNotesHistory(event.vin??'').then((value) {
        emit(VehicleNotesHistoryLoaded(data: value?.data??[]));
      });
    });


  }
}
