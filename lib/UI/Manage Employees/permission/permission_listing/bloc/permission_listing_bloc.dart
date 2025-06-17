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

part 'permission_listing_event.dart';
part 'permission_listing_state.dart';

class PermissionListingBloc extends Bloc<PermissionListingEvent, PermissionListingState>{

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

  Future<Map<String, dynamic>?> _getPermissionList() async => await _apiRepository.getPermissionList();
  Future<Map<String, dynamic>?> _deletePermission({dynamic id}) async => await _apiRepository.deletePermission(id: id);


  PermissionListingBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<AddEditEvent>(_onAddEditEvent);
    on<SearchEvent>(_onSearchEvent);
    on<PaginationEvent>(_onPaginationEvent);
    on<RefreshEvent>(_onRefreshEvent);
    _broadcast.register('refresh_permission', (value, callback) => add(RefreshEvent()));

  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<PermissionListingState> emit) async {
    try {
      emit(LoadingState());
      await _reFetch();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<PermissionListingState> emit) async {
    try {
      emit(LoadingState());
      var response = await _deletePermission(id: event.data['id']);
      if(response?['status'] == 200){
        await _reFetch();
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e) {
      _error(e, emit);
    }
  }

  void _onAddEditEvent(AddEditEvent event, Emitter<PermissionListingState> emit) {
    try {
      emit(AddEditState(event.data));
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onSearchEvent(SearchEvent event, Emitter<PermissionListingState> emit) {
    try {
      _search();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onPaginationEvent(PaginationEvent event, Emitter<PermissionListingState> emit) {
    try {
      currentIndex = event.data;
      filteredResponse = paginateList(
          data: _unFilteredResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      emit(CommonState());
    }catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<PermissionListingState> emit) async {
    try {
      emit(LoadingState());
      await _reFetch();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _reFetch() async {
    var response = await _getPermissionList();
    apiResponse =List.from(response?['permission'] ?? []);
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

  void _error(dynamic error, Emitter<PermissionListingState> emit) {
    emit(ErrorState(error));
    Console.of.error(error);
  }
}