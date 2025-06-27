import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    log("🚀 Running task: $task with data: $inputData ${Str.BASE_URL} CHECKING" , name: "WorkManager");
    var dio = Dio();
    var response = await _get(dio, jsonDecode(inputData?['data'] ?? ""));
    log("🚀 Response Triggering" , name: "WorkManager");
    final SendPort? sendPort = IsolateNameServer.lookupPortByName('workmanager_send_port');

    if (sendPort != null) {
      sendPort.send({task : jsonEncode(response.data ?? {})});
    } else {
      log("❌ No SendPort found. App probably killed or port not registered." , name: "WorkManager");
    }
    log("🚀 Response triggered" , name: "WorkManager");
    return Future.value(true);
  });
}

Future<Response> _get(Dio dio, Map<String, dynamic> mapData) async {
  return await switch(mapData['method']) {
    "get" => dio.get(mapData['url'], queryParameters: mapData['queryParameters'], options: Options(headers: mapData['headers'])),
    "post" => dio.post(mapData['url'], data: mapData['data'], queryParameters: mapData['queryParameters'], options: Options(headers: mapData['headers'])),
    _ => dio.get(mapData['url'], queryParameters: mapData['queryParameters'], options: Options(headers: mapData['headers'])),
  };
}

void triggerWM(Map<String, dynamic> mapData, {String task = "fetchToDoApi"}) {
  String uniqueId = "${task}_${DateTime.now().millisecondsSinceEpoch}";
  Workmanager().registerOneOffTask(uniqueId,task, inputData: {"data": jsonEncode(mapData)});
}

void get triggerAll {
  Map<String, dynamic> mapData = {
    "fetchToDoApi" : _todoMapData,
    "fetchBranchApi" : _getBranch,
    "fetchCohortApi" : _getCohort,
    "fetchBearerTokenApi" : _getBearerToken,
  };
  triggerWM(mapData, task: "fetchAllApi");
}

void get triggerTasker {
  var url = "${Str.BASE_URL}todo-data-mod";
  Map<String, dynamic> mapData = {
    "url" :  url,
    "queryParameters" : {"showOther": true},
    "method" : "get",
    "headers" : Utils.getHeadersWithToken(url: url),
  };
  triggerWM(mapData);
}

void get triggerCohort {
  var url = "${Str.LIST_BASE_URL}getCohortsData";
  Map<String, dynamic> mapData = {
    "url" :  url,
    "queryParameters" : {},
    "method" : "get",
    "headers" : Utils.getHeadersWithToken(url: url),
  };
  triggerWM(mapData, task: "fetchCohortApi");
}

void get triggerBranch {
  var url = "${Str.BASE_URL}getBranch";
  Map<String, dynamic> mapData = {
    "url" :  url,
    "queryParameters" : {},
    "method" : "get",
    "headers" : Utils.getHeadersWithToken(url: url),
  };
  triggerWM(mapData, task: "fetchBranchApi");
}

void get triggerBearerToken {
  var url = "${Str.BASE_URL}getBearerToken";
  Map<String, dynamic> mapData = {
    "url" :  url,
    "queryParameters" : {},
    "method" : "post",
    "headers" : Utils.getHeadersWithToken(url: url),
  };
  triggerWM(mapData, task: "fetchBearerTokenApi");
}

Map<String, dynamic> get _todoMapData {
  var url = "${Str.BASE_URL}todo-data-mod";
  Map<String, dynamic> mapData = {
    "url" :  url,
    "queryParameters" : {"showOther": true},
    "method" : "get",
    "headers" : Utils.getHeadersWithToken(url: url),
  };
  return mapData;
}

Map<String, dynamic> get _getBranch {
  var url = "${Str.BASE_URL}getBranch";
  Map<String, dynamic> mapData = {
    "url" :  url,
    "queryParameters" : {},
    "method" : "get",
    "headers" : Utils.getHeadersWithToken(url: url),
  };
  return mapData;
}

Map<String, dynamic> get _getBearerToken {
  var url = "${Str.BASE_URL}getBearerToken";
  Map<String, dynamic> mapData = {
    "url" :  url,
    "queryParameters" : {},
    "method" : "post",
    "headers" : Utils.getHeadersWithToken(url: url),
  };
  return mapData;
}

Map<String, dynamic> get _getCohort {
  var url = "${Str.LIST_BASE_URL}getCohortsData";
  Map<String, dynamic> mapData = {
    "url" :  url,
    "queryParameters" : {},
    "method" : "get",
    "headers" : Utils.getHeadersWithToken(url: url),
  };
  return mapData;
}