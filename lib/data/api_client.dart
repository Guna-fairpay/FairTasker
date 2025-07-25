import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/converter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:talker/talker.dart' show Talker;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:talker_http_logger/talker_http_logger.dart';
import 'package:talker_http_logger/talker_http_logger_settings.dart';

class ApiClient {
  // get client => http.Client()

  InterceptedClient get client {
    final talker = Talker();
    final client = InterceptedClient.build(interceptors: [
      TalkerHttpLogger(talker: talker),
    ]);
    return client;
  }

  Future<HttpClientResponse?> callHttpClientGetMethod(String url) async {
    if (await Utils.connection()) {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      return response;
    } else {
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  Future<http.Response?> callGetMethod(String url, {Map<String, dynamic>? params}) async {
    if (await Utils.connection()) {
      http.Response response = await compute(_getCompute, {
        "url": url,
        "token": Utils.getHeadersWithToken(url: url),
        "params" : params
      });
      // http.Response response = await client.get(Utils.getUri(url),
      //     headers: Utils.getHeadersWithToken());
      return response;
    } else {
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  Future<http.Response?> callPostMethodWithBody(String url,
      {Map<String, dynamic>? body,
      List<String>? files,
      String? fieldName,
      bool autoIncrement = false,
      int? lastImageIndex,
      int? lastVideoIndex}) async {
    if (await Utils.connection()) {
      http.Response response = await compute(_postMultiPartCompute, {
        "url": Uri.parse(url),
        "token": Utils.getHeadersWithToken(url: url),
        "fields": body,
        "files": files,
        "fieldName": fieldName,
        "autoIncrement": "$autoIncrement",
        "lastImageIndex": lastImageIndex,
        "lastVideoIndex": lastVideoIndex
      });
      return response;
    } else {
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  /// InfusedFiles must be one type "List<Map<String, String?>>" / Map<String, String?>
  /// Value always file path
  Future<http.Response?> callPostMethodWithBodyDynamic(String url, {Map<String, dynamic>? body, dynamic infusedFiles,  String? token}) async {
    if (await Utils.connection()) {
      http.Response response = await compute(_postMultiPartComputeDynamic, {
        "url": Uri.parse(url),
        "token": Utils.getHeadersWithToken(url: url, token: token),
        "fields": body,
        "infusedFiles": infusedFiles,
      });
      return response;
    } else {
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  Future<http.Response?> callPostMethodWithRawBody(String url,
      {Map<String, dynamic>? body, String method = "POST", String? token}) async {
    if (await Utils.connection()) {
      http.Response response = await compute(_postRawJsonCompute, {
        "url": Uri.parse(url),
        "method" : method,
        "token": Utils.getHeadersWithToken(url: url, token: token),
        "fields": body,
      });
      Console.of.log(jsonEncode(body));
      return response;
    } else {
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  Future<http.Response?> callPostMethodWithoutBodyHeader(String url) async {
    if (await Utils.connection()) {
      http.Response response = await client.post(Utils.getUri(url));
      return response;
    } else {
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  Future<http.Response?> callDelete(String url, {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    if (await Utils.connection()) {
      //   http.Response response = await client.delete(Utils.getUri(url),
      //       headers: Utils.getHeadersWithToken(),
      // );
      http.Response response = await compute(_deleteCompute, {
        "url": url,
        "token": Utils.getHeadersWithToken(url: url),
        "params" : params,
        "body" : jsonEncode(body),
      });
      return response;
    } else {
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  Future<http.Response?> callPutMethod(String url,
      {String body = '',
      bool tokenNoNeed = false,
      bool doNotShowToast = false}) async {
    if (await Utils.connection()) {
      if (tokenNoNeed) {
        //debugPrint('Utils.getHeaders(): ${Utils.getHeaders()}');
      } else {
        //  debugPrint('Utils.getHeaders(): ${Utils.getHeadersWithToken()}');
      }
      http.Response response = await client.put(Utils.getUri(url),
          headers:
              tokenNoNeed ? Utils.getHeaders() : Utils.getHeadersWithToken(url: url),
          body: body);
      return response;
    } else {
      if (!doNotShowToast) {
        Utils.showMobileToast(Str.checkInternetConnectionAlert);
      }
      return null;
    }
  }

  Future<http.Response?> callPostMethod(String url,
      {String body = '',
      bool tokenNoNeed = false,
      bool doNotShowToast = false}) async => await client.post(Utils.getUri(url),
      headers:
      tokenNoNeed ? Utils.getHeaders() : Utils.getHeadersWithToken(url: url),
      body: body);

  Future<http.Response> _getCompute(dynamic message) async {
    return await client.get(Utils.getUri(message['url']),
        headers: message['token'], params: message['params']);
  }

  Future<http.Response> _deleteCompute(dynamic message) async {
    return await client.delete(Utils.getUri(message['url']),
        headers: message['token'], params: message['params'], body: message['body']);
  }

  Future<http.Response> _postMultiPartCompute(dynamic message) async {
    var files = List<String>.from(message['files'] ?? []);
    List<http.MultipartFile> multiPartFiles = [];
    if (files.isNotEmpty) {
      if (message['fieldName'] != null) {
        multiPartFiles = (await Converter.instance.convertFilePathToMultipart(
                message['fieldName'],
                files: files,
                autoIncrementField: (message['autoIncrement'] == 'true'))) ??
            [];
      } else {
        multiPartFiles = (await Converter.instance
                .convertFilePathToMultipartWithFileTypeMemes(
                    files: files,
                    lastImageIndex: message['lastImageIndex'] ?? 0,
                    lastVideoIndex: message['lastVideoIndex'] ?? 0)) ??
            [];
      }
    }
    if (multiPartFiles.isNotEmpty) multiPartFiles.forEach((element) => Console.of.debug("TYPE:	${element.field} ${element.filename} ${element.contentType.type}", name: "MULTIPART_IMAGES"));
    var request = http.MultipartRequest("POST", message['url'])
      ..headers.addAll(message['token'])
      // ..fields.addAll(message['fields'])
      ..files.addAll(multiPartFiles);
    if (message['fields'] != null) {
      var fields = Map<String, dynamic>.from(message['fields']).map((key, value) => MapEntry(key, (value?.toString() ?? "")));
      Console.of.log(fields, name: "UPLOADED_FIELDS");
      request.fields.addAll(fields);
    }
    var streamedResponse = await client.send(request);
    var response = await streamedResponse.stream.bytesToString();
    Console.of.log("${streamedResponse.statusCode}: $response", name: "RESPONSE");
    return http.Response(response, streamedResponse.statusCode);
  }

  Future<http.Response> _postMultiPartComputeDynamic(dynamic message) async {
    var infusedFiles = message['infusedFiles'];
    Console.of.debug("${infusedFiles.runtimeType} ${infusedFiles is List}", name: "INFUSION_TYPE");
    List<http.MultipartFile> multiPartFiles = [];
    if (infusedFiles != null) {
      if (infusedFiles is List) {
        var files = List<Map<String, String?>>.from(message['infusedFiles'] ?? []);
        if (files.isNotEmpty) {
          multiPartFiles = (await Converter.instance.convertFilePathToMultipartDynamic(files: files)) ?? [];
        }
      } else if (infusedFiles is Map<String, String?>) {
        multiPartFiles = (await Converter.instance.convertFilePathToMultipartDynamicMap(files: infusedFiles)) ?? [];
      }
    }
    if (multiPartFiles.isNotEmpty) multiPartFiles.forEach((element) => Console.of.debug("TYPE:\t${element.field} ${element.filename} ${element.contentType.type}", name: "MULTIPART_IMAGES"));
    var request = http.MultipartRequest("POST", message['url']);
    if (multiPartFiles.isNotEmpty) request.files.addAll(multiPartFiles);
    if (message['fields'] != null) {
      var fields = Map<String, dynamic>.from(message['fields']).map((key, value) => MapEntry(key, (value?.toString() ?? "")));
      Console.of.log(jsonEncode(fields), name: "UPLOADED_FIELDS");
      request.fields.addAll(fields);
    }
    if (message['token'] != null) request.headers.addAll(message['token']);
    var streamedResponse = await client.send(request);
    var response = await streamedResponse.stream.bytesToString();
    Console.of.log("${streamedResponse.statusCode}: $response");
    return http.Response(response, streamedResponse.statusCode);
  }

  Future<http.Response> _postRawJsonCompute(dynamic message) async {
    var request = http.Request(message["method"] ?? "POST", message['url'])
      ..headers.addAll(message['token'])
      ..body = jsonEncode(message['fields']);
    var streamedResponse = await client.send(request);
    var response = await streamedResponse.stream.bytesToString();
    return http.Response(response, streamedResponse.statusCode);
  }
}
