import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/row_tile.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReleaseNotesViewer {
  static void show(BuildContext context, String? notes) async {
    await showModalBottomSheet(context: context, builder: (context) => _ReleaseNotesViewer(notes: notes),
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
    );
  }
}

class _ReleaseNotesViewer extends StatelessWidget {
  final String? notes;
  const _ReleaseNotesViewer({super.key, this.notes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.spMin.horizontalPadding.copyWith(bottom: 16.spMin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.spMin,
        children: [
          RowTile(
            expandTitle: true,
            title: const CompactText("Release Notes", fontWeight: FontWeight.bold, styleType: TextStyleType.titleMedium),
            trailing: TextButton(onPressed: context.pop, child: const CompactText("Close", color: Colors.blue, styleType: TextStyleType.labelLarge)),
          ),
          Flexible(
            child: Markdown(
              data: (notes ?? "").replaceAll("\\n", "\n"),
              shrinkWrap: true
            ),
          )
        ],
      ),
    );
  }
}
