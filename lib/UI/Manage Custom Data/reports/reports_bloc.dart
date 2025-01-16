import 'package:fairpytasker/Repository/report_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsBloc extends Bloc<ReportDownloadEvent, ReportsState> {
  final ReportRepository _reportRepository = ReportRepository();
  ReportsBloc() : super(const ReportsState(
    isLoading: false,
  )) {
    on<ReportMaintenanceEvent>((event, emit) async {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true, isMaintenanceLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadMaintenanceReport(onError: (v) => errorText = v);
      print("FilePath:\t $val");
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");
      emit(state.copyWith(isLoading: false, error: errorText, maintenanceFile: val, isMaintenanceLoading: false));
    });

    on<ReportVehicleEvent>((event, emit) async {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true, isVehicleLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadVehicleReport(onError: (val) => errorText = val);
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");
      emit(state.copyWith(isLoading: false, error: errorText, vehicleFile: val, isVehicleLoading: false));
    });

    on<ReportEarningEvent>((event, emit) async {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true, isEarningLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadEarningSummary(onError: (val) => errorText = val);
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");
      emit(state.copyWith(isLoading: false, error: errorText, earningFile: val, isEarningLoading: false));
    });
  }

}