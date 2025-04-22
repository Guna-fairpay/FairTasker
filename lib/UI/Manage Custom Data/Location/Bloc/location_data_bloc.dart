
import 'dart:developer' as d;
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import '../../../../Repository/api_repository.dart';
part '../Event/location_data_event.dart';
part '../State/location_data_state.dart';

class LocationDataBloc extends Bloc<LocationDataEvent, LocationDataState> {
  final APiRepository apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  final FBroadcast _broadcast = FBroadcast.instance();
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

  Future<List<Map<String, dynamic>>> _fetchLocations() async => await getIt<CommonService>().getLocationsList(reset: true);
  LocationDataBloc() : super(LocationDataInitial())
  {
    on<LocationDataEvent>((event, emit) {});

    on<GetAddedLocationListData>((event, emit) async {//c
      emit(const LocationDataLoading());
      final locationData = await _fetchLocations();
      location = locationData ?? [];
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
      filterPage = paginateList(data: location, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(LocationDataCommonState());
    });

    on<AddLocationData>((event, emit) async {
      emit(const LocationDataLoading());
      d.log("Event data: id=${event.id}, name=${event.name}, address=${event.address}");
      final formattedAddresses = event.address?.map((addr) {
        d.log("Processing addr: $addr");
        if (event.id != null && addr is Map && addr.containsKey('id')) {
          return addr;
        } else if (addr is Map &&
            addr.containsKey('address') &&
            !addr.containsKey('id')) {
          return addr;
        }
        return addr['address'];
      }).toList() ??
          [];
      d.log("formattedAddresses: $formattedAddresses");

      final locationId = event.id ??
          (isEditMode && tempLocation.isNotEmpty
              ? tempLocation[0]['id']
              : null);
      d.log("Using locationId: $locationId");
      final success = await apiRepository.createLocation(
        id: locationId,
        name: event.name,
        address: formattedAddresses,
      );
      _broadcast.broadcast(Str.addToDoRefresh);
      _broadcast.broadcast(Str.editToDoRefresh);
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
        d.log("Update failed, address sent: $formattedAddresses, success: $success");
      }
    });


    on<DeleteLocation>((event, emit) async {
      emit(const LocationDataLoading());
      final response = await apiRepository.delete(event.id);
      if (response == true) {
        add(const GetAddedLocationListData());
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        emit(LocationDataCommonState());
      } else {
        emit(LocationDataCommonState());
      }
    });

    on<FilterLocationEvent>((event, emit) {
      final allLocation = location;
      final filtered = allLocation.where((location) {
        final name = location['name'].toString().toLowerCase();
        final searchTerm = event.searchTerm.toLowerCase();
        return name.contains(searchTerm);
      });
      filterPage = filtered.toList();
      currentIndex = 1;
      totalCount = filtered.length;

      filterPage = paginateList(data: filterPage, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(LocationDataCommonState());
    });

    on<AddAddressEvent>((event, emit) {
      if (event.address.trim().isNotEmpty) {
        addressesList.add({
          'address': event.address,
          'location_id': -1,
        });
        addressController.clear();
        emit(LocationDataCommonState());
      }
    });

    on<DeleteLocationEvent>((event, emit) async {//c
      emit(const LocationDataLoading());
      final success = await apiRepository.deleteLocation(event.id);
      d.log("${success} delete location");
      if (success == true) {
        if (isEditMode) {
          addressesList.removeWhere((addr) => addr['id'] == event.id);
          final locationData = await _fetchLocations();
          location = locationData ?? [];
          location.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
          filterPage = paginateList(data: location, currentPage: currentIndex, itemsPerPage: itemsPerPage);
          totalCount = location.length;
          add(const GetAddedLocationListData());
          emit(LocationDataCommonState());
        } else {
          add(const GetAddedLocationListData());
          emit(LocationDataCommonState());
        }
      } else {
        emit(LocationDataCommonState());
        d.log('Failed to delete item');
      }
    });

    on<RemoveAddressEvent>((event, emit) {
      if (event.index >= 0 && event.index < addressesList.length) {
        if (isEditMode && addressesList[event.index].containsKey('id')) {
          add(DeleteLocationEvent(id: addressesList[event.index]['id']));
        } else {
          addressesList.removeAt(event.index);
          emit(LocationDataCommonState());
        }
      }
    });

    on<EnterEditModeEvent>((event, emit) {
      d.log("${event.location} location_data");
      isEditMode = true;
      locationId = event.location['id'];
      tempLocation = [event.location];
      d.log("${locationId} location_id");
      locationController.text = event.location['name'];
      // Use the latest location data from the location list
      final updatedLocation = location.firstWhere(
            (loc) => loc['id'] == event.location['id'],
        orElse: () => event.location,
      );

      addressesList = (updatedLocation['addresses'] as List<dynamic>)
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
      tempLocation.clear();
      emit(LocationDataCommonState());
    });

    on<UpdateAddressEvent>((event, emit) {
      if (selectedAddressIndex != null &&
          selectedAddressIndex! < addressesList.length) {
        addressesList[selectedAddressIndex!] = {
          'address': event.updatedAddress,
          'id': addressesList[selectedAddressIndex!]['id'],
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
