import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class VehicleHistoryEvent extends Equatable {
  const VehicleHistoryEvent();

  @override
  List<Object?> get props => [];
}

class VehicleInitialEvent extends VehicleHistoryEvent {
  final dynamic vin;
  final dynamic groupId;
  final String? vehicleName;
  final int itemPerPage;
  const VehicleInitialEvent(this.vin, this.vehicleName, this.groupId, {this.itemPerPage = 10});
  @override
  List<Object?> get props => [vin, vehicleName, groupId, itemPerPage];
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

class VehicleHistoryPageEvent extends VehicleHistoryEvent {
  final int page;
  const VehicleHistoryPageEvent(this.page);
  @override
  List<Object?> get props => [page, Random().nextDouble()];
}

class VehicleHistorySearchEvent extends VehicleHistoryEvent {
  final String searchText;
  const VehicleHistorySearchEvent(this.searchText);
  @override
  List<Object?> get props => [searchText];
}

class VehicleHistoryCompleteEvent extends VehicleHistoryEvent {
  final dynamic todoId;
  final bool status;
  const VehicleHistoryCompleteEvent(this.todoId, this.status);
  @override
  List<Object?> get props => [todoId, status, Random().nextDouble()];
}

class VehicleHistoryDeleteEvent extends VehicleHistoryEvent {
  final dynamic todoId;
  final dynamic reason;
  const VehicleHistoryDeleteEvent(this.todoId, this.reason);
  @override
  List<Object?> get props => [todoId, reason, Random().nextDouble()];
}

class VehicleHistorySameTaskEvent extends VehicleHistoryEvent {
  final dynamic title;
  final bool isChecked;
  const VehicleHistorySameTaskEvent(this.title, this.isChecked);
  @override
  List<Object?> get props => [title, isChecked, Random().nextDouble()];
}

class VehicleHistoryViewEvent extends VehicleHistoryEvent {
  final dynamic task;
  const VehicleHistoryViewEvent(this.task);
  @override
  List<Object?> get props => [task, Random().nextDouble()];
}
