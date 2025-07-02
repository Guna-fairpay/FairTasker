part of '../todo_task_item_card.dart';

class VehiclePlateView extends StatelessWidget {
  final Map<String, dynamic> model;
  final VoidCallback? onPlateNumTap;
  const VehiclePlateView({super.key, required this.model, this.onPlateNumTap});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final hasCompleted = display['hasCompleted'] ?? false;
    final hasVehiclePlate = display['hasVehiclePlate'] ?? false;
    final vehiclePlate = display['vehicle_plate'] ?? 'No Plate';
    final vehicleImageUrl = (display['vehicle_image'] ?? '').toString();
    final hasVehicleImage = vehicleImageUrl.isNotEmpty;
    final vins = List.from(display['vins'] ?? []);
    final vinText = vins.length > 1 ? "MV" : "CT";
    final showPlateText = vehiclePlate.toString().isNotEmpty;
    final avatarColor = hasCompleted ? AppC.green : AppC.appColor;
    final plateColor = showPlateText ? AppC.appColor : AppC.red;

    Widget vehicleImageWidget;
    if (!hasVehicleImage) {
      vehicleImageWidget = Center(
        child: Utils.getText(
          vinText,
          size: 14.spMin,
          overFlow: TextOverflow.ellipsis,
          color: AppC.appColor,
          align: TextAlign.center,
          weight: FontWeight.bold,
        ),
      );
    } else {
      vehicleImageWidget = Image.network(
        vehicleImageUrl.removeStorageUrl.toStorageURL,
        fit: BoxFit.cover,
        width: context.width,
        height: context.height,
        loadingBuilder: (context, child, loadingProgress) {
          final finished = loadingProgress?.cumulativeBytesLoaded ==
              loadingProgress?.expectedTotalBytes;
          return finished ? child : const CustomLoading();
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            Assets.noImages,
            fit: BoxFit.cover,
            width: context.width,
            height: context.height,
          );
        },
      );
    }
    return GestureDetector(
      onTap: hasVehiclePlate ? onPlateNumTap : null,
      child: Container(
        padding: 10.padding,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: avatarColor,
              child: CircleAvatar(
                radius: model.isEmpty ? 30 : 28,
                backgroundColor: AppC.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: vehicleImageWidget,
                ),
              ),
            ),
            if (hasVehiclePlate)
              Utils.getText(
                vehiclePlate,
                size: 10.spMin,
                weight: FontWeight.w900,
                color: plateColor,
              ),
          ],
        ),
      ),
    );
  }
}
