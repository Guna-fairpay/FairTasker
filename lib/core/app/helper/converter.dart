import 'dart:convert';
import 'package:flutter/foundation.dart';

/// A generic method to parse a string into a given type T using compute.
Future<T> parseString<T>(String input, T Function(Map<String, dynamic> json) fromJson) async {
  return compute(_parseHelper, _ParseArgs(input, fromJson));
}

/// Helper function to perform parsing off the main thread.
T _parseHelper<T>(_ParseArgs<T> args) {
  final Map<String, dynamic> jsonMap = jsonDecode(args.input);
  return args.fromJson(jsonMap);
}

/// A class to encapsulate arguments for the compute function.
class _ParseArgs<T> {
  final String input;
  final T Function(Map<String, dynamic>) fromJson;

  _ParseArgs(this.input, this.fromJson);
}
