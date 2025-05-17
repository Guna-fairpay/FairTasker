
import 'dart:io';
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/utils.dart';

class EditTodoExpenseAttachment extends StatelessWidget {
  final VoidCallback? pickImageEvent;
  final VoidCallback? captureImageEvent;
  final VoidCallback? invoiceEvent;
  final Function(dynamic) removeImageEvent;
  final dynamic vendorList;
  final List<dynamic> attachments;

  const EditTodoExpenseAttachment({
    super.key,
    required this.vendorList,
    required this.attachments,
    required this.pickImageEvent,
    required this.captureImageEvent,
    required this.invoiceEvent,
    required this.removeImageEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: SuccessButton(
                  text: 'Upload',
                  icon: Icons.cloud_upload_rounded,
                  foregroundColor: AppC.blue,
                  backgroundColor: AppC.trans,
                  isOutline: true,
                  onPressed: () => pickImageEvent?.call(),
                )),
            Expanded(
                child: SuccessButton(
                  text: 'Capture',
                  icon: Icons.camera_enhance_rounded,
                  foregroundColor: AppC.redAccent,
                  backgroundColor: AppC.trans,
                  isOutline: true,
                  onPressed: () => pickImageEvent?.call(),
                )),
            if (vendorList.isNotEmpty)
              Expanded(
                  child: SuccessButton(
                    text: 'Invoice',
                    icon: Icons.receipt_long_rounded,
                    foregroundColor: AppC.blue,
                    backgroundColor: AppC.trans,
                    isOutline: true,
                    onPressed: () => invoiceEvent?.call(),
                  )),
          ],
        ),
        if (attachments.isNotEmpty)
          SizedBox(
            height: 100,
            child:
            GridView.builder(
              shrinkWrap: true,
              itemCount: attachments.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisSpacing: 10),
              itemBuilder: (context, index) => CloseBadge(
                  onTapView: () {
                    ShowAttachmentsDialog.of.show(context,
                        attachments: attachments,
                        title: "",
                        currentAttachment: attachments[index]);
                  },
                  onTapDelete: () {
                    AskPermissionDialog.show(context,
                        title: "Are you sure?",
                        description: "Do you want to delete this Expense Image?",
                        positiveText: "Yes, delete it!",
                        negativeText: "Cancel",
                        isReasonRequired: false,
                        onPositivePressed: () =>removeImageEvent(attachments[index]));
                  },
                  child: Stack(
                    children: [
                      Container(
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
                          imageInput: attachments[index],
                          isNotImage:
                          !((attachments[index] as Object)
                              .isImage),
                        ),
                      ),
                      if ((attachments[index] as Object).isPDF)
                        Container(
                          decoration: BoxDecoration(
                            color: AppC.green,
                            borderRadius: BorderRadius.circular(16),

                          ),
                          child: InkWell(
                            onTap: () {
                              var data = (attachments[index] is File) ? (attachments[index] as File).path : attachments[index];
                              Console.of.log(data);
                              Utils.openURL(data, isFile: (attachments[index] is File));
                            },child:Padding(
                            padding: 4.padding,
                            child: const Icon(Icons.remove_red_eye_outlined,color: AppC.white,size: 15,),
                          ),),
                        ),
                    ],
                  ),
              ),
            ),
          ),
      ],
    );
  }
}
