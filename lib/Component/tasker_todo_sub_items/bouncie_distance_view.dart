part of '../todo_task_item_card.dart';

class BouncieDistanceView extends StatelessWidget {
  final Map model;
  final VoidCallback? onBouncie;
  const BouncieDistanceView({super.key, required this.model, this.onBouncie});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final hasBouncie = display['hasBouncie'] ?? false;
    final hasDistance = display['hasDistance'] ?? false;
    final vehicleDistance = display['vehicle_distance']?.toString() ?? "";
    final vinsLength = (List.from(display['vins'] ?? [])).length;
    final todoDate = model['todo_date']?.toString().toFormat(format: "yyyy-MM-dd");
    final today = DateTime.now().toFormat();
    final showBouncie = hasBouncie || (todoDate == today && hasDistance && vinsLength == 1);
    if (!showBouncie) return const SizedBox.shrink();
    Widget icon = Icon(
      (hasDistance && (vehicleDistance.isNotEmpty))
          ? Icons.location_on
          : Icons.location_on_outlined,
      color: (vehicleDistance.isEmpty)
          ? AppC.redAccent
          : AppC.green,
      size: 17.sp,
    );
    return GestureDetector(
      onTap: onBouncie,
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          if (hasDistance)
            Utils.getText(
              vehicleDistance,
              weight: FontWeight.normal,
              size: 13.sp,
              color: (vehicleDistance.isNullOrEmpty)
                  ? AppC.redAccent
                  : AppC.green,
            ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
