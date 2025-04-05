import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

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
      content: Container(
        width: context.width,
        height: context.height * 0.9,
        decoration: BoxDecoration(
            color: AppC.white,
            borderRadius: BorderRadius.circular(8)
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
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
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Utils.getText(
                      model?['display']?['vehicle_name'],
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: (model?['display']?['vehicleHistoryIconColorCode'] ?? AppC.trans),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Utils.getText(
                      model?['display']?['vehicleStatusCategoryName'] ?? '',
                      size: 16,
                      color: AppC.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InteractiveViewer(
                  maxScale: 8.0,
                  minScale: 0.01,
                  child: CachedNetworkImage(
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.3,
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
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
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
                  ),
                  const Icon(Icons.rotate_right_outlined),
                  GestureDetector(
                    onTap: () async {
                      String imageUrl = model?['display']?['vehicle_image'];
                      if (imageUrl.isNotEmpty) {
                        String subject = Uri.encodeComponent('Check out this image');
                        String body = Uri.encodeComponent('Here is an image: $imageUrl');
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          queryParameters: {
                            'subject': subject,
                            'body': body,
                          },
                        );
                        Utils.openURL(emailUri.toString());
                      }
                    },
                    child: Image.asset(
                      Assets.mail,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SizedBox(
                // height: MediaQuery.of(context).size.height * 0.5,
                child: VehicleHistoryViewUI(
                  vin: model?['display']?['vins']?[0],
                  vehicleName: model?['display']?['vehicle_name'] ?? '',
                  title: model?['display']?['task_title'],
                  showHeader: false,
                  showSameTask: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
