


import 'package:equatable/equatable.dart';

class OdometerState extends Equatable {
  final Map<String, dynamic> vehicle;
  final Map<String, dynamic> todoItems;
  final dynamic selectedVehicle;
  final bool isLoading;
  final dynamic odometerData;

  const OdometerState({
    required this.vehicle,
    required this.todoItems,
    required this.selectedVehicle,
    this.isLoading = true,
    this.odometerData,
  });

  OdometerState copyWith({
    Map<String, dynamic>? vehicle,
    Map<String, dynamic>? todoItems,
    dynamic selectedVehicle,
    bool? isLoading,
    dynamic odometerData,
}) => OdometerState(
    vehicle: vehicle ?? this.vehicle,
    todoItems: todoItems ?? this.todoItems,
    selectedVehicle: selectedVehicle ?? this.selectedVehicle,
    isLoading: isLoading ?? this.isLoading,
    odometerData: odometerData ?? this.odometerData,
  );

  @override
  List<Object?> get props =>
      [vehicle,
        todoItems,
        selectedVehicle,
        isLoading,
        odometerData,
      ];
}