import 'package:equatable/equatable.dart';

class ReportsState extends Equatable {
  final bool isLoading;
  final bool isMaintenanceLoading;
  final bool isVehicleLoading;
  final bool isEarningLoading;
  final bool isVehicleInventoryLoading;
  final dynamic maintenanceFile;
  final dynamic error;
  final dynamic vehicleFile;
  final dynamic earningFile;
  final dynamic vehicleInventoryFile;

  const ReportsState(
      {this.error,
      this.isLoading = false,
      this.isMaintenanceLoading = false,
      this.isVehicleLoading = false,
      this.isEarningLoading = false,
      this.isVehicleInventoryLoading = false,
      this.maintenanceFile,
      this.vehicleFile,
      this.earningFile,
      this.vehicleInventoryFile});

  ReportsState copyWith({
    bool? isLoading,
    bool? isMaintenanceLoading,
    bool? isVehicleLoading,
    bool? isEarningLoading,
    bool? isVehicleInventoryLoading,
    dynamic error,
    dynamic maintenanceFile,
    dynamic vehicleFile,
    dynamic earningFile,
    dynamic vehicleInventoryFile,
  }) {
    return ReportsState(
        isLoading: isLoading ?? this.isLoading,
        isMaintenanceLoading: isMaintenanceLoading ?? this.isMaintenanceLoading,
        isVehicleLoading: isVehicleLoading ?? this.isVehicleLoading,
        isEarningLoading: isEarningLoading ?? this.isEarningLoading,
        isVehicleInventoryLoading: isVehicleInventoryLoading ?? this.isVehicleInventoryLoading,
        error: error ?? this.error,
        maintenanceFile: maintenanceFile ?? this.maintenanceFile,
        vehicleFile: vehicleFile ?? this.vehicleFile,
        earningFile: earningFile ?? this.earningFile,
        vehicleInventoryFile: vehicleInventoryFile ?? this.vehicleInventoryFile);
  }

  @override
  List<Object?> get props => [
        isLoading,
        isMaintenanceLoading,
        isVehicleLoading,
        isEarningLoading,
        isVehicleInventoryLoading,
        maintenanceFile,
        vehicleFile,
        earningFile,
        vehicleInventoryFile
      ];
}
