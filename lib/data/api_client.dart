
import 'dart:io';

import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:talker/talker.dart' show Talker;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:talker_http_logger/talker_http_logger.dart';

class ApiClient {

  // get client => http.Client();

  InterceptedClient get client {
    final talker = Talker();
    final client = InterceptedClient.build(interceptors: [
      TalkerHttpLogger(talker: talker),
    ]);
    return client;
  }

  Future<HttpClientResponse?>  callHttpClientGetMethod(String url) async{
    if(await Utils.connection()) {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      return response;
    }else{
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  Future<http.Response?>  callGetMethod(String url) async{
    if(await Utils.connection()) {
      http.Response response = await compute(_getCompute, {
        "url" : url,
        "token" : Utils.getHeadersWithToken(),
      });
      // http.Response response = await client.get(Utils.getUri(url),
      //     headers: Utils.getHeadersWithToken());
      return response;
    }else{
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  Future<http.Response?>  callPostMethodWithoutBodyHeader(String url) async{
    if(await Utils.connection()) {
      http.Response response = await client.post(Utils.getUri(url));
      return response;
    }else{
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;

    }
  }

  Future<http.Response?>  callDelete(String url) async{
    if(await Utils.connection()) {
    //   http.Response response = await client.delete(Utils.getUri(url),
    //       headers: Utils.getHeadersWithToken(),
    // );
      http.Response response = await compute(_deleteCompute, {
        "url" : url,
        "token" : Utils.getHeadersWithToken(),
      });
      return response;
    }else{
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;

    }
  }

  Future<http.Response?> callPutMethod(String url, {String body='', bool tokenNoNeed = false, bool doNotShowToast = false}) async{
    if(await Utils.connection()) {
      if(tokenNoNeed){
        //debugPrint('Utils.getHeaders(): ${Utils.getHeaders()}');
      }else{
      //  debugPrint('Utils.getHeaders(): ${Utils.getHeadersWithToken()}');
      }
      http.Response response = await client.put(Utils.getUri(url),
          headers: tokenNoNeed ? Utils.getHeaders() : Utils.getHeadersWithToken(),
          body: body);
      return response;
    }else{
      if(!doNotShowToast) {
        Utils.showMobileToast(Str.checkInternetConnectionAlert);
      }
      return null;
    }
  }

  Future<http.Response?> callPostMethod(String url, {String body='', bool tokenNoNeed = false, bool doNotShowToast = false}) async{
    if(await Utils.connection()) {
      if(tokenNoNeed){
        debugPrint('Utils.getHeaders(): ${Utils.getHeaders()}');
      }else{
        debugPrint('Utils.getHeaders(): ${Utils.getHeadersWithToken()}');
      }
      http.Response response = await client.post(Utils.getUri(url),
          headers: tokenNoNeed ? Utils.getHeaders() : Utils.getHeadersWithToken(),
          body: body);
      return response;
    }else{
      if(!doNotShowToast) {
        Utils.showMobileToast(Str.checkInternetConnectionAlert);
      }
      return null;
    }
  }

  Future<http.Response> _getCompute(dynamic message) async {
    return await client.get(Utils.getUri(message['url']),
        headers: message['token'],
      params: message['params']
    );
  }

  Future<http.Response> _deleteCompute(dynamic message) async {
    return await client.delete(Utils.getUri(message['url']),
        headers: message['token'],
        params: message['params']
    );
  }
}