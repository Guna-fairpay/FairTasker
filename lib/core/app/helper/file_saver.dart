import 'dart:developer';
import 'dart:io';

import 'package:fairpytasker/Utilities/utils.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileSaver {
  FileSaver._();

  static final FileSaver instance = FileSaver._();

  Future<String> saveFile(http.Response response) async {
    // Get the Downloads directory
    Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDirectory = await getApplicationDocumentsDirectory();
    } else {
      throw Exception('Unsupported platform');
    }
    var headResponse = response.headers;
    String? fileName;
    if (headResponse['content-disposition'] != null) {
      var contentDisposition = headResponse['content-disposition'];
      log("$contentDisposition", name: "FILE_SAVER");
      var fileNameMatch = RegExp(r'filename=([^;]+)').firstMatch(contentDisposition ?? '');
      if (fileNameMatch != null) {
        fileName = fileNameMatch.group(1)?.replaceAll(RegExp(r'"'), '').trim();
      }
    }

    if (fileName == null || fileName.isEmpty) {
      throw Exception('Failed to extract file name from headers.');
    }

    var filePath = '${downloadsDirectory.path}/$fileName';
    File newFile = File(filePath);
    if (!(await newFile.exists())) {
      await newFile.create(recursive: true);
    }

    if (await newFile.exists()) {
      var file = await newFile.writeAsBytes(response.bodyBytes);
      filePath = file.path;
    }
    return filePath;
  }
}