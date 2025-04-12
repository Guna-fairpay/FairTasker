import 'dart:developer' as d;
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
  List<Map<String, dynamic>> tempLocation = [];
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
    on<LocationDataEvent>((event, emit) {});

    on<GetAddedLocationListData>((event, emit) async {
      emit(const LocationDataLoading());
      final locationData = await todoListRepo.getLocation();
      location = locationData?.data ?? [];
      location.sort((a, b) => DateTime.parse(b['created_at'])
          .compareTo(DateTime.parse(a['created_at'])));

      filterPage = paginateList(
          data: location,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      totalCount = location.length;
      emit(LocationDataCommonState());
    });

    on<LocationPaginationEvent>((event, emit) async {
      emit(const LocationDataLoading());
      currentIndex = event.page;
      filterPage = paginateList(
          data: location,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      emit(LocationDataCommonState());
    });

    on<AddLocationData>((event, emit) async {
      emit(const LocationDataLoading());
      d.log(
          "Event data: id=${event.id}, name=${event.name}, address=${event.address}");
      // Format addresses: keep full map with id for updates, extract strings for new locations
      final formattedAddresses = event.address?.map((addr) {
            d.log("Processing addr: $addr");
            if (event.id != null && addr is Map && addr.containsKey('id')) {
              return addr; // Keep full map with id for updates
            } else if (addr is Map &&
                addr.containsKey('address') &&
                !addr.containsKey('id')) {
              return addr; // Extract address string for new locations
            }
            return addr['address']; // Fallback
          }).toList() ??
          [];
      d.log("formattedAddresses: $formattedAddresses");

      final locationId = event.id ??
          (isEditMode && tempLocation.isNotEmpty
              ? tempLocation[0]['id']
              : null);
      d.log("Using locationId: $locationId");
      final success = await locationDataRepo.createLocation(
        id: locationId,
        name: event.name,
        address: formattedAddresses,
      );

      if (success == true) {
        emit(LocationDataLoaded(
          message: locationId == null
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
        } else {
          isEditMode = false;
          selectedAddressIndex = null;
        }
      } else {
        d.log(
            "Update failed, address sent: $formattedAddresses, success: $success");
      }
    });

    // on<DeleteLocationEvent>((event, emit) async {
    //   emit(const LocationDataLoading());
    //   await locationDataRepo.deleteLocation(event.id).then((value) {
    //     emit(LocationDataLoaded(message: 'Location Added Successfully'));
    //   });
    // });

    on<DeleteLocation>((event, emit) async {
      emit(const LocationDataLoading());
      await locationDataRepo.delete(event.id).then((value) {
        emit(LocationDataLoaded(message: 'test1 deleted successfully'));
      });
      add(const GetAddedLocationListData());
    });

    on<EnterEditModeEvent>((event, emit) {
      print("${event.location} location_data");
      isEditMode = true;
      locationId = event.location['id'];
      tempLocation = [event.location];
      print("${locationId} location_id");
      locationController.text = event.location['name'];
      addressesList = (event.location['addresses'] as List<dynamic>)
          .map((addr) => {
                'address': addr['address'],
                'id': addr['id'],
              })
          .toList();
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
        //final locationid = isEditMode && tempLocation.isNotEmpty ? tempLocation[0]['id'] : null;
        addressesList.add({
          'address': event.address,
          'location_id': -1,
        });
        addressController.clear();
        emit(LocationDataCommonState());
      }
    });

    on<DeleteLocationEvent>((event, emit) async {
      final success = await locationDataRepo.deleteLocation(event.id);
      if (success == true) {
        // If this was an address delete, remove it from addressesList
        if (isEditMode) {
          addressesList.removeWhere((addr) => addr['id'] == event.id);
        } else {}
        emit(LocationDataLoaded(
            message: 'Item deleted successfully')); // Generic message
      } else {}
    });

    on<RemoveAddressEvent>((event, emit) {
      if (event.index >= 0 && event.index < addressesList.length) {
        if (isEditMode && addressesList[event.index].containsKey('id')) {
          // Trigger server delete for existing address using its id
          add(DeleteLocationEvent(id: addressesList[event.index]['id']));
        } else {
          // Remove locally for new (unsaved) addresses
          addressesList.removeAt(event.index);
          emit(LocationDataCommonState());
        }
      }
    });

    on<UpdateAddressEvent>((event, emit) {
      if (selectedAddressIndex != null &&
          selectedAddressIndex! < addressesList.length) {
        addressesList[selectedAddressIndex!] = {
          'address': event.updatedAddress,
          'id': addressesList[selectedAddressIndex!]['id'],
          // Preserve id for update
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
