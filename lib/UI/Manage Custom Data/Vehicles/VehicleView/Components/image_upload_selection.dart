
import 'dart:io';

import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageUploadSection extends StatelessWidget {
  final String title;
  final Color borderColor;
  final Function? onUpload;
  final Function onRemove;
  final List<dynamic> images;
  final String logName;
  final bool isRequired;
  final bool isDeleteDialog;
  final bool isDeleteIcon;
  final IconData icon;
  final bool showDownload;

  const ImageUploadSection({
    Key? key,
    required this.title,
    required this.borderColor,
    this.onUpload,
    this.isDeleteDialog = true,
    required this.onRemove,
    required this.images,
    required this.logName,
    this.isRequired = true,
    this.isDeleteIcon = true,
    this.icon = Icons.cloud_upload,
    this.showDownload = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(isRequired)...[
          GestureDetector(
            onTap: () => onUpload?.call(),
            child: Container(
              padding: 8.sp.padding,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: borderColor, size: 13.sp),
                  Utils.getText(title, color: borderColor, weight: FontWeight.bold, size: 12.sp),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10)
        ],
        if (images.isNotEmpty)...[
          SizedBox(
            height: 100,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisSpacing: 10),
              itemBuilder: (context, index) => CloseBadge(
                showClose: isDeleteIcon,
                onTapView: () {
                  ShowAttachmentsDialog.of.show(context,
                      attachments: images, title: "",
                      currentAttachment: images[index],
                      showDownload: showDownload,
                      onDownload: (v){
                        var data = (images[index] is File) ? (images[index] as File).path : images[index];
                        Utils.openURL(data, isFile: (images[index] is File));
                      }
                  );
                },
                onTapDelete: () {
                  (isDeleteDialog)?
                  AskPermissionDialog.show(context,
                      title: "Are you sure?",
                      description: "Do you want to remove this image?",
                      positiveText: "Yes, Remove it!",
                      negativeText: "Cancel",
                      isReasonRequired: false,
                      onPositivePressed: () => onRemove(images[index]))
                      : onRemove(images[index]);
                },
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height,
                    minWidth: MediaQuery.sizeOf(context).width,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppC.grey.withValues(alpha: 0.2)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: ImageViewer(
                    fit: BoxFit.cover,
                    imageInput: images[index],
                    isNotImage: !(images[index] as Object).isImage,
                  ),
                ),
              ),
            ),
          ),
          10.spMin.height,
        ],
      ],
    );
  }
}
