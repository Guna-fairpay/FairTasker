import 'dart:io';

import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:image_picker/image_picker.dart';

extension DynoExtension on Object? {

  bool get isImage {
    if (this == null) return false;
    var input = this;
    if (input is String) return input.isImageFile;
    if (input is File) return input.path.isImageFile;
    if (input is XFile) return input.mimeType.isImageFile;
    return false;
  }
}