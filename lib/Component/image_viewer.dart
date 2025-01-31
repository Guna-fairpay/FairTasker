import 'dart:io';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/assets.dart';

class ImageViewer extends StatelessWidget {
  final dynamic imageInput;
  final BoxFit? fit;
  const ImageViewer({super.key, required this.imageInput, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    if ((imageInput is! String) && (imageInput is! File)) return Container();
    return (imageInput is String)
        ? Image.network(imageInput,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(Assets.noImages),
        gaplessPlayback: true,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : const Center(child: CustomLoading()))
        : (imageInput is File)
        ? Image.file(imageInput,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(Assets.noImages),
        gaplessPlayback: true)
        : const SizedBox.shrink();
  }
}
