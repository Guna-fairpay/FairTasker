import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:fairpytasker/Component/audio_player_widget.dart';
import 'package:fairpytasker/UI/dialog/record_audio/record_audio_bloc.dart';
import 'package:fairpytasker/UI/dialog/record_audio/record_audio_events.dart';
import 'package:fairpytasker/UI/dialog/record_audio/record_audio_states.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordAudioDialog {
  RecordAudioDialog._();

  static void show(BuildContext context,
      {void Function(File? file)? onRecorded}) async {
    await showDialog(
        context: context,
        builder: (context) => _RecordAudioDialogView(onRecorded: onRecorded),
        barrierDismissible: false,
        useSafeArea: true);
  }
}

class _RecordAudioDialogView extends StatelessWidget {
  final void Function(File? file)? onRecorded;
  const _RecordAudioDialogView({this.onRecorded});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: 10.padding,
      title: ListTile(
        dense: true,
        minTileHeight: 0,
        contentPadding: EdgeInsets.zero,
        title: const Text("Record Audio"),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: Padding(
            padding: 5.padding,
            child: const Icon(Icons.close_rounded),
          ),
        ),
      ),
      elevation: 5,
      alignment: Alignment.topCenter,
      content: BlocProvider(
          create: (context) => RecordAudioBloc(),
          child: BlocListener<RecordAudioBloc, RecordAudioState>(
            listener: (context, state) {
              switch (state) {
                case RecordAudioPermissionState(): context.read<RecordAudioBloc>().add(RecordAudioRecordEvent()); break;
                case RecordAudioSubmittedState(): onRecorded?.call(state.recorded); context.popDialog(); break;
              }
            },
            child: const _RecordAudioDialogContentView(),
          )),
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
    );
  }
}

class _RecordAudioDialogContentView extends StatelessWidget {
  const _RecordAudioDialogContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordAudioBloc, RecordAudioState>(
        builder: (context, state) => SizedBox(
              width: double.maxFinite,
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!context.watch<RecordAudioBloc>().isRecording)
                  IconButton(
                      onPressed: () => context.read<RecordAudioBloc>().add(RecordAudioRecordEvent()),
                      icon: const Icon(Icons.keyboard_voice_outlined), color: context.watch<RecordAudioBloc>().isRecording ? Colors.red : null),
                  if (context.watch<RecordAudioBloc>().isRecording)
                    IconButton(
                        onPressed: () => context.read<RecordAudioBloc>().add(RecordAudioStopEvent()),
                        icon: const Icon(Icons.mic_off_rounded), color: Colors.red),
                  if (context.watch<RecordAudioBloc>().audio != null)
                    AudioPlayerWidget(source: DeviceFileSource(context.watch<RecordAudioBloc>().audio?.path ?? "")),
                  if (context.watch<RecordAudioBloc>().audio != null)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      spacing: 10,
                      children: [
                        Expanded(child: Utils.getFilledButton("Reset", () => context.read<RecordAudioBloc>().add(RecordAudioResetEvent()), bgColor: Colors.red, textColor: Colors.white)),
                        Expanded(child: Utils.getFilledButton("Submit", () => context.read<RecordAudioBloc>().add(RecordAudioSubmitEvent())))
                      ],
                    )
                ],
              ),
            ));
  }
}
