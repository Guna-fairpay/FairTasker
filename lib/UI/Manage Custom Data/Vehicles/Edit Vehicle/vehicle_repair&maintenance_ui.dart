import 'package:flutter/material.dart';

class VehicleRepairMaintenanceUI extends StatelessWidget {
  const VehicleRepairMaintenanceUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => const Divider(height: 0.5,),
      itemBuilder: (context, index) {
        return SafeArea(child: Text(''));
      },

    ));
  }
}
