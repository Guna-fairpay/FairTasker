part of 'reports_bloc.dart';

abstract class ReportDownloadEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class ReportMaintenanceEvent extends ReportDownloadEvent {}
class ReportVehicleEvent extends ReportDownloadEvent {}
class ReportEarningEvent extends ReportDownloadEvent {}
class ReportVehicleInventoryEvent extends ReportDownloadEvent {}
class ReportTollsEvent extends ReportDownloadEvent {}
class UploadFileEvent extends ReportDownloadEvent {}
class TaskExportEvent extends ReportDownloadEvent {}
class DateRangeEvent extends ReportDownloadEvent {
  final DateRange dateRange;
  DateRangeEvent(this.dateRange);
  @override
  List<Object?> get props => [dateRange];
}