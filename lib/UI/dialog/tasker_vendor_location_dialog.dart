import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerVendorLocationDialog {
  TaskerVendorLocationDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model, {void Function(Map<String, dynamic> val)? onSelected}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) => _TaskerVendorLocationDialogView(model: model, onSelected: onSelected),
    );
  }
}

class _TaskerVendorLocationDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final TextEditingController controller = TextEditingController();
  final void Function(Map<String, dynamic>)? onSelected;
  Map<String, dynamic>? selectedVendor;

  _TaskerVendorLocationDialogView({required this.model, this.onSelected}) {
    var locationId = model?['location_id'];
    var vendorId = model?['vendor_id'];
    if (locationId != null || vendorId != null) {
      var list = CustomSearchDataConverter.convertVLocation(locations: getIt<CommonService>().locationsList, vendors: getIt<CommonService>().vendorsList);
      selectedVendor = list
          .firstWhereOrNull((element) => element['id'] == vendorId);
      controller.text = model?['display']?['vendor_location'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      titlePadding: 10.padding,
      insetPadding: 10.padding,
      backgroundColor: Colors.white,
      alignment: Alignment.topCenter,
      title: ListTile(
        dense: true,
        minTileHeight: 0,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        contentPadding: 10.padding,
        title: Utils.getText("${model?['display']?['task_title']}",
            size: 12.sp, weight: FontWeight.w600),
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      contentPadding: 10.padding,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 5.sp,
          children: [
            CustomVendorLocationField(
              vendorsList: getIt<CommonService>().vendorsList,
              locationsList: getIt<CommonService>().locationsList,
              controller: controller,
              selected: {3: selectedVendor},
              onSelected: (val) {
                selectedVendor = val;
                controller.text = val?['name'];
                Console.of.log(val);
              },
            ),
            SuccessButton(
              text: "Save",
              onPressed: () {
                if (selectedVendor != null) {
                  if (model?['display']?['vendor_location'] != controller.text) {
                    onSelected?.call(selectedVendor ?? {});
                    context.popDialog();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
