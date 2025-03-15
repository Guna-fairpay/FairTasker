import 'dart:async' show Completer;

import 'package:flutter/material.dart';

class CommonHelper {
  CommonHelper._();

  static final CommonHelper instance = CommonHelper._();

  Future<void> waitForPostFrameCallback() {
    final Completer<void> completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) => completer.complete());
    return completer.future;
  }
}