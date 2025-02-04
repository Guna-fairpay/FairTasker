import 'dart:io';
import 'dart:typed_data';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:flutter_video_thumbnail_plus/flutter_video_thumbnail_plus.dart';

class ImageViewer extends StatelessWidget {
  final dynamic imageInput;
  final BoxFit? fit;
  final ValueNotifier<bool> showLoader = ValueNotifier(false);
  final bool isNotImage;
  Uint8List? imageData;

  ImageViewer(
      {super.key,
      required this.imageInput,
      this.fit = BoxFit.contain,
      this.isNotImage = false}) {
    showLoader.value = isNotImage;
    if (isNotImage) _generateThumbnail();
  }

  void _generateThumbnail() async {
    showLoader.value = true;
    imageData = await FlutterVideoThumbnailPlus.thumbnailData(
      video: (imageInput is String) ? imageInput : (imageInput as File).path,
      imageFormat: ImageFormat.png,
      quality: 100,
    );
    showLoader.value = false;
  }

  @override
  Widget build(BuildContext context) {
    if ((imageInput is! String) && (imageInput is! File)) return Container();
    if (isNotImage) {
      return ValueListenableBuilder(
        valueListenable: showLoader,
        builder: (context, value, child) => (value && imageData == null)
            ? const Center(child: CustomLoading())
            : Image.memory(imageData ?? Uint8List(0),
                fit: fit,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(Assets.noImages),
                gaplessPlayback: true),
      );
    }
    return (imageInput is String)
        ? Image.network(imageInput,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset(Assets.noImages),
            gaplessPlayback: true,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) =>
                (loadingProgress == null)
                    ? child
                    : const Center(child: CustomLoading()))
        : (imageInput is File)
            ? Image.file(imageInput,
                fit: fit,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(Assets.noImages),
                gaplessPlayback: true)
            : const SizedBox.shrink();
  }
}
