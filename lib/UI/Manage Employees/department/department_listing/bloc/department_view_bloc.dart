import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'department_view_event.dart';
part 'department_view_state.dart';

class DepartmentViewBloc extends Bloc<DepartmentViewEvent, DepartmentViewState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> _unFilteredResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];

  int selectedTab = 0;
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  Future<Map<String, dynamic>?> _getDepartmentList() async => await _apiRepository.getDepartmentList();
  Future<Map<String, dynamic>?> _deleteDepartment({dynamic id}) async => await _apiRepository.deleteDepartment(id: id);

  DepartmentViewBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<AddEditEvent>(_onAddEditEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<PaginationEvent>(_onPaginationEvent);
    on<SearchEvent>(_onSearchEvent);
    on<RefreshEvent>(_onRefreshEvent);
    _broadcast.register('refresh_department', (value, callback) => add(RefreshEvent()));
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<DepartmentViewState> emit) async {
    try {
      emit(LoadingState());
      await _reFetch();
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<DepartmentViewState> emit) async {
    try {
      emit(LoadingState());
      await _reFetch();
      emit(CommonState());
    }catch (e) {
     _onError(e, emit);
    }
  }

  void _onAddEditEvent(AddEditEvent event, Emitter<DepartmentViewState> emit) {
    try {
      emit(AddEditState(event.model));
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<DepartmentViewState> emit) async {
    try {
      emit(LoadingState());

      var response = await _deleteDepartment(id: event.model['id']);
      if(response?['status'] == 200){
        await _reFetch();
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onPaginationEvent(PaginationEvent event, Emitter<DepartmentViewState> emit) {
    try {
      currentIndex = event.page;
      filteredResponse = paginateList(
          data: _unFilteredResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onSearchEvent(SearchEvent event, Emitter<DepartmentViewState> emit) {
    try {
      _search();
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _reFetch() async {
    var response = await _getDepartmentList();
    apiResponse =List.from(response?['department'] ?? []);
    apiResponse = apiResponse
        .mapIndexed((index, element) => {...element, 'index': index + 1})
        .toList();
    _unFilteredResponse = apiResponse;
    filteredResponse = paginateList(
        data: _unFilteredResponse,
        currentPage: currentIndex,
        itemsPerPage: itemsPerPage);
    totalCount = _unFilteredResponse.length;
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];
    if (query.trim().isNotNullOrEmpty) {
      filteredData = apiResponse.where((element) {
        return [
          element['users']?['first_name'],
          element['users']?['last_name'],
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

  void _onError(dynamic error, Emitter<DepartmentViewState> emit) {
    Console.of.error(error);
    emit(ErrorState(error));
  }
}