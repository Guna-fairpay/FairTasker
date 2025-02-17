
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_view_ui.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/appC.dart';
import 'Private Rental/private_rental_view_ui.dart';

class VehicleTabBar extends StatelessWidget {
  const VehicleTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:Scaffold(
        backgroundColor: AppC.white,
        appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        leadingWidth: 20,
        title: TabBar(
         // controller: tabController,
          tabs: const [
            Tab(
              text: 'Vehicles',
              height: 30,
            ),
            Tab(text: 'Private Rental', height: 30),
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
          SafeArea(child: VehicleViewUI()),
            SafeArea(child: RentalViewUI())
        ],

        ),
      ),
    );
  }
}
