
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class VehicleExpenseHistoryState extends Equatable{

  final TextEditingController searchController;
  final List<dynamic> apiResponse;
  final List<dynamic> filteredResponse;
  final List<dynamic> attachments;
  final dynamic editResponse;
  final bool isLoading;

  const VehicleExpenseHistoryState({
    required this.searchController,
    required this.apiResponse,
    required this.filteredResponse,
    required this.attachments,
    required this.editResponse,
    required this.isLoading,
  });

  VehicleExpenseHistoryState copyWith({
    TextEditingController? searchController,
    List<dynamic>? apiResponse,
    List<dynamic>? filteredResponse,
    List<dynamic>? attachments,
    dynamic? editResponse,
    bool? isLoading,
  }){
    return VehicleExpenseHistoryState(
      searchController: searchController ?? this.searchController,
      apiResponse:apiResponse ?? this.apiResponse,
      filteredResponse:filteredResponse ?? this.filteredResponse,
      attachments: attachments ?? this.attachments,
      editResponse: editResponse ?? this.editResponse,
      isLoading:  isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    searchController,
    apiResponse,
    filteredResponse,
    attachments,
    editResponse,
    isLoading,
  ];

}