import 'package:equatable/equatable.dart';

class ReportsState extends Equatable {

  final bool isLoading;
  final dynamic maintenanceFile;
  final dynamic error;
  final dynamic vehicleFile;
  final dynamic earningFile;

  const ReportsState({
    this.error,
    this.isLoading = false,
    this.maintenanceFile,
    this.vehicleFile,
    this.earningFile});

  ReportsState copyWith({
    bool? isLoading,
    dynamic error,
    dynamic maintenanceFile,
    dynamic vehicleFile,
    dynamic earningFile,
}) {
    return ReportsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      maintenanceFile: maintenanceFile ?? this.maintenanceFile,
      vehicleFile: vehicleFile ?? this.vehicleFile,
      earningFile: earningFile ?? this.earningFile);
  }

  @override
  List<Object?> get props => [isLoading, maintenanceFile, vehicleFile, earningFile];
}