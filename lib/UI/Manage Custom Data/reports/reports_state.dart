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
  final dynamic tollsFile;
  final bool uploadSuccess;

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
      this.vehicleInventoryFile,
        this.tollsFile,
        this.uploadSuccess = false,

      });

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
    dynamic tollsFile,
    bool? uploadSuccess,
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
        vehicleInventoryFile: vehicleInventoryFile ?? this.vehicleInventoryFile,
        tollsFile: tollsFile ?? this.tollsFile,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
    );
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
        vehicleInventoryFile,
        tollsFile,
        uploadSuccess,
      ];
}
