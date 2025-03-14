
import 'dart:io';
import 'dart:developer' as d;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import 'vehicle_bloc.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleEditPageUI extends StatelessWidget {
  final bool showHeader;
  final Map<String, dynamic> vehicle;
  final Map<String, dynamic>? data;
  final Map<String, dynamic> todoItems;

  VehicleEditPageUI({
    Key? key,
    required this.vehicle,
    this.showHeader = true,
    this.data,
    required this.todoItems,
  }) : super(key: key) {
    d.log("${vehicle}", name: "VEHICLE_DATA");
    d.log("${todoItems}", name: "TODO_DATA");
    d.log("${data}", name: "DATA");
  }

  Widget checkBoxWithSingleText({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
    double scale = 1.0,
  }) {
    return Row(
      children: [
        Transform.scale(
          scale: scale,
          child: SizedBox(
            height: 15,
            child: Checkbox(
              activeColor: AppC.blue,
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
        Utils.getText(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => vehicleBloc()
        ..add(
          vehicleInitialEvent(
            todoItems: todoItems,
            vehicle: vehicle,
          ),
        ),
      child: BlocListener<vehicleBloc, vehiclePageState>(
        listener: (context, state) {},
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Utils.getText("2019 Honda Civic"),
                ),
                Utils.getBorderedMultilineTextField(
                  'Address',
                  TextEditingController(),
                ),
                // Removed Expanded, kept ListView directly in Column
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: Column(
                        children: [
                          checkBoxWithSingleText(
                            value: true,
                            onChanged: (bool? newValue) {},
                            label: 'Bouncie',
                          ),
                        ],
                      ),
                      trailing: checkBoxWithSingleText(
                        value: true,
                        onChanged: (bool? newValue) {},
                        label: 'Air Tag',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}