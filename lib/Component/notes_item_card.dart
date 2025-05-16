import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesItemCard extends StatelessWidget {
  final Map<String, dynamic>? model;
  final List<Map<String, dynamic>>? totalItems;
  final VoidCallback? onEditPressed, onDeletePressed, onAddNotesPressed;
  final ValueChanged<Map<String, dynamic>?>? onSwapNoteItems;
  final Function(Map<String, dynamic>? value)? onEditTakPressed;
  final Future<bool?> Function(DismissDirection direction)? onConfirmDismiss;
  final Function(Map<String, dynamic>? model, bool? status)? onNotesComplete, onTaskComplete;

  const NotesItemCard(
      {super.key,
      this.model,
      this.totalItems,
      this.onSwapNoteItems,
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
                title: GestureDetector(
                  onTap: onEditPressed,
                  child: Text("${model?['title'] ?? ""}", style: context.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold, color: AppC.appColor)),
                ),
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
              ReorderableListView.builder(
                shrinkWrap: true,
                buildDefaultDragHandles: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: 26.sp.horizontalPadding.copyWith(bottom: 10.sp),
                itemCount: (List.from(model?['note_items'] ?? []).length) + 1,
                itemBuilder: (context, index) {
                  var list = List.from(model?['note_items'] ?? []);
                  var totalIndex = list.length - 1;
                  var item = (index > totalIndex) ? null : list[index];
                  return (item == null) ? DragTarget<Map<String, dynamic>>(
                    key: Key("$index"),
                    builder: (context, candidateData, rejectedData) => Container(
                      padding: (candidateData.isNotEmpty ? 20 : 8).padding,
                      color: candidateData.isNotEmpty
                          ? AppC.blue50
                          : Colors.transparent,
                    ),
                    onAcceptWithDetails: (details) {
                      var data = details.data;
                      if (data['note_id'] == model?['id']) { // JUST NORMAL SWAP
                        var list = List.from(model?['note_items'] ?? []);
                        var oldIndex = data['item_index'];
                        var newModel = list[index];
                        var oldModel = model;
                        var body = {
                          "items" : [
                            {"id" : oldModel?['id'], "item_index" : index},
                            {"id" : newModel?['id'], "item_index" : oldIndex},
                          ],
                          "note_id" : newModel?['note_id']
                        };
                        Console.of.log(body);
                        onSwapNoteItems?.call(body);
                      } else { // SWAP WITH DIFFERENT PARENT
                        var oldListIds = List.from(totalItems?.firstWhereOrNull((element) => element['id'] == data['note_id'])?['note_items'] ?? []).whereNot((element) => element['id'] == data['id']).map((e) => e['id']).toList();
                        Map<String, dynamic> source = {
                          "note_id" : data['note_id'],
                          "items" : oldListIds.mapIndexed((index, element) => {
                            "id" : element,
                            "item_index" : index,
                          }).toList(),
                        };
                        var newListIds = list.map((e) => e['id']).toList();
                        newListIds.insert(index, data['id']);
                        Map<String, dynamic> destination = {
                          "note_id" : model?['id'],
                          "items" : newListIds.mapIndexed((index, element) => {
                            "id" : element,
                            "item_index" : index,
                          }).toList(),
                        };
                        Map<String, dynamic> body = {
                          "source" : source,
                          "destination" : destination
                        };
                        onSwapNoteItems?.call(body);
                      }
                    },
                  ) : Column(
                    key: Key("${item['id']}"),
                    children: [
                      DragTarget<Map<String, dynamic>>(
                        builder: (context, candidateData, rejectedData) => Container(
                          padding: (candidateData.isNotEmpty ? 20 : 8).padding,
                          color: candidateData.isNotEmpty
                              ? AppC.blue50
                              : Colors.transparent,
                        ),
                        onAcceptWithDetails: (details) {
                          var data = details.data;
                          if (data['note_id'] == model?['id']) { // JUST NORMAL SWAP
                            var list = List.from(model?['note_items'] ?? []);
                            var oldIndex = data['item_index'];
                            var newModel = list[index];
                            var oldModel = model;
                            var body = {
                              "items" : [
                                {"id" : oldModel?['id'], "item_index" : index},
                                {"id" : newModel?['id'], "item_index" : oldIndex},
                              ],
                              "note_id" : newModel?['note_id']
                            };
                            Console.of.log(body);
                            onSwapNoteItems?.call(body);
                          } else { // SWAP WITH DIFFERENT PARENT
                            var oldListIds = List.from(totalItems?.firstWhereOrNull((element) => element['id'] == data['note_id'])?['note_items'] ?? []).whereNot((element) => element['id'] == data['id']).map((e) => e['id']).toList();
                            Map<String, dynamic> source = {
                              "note_id" : data['note_id'],
                              "items" : oldListIds.mapIndexed((index, element) => {
                                "id" : element,
                                "item_index" : index,
                              }).toList(),
                            };
                            var newListIds = list.map((e) => e['id']).toList();
                            newListIds.insert(index, data['id']);
                            Map<String, dynamic> destination = {
                              "note_id" : model?['id'],
                              "items" : newListIds.mapIndexed((index, element) => {
                                "id" : element,
                                "item_index" : index,
                              }).toList(),
                            };
                            Map<String, dynamic> body = {
                              "source" : source,
                              "destination" : destination
                            };
                            onSwapNoteItems?.call(body);
                          }
                        },
                      ),
                      LongPressDraggable<Map<String, dynamic>>(
                        data: item,
                        feedback: Text("${item['title'] ?? ""}"),
                        child: Column(
                          // key: Key("${item['id']}"),
                          spacing: 5.sp,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              leading: Checkbox(
                                value: (item['todos']?['status'].toString().isNotNullOrEmpty ?? false) ? (item['todos']?['status'] == "Completed") : (item['complete_status'] == 1),
                                side:
                                const BorderSide(width: Num.borderWidthThinField),
                                onChanged: (value) => onTaskComplete?.call(item, value),
                              ),
                              minLeadingWidth: 0,
                              horizontalTitleGap: 0,
                              dense: true,
                              trailing: ReorderableDragStartListener(
                                index: index,
                                child: Icon(Icons.drag_handle, color: Colors.black.withValues(alpha: 0.0)),
                              ),
                              titleAlignment: ListTileTitleAlignment.top,
                              title: Text("${item['title'] ?? ""}"),
                              titleTextStyle: context.textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              onTap: () => onEditTakPressed?.call(item),
                            ),
                            if ((item['description'].toString().isNotNullOrEmpty) || ((item['todos'] != null) && (item['todos']?['notes'].toString().isNotNullOrEmpty ?? false)))
                              Padding(
                                padding: 16.leftPadding,
                                child: Text(
                                  item['todos']?['notes'] ?? (item['description'] ?? ""),
                                  style: context.textTheme.labelMedium,
                                ),
                              ),
                            const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ],
                  );
                }, onReorder: (oldIndex, newIndex) {
                var list = List.from(model?['note_items'] ?? []);
                var newModel = list[newIndex];
                var oldModel = list[oldIndex];
                Console.of.log("INDEX $newIndex : MODEL $newModel");
                Console.of.log("OLD_INDEX $oldIndex : OLD_MODEL $oldModel");
                var body = {
                  "items" : [
                    {"id" : oldModel?['id'], "item_index" : newIndex},
                    {"id" : newModel?['id'], "item_index" : oldIndex},
                  ],
                  "note_id" : newModel?['note_id']
                };
                onSwapNoteItems?.call(body);
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
