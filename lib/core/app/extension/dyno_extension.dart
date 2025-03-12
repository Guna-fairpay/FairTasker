import 'dart:io';

import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

extension DynoExtension on Object? {

  bool get isImage {
    if (this == null) return false;
    var input = this;
    if (input is String) return input.isImageFile;
    if (input is File) return input.path.isImageFile;
    if (input is XFile) return input.mimeType.isImageFile;
    return false;
  }

  bool get isPDF {
    if (this == null) return false;
    var input = this;
    if (input is String) return input.isPdf;
    if (input is File) return input.path.isPdf;
    if (input is XFile) return input.mimeType.isPdf;
    return false;
  }

  Future<void> get open async{
    if (this is! String) return;
    await OpenFile.open((this as String));
}
}