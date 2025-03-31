import 'package:audioplayers/audioplayers.dart';
import 'package:fairpytasker/Component/audio_player_widget.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/video_player_view.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseLogAttachmentDialog {
  ExpenseLogAttachmentDialog._();

  static show(BuildContext context,
      {required Map<String, dynamic>? model}) async {
    await showDialog(
        context: context,
        builder: (context) => _ExpenseLogAttachmentDialogView(model: model),
        barrierDismissible: true,
        useSafeArea: true);
  }
}

class _ExpenseLogAttachmentDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;

  const _ExpenseLogAttachmentDialogView({this.model});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      contentPadding: 10.padding,
      titlePadding: 10.padding,
      insetPadding: 10.padding,
      title: ListTile(
        dense: true,
        minTileHeight: 0,
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        title: Utils.getText("", size: 17.sp, weight: FontWeight.bold),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: Icon(Icons.close_rounded, size: 18.sp),
        ),
      ),
      content: _ExpenseLogAttachmentDialogContentView(model: model),
    );
  }
}

class _ExpenseLogAttachmentDialogContentView extends StatelessWidget {
  final Map<String, dynamic>? model;

  const _ExpenseLogAttachmentDialogContentView({this.model});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        padding: 10.padding,
        children: [
          if (model?['video'].toString().isNotNullOrEmpty ?? false) ...[
            Utils.getText("Video", size: 12.sp, weight: FontWeight.bold),
            10.height,
            VideoPlayerView(videoInput: model?['video'], autoPlay: false),
            10.height,
          ],
          if (model?['image'].toString().isNotNullOrEmpty ?? false) ...[
            Utils.getText("Image", size: 12.sp, weight: FontWeight.bold),
            10.height,
            SizedBox(
              height: context.height * 0.3,
              child: ImageViewer(imageInput: model?['image']),
            ),
            10.height,
          ],
          if (model?['audio'].toString().isNotNullOrEmpty ?? false) ...[
            Utils.getText("Audio", size: 12.sp, weight: FontWeight.bold),
            10.height,
            SizedBox(
              width: context.width,
              child: AudioPlayerWidget(source: UrlSource(model?['audio'])),
            ),
            10.height,
          ],
          if (model?['notes'].toString().isNotNullOrEmpty ?? false) ...[
            Utils.getText("Notes", size: 12.sp, weight: FontWeight.bold),
            10.height,
            Text("${model?['notes'] ?? ""}",
                overflow: TextOverflow.visible,
                style:
                    context.textTheme.labelMedium?.copyWith(fontSize: 12.sp)),
            10.height,
          ],
        ],
      ),
    );
  }
}
