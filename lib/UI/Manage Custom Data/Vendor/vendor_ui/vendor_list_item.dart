

import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../../dialog/ask_permission_dialog.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../Bloc/vendor_data_bloc.dart';

class VendorListItem extends TableRow {
  final Map<String, dynamic> vendor;
  final BuildContext context;

  const VendorListItem({required this.vendor, required this.context});

  @override
  List<Widget> get children => [
    //Vendor name
    TableRowInkWell(
      onTap: () {
        context.read<VendorDataBloc>().add(EnterEditModeEvent(vendor: vendor));
      },
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Utils.getText(vendor['name'] ?? '',),
      ),
    ),

    //View attachments
    TableRowInkWell(
      onTap: () {
        context.read<VendorDataBloc>().add(EnterEditModeEvent(vendor: vendor));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: (vendor['images']?.isNotEmpty ?? false)
            ? IconButton(
          onPressed: () {
            ShowAttachmentsDialog.of.show(
              context,
              attachments: vendor['images']
                  ?.map((e) => e['path'].toString().toStorageURL)
                  .toList(),
              title: vendor['name'] ?? '',
            );
          },
          icon: const Icon(
            Icons.visibility,
            color: AppC.appColor,
            size: 20,
          ),
        )
            : Utils.getText(''),
      ),
    ),

    // Navigation
    TableRowInkWell(
      onTap: () {
        context.read<VendorDataBloc>().add(EnterEditModeEvent(vendor: vendor));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: (vendor['latitude'] != null && vendor['longitude'] != null)
            ? IconButton(
          onPressed: () async {
            final Uri mapsUri = Uri(
              scheme: 'https',
              host: 'www.google.com',
              path: '/maps/search/${vendor['latitude']},${vendor['longitude']}',
              queryParameters: {
                'q': '${vendor['latitude']},${vendor['longitude']}'
              },
            );
            if (await canLaunchUrl(mapsUri)) {
              await launchUrl(mapsUri,
                  mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not open the map.';
            }
          },
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(50 * math.pi / 180),
            child: const Icon(
              Icons.navigation_outlined,
              color: AppC.green,
            ),
          ),
        )
            : Utils.getText(''),
      ),
    ),

    // Edit/Delete buttons
    TableRowInkWell(
      onTap: () {
        context.read<VendorDataBloc>().add(EnterEditModeEvent(vendor: vendor));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                context.read<VendorDataBloc>()
                    .add(EnterEditModeEvent(vendor: vendor));
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: AppC.appColor,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {
                AskPermissionDialog.show(
                  context,
                  title: 'Are you sure?',
                  description: 'Do you want to delete this vendor?',
                  positiveText: 'Yes, Delete it!',
                  negativeText: 'Cancel',
                  isReasonRequired: false,
                  onPositivePressed: () {
                    context.read<VendorDataBloc>().add(DeleteVendorEvent(id: vendor['id']));
                    context.read<VendorDataBloc>().add(ExitEditModeEvent());
                  }
                );
              },
              icon: const Icon(
                Icons.delete_outline,
                color: AppC.red,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  Decoration? get decoration => BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.grey.shade300,
        width: 1,
      ),
    ),
  );
}