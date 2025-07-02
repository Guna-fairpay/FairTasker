part of '../detailed_report_ui.dart';

class DetailedReportByDayItem extends StatelessWidget {
  final Map<String, dynamic>? model;
  final void Function(String? value)? onReference;
  const DetailedReportByDayItem({super.key, this.model, this.onReference});

  @override
  Widget build(BuildContext context) {
    var vehicles = List.from(model?['vehicles'] ?? []);
    final users = getIt<CommonService>().userByGroupId(model?['user_group_id']);
    final userInitials = "${<String>[(users.firstOrNull?['first_name'] ?? ""), (users.firstOrNull?['last_name'] ?? "")].toInitial}...";
    String? vehicleImage = (model?['vehicle_image'] ?? (List.from(getIt<CommonService>().activeVehicleList.firstWhereOrNull((element) => element['vin'] == (List.from(model?['vehicles'] ?? []).firstOrNull)?['vin'])?['images'] ?? []).firstWhereOrNull((element) => element['vehicle_image_type'] == 1)?['path'].toString().toStorageURL ?? ""));
    if (vehicles.isNotEmpty && vehicles.length > 1) vehicleImage = null;
    return Padding(
      padding: 10.spMin.padding,
      child: Row(
        spacing: 10.spMin,
        children: [
          CircleAvatar(
            radius: 30.spMin,
            child: ClipOval(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CircleAvatar(
                radius: ((vehicles.length > 1) || (vehicleImage.isNullOrEmpty)) ? 28.spMin : 30.spMin,
                backgroundColor: Colors.white,
                child: (vehicles.length > 1) ? const CompactText("MV") : (vehicleImage.isNullOrEmpty) ? const CompactText("CT") : Image.network(vehicleImage ?? "",
                    errorBuilder: (context, error, stackTrace) => Image.asset(Assets.noImages,
                        height: double.maxFinite,
                        width: double.maxFinite,
                        fit: BoxFit.cover
                    ),
                    height: double.maxFinite,
                    width: double.maxFinite,
                    fit: BoxFit.cover),
              ),
              // borderRadius: BorderRadiusGeometry.circular(30.spMin),
            ),
          ),
          Expanded(child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppC.borderColor
                )
              )
            ),
            child: Column(
              spacing: 5.spMin,
              children: [
                RowTile(
                  title: Row(
                    spacing: 8.spMin,
                    children: [
                      CompactText("${model?['title']}", color: AppC.appColor, fontWeight: FontWeight.bold),
                      if (model?['reference_id'].toString().isNotNullOrEmpty ?? false)
                        GestureDetector(
                          onTap: (onReference == null) ? null : () => onReference?.call(switch(model?['custom_link_id']) {
                            1 => null,
                            3 => (model?['reference_id'].toString().toGetAroundReserveUrl),
                            null => (model?['reference_id'].toString().isNotNullOrEmpty ?? false) ? (model?['reference_id'].toString().toTuroReserveUrl) : "",
                            _ => (model?['reference_id'].toString().toTuroReserveUrl)
                          }),
                          child: CompactText(switch(model?['custom_link_id']) {
                            1 => "",
                          2 => "T",
                          3 => "G",
                          null => (model?['reference_id'].toString().isNotNullOrEmpty ?? false) ? "T" : "",
                          _ => "T"
                          }, color: switch(model?['custom_link_id']) {
                            1 => AppC.grey,
                            2 => AppC.black,
                            3 => AppC.getAroundTextColor,
                            null => (model?['reference_id'].toString().isNotNullOrEmpty ?? false) ? AppC.black : AppC.trans,
                            _ => AppC.black
                          }, fontWeight: FontWeight.bold),
                        )
                    ],
                  ),
                  trailing: Text("${model?['todo_time'].toString().toFormat(inputFormat: "HH:mm:ss", format: "HH:mm")}"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                RowTile(
                  title: Text("${model?['vehicle_name'] ?? (getIt<CommonService>().activeVehicleList.firstWhereOrNull((element) => element['vin'] == (List.from(model?['vehicles'] ?? []).firstOrNull)?['vin'])?['vehicle_name'] ?? "")}"),
                  trailing: CompactText(
                    (model?['user_group_id'] == null) ?
                      <String>[(model?['users']?['first_name'] ?? ""), (model?['users']?['last_name'] ?? "")].toInitial
                      : userInitials,
                      color: AppC.appColor, fontWeight: FontWeight.bold),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                if (((model?['location'] ?? model?['vendor_name'] ?? "").toString().isNotNullOrEmpty) || (model?['notes'].toString().isNotNullOrEmpty ?? false))
                RowTile(
                  expandTitle: true,
                  title: Text.rich(TextSpan(
                    children: [
                      if ("${model?['location'] ?? model?['vendor_name'] ?? ""}".isNotNullOrEmpty)
                      TextSpan(
                        text: "${model?['location'] ?? model?['vendor_name'] ?? ""}\t"
                      ),
                      if (model?['notes'].toString().isNotNullOrEmpty ?? false)
                      TextSpan(
                          text: "(${model?['notes']})",
                        style: context.textTheme.bodySmall?.copyWith(color: AppC.appColor)
                      ),
                    ]
                  ), overflow: TextOverflow.ellipsis, maxLines: 1,),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )
                else const SizedBox.shrink(),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
