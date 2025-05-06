import 'dart:convert';

import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';

class TaskerToDoCompleteDialog {
  TaskerToDoCompleteDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model) async {
    Console.of.log(model, name: "TaskerToDoCompleteDialog");
    await showDialog(context: context, builder: (context) => _TaskerToDoCompleteDialog(model), barrierDismissible: false);
  }
}

class _TaskerToDoCompleteDialog extends StatelessWidget {
  final Map<String, dynamic>? model;
  const _TaskerToDoCompleteDialog(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      content: SingleChildScrollView(
        child: SelectableText("${List.from(model?['statusTodo']?['checklist']).where((element) => [(model?['vehicle_status_category'])].contains(element['id'])).map((e) => List.from(e['checklists']).map((e) => e['checklist_name']).toList()).expand((element) => element).toList()}\n${List.from(model?['display']?['vehicles']).map((e) => e['vehicle_status']) }-${model?['vehicle_status_category']}"),
      ),
    );
  }
}
