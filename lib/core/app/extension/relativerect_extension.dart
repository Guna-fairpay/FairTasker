import 'package:flutter/material.dart';

extension RelativerectExtension on Offset {
  RelativeRect toRelativeRect({BuildContext? context}) {
    return (context == null)
        ? RelativeRect.fromLTRB(dx, dy, dx, dy)
        : RelativeRect.fromLTRB(
            dx,
            dy,
            MediaQuery.of(context).devicePixelRatio - dx,
            MediaQuery.of(context).devicePixelRatio - dy);
  }
}
