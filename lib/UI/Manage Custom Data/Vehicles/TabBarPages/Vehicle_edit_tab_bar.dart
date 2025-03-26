
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/TabBarPages/vehicle_expense_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/TabBarPages/vehicle_log.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/TabBarPages/vehicle_repair&maintenance_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import '../VehicleEdit/UI/edit_vehicle_ui.dart';

class VehicleEditTabBar extends StatelessWidget {
  Map<String, dynamic> vehicle;
   VehicleEditTabBar({super.key,required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child:Scaffold(
        backgroundColor: AppC.white,
        appBar: AppBar(
          backgroundColor: AppC.appColor,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          leadingWidth: 20,
          title: TabBar(
            tabs: const [
              Tab(text: 'Vehicles', height: 30,),
              Tab(text: 'Expense', height: 30),
              Tab(text: 'Repair & Maintenance', height: 30),
              Tab(text: 'Log', height: 30),
            ],
            dividerColor: AppC.trans,
            labelStyle: const TextStyle(fontSize: 16),
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
        body: const TabBarView(
          children: [
            SafeArea(child: EditVehicleUI()),
            SafeArea(child: VehicleExpenseUI()),
            SafeArea(child: VehicleRepairMaintenanceUI()),
            SafeArea(child: VehicleLogUI()),
          ],
        ),
      ),
    );
  }
}
