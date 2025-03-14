import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/Component/video_player_view.dart';
import 'package:fairpytasker/Component/image_preview.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';

class AttachmentSliderView extends StatefulWidget {
  final List<dynamic> attachments;
  final Object? currentAttachment;
  const AttachmentSliderView({super.key, required this.attachments, this.currentAttachment});

  @override
  State<AttachmentSliderView> createState() => _AttachmentSliderViewState();
}

class _AttachmentSliderViewState extends State<AttachmentSliderView> {
  dynamic currentAttachment;
  List<dynamic> attachments = [];
  int currentIndex = 0;

  final ValueNotifier<bool> showOrHide = ValueNotifier(false);

  @override
  void initState() {
    currentAttachment = widget.currentAttachment ?? widget.attachments.first;
    currentIndex = widget.attachments
        .indexWhere((element) => element == currentAttachment);
    attachments = widget.attachments;
    showOrHide.value = true;
    super.initState();
  }

  String get _getValue {
    log("${currentAttachment.runtimeType}", name: "ATTACHMENT_SLIDER_VIEW");
    var result = "";
    if (currentAttachment is File) {
      result = (currentAttachment as File).path;
    } else if (currentAttachment is String) {
      result = currentAttachment as String;
    }
    return result;
  }

  void _nextAttachment() async {
    log("Next $currentIndex ${(currentIndex < attachments.length - 1)}",
        name: "AttachmentSliderView");
    if (currentIndex < attachments.length - 1) {
      currentIndex++;
      currentAttachment = attachments[currentIndex];
      setState(() {});
      showOrHide.value = false;
      await Future.delayed(Durations.medium3);
      showOrHide.value = true;
    }
  }

  void _previousAttachment() async {
    log("Previous $currentIndex ${(currentIndex > 0)}",
        name: "AttachmentSliderView");
    if (currentIndex > 0) {
      currentIndex--;
      currentAttachment = attachments[currentIndex];
      setState(() {});
      showOrHide.value = false;
      await Future.delayed(Durations.medium3);
      showOrHide.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withValues(alpha: 0.02)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: ValueListenableBuilder(
              valueListenable: showOrHide,
              builder: (context, value, child) => (value)
                  ? (_getValue.isImageFile)
                      ? ImagePreview(imageInput: currentAttachment)
                      : (_getValue.isPdf) ? const Icon(Icons.picture_as_pdf_rounded)
                  : VideoPlayerView(videoInput: currentAttachment)
                  : Container(),
            ),
          ),
        ),
        if (attachments.length > 1)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: (currentIndex == 0) ? null : _previousAttachment,
                icon: const Icon(Icons.chevron_left_rounded)),
            const Spacer(),
            IconButton(
                onPressed: (currentIndex == attachments.length - 1) ? null :  _nextAttachment,
                icon: const Icon(Icons.chevron_right_rounded)),
          ],
        )
      ],
    );
  }
}
