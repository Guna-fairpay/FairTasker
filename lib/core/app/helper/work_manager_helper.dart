import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fairpytasker/Remote/dio_remote_client.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    log("🚀 Running task: $task with data: $inputData ${Str.BASE_URL} CHECKING" , name: "WorkManager");
    var response = switch(task) {
      "fetchToDoApi" => await _get(jsonDecode(inputData?['data'] ?? "")),
      String() => null,
    };
    log("🚀 Response Triggering" , name: "WorkManager");
    final SendPort? sendPort = IsolateNameServer.lookupPortByName('workmanager_send_port');

    if (sendPort != null) {
      sendPort.send(jsonEncode(response?.data ?? {}));
    } else {
      log("❌ No SendPort found. App probably killed or port not registered." , name: "WorkManager");
    }
    log("🚀 Response triggered" , name: "WorkManager");
    return Future.value(true);
  });
}

Future<Response> _get(Map<String, dynamic> mapData) async {
  return await Dio().get(mapData['url'], queryParameters: mapData['queryParameters'], options: Options(headers: mapData['headers']));
}

void triggerWM(Map<String, dynamic> mapData) {
  Workmanager().registerOneOffTask("apiFetchTask","fetchToDoApi", inputData: {"data": jsonEncode(mapData)});
}

void get triggerTasker {
  Map<String, dynamic> mapData = {
    "url" :  "${Str.BASE_URL}todo-data-mod",
    "queryParameters" : {"showOther": true},
    "method" : "get",
    "headers" : Utils.getHeadersWithToken(url: "${Str.BASE_URL}todo-data-mod"),
  };
  triggerWM(mapData);
}