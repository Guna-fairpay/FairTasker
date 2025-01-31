import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class VehicleHistoryState extends Equatable {
  final TextEditingController searchController;
  final dynamic vin;
  final String? vehicleName;
  final List<dynamic> apiResponse;
  final List<dynamic> vehicleDataList;
  final List<dynamic> filterVehicleDataList;
  final List<dynamic> resourceList;
  final List<dynamic> userGroupList;
  final List<dynamic> filteredResponse;
  final String? title;
  final bool isLoading;


  const VehicleHistoryState({
    required this.apiResponse,
    required this.vehicleDataList,
    required this.filteredResponse,
    required this.filterVehicleDataList,
    required this.resourceList,
    required this.userGroupList,
    required this.searchController,
    required this.vin,
    required this.vehicleName,
    required this.title,
    required this.isLoading,
  });

  VehicleHistoryState copyWith(
      {TextEditingController? searchController,
        dynamic vin,
        String? vehicleName,
        required List<dynamic>? apiResponse,
        required List<dynamic>? vehicleDataList,
        required List<dynamic>? filteredResponse,
        required List<dynamic>? filterVehicleDataList,
        required List<dynamic>? resourceList,
        required List<dynamic>? userGroupList,
        required ScrollController scrollController,
        required String? title,
        required bool isLoading,}) {
    return VehicleHistoryState(
      searchController: searchController ?? this.searchController,
      vin: vin ?? this.vin,
      vehicleName: vehicleName ?? this.vehicleName,
      apiResponse: apiResponse ?? this.apiResponse,
      vehicleDataList: vehicleDataList ?? this.vehicleDataList,
      filteredResponse: filteredResponse ?? this.filteredResponse,
      filterVehicleDataList: filterVehicleDataList ?? this.filterVehicleDataList,
      resourceList: resourceList ?? this.resourceList,
      userGroupList: userGroupList ?? this.userGroupList,
      title: title ?? this.title,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    searchController,
    vin,
    vehicleName,
    apiResponse,
    vehicleDataList,
    filteredResponse,
    filterVehicleDataList,
    resourceList,
    userGroupList,
    title,
    isLoading,
  ];
}
