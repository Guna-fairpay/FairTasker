
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/location_repository.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:flutter/cupertino.dart';

part '../Event/location_data_event.dart';
part '../State/location_data_state.dart';

class LocationDataBloc extends Bloc<LocationDataEvent, LocationDataState> {
  LocationDataRepo locationDataRepo = LocationDataRepo();
  TodoListRepo todoListRepo = TodoListRepo();
  final TextEditingController searchController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<Map<String, dynamic>> addressesList = [];
  List<Map<String, dynamic>> location = [];
  List<Map<String, dynamic>> filteredLocation = [];
  List<Map<String, dynamic>> filterPage = [];
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;
  bool isEditMode = false;
  int? selectedAddressIndex;
  int? locationId;

  int get totalPages => (totalCount / itemsPerPage).ceil();

  List<T> paginateList<T>({
    required List<T> data,
    required int currentPage,
    required int itemsPerPage,
  }) {
    final pageIndex = currentPage - 1;
    final start = pageIndex * itemsPerPage;
    final end = start + itemsPerPage;

    if (start >= data.length) return [];

    return data.sublist(start, end > data.length ? data.length : end);
  }

  LocationDataBloc() : super(LocationDataInitial()) {
    on<LocationDataEvent>((event, emit) {
    });


    on<GetAddedLocationListData>((event, emit) async {
      emit(const LocationDataLoading());
      final locationData = await todoListRepo.getLocation();
      location = locationData?.data ?? [];
      location.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));

      filterPage = paginateList(data: location, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      totalCount = location.length;
      emit(LocationDataCommonState());
    });

    on<LocationPaginationEvent>((event, emit) async {
      emit(const LocationDataLoading());
      currentIndex = event.page;
      filterPage = paginateList(data: location, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(LocationDataCommonState());
    });


    on<AddLocationData>((event, emit) async {
      emit(const LocationDataLoading());
      final success = await locationDataRepo.createLocation(
        id: locationId,
        name: event.name,
        address: event.address,
      ).then((value){
        isEditMode = false;
        selectedAddressIndex = null;
        locationController.clear();
        addressController.clear();
        addressesList.clear();
      });

      if (success == true) {
        emit(LocationDataLoaded(
          message: event.id == null
              ? 'Location added successfully'
              : 'Location updated successfully',
        ));
        add(const GetAddedLocationListData()); // Refresh list
        if (locationId == null) {
          isEditMode = false;
          selectedAddressIndex = null;
          locationController.clear();
          addressController.clear();
          addressesList.clear();
        }
      } else {
        print("Error in saving or updating location");
      }
    });

    on<DeleteLocationEvent>((event, emit) async {
      emit(const LocationDataLoading());
      await locationDataRepo.deleteLocation(event.id).then((value) {
        emit(LocationDataLoaded(message: 'Location Added Successfully'));
      });
    });

    on<DeleteLocation>((event, emit) async {
      emit(const LocationDataLoading());
      await locationDataRepo.delete(event.id).then((value) {
        emit(LocationDataLoaded(message: 'test1 deleted successfully'));
      });
    });

    on<EnterEditModeEvent>((event, emit) {
      print("${event.location} location_data");
      isEditMode = true;
      locationId = event.location['id'];
      print("${locationId} location_id");
      locationController.text = event.location['name'];
      addressesList = (event.location['addresses'] as List<dynamic>)
          .map((addr) => {
        'address': addr['address'],
        'id': addr['id'],
      }).toList();
      selectedAddressIndex = null;
      addressController.clear();
      emit(LocationDataCommonState());
    });

    on<ExitEditModeEvent>((event, emit) {
      isEditMode = false;
      selectedAddressIndex = null;
      locationController.clear();
      addressController.clear();
      addressesList.clear();
      emit(LocationDataCommonState());
    });

    on<FilterLocationEvent>((event, emit) {
      final allLocation = location;
      final filtered = allLocation.where((location) {
        final name = location['name'].toString().toLowerCase();
        final searchTerm = event.searchTerm.toLowerCase();
        return name.contains(searchTerm);
      });
      filterPage = filtered.toList();
      emit(LocationDataCommonState());
    });

    on<AddAddressEvent>((event, emit) {
      if (event.address.trim().isNotEmpty) {
        addressesList.add({
          'address': event.address,
          if (locationId != null) 'location_id': locationId, // Add location_id for new addresses
        });
        addressController.clear();
        emit(LocationDataCommonState());
      }
    });

    on<RemoveAddressEvent>((event, emit) {
      if (event.index >= 0 && event.index < addressesList.length) {
        addressesList.removeAt(event.index);
        emit(LocationDataCommonState());
      }
    });

    on<UpdateAddressEvent>((event, emit) {
      if (selectedAddressIndex != null && selectedAddressIndex! < addressesList.length) {
        addressesList[selectedAddressIndex!] = {
          'address': event.updatedAddress,
          'id': addressesList[selectedAddressIndex!]['id'], // Preserve id for update
        };
        selectedAddressIndex = null;
        addressController.clear();
        emit(LocationDataCommonState());
      }
    });

    on<SelectAddressForEditEvent>((event, emit) {
      selectedAddressIndex = event.index;
      addressController.text = addressesList[event.index]['address'];
      emit(LocationDataCommonState());
    });


  }
}

