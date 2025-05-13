
import 'dart:developer' as d;
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_repository.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import '../../../../Repository/api_repository.dart';
import '../../../../core/app/extension/liststring_extension.dart';
part '../Event/vendor_data_event.dart';
part '../State/vendor_data_state.dart';

class VendorDataBloc extends Bloc<VendorDataEvent, VendorDataState> {
  final APiRepository apiRepository = APiRepository();

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
  List<Map<String, dynamic>> vendorSearchData = [];
  List<Map<String, dynamic>> filteredVendorType = [];
  List<Map<String, dynamic>> filterPage = [];
  List<File> localImages = []; // For locally picked files
  List<String> remoteImages = []; // For server-stored image URLs
  List<dynamic> vendorImage = [];
  List<dynamic>? attachments = [];
  List<dynamic>? ogAttachments = [];

  Future<List<Map<String, dynamic>>> _fetchVendors() async => await getIt<CommonService>().getVendorsList(reset: true);
  Future<List<Map<String, dynamic>>> _fetchVendorType() async => await getIt<CommonService>().getVendorTypeList(reset: true);

  VendorDataBloc() : super(VendorDataInitial()) {
    on<VendorDataEvent>((event, emit) {
    });

    on<VendorInitialEvent>((event, emit) {
      if (event.title?.trim().isNotNullOrEmpty ?? false) {
        nameController.text = event.title ?? '';
      }
    });

    //vendor Initial Bloc
    on<GetVendorList>((event, emit) async {
      emit(const VendorDataLoading());
      final vendor = await _fetchVendors();
      final vendorType = await _fetchVendorType();
      d.log("${vendorType}", name: "vendor_type");

      vendorTypeData = vendorType ?? [];
      d.log("${vendorTypeData}", name: "vendor_type_data");
      filteredVendorType = vendorType ?? [];
      vendorSearchData = vendorType ?? [];
      vendorsData = vendor ?? [];
      filteredVendors = vendor ?? [];
      FBroadcast.instance().register("vendor type data", (value, callback){
        vendorSearchData = value;
        emit(VendorDataCommonState());
      });

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

    //Vendor Search 2 Event
    on<FilterVendorTypeEvent>((event, emit) {
      final allVendors = vendorTypeData;
      final filtered = allVendors.where((vendor) {
        final name = vendor['name']?.toLowerCase() ?? '';
        return name.contains(event.searchTerm.toLowerCase());
      }).toList();
      filteredVendorType = filtered;
      emit(VendorDataCommonState());
    });

    //vendor add and edit event
    on<AddVendorData>((event, emit) async {
      d.log("${event.id} ${event.name} ${event.vendorTypeId} ${event.address} ${event.phone} ${event.expertise} ${event.description} ${event.images} ${event.website} ${event.latitude} ${event.longitude}");
      emit(const VendorDataLoading());
      final response = await apiRepository.createVendor(
        id : event.id,
        name : event.name ??'',
        vendorTypeId : event.vendorTypeId.toString() ?? '',
        address : event.address ??'',
        phone : event.phone ??'',
        expertise : event.expertise ??'',
        description : event.description ??'',
        images : event.images ?? [],
        website: event.website ?? '',
        latitude: event.latitude?.isNotEmpty == true ? event.latitude : null,
        longitude: event.longitude?.isNotEmpty == true ? event.longitude : null,
      );
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
      latitude = null;
      longitude = null;
      _broadcast.broadcast(Str.addToDoRefresh);
      _broadcast.broadcast(Str.editToDoRefresh);
      _broadcast.broadcast(Str.refetchVendorLocation);
      emit(VendorDataCommonState());
      d.log("response added ${response}");
      add(const GetVendorList());
    });

    //delete vendor event
    on<DeleteVendorEvent>((event, emit) async {
      emit(const VendorDataLoading());
      final response = await apiRepository.deleteVendor(event.id);
      if (response == true) {
        add(const GetVendorList());
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        _broadcast.broadcast(Str.refetchVendorLocation);
        emit(VendorDataCommonState());
      } else {
        emit(VendorDataCommonState());
      }
    });

    //vendor edit event
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
      vendorImage = event.vendor['images'].map((e) => e['path'].toString().toStorageURL).toList() ?? [];
      d.log("Images loaded in edit mode: $vendorImage", name: "edit_mode");
      latitude = double.tryParse(event.vendor['latitude']?.toString() ?? '');
      longitude = double.tryParse(event.vendor['longitude']?.toString() ?? '');
      searchController.text = event.vendor['vendor_type']?['name'] ?? '';
      emit(VendorDataCommonState());
    });

    on<locationEvent>((event, emit) {
      latitude = double.tryParse(event.latitude?.toString() ?? '');
      longitude = double.tryParse(event.longitude?.toString() ?? '');
      emit(VendorDataCommonState());
    });

    //vendor edit event
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
      longitude = null;
      latitude = null;
      emit(VendorDataCommonState());
    });

    //Vendor Types Initial Bloc
    on<GetVendorTypeList>((event, emit) async {
      emit(const VendorDataLoading());
      final vendorType =  await _fetchVendorType();
      vendorTypes = vendorType ?? [];
      FBroadcast.instance().broadcast(
        "vendor type data",
        value: vendorTypes,
      );
      vendorTypes.sort((a,b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
      filterPage1 = paginateList(data: vendorTypes, currentPage: vendorTypeCurrentIndex, itemsPerPage: vendorTypeItemsPerPage);
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
      filterPage1 = paginateList(data: filterPage1, currentPage: vendorTypeCurrentIndex, itemsPerPage: vendorTypeItemsPerPage);
      emit(VendorDataCommonState());
    });

    //Vendor type pagination
    on<VendorTypePaginationEvent>((event, emit) {
      emit(const VendorDataLoading());
      vendorTypeCurrentIndex = event.page;
      filterPage1 = paginateList(data: vendorTypes, currentPage: vendorTypeCurrentIndex, itemsPerPage: vendorTypeItemsPerPage);
      emit(VendorDataCommonState());
    });

    //vendor type edit event
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

    //vendor type add and edit event
    on<AddVendorType>((event, emit) async {
      emit(const VendorDataLoading());
      await apiRepository.createVendorType(event.id, event.name??'',).then((value) {
        isVendorTypeEdit = false;
        vendorTypeNameController.clear();
        add(const GetVendorTypeList());
        emit(VendorDataCommonState());
      });
    });

    //vendor type delete event
    on<DeleteVendorType>((event, emit) async {
      emit(const VendorDataLoading());
      await apiRepository.deleteVendorType(event.id);
      add(const GetVendorTypeList());
      emit(VendorDataCommonState());
    });



    on<RemoveVendorImageEvent>((event, emit) async {
      try {
        if (event.index >= 0 && event.index < vendorImage.length) {
          final image = vendorImage[event.index];
          if (image is String) {
            final path = image.replaceFirst("https://phase1.fairreturns.in/storage/", "");
            final matchedImage = vendorsData
                .map((e) => e['images'])
                .expand((images) => images)
                .firstWhere(
                  (img) => img['path'] == path,
              orElse: () => null,
            );
            if (matchedImage != null) {
              await apiRepository.deleteImages(matchedImage['id']);
            }
          }
          vendorImage.removeAt(event.index);
          d.log("Image removed: $image", name: "image_removal");
          emit(VendorDataCommonState());
          add(const GetVendorList());
        }
      } catch (e) {
        d.log("Failed to remove image: $e");
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


    Future<void> _handleFileSelection(Emitter emit) async {
      final result = await _pickFiles();
      if (result.isNotEmpty) {
        final existingFiles = vendorImage.whereType<File>().map((e) => e.path).toList();
        final newFiles = result.where((file) => !existingFiles.contains(file.path)).toList();
        vendorImage.addAll(newFiles);
        d.log("Images selected: $vendorImage", name: "vendorImageFile");
        emit(VendorDataCommonState());
      }
    }

    on<VendorImageEvent>((event, emit) async {
      await _handleFileSelection(emit);
    });

    on<DeleteImage>((event, emit) async {
      try {
        emit(const VendorDataLoading());
        final imageId = event.id;
        await apiRepository.deleteImages(imageId);
        // Remove the image from remoteImages by matching ID
        remoteImages.removeWhere((url) {
          final path = url.replaceFirst("https://phase1.fairreturns.in/storage/", "");
          return vendorsData
              .map((e) => e['images'])
              .expand((images) => images)
              .any((img) => img['path'] == path && img['id'] == imageId);
        });
        d.log("image deleted");
        add(const GetVendorList()); // Refresh vendor list
      } catch (e) {
        d.log("Failed to delete image: $e");
      }
    });

    on<ResetLocationEvent>((event, emit) {
      latitude = null;
      longitude = null;
      emit(VendorDataCommonState());
    });



  }
}
