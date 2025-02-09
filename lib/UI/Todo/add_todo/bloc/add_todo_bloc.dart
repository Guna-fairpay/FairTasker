import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/location_response.dart';
import 'package:fairpytasker/Response/parts_response.dart';
import 'package:fairpytasker/Response/supplies_response.dart';
import 'package:fairpytasker/Response/task_response.dart';
import 'package:fairpytasker/Response/vehicle_list_response.dart';
import 'package:fairpytasker/Response/vendor_response.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddToDoBloc extends Bloc<AddToDoEvent, AddToDoState> {
  final TodoListRepo todoListRepo = TodoListRepo();
  AddToDoBloc()
      : super(AddToDoState(
            showAppBar: true,
            isLoading: false,
            tasks: const [],
            vLocations: const [],
            vPersons: const [],
            partServices: const [],
            supplies: const [],
            resources: const [],
            clearDurations: const [],
            linkOptions: const [],
            isSelectedPlatformCheck: false,
            showPlatformCheck: false,
            isMoreEnable: false,
            isPartServiceEnable: false,
            isSuppliesEnable: false,
            showCleanCar: false,
            selectedDate: DateTime.now(),
            selectedTime: TimeOfDay.now())) {

    on<AddToDoInitialEvent>((event, emit) {
      emit(state.copyWith(showAppBar: event.showAppBar, isLoading: true));
      // PROCEED API CALL
    });
  }

  // API CALL: TASKS
  Future<TaskExpenseResponse?> _getTasks() async => await todoListRepo.getTaskExpense();

  // API CALL: VENDORS
  Future<VendorResponse?> _getVendors() async => await todoListRepo.getVendor();
  
  // API CALL: LOCATIONS
  Future<LocationResponse?> _getLocations() async => await todoListRepo.getLocation();
  
  // API CALL: ACTIVE-VEHICLES
  Future<VehicleListResponse?> _getVehicles() async => await todoListRepo.fetchVehicleList();

  // API CALL: GET-RESOURCES
  Future<AssignedToResponse?> _getResources() async => await todoListRepo.getAssignedTo();

  // API CALL: GET-PARTS
  Future<PartsResponse?> _getParts() async => await todoListRepo.getParts();

  // API CALL: GET-PARTS
  Future<SuppliesResponse?> _getSupplies() async => await todoListRepo.getSupplies();
}
