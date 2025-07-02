import 'package:dio/dio.dart';
import 'package:fairpytasker/Remote/dio_time_interceptor.dart';
import 'package:talker/talker.dart' show Talker;
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

abstract class DioClient {
  final Dio _dio = Dio(BaseOptions(
    sendTimeout: const Duration(seconds: 30),
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    responseType: ResponseType.json,
    maxRedirects: 2,
  ))..interceptors.addAll([
    TalkerDioLogger(talker: Talker(), settings: const TalkerDioLoggerSettings(printRequestExtra: true, printRequestHeaders: true, printResponseHeaders: true, printResponseRedirects: true, printResponseData: false)),
    DioTimeInterceptor()
  ]);


  String get _returnBearerToken => Session.of.getString(Str.frBearerToken).toBearer;

  String get _bearerToken => Session.of.getString(Str.accessTokenPrefText).toBearer;

  Map<String, String> headers({required String url}) {
    var token = (url.isFairReturns) ? _returnBearerToken : _bearerToken;
    Map<String, String> header = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Encoding': 'gzip',
    };
    if (Session.of.getBool(Str.loginPrefText) ?? false) header['Authorization'] = token;
    return header;
  }

  Future<Response> _get(String url,
          {Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) async =>
      await _dio.get(url,
          queryParameters: queryParameters, options: Options(headers: headers));

  Future<Response> _post(String url,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) async =>
      await _dio.post(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));

  Future<Response> _put(String url,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) async =>
      await _dio.put(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));

  Future<Response> _delete(String url,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) async =>
      await _dio.delete(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));

  Future<Response> _patch(String url,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) async =>
      await _dio.patch(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));

  Future<Response> _head(String url,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) async =>
      await _dio.head(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      return await _get(url,
          queryParameters: queryParameters, headers: headers);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response> post(String url,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      return await _post(url,
          data: data, queryParameters: queryParameters, headers: headers);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response> put(String url,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      return await _put(url,
          data: data, queryParameters: queryParameters, headers: headers);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response> delete(String url,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      return await _delete(url,
          data: data, queryParameters: queryParameters, headers: headers);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response> patch(String url,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      return await _patch(url,
          data: data, queryParameters: queryParameters, headers: headers);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response> head(String url,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      return await _head(url,
          data: data, queryParameters: queryParameters, headers: headers);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response> handler(dynamic value) {
    String url = "";
    String method = "get";
    Map<String, dynamic>? queryParameters;
    Map<String, dynamic>? headers;
    Object? data;
    if (value is Map) {
      url = value['url'];
      method = value['method'];
      queryParameters = value['queryParameters'];
      headers = value['headers'];
      data = value['data'];
    } else if (value is String) {
      url = value;
    }
    return switch(method) {
      "get" => get(url, queryParameters: queryParameters, headers: headers),
      "post" => post(url, data: data, queryParameters: queryParameters, headers: headers),
      "put" => put(url, data: data, queryParameters: queryParameters, headers: headers),
      "delete" => delete(url, data: data, queryParameters: queryParameters, headers: headers),
      "patch" => patch(url, data: data, queryParameters: queryParameters, headers: headers),
      "head" => head(url, data: data, queryParameters: queryParameters, headers: headers),
      _ => throw Exception("Invalid method"),
    };
  }
}
