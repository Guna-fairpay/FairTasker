import 'package:equatable/equatable.dart';

abstract class ReportDownloadEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class ReportMaintenanceEvent extends ReportDownloadEvent {}
class ReportVehicleEvent extends ReportDownloadEvent {}
class ReportEarningEvent extends ReportDownloadEvent {}