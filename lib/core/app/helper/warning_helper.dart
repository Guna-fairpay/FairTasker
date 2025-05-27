import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:flutter/material.dart';

class WarningHelper {
  WarningHelper._();
  static odometerWarning(BuildContext context, {VoidCallback? onPositive}) {
    AskPermissionDialog.show(context,
      description: 'The entered odometer value is less than the previous one. Are you sure you want to continue?',
      positiveText: 'Yes,continue',
      onPositivePressed: onPositive,
    );
  }
}