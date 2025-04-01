import 'dart:developer' as developer;
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' show ConsoleOutput, DevelopmentFilter, Logger, OutputEvent, PrettyPrinter, ProductionFilter;

class Console {
  Console._();
  static final Console of = Console._();
  bool get _isDebug => kDebugMode;
  final Logger _logger = Logger(
    printer: PrettyPrinter(methodCount: 0, errorMethodCount: 30, colors: true),
    // filter: (kDebugMode) ? DevelopmentFilter() : ProductionFilter(),
    level: Logger.level,
    // output: MyConsoleOutput()
  );
  void log(dynamic message, {String name = "Console", Object? error, StackTrace? stackTrace}) {
    if (_isDebug) {
      if ("$message".length > 120) {
        developer.log("$message", error: error, stackTrace: stackTrace, name: name);
      } else {
        _logger.i("[$name] $message", error: error, stackTrace: stackTrace);
      }
    }
  }

  void error(dynamic message, {String name = "Console", Object? error, StackTrace? stackTrace}) {
    if (_isDebug) {
      if ("$message".length > 120) {
        developer.log("$message", error: error, stackTrace: stackTrace, name: name);
      } else {
        _logger.e("[$name] $message", error: error, stackTrace: stackTrace);
      }
    }
  }

  void debug(dynamic message, {String name = "Console", Object? error, StackTrace? stackTrace}) {
    if (_isDebug) {
      if ("$message".length > 120) {
        developer.log("$message", error: error, stackTrace: stackTrace, name: name);
      } else {
        _logger.d("[$name] $message", error: error, stackTrace: stackTrace);
      }
    }
  }

  void warning(dynamic message, {String name = "Console", Object? error, StackTrace? stackTrace}) {
    if (_isDebug) {
      if ("$message".length > 120) {
        developer.log("$message", error: error, stackTrace: stackTrace, name: name);
      } else {
        _logger.w("[$name] $message", error: error, stackTrace: stackTrace);
      }
    }
  }
}

class MyConsoleOutput extends ConsoleOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(developer.log);
  }
}