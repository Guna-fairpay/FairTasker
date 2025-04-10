
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
  final Function onUpload;
  final Function onRemove;
  final List<dynamic> images;
  final String logName;

  const ImageUploadSection({
    Key? key,
    required this.title,
    required this.borderColor,
    required this.onUpload,
    required this.onRemove,
    required this.images,
    required this.logName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onUpload(),
          child: Container(
            padding: 5.sp.padding,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload, color: borderColor, size: 13.sp),
                Utils.getText(title, color: borderColor, weight: FontWeight.bold, size: 12.sp),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (images.isNotEmpty)
          SizedBox(
            height: 100,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisSpacing: 10),
              itemBuilder: (context, index) => CloseBadge(
                onTapView: () {
                  ShowAttachmentsDialog.of.show(context,
                      attachments: images, title: "",
                      currentAttachment: images[index]);
                },
                onTapDelete: () {
                  AskPermissionDialog.show(context,
                      title: "Are you sure?",
                      description: "Do you want to remove this image?",
                      positiveText: "Yes, Remove it!",
                      negativeText: "Cancel",
                      isReasonRequired: false,
                      onPositivePressed: () => onRemove(images[index]));
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
      ],
    );
  }
}
