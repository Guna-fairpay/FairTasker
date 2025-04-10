
import 'dart:developer' as d;
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';
part '../../../Event/vendor_data_event.dart';
part 'vendor_data_state.dart';

class VendorDataBloc extends Bloc<VendorDataEvent, VendorDataState> {
  VendorDataRepo vendorDataRepo = VendorDataRepo();
  TodoListRepo todoListRepo = TodoListRepo();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController vendorTypeController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController vendorSearchController = TextEditingController();

  double? latitude;
  double? longitude;
  bool isEditMode = false;
  int? vendorId;
  int? vendorTypeId;
  List<Map<String, dynamic>> filteredVendors = [];
  List<Map<String, dynamic>> vendorsData = [];
  List<Map<String, dynamic>> vendorTypeData = [];
  List<Map<String, dynamic>> filteredVendorType = [];

  VendorDataBloc() : super(VendorDataInitial()) {
    on<VendorDataEvent>((event, emit) {
    });

    on<AddVendorData>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo.getAndCreateVendor(
         id : event.id,
         name : event.name ??'',
         vendorTypeId : event.vendorTypeId ??'',
         address : event.address ??'',
         phone : event.phone ??'',
         expertise : event.expertise ??'',
         description : event.description ??'',
         images : event.images,
      ).then((value) {
        nameController.clear();
        addressController.clear();
        phoneController.clear();
        expertiseController.clear();
        descriptionController.clear();
        websiteController.clear();
        emit(VendorDataLoaded(result: value.toString()));
      });
    });

    on<EnterEditModeEvent>((event, emit) {
      isEditMode = true;
      nameController.text = event.vendor['name'] ?? '';
      addressController.text = event.vendor['address'] ?? '';
      phoneController.text = event.vendor['phone'] ?? '';
      expertiseController.text = event.vendor['expertise'] ?? '';
      descriptionController.text = event.vendor['description'] ?? '';
      websiteController.text = event.vendor['website'] ?? '';
      vendorId = event.vendor['id'] ?? '';
      vendorTypeId = event.vendor['vendor_type']?['vendor_type_id'] ?? 0;
      emit(VendorDataCommonState());
    });

    on<ExitEditModeEvent>((event, emit) {
      isEditMode = false;
      nameController.clear();
      addressController.clear();
      phoneController.clear();
      expertiseController.clear();
      descriptionController.clear();
      websiteController.clear();
      vendorId = null;
      vendorTypeId = null;
      emit(VendorDataCommonState());
    });

    on<GetVendorList>((event, emit) async {
      emit(const VendorDataLoading());
      final vendor = await vendorDataRepo.getVendor();
      final vendorType = await vendorDataRepo.getVendorType();
      d.log("${vendorType?.data}", name: "vendor_type");
      vendorTypeData = vendorType?.data ?? [];
      filteredVendorType = vendorType?.data ?? [];
      vendorsData = vendor?.data ?? [];
      filteredVendors = vendor?.data ?? [];
      filteredVendors.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
      filteredVendorType.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
      emit(VendorListLoaded(resource: filteredVendors));
    });

    on<DeleteVendorEvent>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .deleteVendor(event.id)
          .then((value) {
        emit(VendorDataLoaded(result: value.toString()));
      });
    });

    on<GetVendorTypeList>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .getVendorType()
          .then((value) {
        emit(VendorTypeListLoaded(resource: value?.data??[]));
      });
    });

    on<AddVendorType>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo.createVendorType(
        event.id,
        event.name??'',
      ).then((value) {
        emit(VendorDataLoaded(result: value.toString()));
      });
    });

    on<DeleteVendorType>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .deleteVendorType(event.id)
          .then((value) {
        emit(VendorDataLoaded(result: value.toString()));
      });
    });

    on<DeleteImage>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo
          .deleteImages(event.id)
          .then((value) {
        emit(VendorDataLoaded(result: value.toString()));
      });
    });

    on<FilterVendorsEvent>((event, emit) {
      final allVendors = vendorsData;
      final filtered = allVendors.where((vendor) {
        final name = vendor['name']?.toLowerCase() ?? '';
        return name.contains(event.searchTerm.toLowerCase());
      }).toList();
      filteredVendors = filtered;
      emit(VendorListLoaded(resource: filtered));
    });

    on<FilterVendorTypeEvent>((event, emit) {
      final allVendors = vendorTypeData;
      final filtered = allVendors.where((vendor) {
        final name = vendor['name']?.toLowerCase() ?? '';
        return name.contains(event.searchTerm.toLowerCase());
      }).toList();
      filteredVendorType = filtered;
      emit(VendorTypeListLoaded(resource: filtered));
    });


  }
}
