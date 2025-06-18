import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'vendor_type_event.dart';
part 'vendor_type_state.dart';

class VendorTypeBloc extends Bloc<VendorTypeEvent, VendorTypeState>{

  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;

  TextEditingController nameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> _unFilteredResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];

  dynamic model;

  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  bool isEdit = false;

  Future<List<Map<String, dynamic>>?> _getVendorType() async => await _apiRepository.getVendorType();
  Future<Map<String, dynamic>?> _addOrEditVendorType({dynamic body, dynamic id}) async => await _apiRepository.addOrEditVendorType(body: body, id: id);
  Future<Map<String, dynamic>?> _deleteVendorType(dynamic id) async => await _apiRepository.deleteVendorType(id);

  VendorTypeBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<SearchEvent>(_onSearchEvent);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<EditEvent>(_onEditEvent);
    on<CancelEvent>(_onCancelEvent);
    on<PaginationEvent>(_onPaginationEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<VendorTypeState> emit) async {
    try{
      emit(LoadingState());
      if(event.title != null) nameController.text = event.title;
      await fetchVendorType();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onSearchEvent(SearchEvent event, Emitter<VendorTypeState> emit) async {
    try{
      _search();
      emit(CommonState());
    }catch(e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSaveEvent(SaveEvent event, Emitter<VendorTypeState> emit) async {
    try{
      autoValidateMode = AutovalidateMode.onUserInteraction;
      if(formKey.currentState?.validate() == false) return emit(CommonState());
      emit(LoadingState());
      autoValidateMode = null;
      var response = await _addOrEditVendorType(id: model?['id'], body: {
        'name' : nameController.text,
        'platform' : 'tasker-web',
        'status' : '1',
      });
      if(response != null){
        FBroadcast.instance().broadcast('refresh_vendor_type');
        model = null;
        isEdit = false;
        nameController.clear();
        await fetchVendorType();
        emit(SuccessState(isEdit ? 'Updated Successfully' : 'Added Successfully'));
      }else{
          emit(ErrorState("$response"));
      }
      emit(CommonState());
    }catch(e) {
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<VendorTypeState> emit) async {
    try{
      emit(LoadingState());
      var response = await _deleteVendorType(event.data['id']);
        await fetchVendorType();
        if(model != null && model?['id'] == event.data['id']){
          model = null;
          isEdit = false;
          nameController.clear();
        }
        emit(SuccessState('Deleted Successfully'));
      emit(CommonState());
    }catch(e) {
      _onError(e, emit);
    }
  }

  Future<void> _onEditEvent(EditEvent event, Emitter<VendorTypeState> emit) async {
    try{
      formKey.currentState?.reset();
      autoValidateMode = null;
      isEdit = true;
      model = event.data;
      nameController.text = model?['name'];
      emit(CommonState());
    }catch(e) {
      _onError(e, emit);
    }
  }

  Future<void> _onCancelEvent(CancelEvent event, Emitter<VendorTypeState> emit) async {
    try{
      isEdit = false;
      model = null;
      nameController.clear();
      emit(CommonState());
    }catch(e) {
      _onError(e, emit);
    }
  }

  Future<void> _onPaginationEvent(PaginationEvent event, Emitter<VendorTypeState> emit) async {
    try{
      currentIndex = event.page;
      filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage,);
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }


  void _onError(dynamic error, Emitter<VendorTypeState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];
    if (query.trim().isNotNullOrEmpty) {
      filteredData = apiResponse.where((element) {
        return [
          element['name'],
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

  Future<void> fetchVendorType() async {
    var response = await _getVendorType();
    apiResponse = List.from(response ?? []);
    apiResponse.sort((b, a) => a['created_at'].compareTo(b['created_at']));
    _unFilteredResponse = apiResponse;
    filteredResponse = paginateList(
        data: _unFilteredResponse,
        currentPage: currentIndex,
        itemsPerPage: itemsPerPage);
    totalCount = _unFilteredResponse.length;
  }

}