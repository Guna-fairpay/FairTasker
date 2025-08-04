import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

// This code is also used in the example.md. Please keep it up to date.
class AudioPlayerWidget extends StatefulWidget {
  final Source source;
  final VoidCallback? onSave, onReset;
  const AudioPlayerWidget({
    required this.source,
    this.onSave,
    this.onReset,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _AudioPlayerWidgetState();
  }
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    player.setSource(widget.source);
    _playerState = player.state;
    player.onPlayerComplete.listen((event) => player.stop());
    player.getDuration().then(
          (value) => setState(() {
        _duration = value;
      }),
    );
    player.getCurrentPosition().then(
          (value) => setState(() {
        _position = value;
      }),
    );
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    player.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
            _position != null
                ? '$_positionText '
                : '',
            style: const TextStyle(fontSize: 16.0),
          ),
          Expanded(child: Slider(
            inactiveColor: Colors.grey.shade200,
            onChanged: (value) {
              final duration = _duration;
              if (duration == null) {
                return;
              }
              final position = value * duration.inMilliseconds;
              player.seek(Duration(milliseconds: position.round()));
            },
            value: (_position != null &&
                _duration != null &&
                _position!.inMilliseconds > 0 &&
                _position!.inMilliseconds < _duration!.inMilliseconds)
                ? _position!.inMilliseconds / _duration!.inMilliseconds
                : 0.0,
          )),
          Text(_duration != null
              ? _durationText
              : '',
            style: const TextStyle(fontSize: 16.0),
          ),
        ],),
        /*Slider(
          inactiveColor: Colors.grey.shade200,
          onChanged: (value) {
            final duration = _duration;
            if (duration == null) {
              return;
            }
            final position = value * duration.inMilliseconds;
            player.seek(Duration(milliseconds: position.round()));
          },
          value: (_position != null &&
              _duration != null &&
              _position!.inMilliseconds > 0 &&
              _position!.inMilliseconds < _duration!.inMilliseconds)
              ? _position!.inMilliseconds / _duration!.inMilliseconds
              : 0.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _position != null
                  ? '$_positionText '
                  : '',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(_duration != null
                  ? _durationText
                  : '',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),*/
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.onReset != null)
            IconButton(
              key: const Key('reset_button'),
              onPressed: widget.onReset,
              iconSize: 30,
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppC.redAccent,
            ),
            IconButton(
              key: const Key('play_button'),
              onPressed: _isPlaying ? null : _play,
              iconSize: 48.0,
              icon: const Icon(Icons.play_arrow_rounded),
              color: color,
            ),
            IconButton(
              key: const Key('pause_button'),
              onPressed: _isPlaying ? _pause : null,
              iconSize: 48.0,
              icon: const Icon(Icons.pause_rounded),
              color: color,
            ),
            IconButton(
              key: const Key('stop_button'),
              onPressed: _isPlaying || _isPaused ? _stop : null,
              iconSize: 48.0,
              icon: const Icon(Icons.stop_rounded),
              color: color,
            ),
            if (widget.onSave != null)
            IconButton(
              key: const Key('save_button'),
              onPressed: widget.onSave,
              iconSize: 30,
              icon: const Icon(Icons.save_rounded),
              color: AppC.green,
            ),
          ],
        ),
      ],
    );
  }

  void _initStreams() async {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
          (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
          setState(() {
            _playerState = state;
          });
        });
  }

  Future<void> _play() async {
    await player.play(widget.source);
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }
}