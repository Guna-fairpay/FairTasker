part of '../todo_task_item_card.dart';

class VehicleBouncieRow extends StatelessWidget {
  final Map<String, dynamic> model;
  final VoidCallback? onBouncie;
  final GestureTapDownCallback? onVehicleOrPerson, onMeeting;
  final VoidCallback? onVehicleHistory;
  final GestureTapDownCallback? onVehicleGroup;
  final GestureTapDownCallback? onParts;
  final GestureTapDownCallback? onSupplies;

  const VehicleBouncieRow(
      {super.key,
      required this.model,
      this.onBouncie,
      this.onVehicleOrPerson,
      this.onMeeting,
      this.onVehicleHistory,
      this.onVehicleGroup,
      this.onParts,
      this.onSupplies});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: VehicleExtrasView(
              model: model,
              onParts: onParts,
              onMeeting: onMeeting,
              onSupplies: onSupplies,
              onVehicleGroup: onVehicleGroup,
              onVehicleHistory: onVehicleHistory,
              onVehicleOrPerson: onVehicleOrPerson)),
      BouncieDistanceView(model: model, onBouncie: onBouncie),
    ]);
  }
}
