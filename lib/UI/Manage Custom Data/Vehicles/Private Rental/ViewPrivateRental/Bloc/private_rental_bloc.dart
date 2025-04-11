import 'dart:async';
import 'dart:developer';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivateRentalBloc extends Bloc<PrivateRentalEvent, PrivateRentalState>{
  Map<String, dynamic>? selectedModel;
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  final FBroadcast _broadcast = FBroadcast.instance();
  final APiRepository _apiRepository = APiRepository();
  int currentPage = 1, itemsPerPage = 10, totalItems = 0;
  final TextEditingController searchController = TextEditingController();

  PrivateRentalBloc() : super(PrivateRentalLoadingState()){
    _registerBroadcast();
    on<PrivateRentalInitialEvent>(_onInitialEvent);
    on<SearchPrivateRentalEvent>(_onSearchEvent);
    on<DeletePrivateRentalEvent>(_onDeleteEvent);
    on<AddPrivateRentalEvent>(_onAddEvent);
    on<EditPrivateRentalEvent>(_onEditEvent);
    on<PrivateRentalClearEditEvent>(_onClearEditEvent);
  }

  int get totalPages => (totalItems / itemsPerPage).ceil();

  bool get isEditing => (selectedModel?['rental'] != null);

  ///PRIVATE RENTAL VEHICLE API CALL
  Future<List<Map<String, dynamic>>> _getPrivateRentalVehicle() async => await getIt<CommonService>().getPrivateRentalVehicleList(reset: true);

  Future<List<Map<String, dynamic>>> _getPrivateRentalCustomers() async => await getIt<CommonService>().getPrivateRentalCustomersList(reset: true);

  void _registerBroadcast() => _broadcast.register("PR_refresh", (value, callback) => add(PrivateRentalInitialEvent()));

  void _onInitialEvent(PrivateRentalInitialEvent event, Emitter<PrivateRentalState> emit) async {
    try{
      emit(PrivateRentalLoadingState());
      var response = await Future.wait([
        _getPrivateRentalVehicle(),
        _getPrivateRentalCustomers(),
      ]);
      apiResponse = response[0];
      totalItems = apiResponse.length;
      filteredResponse = paginateList(data: apiResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
      emit(PrivateRentalCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(PrivateRentalCommonState());
      log(e.toString(), name: "PrivateRentalBloc");
    }
  }

  void _onSearchEvent(SearchPrivateRentalEvent event, Emitter<PrivateRentalState> emit) {
    var searchQuery = event.query;
    List<Map<String, dynamic>> result = [];
    if (searchQuery.isNotNullOrEmpty) {
      var response = apiResponse.where((element) =>
          element['vehicle_name'].toString().toLowerCase().contains(
              searchQuery.toString().toLowerCase())).toList();
      result = response;
    } else {
      result = apiResponse;
    }
    currentPage = 1;
    totalItems = result.length;
    filteredResponse = paginateList(data: result, currentPage: currentPage, itemsPerPage: itemsPerPage);
    emit(PrivateRentalCommonState());
  }

  void _onDeleteEvent(DeletePrivateRentalEvent event, Emitter<PrivateRentalState> emit) async {
    emit(PrivateRentalLoadingState());
    var response = await _apiRepository.deleteActiveVehicle(event.vehicleId);
    if (response != null) {
      apiResponse.removeWhere((element) => element['id'] == event.vehicleId);
      totalItems = apiResponse.length;
      filteredResponse = paginateList(data: apiResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
    }
    emit(PrivateRentalCommonState());
  }

  void _onAddEvent(AddPrivateRentalEvent event, Emitter<PrivateRentalState> emit) async {
    selectedModel = event.vehicleData;
    _broadcast.broadcast('selected_pr_model', value: selectedModel);
    emit(PrivateRentalCommonState());
  }

  void _onClearEditEvent(PrivateRentalClearEditEvent event, Emitter<PrivateRentalState> emit) {
    selectedModel = null;
    emit(PrivateRentalCommonState());
  }

  void _onEditEvent(EditPrivateRentalEvent event, Emitter<PrivateRentalState> emit) {
    selectedModel = event.rentalData;
    emit(PrivateRentalCommonState());
  }
}
