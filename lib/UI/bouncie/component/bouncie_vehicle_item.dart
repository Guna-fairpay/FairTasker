part of '../bouncie_main_ui.dart';

class BouncieVehicleItem extends StatelessWidget {
  final Map<String, dynamic>? model;
  final VoidCallback? onTap;
  const BouncieVehicleItem({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    var vImage = List.from(model?['images'] ?? []).firstWhereOrNull((element) => element['vehicle_image_type'] == 1)?['path'].toString().toStorageURL;
    Console.of.log(vImage ?? "", name: "V_IMAGE");
    return RowTile(
      spacing: 10.spMin,
      leading: CircleAvatar(
        backgroundColor: AppC.appColor,
        radius: 35.spMin,
        child: ClipOval(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network(vImage ?? "",
              fit: BoxFit.cover,
            width: context.width,
            height: context.height,
            loadingBuilder: (context, child, loadingProgress) => ((loadingProgress?.expectedTotalBytes ?? 0) != (loadingProgress?.cumulativeBytesLoaded ?? 0)) ? CircleAvatar(
              backgroundColor: AppC.white,
              radius: 35.spMin,
              child: const CircularProgressIndicator(),
            ) : child,
            errorBuilder: (context, error, stackTrace) => CircleAvatar(
              backgroundColor: AppC.white,
              radius: 34.spMin,
              child: const CompactText("V", color: AppC.appColor),
            ),
          ),
        ),
      ),
      expandTitle: true,
      title: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppC.borderColor, width: Num.borderWidthButton)
          )
        ),
        child: RowTile(
          expandTitle: true,
          title: Column(
            spacing: 2.spMin,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompactText((model?['vehicle_name'] ?? "").toString().toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold, color: ((model?['bouncie']?['stats']?['isRunning'] ?? false)) ? AppC.darkestGreen : AppC.black),
              CompactText(model?['bouncie']?['address'] ?? ""),
              CompactText("${model?['bouncie']?['vin'] ?? ""}/${model?['vehicle_number'] ?? ""}", color: AppC.appColor),
            ],
          ),
          trailing: RowTile(
            onTap: onTap,
            leading: const Icon(Icons.location_on_outlined, color: AppC.redAccent),
            title: CompactText("${model?['bouncie']?['distance'] ?? 0}"),
          ),
        ),
      ),
    );
  }
}
