import 'package:equatable/equatable.dart';

class VehicleHistoryState extends Equatable {
  final dynamic vin;
  final int totalPage;
  final bool isLoading;
  final int currentPage;
  final bool hasMoreData;
  final String? vehicleName;
  final List<dynamic> apiResponse;
  final Map<DateTime, List<dynamic>> vehicleDataList;
  final List<dynamic> resourceList;
  final List<dynamic> userGroupList;

  const VehicleHistoryState({
    required this.apiResponse,
    required this.vehicleDataList,
    required this.resourceList,
    required this.userGroupList,
    required this.vin,
    required this.vehicleName,
    required this.isLoading,
    required this.totalPage,
    required this.currentPage,
    required this.hasMoreData,
  });

  VehicleHistoryState copyWith({
    dynamic vin,
    String? vehicleName,
    List<dynamic>? apiResponse,
    Map<DateTime, List<dynamic>>? vehicleDataList,
    List<dynamic>? resourceList,
    List<dynamic>? userGroupList,
    String? title,
    bool? isLoading,
    int? totalPage,
    int? currentPage,
    bool? hasMoreData,
  }) {
    return VehicleHistoryState(
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      vin: vin ?? this.vin,
      vehicleName: vehicleName ?? this.vehicleName,
      apiResponse: apiResponse ?? this.apiResponse,
      vehicleDataList: vehicleDataList ?? this.vehicleDataList,
      resourceList: resourceList ?? this.resourceList,
      userGroupList: userGroupList ?? this.userGroupList,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        totalPage,
        currentPage,
        hasMoreData,
        vin,
        vehicleName,
        apiResponse,
        vehicleDataList,
        resourceList,
        userGroupList,
        isLoading,
      ];
}
