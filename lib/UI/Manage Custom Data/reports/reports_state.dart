part of 'reports_bloc.dart';

abstract class ReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportsLoadingState extends ReportState {}
class ReportsGeneratingState extends ReportState {}
class ReportsUploadingState extends ReportState {}
class ReportsDownloadingState extends ReportState {}
class ReportsCommonState extends ReportState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ReportsErrorState extends ReportState {
  final dynamic message;
  ReportsErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class ReportsSuccessState extends ReportState {
  final dynamic message;
  ReportsSuccessState(this.message);
  @override
  List<Object?> get props => [Random().nextDouble()];
}
