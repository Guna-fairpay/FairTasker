import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class TodoTopHoursView extends StatelessWidget {
  final Map<String, dynamic>? model;
  const TodoTopHoursView({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text.rich(TextSpan(
            text: model?['checkIn'] ?? "00:00",
            children: [
              WidgetSpan(child: 3.width),
              TextSpan(text: "Check in", style: context.textTheme.labelSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.normal))
            ]
        ), style: context.textTheme.labelMedium?.copyWith(fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Text.rich(TextSpan(
              text: model?['totalHours'] ?? "00:00",
              children: [
                WidgetSpan(child: 3.width),
                TextSpan(text: "Hours Active", style: context.textTheme.labelSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.normal))
              ]
          ), style: context.textTheme.labelMedium?.copyWith(fontSize: 13, color: AppC.red, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        Text.rich(TextSpan(
            text: model?['checkOut'] ?? "00:00",
            children: [
              WidgetSpan(child: 3.width),
              TextSpan(text: "Hours Total", style: context.textTheme.labelSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.normal))
            ]
        ), style: context.textTheme.labelMedium?.copyWith(fontSize: 13, color: AppC.red, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
