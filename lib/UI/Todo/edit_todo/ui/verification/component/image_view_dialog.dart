import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/image_preview.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class ImageViewDialog  {
  ImageViewDialog._();

  static void show(BuildContext context, {
    dynamic model,
    List<dynamic>? attachments,
    bool? deleteIcon,
    Function(dynamic value)? onDelete,
    String? title,
  }) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => _ImageViewDialog(
          model: model,
          attachments: attachments,
          overrideDelete: deleteIcon ?? false,
          onDelete: onDelete,
          title: title,
      ),
    );
  }
}

class _ImageViewDialog extends StatefulWidget {
  final dynamic model;
  final List<dynamic>? attachments;
  final bool overrideDelete;
  final Function(dynamic value)? onDelete;
  final String? title;

  const _ImageViewDialog({
    this.model,
    this.attachments,
    this.overrideDelete = false,
    this.onDelete,
    this.title,
  });

  @override
  State<_ImageViewDialog> createState() => _ImageViewDialogState();
}

class _ImageViewDialogState extends State<_ImageViewDialog> {
  String? title;
  List<dynamic>? attachments;
  @override
  void initState() {
    attachments = widget.attachments;
    title = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        title: CompactText(
          title ?? "Preview",
          fontWeight: FontWeight.bold,
          styleType: TextStyleType.titleMedium,
        ),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: const Icon(Icons.close_rounded),
        ),
      ),
      insetPadding: 10.padding,
      titlePadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      contentPadding: 15.horizontalPadding,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 0.7,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.grey.shade300
                        ]),
                    borderRadius: BorderRadius.circular(5)
                ),
                width: double.maxFinite,
                padding: 10.bottomPadding,
                child: Swiper(
                  scrollDirection: Axis.horizontal,
                  itemCount: attachments?.length ?? 0,
                  loop: false,
                  control: const SwiperControl(),
                  // pagination: const SwiperPagination(),
                  outer: true,
                  allowImplicitScrolling: true,
                  indicatorLayout: PageIndicatorLayout.NONE,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var attachment = attachments?[index];
                    return Column(
                      children: [
                        Expanded(child: ImagePreview(imageInput: attachment)),
                        if (attachment is File || widget.overrideDelete)
                        Padding(
                          padding: 10.verticalPadding,
                          child: InkWell(
                            onTap: () {
                              widget.onDelete?.call(attachment);
                              attachments?.remove(attachment);
                              if(attachments?.isEmpty ?? false){
                                context.popDialog();
                              }
                              setState(() {});
                            },
                              child: const Icon(RemixIcons.delete_bin_line, color: AppC.redAccent,)),
                        )
                      ],
                    );
                  },

                ),
              ),
            ),
          ),

        ],
      )
    );
  }
}
