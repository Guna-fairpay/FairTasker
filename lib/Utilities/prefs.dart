import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  Session._();
  static final Session of = Session._();

  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    log("Session has been initialized", name: "Session");
  }

  void _write(String key, dynamic value) {
    switch (value.runtimeType) {
      case const (int): _preferences.setInt(key, value);
      case const (double): _preferences.setDouble(key, value);
      case const (bool): _preferences.setBool(key, value);
      case const (String): _preferences.setString(key, value);
      case const (List): _preferences.setStringList(key, value);
      case const (Map): _preferences.setString(key, value.toString());
    }
  }

  T _read<T>(String key, T defaultValue) {
    if (T == int) {
      return (_preferences.getInt(key) ?? defaultValue) as T;
    } else if (T == double) {
      return (_preferences.getDouble(key) ?? defaultValue) as T;
    } else if (T == bool) {
      return (_preferences.getBool(key) ?? defaultValue) as T;
    } else if (T == String) {
      return (_preferences.getString(key) ?? defaultValue) as T;
    } else if (T == List<String>) {
      return (_preferences.getStringList(key) ?? defaultValue) as T;
    } else if (T == Map) {
      return ((_preferences.getString(key) == null) ? defaultValue : jsonDecode(_preferences.getString(key)!)) as T;
    } else {
      throw ArgumentError('Unsupported type: $T');
    }
  }

  String? getString(String key) => _preferences.getString(key);
  int? getInt(String key) => _preferences.getInt(key);
  bool? getBool(String key) => _preferences.getBool(key);
  double? getDouble(String key) => _preferences.getDouble(key);
  Map? getMap(String key) {
    var value = getString(key);
    if (value != null) {
      return jsonDecode(value);
    } else {
      return null;
    }
  }
  List<String>? getStringList(String key) => _preferences.getStringList(key);

  T get<T>(String key, T defaultValue) => _read(key, defaultValue);
  set(String key, dynamic value) => _write(key, value);

  Future<void> clear() async => await _preferences.clear();

}