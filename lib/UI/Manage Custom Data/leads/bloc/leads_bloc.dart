import 'dart:async' show Timer;
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Remote/downloader.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'leads_event.dart';
part 'leads_state.dart';

class LeadsBloc extends Bloc<LeadsEvent, LeadsState>{

  APiRepository apiRepository = APiRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;
  DateRange? selectedDateRange;
  final FBroadcast _broadcast = FBroadcast.instance();

  TextEditingController searchController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController carNameController = TextEditingController();
  TextEditingController plateNoController = TextEditingController();
  TextEditingController partOrFullTimeController = TextEditingController();
  TextEditingController availableDaysController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController driverRatingController = TextEditingController();
  TextEditingController satisfactionRateController = TextEditingController();
  TextEditingController acceptanceRateController = TextEditingController();
  TextEditingController cancellationRateController = TextEditingController();
  TextEditingController tenureController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController totalTripsController = TextEditingController();
  TextEditingController uberProController = TextEditingController();
  TextEditingController appliedAtController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController rentalModelController = TextEditingController();
  TextEditingController inviteStatusController = TextEditingController();
  TextEditingController backgroundCheckController = TextEditingController();
  TextEditingController driverLicenseController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();

  bool showMore = false;
  bool isEdit = false;

  List<dynamic> activeStatus =[{'id': 1, 'name': 'Active'}, {'id': 2, 'name': 'Inactive'}];

  List<dynamic> apiResponse = [];
  List<dynamic> filteredResponse = [];
  List<dynamic> _unFilteredResponse = [];

  dynamic selectedStatus;
  dynamic editModel;
  String searchText = '';

  int selectedTab = 0;
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  Timer? _debouncer;

  // Future<Map<String, dynamic>?> _getLeads({dynamic page, dynamic search, dynamic type}) async => await apiRepository.getLeads(page: page, search: search, type: type);
  Future<List<Map<String, dynamic>>> _getLeads() async => await getIt<CommonService>().fetchLeads(reset: true);
  Future<Map<String, dynamic>?> _addEditLeads({dynamic body, dynamic id}) async => await apiRepository.addEditLeads(body: body, id: id);
  Future<Map<String, dynamic>?> _getEditLeads({dynamic id}) async => await apiRepository.getEditLeads(id: id);
  Future<Map<String, dynamic>?> _deleteLeads({dynamic id}) async => await apiRepository.deleteLeads(id: id);
  Future<Map<String, dynamic>?> _exportLeads({dynamic body}) async => await apiRepository.exportLeads(body: body);

  LeadsBloc() : super(LoadingState()){
   on<InitialEvent>(_onInitialEvent);
   on<ShowMoreEvent>(_onShowMoreEvent);
   on<ActiveStatesEvent>(_onActiveStatesEvent);
   on<SearchEvent>(_onSearchEvent);
   on<SaveEvent>(_onSaveEvent);
   on<CloseEvent>(_onCloseEvent);
   on<DeleteEvent>(_onDeleteEvent);
   on<PaginationEvent>(_onPaginationEvent);
   on<DateRangeEvent>(_onDateRangeEvent);
   on<EditEvent>(_onEditEvent);
   on<AppliedAtEvent>(_onAppliedAtEvent);
   on<ExportEvent>(_onExportEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<LeadsState> emit) async {
    try{
      if(event.customerName != null)  customerNameController.text = event.customerName;
      emit(LoadingState());
      await fetchData();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onShowMoreEvent(ShowMoreEvent event, Emitter<LeadsState> emit) async {
    try{
      showMore = !showMore;
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onActiveStatesEvent(ActiveStatesEvent event, Emitter<LeadsState> emit) async {
    try{
      selectedStatus = event.status;
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void debounce(String query) {
    _debouncer?.cancel();
    _debouncer = Timer(const Duration(seconds: 1), () => add(SearchEvent(query)));
  }

  @override
  Future<void> close() {
    _debouncer?.cancel();
    _debouncer = null;
    return super.close();
  }

  Future<void> _onSearchEvent(SearchEvent event, Emitter<LeadsState> emit) async {
    try{
      // emit(LoadingState());
      // var query = event.query;
      // searchText = query;
      // var response = await _getLeads(page: 1, search: query, type: '');
      // if(response?['status'] == true){
      //   apiResponse = List.from(response?['data']?['data'] ?? []);
      //   totalCount = response?['data']?['total'] ?? 0;
      //   _unFilteredResponse = List.from(apiResponse);
      //   paginateList(data: _unFilteredResponse, currentPage: 1, itemsPerPage: itemsPerPage);
      // }else{
      //   emit(ErrorState(response?['message']));
      // }
      _search();
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onSaveEvent(SaveEvent event, Emitter<LeadsState> emit) async {
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if(formKey.currentState?.validate() == false) return emit(CommonState());
    try{
      autoValidateMode = null;
      emit(LoadingState());
      var response = await _addEditLeads(body: _saveData(), id: editModel?['id']);
      if(response?['status'] == true){
        await fetchData();
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        clearAll();
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onCloseEvent(CloseEvent event, Emitter<LeadsState> emit) async {
    try{
      clearAll();
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(LoadingState());
      var response = await _deleteLeads(id: event.data?['id']);
      if(response?['status'] == true){
        await fetchData();
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        if(event.data?['id'] == editModel?['id']){
          clearAll();
        }
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onPaginationEvent(PaginationEvent event, Emitter<LeadsState> emit) async {
    try{
      currentIndex = event.page;
      filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage,);
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onDateRangeEvent(DateRangeEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(LoadingState());
      selectedDateRange = event.range;
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onAppliedAtEvent(AppliedAtEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(LoadingState());
      if(event.data != null) {
        appliedAtController.text = "${event.data?.toFormat(format: 'MM-dd-yyyy')}";
      }
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onExportEvent(ExportEvent event, Emitter<LeadsState> emit) async {
    if(selectedDateRange == null) return emit(ErrorState('Please select date range'));
    try{
      emit(LoadingState());
      var response = await _exportLeads(body: {
        'from': selectedDateRange?.start.toFormat(),
        'to': selectedDateRange?.end.toFormat(),
      });
      if(response?['url'] != null){
        await Downloader.instance.start(response?['url']);
        //ReportRepository().customDownload(response?['url']);
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e){
      _onError(e, emit);
    }
  }

  // Future<void> fetchData() async {
  //   var response = await _getLeads(page: currentIndex, search: searchText, type: '');
  //   apiResponse = List.from(response?['data']?['data'] ?? []);
  //   totalCount = response?['data']?['total'] ?? 0;
  //   _unFilteredResponse = List.from(apiResponse);
  //   paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
  //   _broadcast.broadcast(Str.addToDoRefresh);
  //   _broadcast.broadcast(Str.editToDoRefresh);
  // }

  Future<void> fetchData() async {
    var response = await _getLeads();
    apiResponse = List.from(response);
    _unFilteredResponse = List.from(apiResponse);
    filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
    totalCount = _unFilteredResponse.length;
  }

  void _onEditEvent(EditEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(LoadingState());
      var response = await _getEditLeads(id: event.data?['id']);
      if(response?['status'] == true){
        isEdit = true;
        editModel = response?['data'];
        loadAllData();
        emit(CommonState());
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<LeadsState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<dynamic> filteredData = [];
    if (query.trim().isNotNullOrEmpty) {
      filteredData = apiResponse.where((element) {
        return [
          element['customer_name'],
        ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    } else {
      filteredData = apiResponse;
    }
    _unFilteredResponse = filteredData;
    currentIndex=1;
    totalCount = filteredData.length;
    filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage,);
  }

  Map<String, dynamic> _saveData(){
    Map<String, dynamic> data = {};
    data['acceptance_rate'] = acceptanceRateController.text;
    data['active'] = selectedStatus?['id'];
    data['applied_at'] = appliedAtController.text;
    data['available_days'] = availableDaysController.text;
    data['background_check'] = backgroundCheckController.text;
    data['cancellation_rate'] = cancellationRateController.text;
    data['car_brand_name'] = carNameController.text;
    data['contact_number'] = contactNumberController.text;
    data['contract_type'] = partOrFullTimeController.text;
    data['customer_name'] = customerNameController.text;
    data['day'] = dayController.text;
    data['driver_license'] = driverLicenseController.text;
    data['driver_rating'] = driverRatingController.text;
    data['email'] = emailController.text;
    data['invite_status'] = inviteStatusController.text;
    data['location'] = locationController.text;
    data['notes'] = notesController.text;
    data['plate_no'] = plateNoController.text;
    data['profile_picture'] = profilePictureController.text;
    data['rating'] = ratingController.text;
    data['rental_model'] = rentalModelController.text;
    data['satisfaction_rate'] = satisfactionRateController.text;
    data['shift'] = shiftController.text;
    data['tenure'] = tenureController.text;
    data['total_trips'] = totalTripsController.text;
    data['uber_pro'] = uberProController.text;
    return data;
  }

  void clearAll(){
    isEdit = false;
    editModel = null;
    showMore = false;
    autoValidateMode = null;
    customerNameController.clear();
    emailController.clear();
    contactNumberController.clear();
    notesController.clear();
    carNameController.clear();
    plateNoController.clear();
    partOrFullTimeController.clear();
    availableDaysController.clear();
    shiftController.clear();
    driverRatingController.clear();
    satisfactionRateController.clear();
    acceptanceRateController.clear();
    cancellationRateController.clear();
    tenureController.clear();
    ratingController.clear();
    totalTripsController.clear();
    uberProController.clear();
    appliedAtController.clear();
    dayController.clear();
    locationController.clear();
    rentalModelController.clear();
    inviteStatusController.clear();
    backgroundCheckController.clear();
    driverLicenseController.clear();
    profilePictureController.clear();
    selectedStatus = null;
  }

  Future<void> loadAllData()async{
    customerNameController.text = editModel?['customer_name'] ?? '';
    emailController.text = editModel?['email'] ?? '';
    contactNumberController.text = editModel?['contact_number'] ?? '';
    notesController.text = editModel?['notes'] ?? '';
    carNameController.text = editModel?['car_brand_name'] ?? '';
    plateNoController.text = editModel?['plate_no'] ?? '';
    partOrFullTimeController.text = editModel?['contract_type'] ?? '';
    availableDaysController.text = editModel?['available_days'] ?? '';
    shiftController.text = editModel?['shift'] ?? '';
    driverRatingController.text = editModel?['driver_rating'] ?? '';
    satisfactionRateController.text = editModel?['satisfaction_rate'] ?? '';
    acceptanceRateController.text = editModel?['acceptance_rate'] ?? '';
    cancellationRateController.text = editModel?['cancellation_rate'] ?? '';
    tenureController.text = editModel?['tenure'] ?? '';
    ratingController.text = editModel?['rating'] ?? '';
    totalTripsController.text = editModel?['total_trips'] ?? '';
    uberProController.text = editModel?['uber_pro'] ?? '';
    appliedAtController.text = editModel?['applied_at'] ?? '';
    dayController.text = editModel?['day'] ?? '';
    locationController.text = editModel?['location'] ?? '';
    rentalModelController.text = editModel?['rental_model'] ?? '';
    inviteStatusController.text = editModel?['invite_status'] ?? '';
    backgroundCheckController.text = editModel?['background_check'] ?? '';
    driverLicenseController.text = editModel?['driver_license'] ?? '';
    profilePictureController.text = editModel?['profile_picture'] ?? '';
    selectedStatus = activeStatus.firstWhereOrNull((element) => element?['id'].toString() == editModel?['active'].toString());
  }

}