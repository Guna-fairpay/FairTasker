import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';

class VehicleLogListItem extends StatelessWidget {
  final Map<String, dynamic>? model;
  final VoidCallback? onNotesTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onAttachmentTap;
  const VehicleLogListItem({super.key, required this.model, this.onNotesTap, this.onDeleteTap, this.onAttachmentTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(DateTime.tryParse(model?['created_at'] ?? "")
              .toFormat(format: "MM/dd/yy") ??
              ""),
          Text(
            DateTime.tryParse(model?['created_at'] ?? "")?.toLocal()
                .toFormat(format: "hh:mm a") ??
                "",
            style: context.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      title: Text("${model?['title'] ?? "Reference"} ${(model?['hasAttachments'] ?? false) ? "(${model?['attachmentLabel']})" : ""}"),
      subtitle: Text.rich(TextSpan(text: model?['notes'] ?? "", recognizer: TapGestureRecognizer()..onTap = onNotesTap),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      titleTextStyle: context.textTheme.labelLarge,
      subtitleTextStyle: context.textTheme.labelSmall
          ?.copyWith(color: AppC.appColor),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(<String>[
            (model?['user']?['first_name'] ?? ""),
            (model?['user']?['last_name'] ?? "")
          ].toInitial, style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
          if (model?['hasAttachments'] ?? false)
            GestureDetector(
                onTap: onAttachmentTap,
                child: Padding(padding: 5.horizontalPadding, child: const Icon(Icons.attach_file_rounded,
                    color: AppC.appColor))),
          GestureDetector(
              onTap: onDeleteTap,
              child: Padding(padding: 5.horizontalPadding, child: const Icon(Icons.delete_outline_rounded,
                  color: AppC.red))),
        ],
      ),
    );
  }
}
