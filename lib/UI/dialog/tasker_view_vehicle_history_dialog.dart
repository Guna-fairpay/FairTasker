import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairpytasker/Component/compact_rotation_view.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskerViewVehicleHistoryDialog {
  TaskerViewVehicleHistoryDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) => _TaskerViewVehicleHistoryView(model: model),
    );
  }
}

class _TaskerViewVehicleHistoryView extends StatelessWidget {
  final Map<String, dynamic>? model;
  const _TaskerViewVehicleHistoryView({this.model});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      contentPadding: EdgeInsets.zero,
      insetPadding: 10.padding,
      backgroundColor: AppC.white,
      titlePadding: EdgeInsets.zero,
      title: ListTile(
        dense: true,
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 20,
            ),
          ),
        ),
      ),
      content: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AppC.white,
            borderRadius: BorderRadius.circular(8)
        ),
        padding: 16.spMin.padding,
        child: ListView(
          // spacing: 10.spMin,
          // mainAxisSize: MainAxisSize.min,
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Utils.getText(
                      model?['display']?['vehicle_name'],
                      size: 12.spMin,
                      weight: FontWeight.bold
                    ),
                  ),
                  Utils.getText(
                    model?['display']?['vehicleStatusCategoryName'] ?? '',
                    size: 12.spMin,
                    color: Color(int.parse('0xFF${model?['display']?['vehicleHistoryIconColorCode']}') ?? 0x00000000),
                  ),
                ],
              ),
            ),
            CompactRotationView(prefixChild: GestureDetector(
              onTap: () async {
                String imageUrl = model?['display']?['vehicle_image'];
                if (imageUrl.isNotEmpty) {
                  String whatsappUrl =
                      "https://wa.me/?text=Check out this image: $imageUrl";
                  Utils.openURL(whatsappUrl);
                }
              },
              child: Image.asset(
                Assets.whatsAppIcon,
                height: 24,
                width: 24,
              ),
            ), suffixChild: GestureDetector(
              onTap: () async {
                String imageUrl = model?['display']?['vehicle_image'] ?? "";
                if (imageUrl.isNotNullOrEmpty) {
                  final mailUri = Uri.parse("mailto:email?subject=Check out this image!&body=Check out this image! $imageUrl");
                  await launchUrl(mailUri);
                  // Utils.openURL(emailUri.toString());
                }
              },
              child: Image.asset(
                Assets.mail,
                height: 24,
                width: 24,
              ),
            ),
                child: InteractiveViewer(
              maxScale: 8.0,
              minScale: 0.01,
              child: CachedNetworkImage(
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  );
                },
                imageUrl: model?['display']?['vehicle_image'] ?? "",
                placeholder: (context, url) =>
                    Utils.getProgressIndicator(context),
                errorWidget: (context, url, error) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.center,
                    child: Utils.getText("CT",
                        size: 22,
                        color: AppC.red,
                        weight: FontWeight.bold),
                  );
                },
              ),
            )),
            VehicleHistoryViewUI(
              vin: model?['display']?['vins']?[0],
              vehicleName: model?['display']?['vehicle_name'] ?? '',
              title: model?['display']?['task_title'],
              showHeader: false,
              showSameTask: true,
              additionalScroll: false,
              itemPerPage: 5,
            ),
          ],
        ),
      ),
    );
  }
}
