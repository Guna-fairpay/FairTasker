import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
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
  }

  bool get isEditing => _editModel != null;
  int get totalPages => (_apiResponse?.length ?? 0) ~/ _itemsPerPage;

  void _pagination(Emitter<State> emit) {
    emit(CommonState());
  }

  void _onInitialEvent(InitEvent event, Emitter<State> emit) {
  }

  void _onPaginationEvent(PaginationEvent event, Emitter<State> emit) {
    currentPage = event.page;
    _pagination(emit);
  }

  void _onSearchEvent(SearchEvent event, Emitter<State> emit) {

  }

  void _onEditEvent(EditEvent event, Emitter<State> emit) {

  }

  void _onDeleteEvent(DeleteEvent event, Emitter<State> emit) {

  }

  void _onRentalDateEvent(RentalDateEvent event, Emitter<State> emit) {
  }

  void _onPickLicenseEvent(PickLicenseEvent event, Emitter<State> emit) {
  }

  void _onPickInsuranceEvent(PickInsuranceEvent event, Emitter<State> emit) {

  }

  void _onDeleteLicenseEvent(DeleteLicenseEvent event, Emitter<State> emit) {
  }

  void _onDeleteInsuranceEvent(DeleteInsuranceEvent event, Emitter<State> emit) {
  }



}