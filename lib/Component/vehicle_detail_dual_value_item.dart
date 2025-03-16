import 'package:fairpytasker/Component/vehicle_detail_list_tile.dart' show VehicleDetailListTile;
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';

class VehicleDetailDualValueItem extends StatelessWidget {
  final String? firstLabel, lastLabel;
  final dynamic firstValue, lastValue;
  const VehicleDetailDualValueItem({super.key, this.firstLabel, this.firstValue, this.lastLabel, this.lastValue});

  @override
  Widget build(BuildContext context) {
    return ((firstLabel.isNotNullOrEmpty) || (lastLabel.isNotNullOrEmpty)) ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: (firstLabel != null && (firstLabel.isNotNullOrEmpty)) ? VehicleDetailListTile(label: firstLabel ?? "", value: "${firstValue ?? ""}") : Container()),
        Expanded(child: (lastLabel != null && (lastLabel.isNotNullOrEmpty)) ? VehicleDetailListTile(label: lastLabel ?? "", value: "${lastValue ?? ""}") : Container()),
      ],
    ) : const SizedBox.shrink();
  }
}
