import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_state.dart';
import 'package:fairpytasker/Repository/report_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class ReportsBloc extends Bloc<ReportDownloadEvent, ReportState> {
  final ReportRepository _reportRepository = ReportRepository();
  TextEditingController tollFileController = TextEditingController();
  File? tollFile;
  String? fileName;
  String? maintenanceFile, vehicleFile, earningFile, vehicleInventoryFile;
  ReportsBloc() : super(ReportsLoadingState()) {
    on<ReportMaintenanceEvent>(_onReportMaintenanceEvent);
    on<ReportVehicleEvent>(_onReportVehicleEvent);
    on<ReportEarningEvent>(_onReportEarningEvent);
    on<ReportVehicleInventoryEvent>(_onReportVehicleInventoryEvent);
    on<ReportTollsEvent>(_onPickFileEvent);
    on<UploadFileEvent>(_onUploadFileEvent);
    /*on<ReportMaintenanceEvent>((event, emit) async {
      if (state.maintenanceFile != null) {
        state.maintenanceFile.toString().open;
        return;
      }
      emit(state.copyWith(isLoading: true, isMaintenanceLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadMaintenanceReport(onError: (v) => errorText = v);
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");
      emit(state.copyWith(isLoading: false, error: errorText, maintenanceFile: val, isMaintenanceLoading: false));
    });*/

    /*on<ReportVehicleEvent>((event, emit) async {
      if (state.vehicleFile != null) {
        state.vehicleFile.toString().open;
        return;
      }
      emit(state.copyWith(isLoading: true, isVehicleLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadVehicleReport(onError: (val) => errorText = val);
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");
      emit(state.copyWith(isLoading: false, error: errorText, vehicleFile: val, isVehicleLoading: false));
    });*/

    /*on<ReportEarningEvent>((event, emit) async {
      if (state.earningFile != null) {
        state.earningFile.toString().open;
        return;
      }
      emit(state.copyWith(isLoading: true, isEarningLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadEarningSummary(onError: (val) => errorText = val);
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");
      emit(state.copyWith(isLoading: false, error: errorText, earningFile: val, isEarningLoading: false));
    });*/

    /*on<ReportVehicleInventoryEvent>((event, emit) async {
      if (state.vehicleInventoryFile != null) {
        state.vehicleInventoryFile.toString().open;
        return;
      }
      emit(state.copyWith(isLoading: true, isVehicleInventoryLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadVehicleInventoryData(onError: (val) => errorText = val);
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");

      emit(state.copyWith(isLoading: false, error: errorText, vehicleInventoryFile: val, isVehicleInventoryLoading: false));
    });*/

    /*on<ReportTollsEvent>((event, emit) async{
      //Open file picker
      var result = await CommonHelper.instance.pickFiles(type: FileType.custom, allowedExtensions: ["xls", "xlsx"]);
      // FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowedExtensions: ['xlsx'],//types allowed
      // );
      if (result.isNotEmpty) {
        file = result.firstOrNull;
        fileName = p.basename(file?.path ?? '');
        tolls.text = fileName!;
        log("${p.basename(file!.path)}", name: "File_name");
        log("${file?.path}", name: "File_name");
        emit(state.copyWith(tollsFile: file));
      }
    });*/

    /*on<UploadFileEvent>((event, emit) async {
      if (state.tollsFile == null) return;
      if(state.tollsDownloadPath != null){
        state.tollsDownloadPath.toString().open;
        return;
      } else {
        emit(state.copyWith(tollFileLoading: true));
        var response = await _reportRepository.uploadFile(state.tollsFile?.path.toString() ?? '');
        log("Response: ${response}");
        if((response != null) && (response.isNotEmpty)){
          tollFileController.clear();
          emit(state.copyWith(tollFileLoading: false, uploadSuccess: true, tollsDownloadPath: response));
        } else {

        }
      }
    });*/

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
      emit(ReportsUploadingState());
      var response = await _reportRepository.uploadFile(tollFile?.path.toString() ?? '');
      if ((response != null) && (response.isNotEmpty)) tollFileController.clear();
      emit(ReportsCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ReportsErrorState(e));
    }
  }
}