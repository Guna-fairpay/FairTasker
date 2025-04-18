

import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:fairpytasker/Repository/report_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_state.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;


class ReportsBloc extends Bloc<ReportDownloadEvent, ReportsState> {
  final ReportRepository _reportRepository = ReportRepository();
  TextEditingController tolls = TextEditingController();
  File? file;
  String? fileName;
  ReportsBloc() : super(const ReportsState(
    isLoading: false,
  )) {
    on<ReportMaintenanceEvent>((event, emit) async {
      if (state.maintenanceFile != null) {
        // Utils.openURL(state.maintenanceFile!, isFile: true);
        state.maintenanceFile.toString().open;
        return;
      }
      emit(state.copyWith(isLoading: true, isMaintenanceLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadMaintenanceReport(onError: (v) => errorText = v);
      print("FilePath:\t $val");
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");
      emit(state.copyWith(isLoading: false, error: errorText, maintenanceFile: val, isMaintenanceLoading: false));
    });

    on<ReportVehicleEvent>((event, emit) async {
      if (state.vehicleFile != null) {
        state.vehicleFile.toString().open;
        return;
      }
      emit(state.copyWith(isLoading: true, isVehicleLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadVehicleReport(onError: (val) => errorText = val);
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");
      emit(state.copyWith(isLoading: false, error: errorText, vehicleFile: val, isVehicleLoading: false));
    });

    on<ReportEarningEvent>((event, emit) async {
      if (state.earningFile != null) {
        state.earningFile.toString().open;
        return;
      }
      emit(state.copyWith(isLoading: true, isEarningLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadEarningSummary(onError: (val) => errorText = val);
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");
      emit(state.copyWith(isLoading: false, error: errorText, earningFile: val, isEarningLoading: false));
    });

    on<ReportVehicleInventoryEvent>((event, emit) async {
      if (state.vehicleInventoryFile != null) {
        state.vehicleInventoryFile.toString().open;
        return;
      }
      emit(state.copyWith(isLoading: true, isVehicleInventoryLoading: true));
      String? errorText;
      var val = await _reportRepository.downloadVehicleInventoryData(onError: (val) => errorText = val);
      if (errorText?.isNotEmpty ?? false) Utils.showMobileToast("$errorText");

      emit(state.copyWith(isLoading: false, error: errorText, vehicleInventoryFile: val, isVehicleInventoryLoading: false));
    });

    on<ReportTollsEvent>((event, emit) async{
      //Open file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],//types allowed
      );
      if (result != null && result.files.single.path != null) {
        file = File(result.files.single.path!);
        fileName = p.basename(file?.path ?? '');
        tolls.text = fileName!;
        log("${p.basename(file!.path)}", name: "File_name");
        log("${file?.path}", name: "File_name");
        emit(state.copyWith(tollsFile: file));
      }
    });

    on<UploadFileEvent>((event, emit) async {
      if (state.tollsFile == null) return;
      log("${state.tollsFile}", name: "File_Path");
      var response = await _reportRepository.uploadFile(state.tollsFile?.path.toString() ?? '');
      if(response == true){
        tolls.clear();
        emit(state.copyWith(tollsFile: null));
      }
      log("${state.tollsFile?.path ?? ''}");
      log("${response}");
    });

  }

}