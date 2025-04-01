import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final dynamic videoInput;
  final bool showMediaControllers;
  final bool enableAudio;
  final bool fillHeight;
  final bool autoPlay;

  const VideoPlayerView(
      {super.key,
      required this.videoInput,
      this.autoPlay = true,
      this.showMediaControllers = true,
      this.enableAudio = true,
      this.fillHeight = false})
      : assert(
          fillHeight == true || showMediaControllers == true,
          'Cannot provide both a fillHeight and a showMediaControllers\n'
          'Can able to provide any one at a time".',
        );

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController? _controller;
  double playSpeed = 1.0;
  double maxSpeed = 5.0;
  double minSpeed = 0.25;
  bool showSpeed = false;

  @override
  void initState() {
    if (widget.videoInput is String) {
      // URL
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoInput),
              videoPlayerOptions: VideoPlayerOptions(
                allowBackgroundPlayback: false,
                mixWithOthers: false,
              ))
            ..initialize().then((value) {
              if (widget.autoPlay) _controller?.setLooping(true);
              if (!widget.enableAudio) _controller?.setVolume(0);
              if (widget.autoPlay) _controller?.play();
              _setState;
            });
    } else if (widget.videoInput is File) {
      // File
      _controller = VideoPlayerController.file(widget.videoInput,
          videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: false,
            mixWithOthers: false,
          ))
        ..initialize().then((value) {
          if (widget.autoPlay) _controller?.setLooping(true);
          if (!widget.enableAudio) _controller?.setVolume(0);
          if (widget.autoPlay) _controller?.play();
          _setState;
        });
    }
    super.initState();
  }

  @override
  void dispose() async {
    _controller?.dispose();
    log("Dispose", name: "VideoPlayerView");
    super.dispose();
  }

  void get _setState {
    if (mounted) {
      setState(() {});
    }
  }

  void rewind() async {
    var currentSpeed = _controller?.value.playbackSpeed ?? 0;
    if (currentSpeed > minSpeed) {
      await _controller?.setPlaybackSpeed(currentSpeed - minSpeed);
      playSpeed = _controller?.value.playbackSpeed ?? 0;
      showSpeed = true;
      _setState;
      await Future.delayed(const Duration(seconds: 1));
      showSpeed = false;
      _setState;
    }
  }

  void faster() async {
    var currentSpeed = _controller?.value.playbackSpeed ?? 0;
    if (currentSpeed < maxSpeed) {
      await _controller?.setPlaybackSpeed(currentSpeed + minSpeed);
      playSpeed = _controller?.value.playbackSpeed ?? 0;
      showSpeed = true;
      _setState;
      await Future.delayed(const Duration(seconds: 1));
      showSpeed = false;
      _setState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_controller?.value.isInitialized ?? false)
        ? (widget.fillHeight)
            ? AspectRatio(
                aspectRatio: _controller?.value.aspectRatio ?? 0,
                child: Stack(
                  children: [
                    if (_controller != null) VideoPlayer(_controller!),
                    if (showSpeed)
                      Center(
                        child: Text(
                          "$playSpeed",
                          style: context.textTheme.titleLarge?.copyWith(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: const Border(),
                        borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: AspectRatio(
                            aspectRatio: _controller?.value.aspectRatio ?? 0,
                            child: Stack(
                              children: [
                                if (_controller != null)
                                  VideoPlayer(_controller!),
                                if (showSpeed)
                                  Center(
                                    child: Text(
                                      "$playSpeed",
                                      style: context.textTheme.titleLarge
                                          ?.copyWith(
                                              color: Colors.white60,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                        if (widget.showMediaControllers)
                          Container(
                            decoration:
                                const BoxDecoration(color: Colors.black12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: rewind,
                                    icon:
                                        const Icon(Icons.fast_rewind_rounded)),
                                IconButton(
                                    onPressed: () async {
                                      await ((_controller?.value.isPlaying ??
                                              false)
                                          ? _controller?.pause()
                                          : (_controller?.value.isCompleted ??
                                                  false)
                                              ? _controller?.setLooping(true)
                                              : _controller?.play());
                                      _setState;
                                    },
                                    icon: Icon(
                                        (_controller?.value.isPlaying ?? false)
                                            ? Icons.pause_rounded
                                            : (_controller?.value.isCompleted ??
                                                    false)
                                                ? Icons.replay_rounded
                                                : Icons.play_arrow_rounded)),
                                IconButton(
                                    onPressed: faster,
                                    icon:
                                        const Icon(Icons.fast_forward_rounded)),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              )
        : (_controller?.value.hasError ?? false)
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    const Icon(Icons.warning_amber_rounded),
                    Utils.getText("Failed to load video")
                  ],
                ),
              )
            : const Center(
                child: CustomLoading(),
              );
  }
}
