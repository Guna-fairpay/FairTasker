import 'dart:async' show Completer;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CommonHelper {
  CommonHelper._();

  static final CommonHelper instance = CommonHelper._();

  final navigatorKey = GlobalKey<NavigatorState>();

  Future<void> waitForPostFrameCallback() {
    final Completer<void> completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) => completer.complete());
    return completer.future;
  }

  Future<File?> pickVideo() async {
    var result = await ImagePicker().pickVideo(source: ImageSource.camera);
    return (result != null) ? File(result.path) : null;
  }

  Future<File?> pickImage() async {
    var result = await ImagePicker().pickImage(source: ImageSource.camera);
    return (result != null) ? File(result.path) : null;
  }

  Future<File?> pickMedia() async {
    var result = await ImagePicker().pickMedia();
    return (result != null) ? File(result.path) : null;
  }

  Future<List<File>?> pickImages() async {
    var result = await ImagePicker().pickMultiImage();
    return ((result.isNotEmpty)) ? result.map((e) => File(e.path)).toList() : null;
  }

  Future<List<File>?> pickMedias() async {
    var result = await ImagePicker().pickMultipleMedia();
    return ((result.isNotEmpty)) ? result.map((e) => File(e.path)).toList() : null;
  }

  Future<List<File>> pickFiles({FileType type = FileType.any, List<String>? allowedExtensions}) async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true,
      type: type,
      allowedExtensions: allowedExtensions
    );
    return result?.paths.where((element) => (element?.isNotEmpty ?? false)).map((e) => File(e!)).toList() ?? [];
  }
}