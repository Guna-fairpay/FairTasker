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

    bool registered = IsolateNameServer.registerPortWithName(
      _receivePort!.sendPort,
      'workmanager_send_port',
    );
    Console.of.debug("✅ Port registered: $registered");

    _receivePort?.listen((dynamic message) {
      Console.of.log("✅ Main isolate received from WorkManager isolate (${message.runtimeType})");
      // ✅ TODO: Update your UI, Bloc, etc here
      if (message is Map) {
        switch(message.keys.first) {
          case "fetchToDoApi": getIt<CommonService>().initializeTasker(jsonDecode(message['fetchToDoApi'])); break;
          case "fetchBearerTokenApi" : {
            var response = jsonDecode(message['fetchBearerTokenApi']);
            Session.of.set(Str.frBearerToken, (response['data'] ?? ""));
            Utils.setStringPreference(Str.frBearerToken, (response['data'] ?? ""));
            Console.of.debug("🕒 Initialized BearerToken", name: "WorkManagerBridge");
          } break;
          case "fetchBranchApi" : getIt<CommonService>().initializeBranch(jsonDecode(message['fetchBranchApi'])); break;
          case "getCohortsData" : getIt<CommonService>().initializeCohort(jsonDecode(message['getCohortsData'])); break;
        }
      }
    });
  }
}