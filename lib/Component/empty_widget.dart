import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final bool withExpand;
  const EmptyWidget({super.key, this.withExpand = true});

  @override
  Widget build(BuildContext context) {
    return (withExpand) ? Expanded(
      child: getEmptyWidget(context),
    ) : getEmptyWidget(context);
  }

  Widget getEmptyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cached_rounded, size: context.width * 0.15, color: AppC.borderColor),
        Text("No record found!", style: context.textTheme.titleMedium?.copyWith(color: AppC.borderColor)),
      ],
    );
  }
}
