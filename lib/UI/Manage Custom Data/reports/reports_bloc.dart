import 'package:fairpytasker/Repository/report_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:path/path.dart' as p;
import 'dart:math';
import 'dart:io';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportDownloadEvent, ReportState> {
  final ReportRepository _reportRepository = ReportRepository();
  TextEditingController tollFileController = TextEditingController();
  File? tollFile;
  String? fileName;
  String? maintenanceFile, vehicleFile, earningFile, vehicleInventoryFile;
  DateRange? dateRange;
  ReportsBloc() : super(ReportsLoadingState()) {
    on<ReportMaintenanceEvent>(_onReportMaintenanceEvent);
    on<ReportVehicleEvent>(_onReportVehicleEvent);
    on<ReportEarningEvent>(_onReportEarningEvent);
    on<ReportVehicleInventoryEvent>(_onReportVehicleInventoryEvent);
    on<ReportTollsEvent>(_onPickFileEvent);
    on<UploadFileEvent>(_onUploadFileEvent);
    on<TaskExportEvent>(_onTaskExportEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
  }

  void _onReportMaintenanceEvent(ReportMaintenanceEvent event, Emitter<ReportState> emit) async {
    try {
      if (maintenanceFile.isNotNullOrEmpty) { maintenanceFile.open; return; }
      emit(ReportsGeneratingState());
      maintenanceFile = await _reportRepository.downloadMaintenanceReport();
      emit(ReportsCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ReportsErrorState(e));
    }
  }

  void _onReportVehicleEvent(ReportVehicleEvent event, Emitter<ReportState> emit) async {
    try {
      if (vehicleFile.isNotNullOrEmpty) { vehicleFile.open; return; }
      emit(ReportsGeneratingState());
      vehicleFile = await _reportRepository.downloadVehicleReport();
      emit(ReportsCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ReportsErrorState(e));
    }
  }

  void _onReportEarningEvent(ReportEarningEvent event, Emitter<ReportState> emit) async {
    try {
      if (earningFile.isNotNullOrEmpty) { earningFile.open; return; }
      emit(ReportsGeneratingState());
      earningFile = await _reportRepository.downloadEarningSummary();
      emit(ReportsCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ReportsErrorState(e));
    }
  }

  void _onReportVehicleInventoryEvent(ReportVehicleInventoryEvent event, Emitter<ReportState> emit) async {
    try {
      if (vehicleInventoryFile.isNotNullOrEmpty) { vehicleInventoryFile.open; return; }
      emit(ReportsGeneratingState());
      vehicleInventoryFile = await _reportRepository.downloadVehicleInventoryData();
      emit(ReportsCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ReportsErrorState(e));
    }
  }

  void _onPickFileEvent(ReportTollsEvent event, Emitter<ReportState> emit) async {
    try {
      var result = await CommonHelper.instance.pickFiles(type: FileType.custom, allowedExtensions: ["xls", "xlsx"]);
      if (result.isNotEmpty) {
        tollFile = result.firstOrNull;
        fileName = p.basename(tollFile?.path ?? '');
        tollFileController.text = fileName ?? "";
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ReportsErrorState(e));
    }
  }

  void _onUploadFileEvent(UploadFileEvent event, Emitter<ReportState> emit) async {
    try {
      if (tollFile == null) return emit(ReportsErrorState("No file selected"));
      emit(ReportsUploadingState());
      var response = await _reportRepository.uploadFile(tollFile?.path.toString() ?? '');
      if ((response != null) && (response.isNotEmpty)) tollFileController.clear();
      emit(ReportsCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ReportsErrorState(e));
    }
  }

  void _onTaskExportEvent(TaskExportEvent event, Emitter<ReportState> emit) async {
    try {
      if (dateRange == null) return emit(ReportsErrorState("No date range selected"));
      emit(ReportsDownloadingState());
      var response = await _reportRepository.downloadTaskReport(dateRange);
      if ((response != null) && (response.isNotEmpty)) dateRange = null;
      if (response?['download'].toString().isNotNullOrEmpty ?? false) Toaster.showSuccess("Report downloaded successfully!", title: "Task Report");
      emit(ReportsCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ReportsErrorState(e));
    }
  }

  void _onDateRangeEvent(DateRangeEvent event, Emitter<ReportState> emit) {
    dateRange = event.dateRange;
    emit(ReportsCommonState());
  }
}