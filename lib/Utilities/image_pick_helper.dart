
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickHelper {
  File? selectedFile;

  Future getSingleImage(ImageSource source) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(
          source: source,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 40
        );
    if (pickedFile != null) {
      selectedFile = File(pickedFile.path);
      return selectedFile;
    } else {
      return;
    }
  }
}

class MultiImagePickHelper {
  List<String> selectedFiles = [];

  Future<List<String>> getMultiImage(ImageSource source) async {
    try {
      List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 40,
      );

      for (var file in pickedFiles) {
        if (!selectedFiles.contains(file.path)) {
          selectedFiles.add(file.path);
        }
      }
        } catch (e) {
      print("Error picking images: $e");
    }

    return selectedFiles;
  }
}


