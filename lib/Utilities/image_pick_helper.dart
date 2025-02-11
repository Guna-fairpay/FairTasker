
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

class MultiImagePickHelpers {
  // This is for storing file paths (or you can store XFile if you want)
  List<XFile> selectedFiles = [];

  Future<List<XFile>> getMultiImage(ImageSource source) async {
    try {
      // Picking multiple images with specified parameters
      List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 40,
      );

      if (pickedFiles != null) {
        // Add only unique files (avoids duplicates)
        for (var file in pickedFiles) {
          if (!selectedFiles.contains(file)) {
            selectedFiles.add(file);
          }
        }
      }
    } catch (e) {
      print("Error picking images: $e");
    }

    return selectedFiles;  // Return a list of XFile objects
  }
}


