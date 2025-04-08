import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesItemCard extends StatelessWidget {
  final Map<String, dynamic>? model;
  final VoidCallback? onEditPressed, onDeletePressed, onAddNotesPressed;
  final Function(Map<String, dynamic>? value)? onEditTakPressed;
  final Future<bool?> Function(DismissDirection direction)? onConfirmDismiss;
  final Function(Map<String, dynamic>? model, bool? status)? onNotesComplete, onTaskComplete;

  const NotesItemCard(
      {super.key,
      this.model,
      this.onConfirmDismiss,
      this.onEditPressed,
      this.onDeletePressed,
      this.onAddNotesPressed,
      this.onEditTakPressed,
      this.onNotesComplete,
      this.onTaskComplete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: key ?? Key("${model?['id'] ?? 0}"),
        direction: DismissDirection.horizontal,
        confirmDismiss: onConfirmDismiss,
        secondaryBackground: Padding(
            padding: 16.sp.padding,
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    (model?['status'] == 1) ? "In Complete" : "Complete",
                    style: context.textTheme.titleMedium?.copyWith(
                        color: (model?['status'] == 1) ? AppC.red : AppC.green,
                        fontWeight: FontWeight.bold)))),
        background: Padding(
            padding: 16.sp.padding,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Tomorrow",
                    style: context.textTheme.titleMedium?.copyWith(
                        color: AppC.red, fontWeight: FontWeight.bold)))),
        child: Card(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
          elevation: 5,
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Checkbox(
                  value: (model?['status'] == 1),
                  side: const BorderSide(width: Num.borderWidthThinField),
                  onChanged: (value) => onNotesComplete?.call(model, value),
                ),
                minLeadingWidth: 10,
                dense: true,
                titleAlignment: ListTileTitleAlignment.center,
                horizontalTitleGap: 0,
                title: Text("${model?['title'] ?? ""}"),
                titleTextStyle: context.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onEditPressed,
                      icon: const Icon(Icons.mode_edit_outline_outlined),
                      color: AppC.appColor,
                    ),
                    IconButton(
                        onPressed: onDeletePressed,
                        icon: const Icon(Icons.delete_outline_rounded),
                        color: AppC.red),
                  ],
                ),
              ),
              const Divider(),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: 26.sp.horizontalPadding.copyWith(bottom: 10.sp),
                itemCount: List.from(model?['note_items'] ?? []).length,
                separatorBuilder: (context, index) => 5.sp.height,
                itemBuilder: (context, index) {
                  var item = List.from(model?['note_items'] ?? [])[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        leading: Checkbox(
                          value: (item['complete_status'] == 1),
                          side:
                              const BorderSide(width: Num.borderWidthThinField),
                          onChanged: (value) => onTaskComplete?.call(item, value),
                        ),
                        minLeadingWidth: 0,
                        horizontalTitleGap: 0,
                        dense: true,
                        titleAlignment: ListTileTitleAlignment.top,
                        title: Text("${item['title'] ?? ""}"),
                        titleTextStyle: context.textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        onTap: () => onEditTakPressed?.call(item),
                      ),
                      if ((item['description'].toString().isNotNullOrEmpty) || (item['todos'] != null))
                      Padding(
                        padding: 16.leftPadding,
                        child: Text(
                          item['todos']?['notes'] ?? item['description'],
                          style: context.textTheme.labelMedium,
                        ),
                      )
                    ],
                  );
                },
              ),
              Padding(
                  padding: 20.leftPadding,
                  child: IconButton(
                      onPressed: onAddNotesPressed,
                      icon: const Icon(Icons.add_rounded),
                      color: AppC.appColor,
                      alignment: Alignment.centerLeft)),
              20.height,
            ],
          ),
        ));
  }
}
