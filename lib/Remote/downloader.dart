import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class Downloader {

  Downloader._();

  static final Downloader instance = Downloader._();

  Future<String?> start(String path, {Function(String?)? onError}) async {

    try {
      // Check and request storage permission
      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission not granted');
        }
      }

      // Get the Downloads directory
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      } else {
        throw Exception('Unsupported platform');
      }

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
      }

      // Ensure fileName is not null
      if (fileName == null || fileName.isEmpty) {
        throw Exception('Failed to extract file name from headers.');
      }

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

      print('File downloaded to: $filePath');
      return filePath;
    } catch (e) {
      if ((e is DioException) && (e.type == DioExceptionType.badResponse)) {
        var response = e.response?.data;
        if (response is Map<String, dynamic>) print("Error: ${response.values.last}");
        if (response is Map<String, dynamic>) onError?.call(response.values.last);
      } else {
        debugPrint('Error downloading file: $e');
      }
    }
  }

}