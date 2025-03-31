
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/UI/vehicle_expense_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/UI/vehicle_rm_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/TabBarPages/vehicle_log.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/UI/edit_vehicle_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class VehicleEditTabBar extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  const VehicleEditTabBar({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: AppBar(
          backgroundColor: AppC.appColor,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          leadingWidth: 40,
          title: TabBar(
            tabs: const [
              Tab(
                text: 'Vehicles',
                height: 40,
              ),
              Tab(text: 'Expense', height: 40),
              Tab(text: 'Repair & Maintenance', height: 40),
              Tab(text: 'Log', height: 40),
            ],
            dividerColor: AppC.trans,
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            labelColor: AppC.appColor,
            unselectedLabelColor: AppC.white,
            indicator: BoxDecoration(
                color: AppC.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppC.appColor)),
            indicatorSize: TabBarIndicatorSize.tab,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            EditVehicleUI(
              vehicleData: vehicle,
            ),
            EditVehicleExpenseDetailsUI(vin: "${vehicle['vin']}"),
            VehicleRMUI(vin: "${vehicle['vin']}"),
            VehicleLogUI(vin: vehicle['vin']),
          ],
        ),
      ),
    );
  }
}
