part of '../todo_task_item_card.dart';

class VehicleExtrasView extends StatelessWidget {
  final Map model;
  final GestureTapDownCallback? onVehicleOrPerson;
  final VoidCallback? onVehicleHistory;
  final GestureTapDownCallback? onVehicleGroup;
  final GestureTapDownCallback? onParts;
  final GestureTapDownCallback? onSupplies;
  const VehicleExtrasView({super.key,
    required this.model,
    this.onVehicleOrPerson,
    this.onVehicleHistory,
    this.onVehicleGroup,
    this.onParts,
    this.onSupplies,
  });

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final vehicleName = display['vehicle_or_person_name']?.toString() ?? '';
    final hasVehicleHistory = display['hasVehicleHistory'] ?? false;
    final vehicleHistoryColorCode = display['vehicleHistoryIconColorCode']?.toString();
    final hasG = display['hasG'] ?? false;
    final hasParts = display['hasParts'] ?? false;
    final hasSupplies = display['hasSupplies'] ?? false;
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (vehicleName.isNotEmpty)
          Flexible(
            child: GestureDetector(
              onTapDown: onVehicleOrPerson,
              child: Utils.getText(
                vehicleName,
                size: (vehicleName == "MV") ? 14.spMin : 11.spMin,
                overFlow: TextOverflow.ellipsis,
                weight: FontWeight.bold,
              ),
            ),
          ),
        if (hasVehicleHistory)
          GestureDetector(
            onTap: onVehicleHistory,
            child: Icon(
              Icons.remove_red_eye,
              color: (vehicleHistoryColorCode?.isNotEmpty ?? false)
                  ? Color(int.parse("0xff$vehicleHistoryColorCode"))
                  : AppC.blue,
              size: 16.spMin,
            ),
          ),
        if (hasG)
          GestureDetector(
            onTapDown: onVehicleGroup,
            child: Utils.getText("G", weight: FontWeight.bold, size: 14.spMin),
          ),
        if (hasParts)
          GestureDetector(
            onTapDown: onParts,
            child: Utils.getText("P", weight: FontWeight.bold, size: 14.spMin),
          ),
        if (hasSupplies)
          GestureDetector(
            onTapDown: onSupplies,
            child: Utils.getText("S", weight: FontWeight.bold, size: 14.spMin),
          ),
      ],
    );
  }
}
