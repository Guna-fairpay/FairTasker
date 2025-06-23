import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/vehicle_detail_dual_value_item.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VehicleDetailsUi extends StatelessWidget {
  final Map<String, dynamic>? model;
  VehicleDetailsUi({super.key, required this.model});
  final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: _isExpanded, builder: (context, value, child) => SingleChildScrollView(
      padding: 10.padding,
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (kDebugMode) SelectableText(model?['vin']),
          VehicleDetailDualValueItem(
            firstLabel: "Year",
            lastLabel: "Make",
            firstValue: model?['year'],
            lastValue: model?['make'],
          ),
          VehicleDetailDualValueItem(
            firstLabel: "Model",
            lastLabel: "Cohort",
            firstValue: model?['model'],
            lastValue: model?['cohort']?['cohort'],
          ),
          VehicleDetailDualValueItem(
            firstLabel: "Vin",
            lastLabel: "Vehicle ID",
            firstValue: model?['vin'],
            lastValue: model?['vehicle_id'],
          ),
          VehicleDetailDualValueItem(
            firstLabel: "Purchase Date",
            lastLabel: "Purchase Price",
            firstValue: model?['purchase_date'],
            lastValue: model?['purchase_price'],
          ),
          if (value)
            ...[
              VehicleDetailDualValueItem(
                firstLabel: "Earnings",
                lastLabel: "Utilization Rate",
                firstValue: model?['earnings'],
                lastValue: model?['utilization_rate'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Platform",
                lastLabel: "Mileage",
                firstValue: model?['platform'],
                lastValue: model?['mileage'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Wholesale Amount",
                lastLabel: "vehicle_status",
                firstValue: model?['wholesale_amount'],
                lastValue: getIt<CommonService>().activeVehicleCountList.firstWhereOrNull((element) => element['id'] == model?['vehicle_status'])?['category_name'] ?? "" ,
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Status",
                lastLabel: "Address",
                firstValue: model?['active'] == 1 ? "Active" : "Inactive",
                lastValue: model?['address'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Bouncie",
                lastLabel: "AirTag",
                firstValue: model?['bouncie'] == 1 ? "Yes" : "No",
                lastValue: model?['air_tag'] == 1 ? "Yes" : "No",
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Toll Tags",
                lastLabel: "Spare Tires",
                firstValue: model?['toll_tags'] == 1 ? "Yes" : "No",
                lastValue: model?['spare_tire'] == 1 ? "Yes" : "No",
              ),
              VehicleDetailDualValueItem(
                firstLabel: (model?['toll_tags_id'].toString().isNullOrEmpty ?? false) ? null : "Toll Tag ID",
                lastLabel: "Tire Size",
                firstValue: model?['toll_tags_id'],
                lastValue: model?['tire_size'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Spare Key",
                lastLabel: "Permanent Plate",
                firstValue: model?['spare_key'] == 1 ? "Yes" : "No",
                lastValue: model?['permanent_plate'] == 1 ? "Yes" : "No",
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Front License Plate",
                lastLabel: "Number Plate",
                firstValue: model?['front_license_plate'] == 1 ? "Yes" : "No",
                lastValue: model?['vehicle_number'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Car Number",
                lastLabel: "Oil Grade",
                firstValue: model?['car_number'],
                lastValue: model?['oil_grade'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Front Tire",
                lastLabel: "Rear Tire",
                firstValue: model?['front_tire'],
                lastValue: model?['rear_tire'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Reg Sticker Date",
                firstValue: model?['registration_renewal_date'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Current Odometer",
                lastLabel: "Oil Change Odometer (next)",
                firstValue: model?['current_odometer'],
                lastValue: model?['oil_change_odometer'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Maintenance Check (days from today)",
                firstValue: model?['maintenance_check'],
              ),
              VehicleDetailDualValueItem(
                firstLabel: "Insurance Agent",
                lastLabel: "Insurance Cost",
                firstValue: model?['insurance_agent'],
                lastValue: model?['insurance_cost'],
              ),
            ],
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _isExpanded.value = !_isExpanded.value;
                  _isExpanded.notifyListeners();
                },
                child: Text("${value ? "Less" : "More"}...", style: context.textTheme.labelLarge?.copyWith(color: const Color(0xFF0580b5)),),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
