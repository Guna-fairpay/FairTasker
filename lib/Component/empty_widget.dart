import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cached_rounded, size: context.width * 0.15, color: AppC.borderColor),
          Text("No record found!", style: context.textTheme.titleMedium?.copyWith(color: AppC.borderColor)),
        ],
      ),
    );
  }
}
