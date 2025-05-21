import 'dart:async';
import 'dart:io';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:path/path.dart' show basename;
import 'package:fairpytasker/UI/dialog/reclean/bloc/reclean_events.dart';
import 'package:fairpytasker/UI/dialog/reclean/bloc/reclean_states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecleanBloc extends Bloc<RecleanEvent, RecleanState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController fileController = TextEditingController();
  List<dynamic> reasonFiles = [];
  bool isReasonEnabled = false;
  Map<String, dynamic> model = {};
  RecleanBloc() : super(RecleanLoadingState()) {
    on<RecleanInitialEvent>(_onInitialEvent);
    on<RecleanTriggerEvent>(_onTriggerEvent);
    on<RecleanPickFileEvent>(_onPickFileEvent);
    on<RecleanDeleteFileEvent>(_onDeleteFileEvent);
    on<RecleanSubmitEvent>(_onSubmitEvent);
    on<RecleanCloseEvent>(_onCloseEvent);
  }

  void _onInitialEvent(RecleanInitialEvent event, Emitter<RecleanState> emit) {
    model = event.model ?? {};
    emit(RecleanCommonState());
  }

  void _onTriggerEvent(RecleanTriggerEvent event, Emitter<RecleanState> emit) {
    isReasonEnabled = !isReasonEnabled;
    emit(RecleanCommonState());
  }

  void _onPickFileEvent(RecleanPickFileEvent event, Emitter<RecleanState> emit) async {
    try {
      var response = await _pickFiles();
      if (response != null) {
        var filePaths = reasonFiles.map((e) => e.path).toList();
        for (var element in response) {
          if (!filePaths.contains(element.path)) {
            reasonFiles.add(element);
          }
        }
        var filePath = reasonFiles.whereType<File>().lastOrNull?.path;
        if (filePath.isNotNullOrEmpty) {
          fileController.text = basename(filePath ?? "");
        } else {
          fileController.clear();
        }
        emit(RecleanCommonState());
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      Toaster.showError("$e");
    }
  }

  Future<List<File>?> _pickFiles() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        allowCompression: false,
      );
      return result?.files.map((e) => File(e.path ?? "")).toList();
    } catch (e) {
      rethrow;
    }
  }

  void _onDeleteFileEvent(RecleanDeleteFileEvent event, Emitter<RecleanState> emit) {
    reasonFiles.remove(event.model);
    var filePath = reasonFiles.whereType<File>().lastOrNull?.path;
    if (filePath.isNotNullOrEmpty) {
      fileController.text = basename(filePath ?? "");
    } else {
      fileController.clear();
    }
    emit(RecleanCommonState());
  }

  void _onSubmitEvent(RecleanSubmitEvent event, Emitter<RecleanState> emit) {
    if (formKey.currentState?.validate() == false) return;
    emit(RecleanSubmitState(reasonController.text, reasonFiles));
  }

  void _onCloseEvent(RecleanCloseEvent event, Emitter<RecleanState> emit) {
    emit(RecleanCloseState());
  }
}