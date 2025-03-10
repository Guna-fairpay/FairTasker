import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/sub_components/vehicle_status_car_listing.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/sub_components/vehicle_status_categories_ui.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/sub_components/vehicle_status_filter_ui.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/sub_components/vehicle_status_searcher_ui.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/sub_components/vehicle_status_trip_categories.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class VehicleStatusListBody extends StatelessWidget {
  const VehicleStatusListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: 10.padding,
        child: const Column(
          // spacing: 10,
          children: [
            VehicleStatusSearcherUi(),
            VehicleStatusCategoriesUi(),
            VehicleStatusFilterUi(),
            VehicleStatusTripCategories(),
            VehicleStatusCarListing(),
          ],
        ));
  }
}
