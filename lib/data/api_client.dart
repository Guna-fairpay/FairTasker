
import 'dart:io';

import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {

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
      http.Response response = await http.get(Utils.getUri(url),
          headers: Utils.getHeadersWithToken());
      return response;
    }else{
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;
    }
  }

  Future<http.Response?>  callPostMethodWithoutBodyHeader(String url) async{
    if(await Utils.connection()) {
      http.Response response = await http.post(Utils.getUri(url));
      return response;
    }else{
      Utils.showMobileToast(Str.checkInternetConnectionAlert);
      return null;

    }
  }

  Future<http.Response?>  callDelete(String url) async{
    if(await Utils.connection()) {
      http.Response response = await http.delete(Utils.getUri(url),
          headers: Utils.getHeadersWithToken(),
    );
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
      http.Response response = await http.put(Utils.getUri(url),
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
      http.Response response = await http.post(Utils.getUri(url),
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
}