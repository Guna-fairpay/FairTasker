import 'dart:developer' show log;

import 'package:dio/dio.dart';

class DioTimeInterceptor extends InterceptorsWrapper {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final start = err.requestOptions.extra['startTime'] as DateTime?;
    if (start != null) {
      final duration = DateTime.now().difference(start);
      log('❌ [${err.requestOptions.uri}] failed after ${duration.inMilliseconds} ms');
    }
    return handler.next(err);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final start = response.requestOptions.extra['startTime'] as DateTime?;
    if (start != null) {
      final duration = DateTime.now().difference(start);
      log('🔁 [${response.requestOptions.path}] took ${duration.inMilliseconds} ms');
    }
    return handler.next(response);
  }
}