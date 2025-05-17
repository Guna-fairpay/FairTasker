import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/device_info_helper.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class Downloader {

  Downloader._();

  static final Downloader instance = Downloader._();

  Future<String?> start(String path, {Function(String?)? onError, bool openFile = false}) async {

    try {
      // Check and request storage permission
      if (Platform.isAndroid) {
        var status = (await DeviceInfoHelper.of.isBelow13) ? await Permission.storage.request() : await Permission.manageExternalStorage.request();
        if (!status.isGranted) throw Exception('Storage permission not granted');
      }

      // Get the Downloads directory
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      } else throw Exception('Unsupported platform');

      // Create Dio instance
      final dio = Dio();
      dio.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printResponseMessage: true,
          ),
        ),
      );


      // Make a HEAD request to fetch the headers (optional for getting filename)
      Response headResponse = await dio.head(path);
      String? fileName;

      // Extract the file name from Content-Disposition header
      if (headResponse.headers['content-disposition'] != null) {
        var contentDisposition = headResponse.headers['content-disposition']!.first;
        var fileNameMatch = RegExp(r'filename=([^;]+)').firstMatch(contentDisposition);
        if (fileNameMatch != null) {
          fileName = fileNameMatch.group(1)?.replaceAll(RegExp(r'"'), '').trim();
        }
      } else {
        fileName = path.split("/").lastOrNull;
      }

      // Ensure fileName is not null
      if (fileName == null || fileName.isEmpty) throw Exception('Failed to extract file name from headers.');

      final filePath = '${downloadsDirectory.path}/$fileName';

      // Download the file
      await dio.download(
        path,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );
      if (openFile) {
        Toaster.showSuccess("File downloaded successfully!");
        filePath.open;
      }

      print('File downloaded to: $filePath');
      return filePath;
    } catch (e) {
      if ((e is DioException) && (e.type == DioExceptionType.badResponse)) {
        var response = e.response?.data;
        if (response is Map<String, dynamic>) {
          onError?.call(response.values.last);
          throw Exception(response.values.last);
        } else {
          throw Exception("${e.response?.statusCode} : ${e.message}");
        }
      } else {
        debugPrint('Error downloading file: $e');
        throw Exception('Error downloading file: $e');
      }
    }
  }

}