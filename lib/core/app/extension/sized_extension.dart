import 'package:flutter/cupertino.dart';

extension SizedExtension on num {

  SizedBox get width => SizedBox(width: toDouble());
  SizedBox get height => SizedBox(height: toDouble());

  EdgeInsets get padding => EdgeInsets.all(toDouble());
}