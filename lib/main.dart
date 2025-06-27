import 'package:fairpytasker/core/app/helper/work_manager_helper.dart';
import 'package:fairpytasker/core/initializer/main_initializer.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/core/app/config/easy_loading_config.dart';
import 'package:fairpytasker/UI/fairtasker/fair_tasker_app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fairpytasker/core/app/build_flavor/flavor.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:workmanager/workmanager.dart';

final Flavor flavor = Flavor.debug; // SHOULD NOT CHANGE UNTIL GET PROPER PERMISSION FROM THE LEAD

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // Required for the line below
    await Firebase.initializeApp();
    await Session.of.init();
    Initializer.of.init(); // GET_IT INITIALIZATION
    WorkManagerBridge.setupMainIsolatePort();
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    FlutterError.onError = (error) {
      FlutterError.presentError(error);
      FirebaseCrashlytics.instance.recordFlutterFatalError(error);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(const FairTaskerApp());
    EasyLoadingConfig.config();
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, printDetails: true, fatal: true));
}
