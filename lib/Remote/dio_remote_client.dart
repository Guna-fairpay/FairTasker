import 'package:fairpytasker/data/dio_client.dart';
import 'package:flutter/foundation.dart';

class RemoteClient<T> extends DioClient {

  static RemoteClient? _instance;

  RemoteClient._();

  static RemoteClient get instance {
    _instance ??= RemoteClient._();
    return _instance!;
  }
  
  Future<T?> getRequest(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      var response = await compute(handler, {
        "url" : url,
        "queryParameters" : queryParameters,
        "method" : "get",
        "headers" : headers(url: url),
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<T?> postRequest(String url, {Map<String, dynamic>? queryParameters, dynamic data}) async {
    try {
      var response = await compute(handler, {
        "url" : url,
        "queryParameters" : queryParameters,
        "method" : "post",
        "headers" : headers(url: url),
        "data" : data,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<T?> putRequest(String url, {Map<String, dynamic>? queryParameters, dynamic data}) async {
    try {
      var response = await compute(handler, {
        "url" : url,
        "queryParameters" : queryParameters,
        "method" : "put",
        "headers" : headers(url: url),
        "data" : data,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<T?> deleteRequest(String url, {Map<String, dynamic>? queryParameters, dynamic data}) async {
    try {
      var response = await compute(handler, {
        "url" : url,
        "queryParameters" : queryParameters,
        "method" : "delete",
        "headers" : headers(url: url),
        "data" : data,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}