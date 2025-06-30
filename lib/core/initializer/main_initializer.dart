import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';

class WorkManagerBridge {
  static ReceivePort? _receivePort;

  static void setupMainIsolatePort() {
    _receivePort = ReceivePort();
    const portName = 'workmanager_send_port';

    IsolateNameServer.removePortNameMapping(portName);
    bool registered = IsolateNameServer.registerPortWithName(_receivePort!.sendPort, portName);
    Console.of.debug("✅ Port registered: $registered");

    _receivePort?.listen((dynamic message) {
      Console.of.log("✅ Main isolate received from WorkManager isolate (${message.runtimeType})");
      // ✅ TODO: Update your UI, Bloc, etc here
      if (message is Map) {
        if (message.containsKey("fetchAllApi")) {
          var newMessage = message['fetchAllApi'];
          for (var element in newMessage.entries) {
            Console.of.log("✅ Main isolate (${element.key})");
            switch(element.key) {
              case "fetchToDoApi": getIt<CommonService>().initializeTasker(jsonDecode(element.value)); break;
              case "fetchBearerTokenApi" : {
                var response = jsonDecode(element.value);
                Session.of.set(Str.frBearerToken, (response['data'] ?? ""));
                Utils.setStringPreference(Str.frBearerToken, (response['data'] ?? ""));
                Console.of.debug("🕒 Initialized BearerToken", name: "WorkManagerBridge");
              } break;
              case "fetchBranchApi" : getIt<CommonService>().initializeBranch(jsonDecode(element.value)); break;
              case "fetchCohortApi" : getIt<CommonService>().initializeCohort(jsonDecode(element.value)); break;
            }
          }
        } else {
          switch(message.keys.first) {
            case "fetchToDoApi": getIt<CommonService>().initializeTasker(message['fetchToDoApi']); break;
            case "fetchBearerTokenApi" : {
              var response = message['fetchBearerTokenApi'];
              Session.of.set(Str.frBearerToken, (response['data'] ?? ""));
              Utils.setStringPreference(Str.frBearerToken, (response['data'] ?? ""));
              Console.of.debug("🕒 Initialized BearerToken", name: "WorkManagerBridge");
            } break;
            case "fetchBranchApi" : getIt<CommonService>().initializeBranch(message['fetchBranchApi']); break;
            case "fetchCohortApi" : getIt<CommonService>().initializeCohort(message['getCohortsData']); break;
          }
        }
      }
    });
  }
}