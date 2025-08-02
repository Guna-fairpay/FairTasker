import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

class TextWithAttachmentIcon extends StatelessWidget {
  final bool withCheckBox;
  final String title;
  final bool? checkBoxValue;
  final ValueChanged<bool?>? onChanged;
  final Function() onUploaded;
  final Function() onCamera;
  final Function() onPreview;
  final List<dynamic> attachments;

  const TextWithAttachmentIcon({super.key,
    this.withCheckBox = false,
    required this.title,
    this.checkBoxValue,
    this.onChanged,
    required this.onUploaded,
    required this.onCamera,
    required this.onPreview,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        (!withCheckBox)
            ? Expanded(child: CompactText(title, overflow: TextOverflow.ellipsis,))
            : Expanded(
              child: CustomCheckboxListTile(
                title: CompactText(title, overflow: TextOverflow.ellipsis,),
                value: checkBoxValue,
                onChanged: onChanged ?? (value) {},
                useExpand: true,
                padding: 0.padding,
                radius: 8.spMin,

              ),
            ),
        CompactIconButton(
          icon: RemixIcons.upload_cloud_2_line,
          iconSize: 20.spMin,
          backgroundColor: AppC.white,
          foregroundColor: AppC.appColor,
          side: const WidgetStatePropertyAll<BorderSide?>(
            BorderSide(color: AppC.appColor, width: 1.0,),
          ),
          onPressed: ()=> onUploaded(),
        ),
        CompactIconButton(
          icon: RemixIcons.camera_line,
          iconSize: 20.spMin,
          backgroundColor: AppC.white,
          foregroundColor: AppC.appColor,
          side: const WidgetStatePropertyAll<BorderSide?>(
            BorderSide(color: AppC.appColor, width: 1.0,),
          ),
          onPressed: ()=> onCamera(),
        ),
        if(attachments.isNotEmpty)...[
          CompactIconButton(
            icon: RemixIcons.eye_fill,
            iconSize: 20.spMin,
            backgroundColor: AppC.white,
            foregroundColor: Colors.black54,
            side: const WidgetStatePropertyAll<BorderSide?>(
              BorderSide(color: Colors.black54, width: 1.0,),
            ),
            onPressed: ()=> onPreview(),
          ),
        ],
      ],
    );
  }
}
