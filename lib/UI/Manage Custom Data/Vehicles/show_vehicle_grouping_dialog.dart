
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping_ui.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

void showVehicleGroupingDialog({
  required BuildContext context,
  required List<Map<String, dynamic>> vehicleName,
  required List<Map<String, dynamic>> vehicleData,
  required List<int> selectedVehicleIds,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppC.white,
        insetPadding: EdgeInsets.zero,
        alignment: Alignment.topCenter,
        contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        titlePadding: EdgeInsets.zero,
        // actionsPadding: EdgeInsets.zero,
        title: ListTile(
         contentPadding: EdgeInsets.zero,
          title: Utils.getText(
            'Vehicle Grouping',
            size: 18,
            color: AppC.appColor,
            weight: FontWeight.bold,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        content: VehicleGroupingUI(
          vehicleList: vehicleName,
          groupVehicleList: vehicleData,
          selectedVehicleIds: selectedVehicleIds,
        ),
      );
    },
  );
}
