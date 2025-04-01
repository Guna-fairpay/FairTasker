
import 'package:audioplayers/audioplayers.dart';
import 'package:fairpytasker/Component/audio_player_widget.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class PlayAudioDialog {
  final String? audioUrl;
  PlayAudioDialog._({required this.audioUrl});

  static void show(BuildContext context,{String? audioUrl}) async {
    await showDialog(context: context, builder: (context) {
      return  _PlayAudioDialog(audioUrl: audioUrl);
    });
  }
}

class _PlayAudioDialog extends StatelessWidget {
  final String? audioUrl;
  const _PlayAudioDialog({required this.audioUrl});

  @override
  Widget build(BuildContext context) {
      return Dialog(
        backgroundColor: AppC.white,
        insetPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AudioPlayerWidget(source: UrlSource('${Str.TODO_ATTACHMENTS_URL}$audioUrl')),
            ],
          ),
        ),
      );
    }
}
