import 'package:flutter/material.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/double_tap_zoom_interactiveviewer.dart';

class ImagePreview extends StatelessWidget {
  final dynamic imageInput;

  const ImagePreview({super.key, required this.imageInput});

  @override
  Widget build(BuildContext context) {
    return DoubleTappableInteractiveViewer(
        scaleDuration: Durations.extralong3,
        child: ImageViewer(imageInput: imageInput));
  }
}
