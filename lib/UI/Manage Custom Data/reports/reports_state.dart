import 'package:equatable/equatable.dart';

class ReportsState extends Equatable {
  final bool isLoading;
  final bool isMaintenanceLoading;
  final bool isVehicleLoading;
  final bool isEarningLoading;
  final dynamic maintenanceFile;
  final dynamic error;
  final dynamic vehicleFile;
  final dynamic earningFile;

  const ReportsState(
      {this.error,
      this.isLoading = false,
      this.isMaintenanceLoading = false,
      this.isVehicleLoading = false,
      this.isEarningLoading = false,
      this.maintenanceFile,
      this.vehicleFile,
      this.earningFile});

  ReportsState copyWith({
    bool? isLoading,
    bool? isMaintenanceLoading,
    bool? isVehicleLoading,
    bool? isEarningLoading,
    dynamic error,
    dynamic maintenanceFile,
    dynamic vehicleFile,
    dynamic earningFile,
  }) {
    return ReportsState(
        isLoading: isLoading ?? this.isLoading,
        isMaintenanceLoading: isMaintenanceLoading ?? this.isMaintenanceLoading,
        isVehicleLoading: isVehicleLoading ?? this.isVehicleLoading,
        isEarningLoading: isEarningLoading ?? this.isEarningLoading,
        error: error ?? this.error,
        maintenanceFile: maintenanceFile ?? this.maintenanceFile,
        vehicleFile: vehicleFile ?? this.vehicleFile,
        earningFile: earningFile ?? this.earningFile);
  }

  @override
  List<Object?> get props => [
        isLoading,
        isMaintenanceLoading,
        isVehicleLoading,
        isEarningLoading,
        maintenanceFile,
        vehicleFile,
        earningFile
      ];
}
