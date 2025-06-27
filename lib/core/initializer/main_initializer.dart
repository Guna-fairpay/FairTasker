import 'dart:isolate';
import 'dart:ui';

import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';

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
      Console.of.log("✅ Main isolate received from WorkManager isolate");
      // ✅ TODO: Update your UI, Bloc, etc here
      FBroadcast.instance().broadcast(Str.valueChange, value: message, persistence: true);
    });
  }
}