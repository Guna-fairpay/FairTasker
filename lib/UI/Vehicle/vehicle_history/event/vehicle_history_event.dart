import 'package:equatable/equatable.dart';

abstract class VehicleHistoryEvent extends Equatable {
  const VehicleHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadVehicleInitialEvent extends VehicleHistoryEvent {
  final dynamic vin;
  final String? vehicleName;
  final List<dynamic> resourceList;
  final List<dynamic> userGroupList;
  final String? title;
  const LoadVehicleInitialEvent(
      {required this.vin,
        required this.vehicleName,
        required this.userGroupList,
        required this.resourceList,
        required this.title
      });
  @override
  List<Object?> get props => [vin, vehicleName, userGroupList, resourceList, title];
}

class LoadVehicleHistory extends VehicleHistoryEvent {
  final String? pageNo;
  final String? vin;
  const LoadVehicleHistory(
      this.pageNo,
      this.vin,);
  @override
  List<Object?> get props => [pageNo,vin];
}

class UpdateVehicleName extends VehicleHistoryEvent {
  final String? vehicleName;

  const UpdateVehicleName({required this.vehicleName});

  @override
  List<Object?> get props => [vehicleName];
}

class SearchFleetQuery extends VehicleHistoryEvent {
  final String query;

  const SearchFleetQuery(this.query);

  @override
  List<Object> get props => [query];
}

class SameTask extends VehicleHistoryEvent {}

class CompleteTask extends VehicleHistoryEvent {}

class PopUp extends VehicleHistoryEvent {}
