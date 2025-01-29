import 'dart:io';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Component/double_tap_zoom_interactiveviewer.dart';

class ImagePreview extends StatelessWidget {
  final dynamic imageInput;

  const ImagePreview({super.key, required this.imageInput});

  @override
  Widget build(BuildContext context) {
    return DoubleTappableInteractiveViewer(
        scaleDuration: Durations.extralong3,
        child: (imageInput is String)
            ? Image.network(imageInput,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(Assets.noImages),
                gaplessPlayback: true,
                loadingBuilder: (context, child, loadingProgress) =>
                    const Center(child: CustomLoading()))
            : (imageInput is File)
                ? Image.file(imageInput,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(Assets.noImages),
                    gaplessPlayback: true)
                : const SizedBox.shrink());
  }
}
