import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ReceiveIntent {

  final ReceiveSharingIntent _sharingIntent = ReceiveSharingIntent.instance;
  final ValueNotifier<List<SharedMediaFile>> _mediasNotifier = ValueNotifier([]);
  ReceiveIntent() {
    Console.of.debug("ReceiveIntent Created", name: "ReceiveIntent");
    _initialize();
  }

  void _initialize() async {
    _mediasNotifier.value = await _sharingIntent.getInitialMedia();
    _sharingIntent.getMediaStream().listen((event) => _mediasNotifier.value.addAll(event));
    Console.of.debug("ReceiveIntent Initialized", name: "ReceiveIntent");
  }

  List<SharedMediaFile> get medias => _mediasNotifier.value;
  void clear() {
    _mediasNotifier.value.clear();
    Console.of.debug("Media's cleared", name: "ReceiveIntent");
  }

}