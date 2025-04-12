
import 'dart:developer' as d;
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
part '../../../Event/vendor_data_event.dart';
part 'vendor_data_state.dart';

class VendorDataBloc extends Bloc<VendorDataEvent, VendorDataState> {
  VendorDataRepo vendorDataRepo = VendorDataRepo();
  TodoListRepo todoListRepo = TodoListRepo();

  final FBroadcast _broadcast = FBroadcast.instance();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController vendorTypeController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController vendorSearchController = TextEditingController();

  final TextEditingController vendorTypeNameController = TextEditingController();
  final TextEditingController vendorTypeSearchController = TextEditingController();
  bool isVendorTypeEdit = false;
  List<Map<String, dynamic>> vendorTypes = [];
  List<Map<String, dynamic>> filterPage1 = [];
  List<Map<String, dynamic>> filterVendorType = [];
  int vendorTypeItemsPerPage = 10;
  int vendorTypeCurrentIndex = 1;
  int vendorTypeTotalCount = 0;
  int? vendorTypeEditId;

  double? latitude;
  double? longitude;
  bool isEditMode = false;
  int? vendorId;
  int? vendorTypeId;
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;
  List<Map<String, dynamic>> filteredVendors = [];
  List<Map<String, dynamic>> vendorsData = [];
  List<Map<String, dynamic>> vendorTypeData = [];
  List<Map<String, dynamic>> filteredVendorType = [];
  List<Map<String, dynamic>> filterPage = [];
  List<dynamic> vendorImage = [];
  List<dynamic>? attachments = [];
  List<dynamic>? ogAttachments = [];

  VendorDataBloc() : super(VendorDataInitial()) {
    void _registerBroadcast() => _broadcast.register("vehicle_refresh", (value, callback) => add(GetVendorList()));
    on<VendorDataEvent>((event, emit) {
      _registerBroadcast();
    });

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

    List<T> paginateList1<T>({
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


    //Initial Bloc
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

      filterPage = paginateList(data: filteredVendors, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      totalCount = filteredVendors.length;

      attachments = vendorsData.map((e) => e['images'].map((e) => e['path'].toString().toStorageURL).toList()).expand((element) => element).toList();
      ogAttachments = attachments;
      emit(VendorDataCommonState());
    });





    //Filter vendor Search Event 2
    on<FilterVendorsEvent>((event, emit) {
      final allVendors = vendorsData;
      final filtered = allVendors.where((vendor) {
        final name = vendor['name']?.toLowerCase() ?? '';
        return name.contains(event.searchTerm.toLowerCase());
      }).toList();
      filterPage = filtered;
      totalCount = filtered.length;
      currentIndex = 1;
      filterPage = paginateList(data: filterPage, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(VendorDataCommonState());
    });

    //Vendors Pagination
    on<VendorPaginationEvent>((event, emit) {
      emit(const VendorDataLoading());
      currentIndex = event.page;
      filterPage = paginateList(data: filteredVendors, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(VendorDataCommonState());
    });

    on<FilterVendorTypeEvent>((event, emit) {
      final allVendors = vendorTypeData;
      final filtered = allVendors.where((vendor) {
        final name = vendor['name']?.toLowerCase() ?? '';
        return name.contains(event.searchTerm.toLowerCase());
      }).toList();
      filteredVendorType = filtered;
      emit(VendorDataCommonState());
    });

    //Vendor Types Initial Bloc
    on<GetVendorTypeList>((event, emit) async {
      emit(const VendorDataLoading());
      final vendorType =  await vendorDataRepo.getVendorType();
      vendorTypes = vendorType?.data ?? [];
      vendorTypes.sort((a,b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
      filterPage1 = paginateList1(data: vendorTypes, currentPage: vendorTypeCurrentIndex, itemsPerPage: vendorTypeItemsPerPage);
      vendorTypeTotalCount = vendorTypes.length;
      emit(VendorDataCommonState());
    });

    //vendor type Search Event
    on<FilterVendorEvent>((event, emit) {
      final allVendors = vendorTypes;
      final filtered = allVendors.where((vendor) {
        final name = vendor['name']?.toLowerCase() ?? '';
        return name.contains(event.searchTerm.toLowerCase());
      }).toList();
      filterPage1 = filtered;
      vendorTypeTotalCount = filtered.length;
      vendorTypeCurrentIndex = 1;
      filterPage1 = paginateList1(data: filterPage1, currentPage: vendorTypeCurrentIndex, itemsPerPage: vendorTypeItemsPerPage);
      emit(VendorDataCommonState());
    });

    on<VendorTypePaginationEvent>((event, emit) {
      emit(const VendorDataLoading());
      vendorTypeCurrentIndex = event.page;
      filterPage1 = paginateList1(data: vendorTypes, currentPage: vendorTypeCurrentIndex, itemsPerPage: vendorTypeItemsPerPage);
      emit(VendorDataCommonState());
    });

    on<AddVendorData>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo.getAndCreateVendor(
         id : event.id ?? null,
         name : event.name ??'',
         vendorTypeId : event.vendorTypeId ??'',
         address : event.address ??'',
         phone : event.phone ??'',
         expertise : event.expertise ??'',
         description : event.description ??'',
         images : event.images ?? [],
        website: event.website ?? '',
        latitude: event.latitude ?? '',
        longitude: event.longitude ?? '',).then((value) {
        isEditMode = false;
        nameController.clear();
        addressController.clear();
        phoneController.clear();
        expertiseController.clear();
        descriptionController.clear();
        websiteController.clear();
        vendorId = null;
        vendorTypeId = null;
        vendorImage.clear();
        searchController.clear();
        emit(VendorDataCommonState());
      });
      add(const GetVendorList());
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
      vendorTypeId = event.vendor['vendor_type']?['id'] ?? 0;
      vendorImage = event.vendor['images'].map((e) => e['path'].toString().toStorageURL).toList();
      latitude = double.tryParse(event.vendor['latitude'] ?? '');
      longitude = double.tryParse(event.vendor['longitude'] ?? '');
      searchController.text = event.vendor['vendor_type']?['name'] ?? '';
      emit(VendorDataCommonState());
    });

    on<EnterVendorTypeEditEvent>((event, emit) {
      isVendorTypeEdit = true;
      vendorTypeNameController.text = event.vendor['name'] ?? '';
      vendorTypeEditId = event.vendor['id'];
      emit(VendorDataCommonState());
    });

    on<ExitVendorTypeEditEvent>((event, emit) {
      isVendorTypeEdit = false;
      vendorTypeNameController.clear();
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
      vendorImage.clear();
      searchController.clear();
      emit(VendorDataCommonState());
    });

    on<DeleteVendorEvent>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo.deleteVendor(event.id);
      add(const GetVendorList());
      emit(VendorDataCommonState());
    });

    on<AddVendorType>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo.createVendorType(event.id, event.name??'',).then((value) {
        isVendorTypeEdit = false;
        vendorTypeNameController.clear();
        emit(VendorDataCommonState());
      });
      add(const GetVendorTypeList());
    });

    on<DeleteVendorType>((event, emit) async {
      emit(const VendorDataLoading());
      await vendorDataRepo.deleteVendorType(event.id);
      add(const GetVendorTypeList());
      emit(VendorDataCommonState());
    });

    on<DeleteImage>((event, emit) async {
      // emit(const VendorDataLoading());
      print("${event.id} delete_image_event");
      String imageUrl = "${event.id}";

      String path = imageUrl.replaceFirst("https://phase1.fairreturns.in/storage/", "");

      List allImages = vendorsData
          .map((e) => e['images'])
          .expand((images) => images)
          .toList();

      final matchedImage = allImages.firstWhere(
      (img) => img['path'] == path,
      orElse: () => null,
      );

      if (matchedImage != null) {
      int imageId = matchedImage['id'];
      await vendorDataRepo.deleteImages(imageId);
      emit(VendorDataCommonState());
      print("Image ID: $imageId");
      } else {
      print("Image not found");
      }

    });

    // on<RemoveVendorImageEvent>((event, emit) {
    //   final updatedList = List<String>.from(state.vendorImage)..removeAt(event.index);
    // });

    on<RemoveVendorImageEvent>((event, emit) {
      if (event.index >= 0 && event.index < vendorImage.length) {
        vendorImage = List<String>.from(vendorImage)..removeAt(event.index);
        emit(VendorDataCommonState());
      }
    });





    Future<List<File>> _pickFiles() async {
      var result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          allowCompression: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov',]);
      return result?.paths
          .where((element) => (element?.isNotEmpty ?? false))
          .map((e) => File(e!))
          .toList() ??
          [];
    }


    Future<void> _handleFileSelection(
        List<dynamic> fileList, String logName, Emitter emit) async {
      var result = await _pickFiles();
      if (result.isNotEmpty) {
        var existingAttachments =
        fileList.whereType<File>().map((e) => e.path).toList();

        List<File> newFiles = [];
        for (var element in result) {
          if (!existingAttachments.contains(element.path)) {
            newFiles.add(element);
          }
        }
        fileList.clear();
        fileList.addAll(existingAttachments.map((path) => File(path))); // Retain existing
        fileList.addAll(newFiles);

        d.log("$fileList", name: logName);
        emit(VendorDataCommonState());
      }
    }

    on<VendorImageEvent>((event, emit) async {
      await _handleFileSelection(vendorImage, "vendorImageFile", emit);
    });

    // Future<dynamic> _handleFileRemoval(
    //     {required List<dynamic> fileList,
    //       required List<dynamic> fullImageList,
    //       required dynamic data}) async {
    //   if (data == null) return;
    //   if (data is File) {
    //     fileList.remove(data);
    //     return data;
    //   } else if(data is String){
    //     var path = fileList.firstWhereOrNull((element) => element == data.toString());
    //     var imageId = fullImageList.firstWhereOrNull((element) => element['path'] == path.toString().removeStorageUrl)?['id'];
    //     var response =  await vendorDataRepo.deleteImages(imageId);
    //     // if(response?['success'] != null){
    //     //   Toaster.showSuccess(response?['success'] ?? []);
    //     //   fileList.remove(data);
    //     //   _broadcast.stickyBroadcast("vehicle_refresh", value: true);
    //     //   return data;
    //     // }
    //   }
    // }
    //
    // on<RemoveVendorImageEvent>((event, emit) async {
    //   _handleFileRemoval(fileList: [], fullImageList: [], data: null);
    // });

    on<ResetLocationEvent>((event, emit) {
      latitude = null;
      longitude = null;
      emit(VendorDataCommonState());
    });

  }
}
