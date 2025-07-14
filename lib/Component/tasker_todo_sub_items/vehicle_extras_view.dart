part of '../todo_task_item_card.dart';

class VehicleExtrasView extends StatelessWidget {
  final Map model;
  final GestureTapDownCallback? onVehicleOrPerson, onMeeting;
  final VoidCallback? onVehicleHistory;
  final GestureTapDownCallback? onVehicleGroup;
  final GestureTapDownCallback? onParts;
  final GestureTapDownCallback? onSupplies;
  const VehicleExtrasView({super.key,
    required this.model,
    this.onVehicleOrPerson,
    this.onMeeting,
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
    final hasMeeting = model['meeting_mode'].toString().isNotNullOrEmpty;
    final meetingType = model['meeting_mode'].toString().toTitleCase();
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (vehicleName.isNotEmpty)
          Flexible(
            child: GestureDetector(
              onTapDown: onVehicleOrPerson,
              child: CompactText(
                vehicleName,
                // size: (vehicleName == "MV") ? 16.spMin : 14.spMin,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                styleType: TextStyleType.labelLarge
              ),
            ),
          ),
        if (hasMeeting)
        Flexible(
          child: GestureDetector(
            onTapDown: onMeeting,
            child: Utils.getText(
              meetingType,
              size: 11.sp,
              overFlow: TextOverflow.ellipsis,
              weight: FontWeight.w600,
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
            child: const CompactText("G", fontWeight: FontWeight.bold, styleType: TextStyleType.titleSmall),
          ),
        if (hasParts)
          GestureDetector(
            onTapDown: onParts,
            child: const CompactText("P", fontWeight: FontWeight.bold, styleType: TextStyleType.titleSmall),
          ),
        if (hasSupplies)
          GestureDetector(
            onTapDown: onSupplies,
            child: const CompactText("S", fontWeight: FontWeight.bold, styleType: TextStyleType.titleSmall),
          ),
      ],
    );
  }
}
