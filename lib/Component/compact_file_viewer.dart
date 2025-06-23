import 'dart:io';

import 'package:fairpytasker/Component/compact_audio_player.dart';
import 'package:fairpytasker/Component/compact_doc_viewer.dart';
import 'package:fairpytasker/Component/image_preview.dart';
import 'package:fairpytasker/Component/video_player_view.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';

class CompactFileViewer extends StatelessWidget {
  final dynamic input;
  const CompactFileViewer({super.key, this.input});

  String get _getValue {
    Console.of.log("${input.runtimeType}", name: "ATTACHMENT_SLIDER_VIEW");
    var result = "";
    if (input is File) {
      result = (input as File).path;
    } else if (input is String) {
      result = input as String;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (_getValue.isImageFile) return ImagePreview(imageInput: input);
    if (_getValue.isAudio) return CompactAudioPlayer(input: input);
    if (_getValue.isVideo) return VideoPlayerView(videoInput: input, autoPlay: false);
    return DocumentViewer(input: input);
  }
}
