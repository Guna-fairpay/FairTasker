import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:fairpytasker/Component/audio_player_widget.dart';
import 'package:flutter/material.dart';

class CompactAudioPlayer extends StatelessWidget {
  final dynamic input;
  const CompactAudioPlayer({super.key, required this.input});

  @override
  Widget build(BuildContext context) {
    if ((input == null) || ((input is! String) && (input is! File))) return const SizedBox.shrink();
    return Center(
      child: Transform.scale(
          scale: 0.8,
          filterQuality: FilterQuality.low,
          alignment: Alignment.topCenter,
          child: AudioPlayerWidget(source: (input is String) ? UrlSource(input) : DeviceFileSource(input.path ?? ""))),
    );
  }
}
