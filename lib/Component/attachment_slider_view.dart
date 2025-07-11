import 'package:fairpytasker/Component/compact_audio_player.dart';
import 'package:fairpytasker/Component/compact_doc_viewer.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/Component/video_player_view.dart';
import 'package:fairpytasker/Component/image_preview.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';

class AttachmentSliderView extends StatefulWidget {
  final List<dynamic> attachments;
  final Object? currentAttachment;
  final ValueChanged<dynamic>? onDeleted;
  final ValueChanged<dynamic>? onDownload;
  final VoidCallback? onClose;
  final bool showDownload;
  const AttachmentSliderView({super.key, required this.attachments, this.currentAttachment, this.onDeleted, this.onClose, this.onDownload, this.showDownload = false});

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
            width: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withValues(alpha: 0.02)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: ValueListenableBuilder(
              valueListenable: showOrHide,
              builder: (context, value, child) {
                if (!value) return const SizedBox.shrink();
                if (_getValue.isImageFile) return ImagePreview(imageInput: currentAttachment);
                if (_getValue.isAudio) return CompactAudioPlayer(input: currentAttachment);
                if (_getValue.isVideo) return VideoPlayerView(videoInput: currentAttachment);
                return DocumentViewer(input: currentAttachment);
              },
            ),
          ),
        ),
        if ((attachments.length > 1) || (widget.onDeleted != null))
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (attachments.length > 1)
            IconButton(
                onPressed: (currentIndex == 0) ? null : _previousAttachment,
                icon: const Icon(Icons.chevron_left_rounded)),
            const Spacer(),
            if (widget.onDeleted != null)
              ...[
                IconButton(
                    onPressed: () {
                      widget.onDeleted?.call(currentAttachment);
                      attachments.remove(currentAttachment);
                      if (currentIndex <= attachments.length) {
                        currentIndex = (attachments.isEmpty) ? 0 : (currentIndex - 1);
                        currentIndex = currentIndex.abs();
                      }
                      Console.of.log("TOTAL ${attachments.length} $currentIndex");
                      try {
                        currentAttachment = attachments[currentIndex];
                        if (mounted) setState(() {});
                      } catch (e) {

                      }
                      if (attachments.isEmpty) {
                        widget.onClose?.call();
                      }
                    },
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.red,)),
                const Spacer()
              ],
            if(widget.showDownload)...[
              IconButton(
                  onPressed: () {
                    widget.onDownload?.call(currentAttachment);
                  },
                  icon: const Icon(Icons.download_rounded, color: Colors.green,)),
              const Spacer()
            ],
            if (attachments.length > 1)
            IconButton(
                onPressed: (currentIndex == attachments.length - 1) ? null :  _nextAttachment,
                icon: const Icon(Icons.chevron_right_rounded)),
          ],
        )
      ],
    );
  }
}
