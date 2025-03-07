import 'package:equatable/equatable.dart';

abstract class VehicleExpenseHistoryEvent extends Equatable {
  const VehicleExpenseHistoryEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleExpenseHistoryList extends VehicleExpenseHistoryEvent {
  final String? vin;
  const GetVehicleExpenseHistoryList({required this.vin});
  @override
  List<Object?> get props => [vin];
}

class GetEditVehicleExpenseHistory extends VehicleExpenseHistoryEvent {
  final String? id;
  const GetEditVehicleExpenseHistory({required this.id});
  @override
  List<Object?> get props => [id];
}

class SearchVehicleExpenseHistoryEvent extends VehicleExpenseHistoryEvent {
  final String? query;
  const SearchVehicleExpenseHistoryEvent(this.query);
  @override
  List<Object?> get props => [query];
}
