import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as p;

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'private_rental_customers_event.dart';
part 'private_rental_customers_state.dart';

class RentalCustomerBloc extends Bloc<Event, State> {
  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey();
  final int _itemsPerPage = 10;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController rentalDateController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController insuranceController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController securityDepositController = TextEditingController();
  final TextEditingController monthlyRentalController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();

  List<dynamic> licenseAttachments = [], insuranceAttachments = [];

  Map<String, dynamic>? _editModel;
  List<Map<String, dynamic>>? _apiResponse;
  List<Map<String, dynamic>>? _filteredResponse;
  List<Map<String, dynamic>>? filteredResponse;
  DateTime? rentalDate;
  int currentPage = 1;
  RentalCustomerBloc() : super(LoadingState()) {
    on<InitEvent>(_onInitialEvent);
    on<PaginationEvent>(_onPaginationEvent);
    on<SearchEvent>(_onSearchEvent);
    on<EditEvent>(_onEditEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<RentalDateEvent>(_onRentalDateEvent);
    on<PickLicenseEvent>(_onPickLicenseEvent);
    on<PickInsuranceEvent>(_onPickInsuranceEvent);
    on<DeleteLicenseEvent>(_onDeleteLicenseEvent);
    on<DeleteInsuranceEvent>(_onDeleteInsuranceEvent);
    on<CancelEditEvent>(_onCancelEvent);
    on<SubmitEvent>(_onSubmitEvent);
  }

  Future<Map<String, dynamic>?> _fetchCustomers() async => await _apiRepository.getPrivateRentalCustomersList();
  Future<Map<String, dynamic>?> _fetchCustomer(dynamic id) async => await _apiRepository.getPrivateRentalEditCustomer(id: id);
  Future<Map<String, dynamic>?> _deleteCustomer(dynamic id) async => await _apiRepository.deletePrivateRentalCustomer(id: id);
  Future<Map<String, dynamic>?> _createCustomer() async => await _apiRepository.storePrivateRentalCustomer(model: _toSaveBody, infusedFiles: _fileFusion);
  Future<Map<String, dynamic>?> _updateCustomer() async => await _apiRepository.updatePrivateRentalCustomer(_editModel?['id'],model: _toSaveBody, infusedFiles: _fileFusion);

  bool get isEditing => _editModel != null;
  int get totalPages => ((_filteredResponse?.length ?? 0) / _itemsPerPage).ceil();

  Map<String, dynamic> get _toSaveBody => {
    "first_name": firstNameController.text,
    "last_name" : lastNameController.text,
    "phone" : phoneController.text,
    "email" : null,
    "address" : addressController.text,
    "monthly_rental" : monthlyRentalController.text,
    "rental_start_date" : rentalDate?.toFormat(format: "yyyy-MM-dd"),
    "security_deposit" : securityDepositController.text,
    "note" : notesController.text,
    "platform" : "taskerApp",
    "status" : 1,
    ((_editModel == null) ? "created_by" : "updated_by") : getIt<CommonService>().userId
  };

  List<Map<String, String?>> get _fileFusion {
    List<Map<String, String?>> data = [];
    licenseAttachments.whereType<File>().forEach((element) => data.add({"licenseAttach": element.path}));
    insuranceAttachments.whereType<File>().forEach((element) => data.add({"insuranceAttach": element.path}));
    return data;
  }

  void _error(dynamic e, Emitter<State> emit) {
    Console.of.error("Error", error: e);
    emit(ErrorState(e));
  }

  void _pagination(Emitter<State> emit) {
    filteredResponse = paginateList(data: (_filteredResponse ?? []), currentPage: currentPage, itemsPerPage: _itemsPerPage);
    emit(CommonState());
  }

  void _updateFileControllers() {
    insuranceController.text = p.basename(insuranceAttachments.whereType<File>().lastOrNull?.path ?? "");
    licenseController.text = p.basename(licenseAttachments.whereType<File>().lastOrNull?.path ?? "");
    if (licenseAttachments.whereType<File>().isEmpty) licenseController.clear();
    if (insuranceAttachments.whereType<File>().isEmpty) insuranceController.clear();
  }

  void _processEdit() {
    firstNameController.text = (_editModel?['first_name'] ?? "");
    lastNameController.text = (_editModel?['last_name'] ?? "");
    phoneController.text = (_editModel?['phone'] ?? "");
    addressController.text = (_editModel?['address'] ?? "");
    monthlyRentalController.text = (_editModel?['monthly_rental'] ?? "").toString();
    rentalDateController.text = (_editModel?['rental_start_date'].toString().toFormat(format: "dd-MM-yyyy") ?? "");
    securityDepositController.text = (_editModel?['security_deposit'] ?? "").toString();
    notesController.text = (_editModel?['note'] ?? "");
    rentalDate = (_editModel?['rental_start_date'].toString().toDateTime());
  }

  void _clearController() {
    formKey.currentState?.reset();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    addressController.clear();
    monthlyRentalController.clear();
    rentalDateController.clear();
    securityDepositController.clear();
    notesController.clear();
    licenseAttachments.clear();
    insuranceAttachments.clear();
    licenseController.clear();
    insuranceController.clear();
    rentalDate = null;
    _editModel = null;
  }

  void _onInitialEvent(InitEvent event, Emitter<State> emit) async {
    try {
      emit(LoadingState());
      _apiResponse = List<Map<String, dynamic>>.from((await _fetchCustomers())?['customers'] ?? []);
      _apiResponse?.sort((a, b) => b['id'].compareTo(a['id']));
      _filteredResponse = _apiResponse;
      return _pagination(emit);
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onPaginationEvent(PaginationEvent event, Emitter<State> emit) {
    currentPage = event.page;
    return _pagination(emit);
  }

  void _onSearchEvent(SearchEvent event, Emitter<State> emit) {
    Console.of.log("SEARCHING...");
    if (event.query.trim().isNullOrEmpty) {
      _filteredResponse = _apiResponse;
      return _pagination(emit);
    } else {
      var query = event.query.toLowerCase();
      currentPage = 1;
      _filteredResponse = _apiResponse
          ?.where((element) => element['first_name'].toString().toLowerCase().contains(query) ||
                               element['last_name'].toString().toLowerCase().contains(query) ||
                               element['phone'].toString().contains(query) ||
                               element['monthly_rental'].toString().contains(query) ||
                               element['rental_start_date'].toString().contains(query))
          .toList();
      return _pagination(emit);
    }
  }

  void _onEditEvent(EditEvent event, Emitter<State> emit) async {
    try {
      emit(LoadingState());
      var model = event.model;
      _editModel = (await _fetchCustomer(model?['id']))?['data'];
      licenseAttachments = List.from(_editModel?['licenceAttach'] ?? []);
      insuranceAttachments = List.from(_editModel?['insuranceAttach'] ?? []);
      _processEdit();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<State> emit) async {
    if (event.model == null) return;
    if (event.proceed == null) return emit(DeleteState(event.model));
    try {
      emit(LoadingState());
      var model = event.model;
      var response = await _deleteCustomer(model?['id']);
      if (response?['success'] == true) {
        if (_editModel?['id'] == model?['id']) _clearController();
        _apiResponse?.removeWhere((element) => element['id'] == model?['id']);
        _filteredResponse = _apiResponse;
        return add(SearchEvent(searchController.text));
      } else {
        return emit(ErrorState(response?['message'] ?? "Something went wrong!"));
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onRentalDateEvent(RentalDateEvent event, Emitter<State> emit) {
    rentalDate = event.date;
    rentalDateController.text = event.date?.toFormat(format: "dd-MM-yyyy") ?? "";
    emit(CommonState());
  }

  void _onPickLicenseEvent(PickLicenseEvent event, Emitter<State> emit) async {
    var files = await CommonHelper.instance.pickImages();
    if (files != null) {
      licenseAttachments.addAll(files);
      _updateFileControllers();
      emit(CommonState());
    }
  }

  void _onPickInsuranceEvent(PickInsuranceEvent event, Emitter<State> emit) async {
    var files = await CommonHelper.instance.pickImages();
    if (files != null) {
      insuranceAttachments.addAll(files);
      _updateFileControllers();
      emit(CommonState());
    }
  }

  void _onDeleteLicenseEvent(DeleteLicenseEvent event, Emitter<State> emit) {
    if (event.proceed == null) return emit(DeleteLicenseState(event.model));
    var file = event.model;
    if (file is File) {
      licenseAttachments.remove(file);
      _updateFileControllers();
      emit(CommonState());
    } else {
      // REMOVE FROM API
    }
  }

  void _onDeleteInsuranceEvent(DeleteInsuranceEvent event, Emitter<State> emit) {
    if (event.proceed == null) return emit(DeleteInsuranceState(event.model));
    var file = event.model;
    if (file is File) {
      insuranceAttachments.remove(file);
      _updateFileControllers();
      emit(CommonState());
    } else {
      // REMOVE FROM API
    }
  }

  void _onCancelEvent(CancelEditEvent event, Emitter<State> emit) {
    _clearController();
    emit(CommonState());
  }

  void _onSubmitEvent(SubmitEvent event, Emitter<State> emit) async {
    if (formKey.currentState?.validate() == false) return emit(CommonState());
    try {
      emit(LoadingState());
      if (_editModel == null) {
        // CREATE
        var response = await _createCustomer();
        if (response?['success'] == true) {
          if (response?['data'] != null) {
            _apiResponse?.add(response?['data']);
            _apiResponse?.sort((a, b) => b['id'].compareTo(a['id']));
            _filteredResponse = _apiResponse;
            // _pagination(emit);
            add(SearchEvent(searchController.text));
          }
          _clearController();
          return emit(SuccessState(response?['message'] ?? "Saved Successfully!"));
        } else {
          return emit(ErrorState(response?['message'] ?? "Something went wrong!"));
        }
      } else {
        // UPDATE
        var response = await _updateCustomer();
        if (response?['success'] == true) {
          if (response?['data'] != null) {
            _apiResponse?.removeWhere((element) => element['id'] == _editModel?['id']);
            _apiResponse?.add(response?['data']);
            _apiResponse?.sort((a, b) => b['id'].compareTo(a['id']));
            _filteredResponse = _apiResponse;
            // _pagination(emit);
            add(SearchEvent(searchController.text));
          }
          _clearController();
          return emit(SuccessState(response?['message'] ?? "Saved Successfully!"));
        } else {
          return emit(ErrorState(response?['message'] ?? "Something went wrong!"));
        }
      }
    } catch (e) {
      _error(e, emit);
    }
  }
}