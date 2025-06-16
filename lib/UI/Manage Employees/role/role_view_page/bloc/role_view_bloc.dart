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

part 'role_view_event.dart';
part 'role_view_state.dart';

class RoleViewBloc extends Bloc<RoleViewEvent, RoleViewState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> rolesList = [];
  List<Map<String, dynamic>> usersList = [];
  List<Map<String, dynamic>> _unFilteredRolesList = [];
  List<Map<String, dynamic>> _unFilteredUsersList = [];
  List<Map<String, dynamic>> filteredRolesList = [];
  List<Map<String, dynamic>> filteredUsersList = [];

  int selectedTab = 0;
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  int selectedTabValue = 1;

  Future<Map<String, dynamic>?> _getEmployeeData() async => await _apiRepository.getEmployeeData();
  Future<Map<String, dynamic>?> _getRoleList() async => await _apiRepository.getRoleList();
  Future<Map<String, dynamic>?> _deleteRole({dynamic id}) async => await _apiRepository.deleteRole(id);


  RoleViewBloc() : super(LoadingState()){
    on<InitialEvent>(_initialEvent);
    on<SearchEvent>(_searchEvent);
    on<DeleteEvent>(_deleteEvent);
    on<PaginationEvent>(_paginationEvent);
    on<TabEvent>(_tabEvent);
    on<AddEditEvent>(_addEditEvent);
    on<RefreshEvent>(_refreshEvent);
    _broadcast.register('refreshRoles', (value, callback) => add(RefreshEvent()));
  }

  Future<void> _addEditEvent(AddEditEvent event, Emitter<RoleViewState> emit) async {
    try {
      emit(AddEditState(model: event.data, isRoleEdit: event.isRoleEdit, isUserEdit: event.isUserEdit));
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _refreshEvent(RefreshEvent event, Emitter<RoleViewState> emit) async {
    try {
      await _reFetch();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _initialEvent(InitialEvent event, Emitter<RoleViewState> emit) async {
    try {
      emit(LoadingState());
      await _reFetch();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _searchEvent(SearchEvent event, Emitter<RoleViewState> emit){
    try {
      _search();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _deleteEvent(DeleteEvent event, Emitter<RoleViewState> emit) async {
    try {
      emit(LoadingState());
      var response = await _deleteRole(id: event.data?['id']);
      if(response?['status'] == true){
        await _reFetch();
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  void _paginationEvent(PaginationEvent event, Emitter<RoleViewState> emit){
    try {
      currentIndex = event.page;
      paginationData();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _tabEvent(TabEvent event, Emitter<RoleViewState> emit){
    try {
      selectedTabValue = event.index;
      currentIndex = 1;
      paginationData();
      _search();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _reFetch() async {
    var rolesResponse = await _getRoleList();
    var usersResponse = await _getEmployeeData();
    rolesList =List.from(rolesResponse?['role'] ?? []);
    usersList =List.from(usersResponse?['role'] ?? []);
    rolesList = rolesList
        .mapIndexed((index, element) => {...element, 'index': index})
        .toList();
    usersList = usersList
        .mapIndexed((index, element) => {...element, 'index': index})
        .toList();
    _unFilteredRolesList = rolesList;
    _unFilteredUsersList = usersList;
    paginationData();
  }

  void paginationData(){
    if(selectedTabValue == 1) {
      filteredRolesList = paginateList(
          data: _unFilteredRolesList,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      totalCount = _unFilteredRolesList.length;
    }else{
      filteredUsersList = paginateList(
          data: _unFilteredUsersList,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      totalCount = _unFilteredUsersList.length;
    }
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];
    if(selectedTabValue == 1){
      if (query.trim().isNotNullOrEmpty) {
        filteredData = rolesList.where((element) {
          return [
            element['name'],
          ].any((value) =>
              value?.toString().toLowerCase().contains(query) ?? false);
        }).toList();
      } else {
        filteredData = rolesList;
      }
      _unFilteredRolesList = filteredData;
      currentIndex = 1;
      totalCount = filteredData.length;
      filteredRolesList = paginateList(
        data: _unFilteredRolesList,
        currentPage: currentIndex,
        itemsPerPage: itemsPerPage,
      );
    }else{
      if (query.trim().isNotNullOrEmpty) {
        filteredData = usersList.where((element) {
          return [
            element['first_name'],
            element['last_name'],
          ].any((value) =>
              value?.toString().toLowerCase().contains(query) ?? false);
        }).toList();
      } else {
        filteredData = usersList;
      }
      _unFilteredUsersList = filteredData;
      currentIndex = 1;
      totalCount = filteredData.length;
      filteredUsersList = paginateList(
        data: _unFilteredUsersList,
        currentPage: currentIndex,
        itemsPerPage: itemsPerPage,
      );
    }
  }

  void _error(dynamic error, Emitter<RoleViewState> emit) {
    emit(ErrorState(error));
    Console.of.error(error);
  }

}