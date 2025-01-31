
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class PartsState extends Equatable{
  final TextEditingController searchController;
  final List<dynamic> apiResponse;
  final List<dynamic> filteredResponse;
  final bool isLoading;

  final bool isAddPressed;

  const PartsState({
    required this.searchController,
    required this.apiResponse,
    required this.filteredResponse,
    required this.isLoading,
    required this.isAddPressed,
});

  PartsState copyWith({
    TextEditingController? searchController,
    List<dynamic>? apiResponse,
    List<dynamic>? filteredResponse,
    bool? isLoading,
    bool? isAddPressed,
  }){
    return PartsState(
        searchController: searchController ?? this.searchController,
        apiResponse:apiResponse ?? this.apiResponse,
        filteredResponse:filteredResponse ?? this.filteredResponse,
        isLoading:  isLoading ?? this.isLoading,
      isAddPressed: isAddPressed ?? this.isAddPressed,
    );
  }

  @override
  List<Object?> get props => [
    searchController,
    apiResponse,
    filteredResponse,
    isLoading,
    isAddPressed,
  ];

}