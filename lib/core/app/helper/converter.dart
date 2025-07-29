import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// A generic method to parse a string into a given type T using compute.
Future<T> parseString<T>(String? input, T Function(dynamic json) fromJson) async {
  return compute(_parseHelper, _ParseArgs(input, fromJson));
}

/// Helper function to perform parsing off the main thread.
T _parseHelper<T>(_ParseArgs<T> args) {
  return args.fromJson(jsonDecode(args.input ?? ""));
}

/// A class to encapsulate arguments for the compute function.
class _ParseArgs<T> {
  final String? input;
  final T Function(dynamic) fromJson;

  _ParseArgs(this.input, this.fromJson);
}

class Converter {

  Converter._();

  static final Converter instance = Converter._();

  Future<List<http.MultipartFile>?> convertFilePathToMultipart(String fieldName,{List<String>? files, bool autoIncrementField = true}) async {
    if (files == null || files.isEmpty) return null;
    return await Future.wait(files.asMap().entries.map((entry) async {
      int index = entry.key;
      String filePath = entry.value;
      var file = File(filePath);
      String fileName = basename(file.path);
      var field = (autoIncrementField) ? "$fieldName[$index]" : fieldName;

      return await http.MultipartFile.fromPath(field, file.path, filename: fileName);
    }));
  }

  Future<List<http.MultipartFile>?> convertFilePathToMultipartDynamic({required List<Map<String, String?>>? files}) async {
    if (files == null || files.isEmpty) return null;
    return await Future.wait(files.asMap().entries.map((entry) async {
      int index = entry.key;
      var fieldName = entry.value.keys.first;
      String filePath = entry.value.values.first ?? "";
      var file = File(filePath);
      String fileName = basename(file.path);
      var field = "$fieldName[$index]";
      return await http.MultipartFile.fromPath(field, file.path, filename: fileName);
    }));
  }

  Future<List<http.MultipartFile>?> convertFilePathToMultipartDynamicMap({required Map<String, String?>? files}) async {
    if (files == null || files.isEmpty) return null;
    return await Future.wait(files.entries.map((entry) async {
      var fieldName = entry.key;
      String filePath = entry.value ?? "";
      var file = File(filePath);
      String fileName = basename(file.path);
      Console.of.warning("Field: $fieldName, FilePath: $filePath");
      return await http.MultipartFile.fromPath(fieldName, file.path, filename: fileName);
    }));
  }

  Future<List<http.MultipartFile>?> convertFilePathToMultipartWithFileTypeMemes({List<String>? files, int lastImageIndex = 0, int lastVideoIndex = 0}) async {
    if (files == null || files.isEmpty) return null;
    List<http.MultipartFile> multipartFiles = [];
    multipartFiles.addAll(await Future.wait(files.asMap().entries.where((element) => element.value.isImageFile).map((entry) async {
      int index = entry.key;
      String filePath = entry.value;
      var file = File(filePath);
      var isImageFile = file.isImage;
      String fieldName = "images";
      String fileName = basename(file.path);
      var field = "$fieldName[${index + (isImageFile ? lastImageIndex : lastVideoIndex)}]";
      return await http.MultipartFile.fromPath(field, file.path, filename: fileName);
    })));
    multipartFiles.addAll(await Future.wait(files.asMap().entries.where((element) => !element.value.isImageFile).map((entry) async {
      int index = entry.key;
      String filePath = entry.value;
      var file = File(filePath);
      String fieldName = "videos";
      String fileName = basename(file.path);
      var field = "$fieldName[${index + lastVideoIndex}]";
      return await http.MultipartFile.fromPath(field, file.path, filename: fileName);
    })));
    return multipartFiles;
  }

  List<http.MultipartFile> convertFilesToMultipart(String fieldName,{List<File>? files, bool autoIncrementField = true}) {
    List<http.MultipartFile> multipartFiles = [];
    if (files != null && files.isNotEmpty) {
      files.forEachIndexed((index, e) {
        String fileName = basename(e.path);
        var stream = e.readAsBytesSync();
        var field = (autoIncrementField) ? "$fieldName[$index]" : fieldName;
        multipartFiles.add(http.MultipartFile.fromBytes(field, stream, filename: fileName));
      });
    }
    return multipartFiles;
  }

  Future<List<http.MultipartFile>?> convertFilePathToMultipartDynamicWithAutoIncrement({required List<Map<String, String?>>? files, required bool autoIncrementField}) async {
    if (files == null || files.isEmpty) return null;
    return await Future.wait(files.asMap().entries.map((entry) async {
      int index = entry.key;
      var fieldName = entry.value.keys.first;
      String filePath = entry.value.values.first ?? "";
      var file = File(filePath);
      String fileName = basename(file.path);
      var field = (autoIncrementField) ? "$fieldName[$index]" : fieldName;
      return await http.MultipartFile.fromPath(field, file.path, filename: fileName);
    }));
  }

}
