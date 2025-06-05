import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/dismissable_background_text.dart';
import 'package:fairpytasker/Component/row_tile.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotesItemCard extends StatelessWidget {
  final bool isSharedNotes;
  final Map<String, dynamic>? model;
  final List<Map<String, dynamic>>? totalItems;
  final VoidCallback? onEditPressed, onDeletePressed, onAddNotesPressed;
  final ValueChanged<Map<String, dynamic>?>? onSwapNoteItems;
  final Function(Map<String, dynamic>? value)? onEditTakPressed, onTimePicker;
  final Future<bool?> Function(DismissDirection direction)? onConfirmDismiss;
  final Function(Map<String, dynamic>? model, bool? status)? onNotesComplete, onTaskComplete;

  const NotesItemCard(
      {super.key,
      this.isSharedNotes = false,
      this.model,
      this.totalItems,
      this.onSwapNoteItems,
      this.onConfirmDismiss,
      this.onTimePicker,
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
        secondaryBackground: DismissibleBackgroundText(
            alignment: Alignment.centerRight,
            title: (model?['status'] == 1) ? "In Complete" : "Complete",
            color: (model?['status'] == 1) ? AppC.red : AppC.green),
        background: const DismissibleBackgroundText(
            alignment: Alignment.centerLeft,
            title: "Tomorrow",
            color: AppC.red),
        child: Card(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
          elevation: 5,
          color: AppC.lightsGrey,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowTile(
                expandTitle: true,
                leading: Checkbox(
                  value: (model?['status'] == 1),
                  side: const BorderSide(width: Num.borderWidthThinField),
                  onChanged: (value) => onNotesComplete?.call(model, value),
                ),
                title: GestureDetector(
                  onTap: onEditPressed,
                  child: Text("${model?['title'] ?? ""}", style: context.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold, color: AppC.appColor)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSharedNotes)
                      CompactText(<String>[(model?['users']?['first_name'] ?? ""), (model?['users']?['last_name'] ?? "")].toInitial, fontWeight: FontWeight.bold, color: AppC.appColor),
                    if (!isSharedNotes)
                      IconButton(
                        onPressed: onAddNotesPressed,
                        icon: SvgPicture.asset(Assets.tablePlusIcon, theme: const SvgTheme(currentColor: AppC.appColor),),
                        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      ),
                    IconButton(
                      onPressed: onEditPressed,
                      icon: SvgPicture.asset(Assets.penEditIcon, theme: const SvgTheme(currentColor: AppC.appColor),),
                      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    ),
                    IconButton(
                      onPressed: onDeletePressed,
                      icon: SvgPicture.asset(Assets.trashIcon, theme: const SvgTheme(currentColor: AppC.redAccent)),
                      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ReorderableListView.builder(
                shrinkWrap: true,
                buildDefaultDragHandles: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: 26.sp.horizontalPadding.copyWith(bottom: 10.sp),
                itemCount: (List.from(model?[ (isSharedNotes) ? 'products_items' : 'note_items'] ?? []).length) + 1,
                itemBuilder: (context, index) {
                  var list = List.from(model?[(isSharedNotes) ? 'products_items' : 'note_items'] ?? []);
                  var totalIndex = list.length - 1;
                  var item = (index > totalIndex) ? null : list[index];
                  return (item == null) ? DragTarget<Map<String, dynamic>>(
                    key: Key("$index"),
                    builder: (context, candidateData, rejectedData) => Container(
                      padding: (candidateData.isNotEmpty ? 20 : 1).padding,
                      color: candidateData.isNotEmpty
                          ? AppC.blue50
                          : Colors.transparent,
                    ),
                    onAcceptWithDetails: (details) => _onAcceptWithDetails(details, list, index),
                  ) : Column(
                    key: Key("${item['id']}"),
                    children: [
                      DragTarget<Map<String, dynamic>>(
                        builder: (context, candidateData, rejectedData) => Container(
                          padding: (candidateData.isNotEmpty ? 20 : 1).padding,
                          color: candidateData.isNotEmpty
                              ? AppC.blue50
                              : Colors.transparent,
                        ),
                        onAcceptWithDetails: (details) => _onAcceptWithDetails(details, list, index),
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
                            RowTile(
                              expandTitle: true,
                              onTap: () => onEditTakPressed?.call(item),
                              leading: Checkbox(
                                value: (item['todos']?['status'].toString().isNotNullOrEmpty ?? false) ? (item['todos']?['status'] == "Completed") : (item['complete_status'] == 1),
                                side:
                                const BorderSide(width: Num.borderWidthThinField),
                                onChanged: (value) => onTaskComplete?.call(item, value),
                              ),
                              title: CompactText("${item['title'] ?? ""}", styleType: TextStyleType.labelLarge, fontWeight: FontWeight.bold,
                              decoration: (isSharedNotes ? ((item?['complete_status'] == 1) ? TextDecoration.lineThrough : null) : null)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (isSharedNotes)
                                    CompactText(item?['end_date'].toString().toFormat(inputFormat: "yyyy-MM-dd", format: "MM-dd-yy") ?? "", color: AppC.grey),
                                  if (!isSharedNotes)
                                  GestureDetector(
                                      onTap: () => onTimePicker?.call(item),
                                      child: (item?['note_time'].toString().isNullOrEmpty ?? false) ? SvgPicture.asset(Assets.durationIcon) : CompactText(item?['note_time'].toString().toFormat(inputFormat: "HH:mm:ss", format: "hh:mm a") ?? "")
                                  ),
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: const Icon(Icons.drag_handle, color: AppC.trans),
                                  )
                                ],
                              ),
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
                }, onReorder: _onReorder),
              if (isSharedNotes)
              Padding(
                  padding: 20.spMin.leftPadding.copyWith(bottom: 20.spMin),
                  child: IconButton(
                      onPressed: onAddNotesPressed,
                      icon: const Icon(Icons.add_rounded),
                      color: AppC.appColor,
                      alignment: Alignment.centerLeft)),
              // 20.height,
            ],
          ),
        ));
  }

  void _onReorder(int oldIndex, int newIndex) {
    var list = List.from(model?['note_items'] ?? []);
    var newModel = list[newIndex];
    var oldModel = list[oldIndex];
    var body = {
      "items" : [
        {"id" : oldModel?['id'], "item_index" : newIndex},
        {"id" : newModel?['id'], "item_index" : oldIndex},
      ],
      "note_id" : newModel?['note_id']
    };
    onSwapNoteItems?.call(body);
  }

  void _onAcceptWithDetails(DragTargetDetails<Map<String, dynamic>> details, List<dynamic> list, int index) {
    try {
      var data = details.data;
      if (data['note_id'] == model?['id']) { // JUST NORMAL SWAP
        var list = List.from(model?['note_items'] ?? []);
        var oldIndex = data['item_index'];
        var newIndex = ((list.length - 1) < index) ? index - 1 : index;
        var newModel = list[newIndex];
        if (newIndex == oldIndex) oldIndex--;
        var oldModel = data;
        var body = {
          "items" : [
            {"id" : oldModel['id'], "item_index" : newIndex},
            {"id" : newModel?['id'], "item_index" : oldIndex},
          ],
          "note_id" : newModel?['note_id']
        };
        Console.of.log(body, name: "NOTES");
        Console.of.log(oldModel, name: "NOTES_OLD");
        Console.of.log(newModel, name: "NOTES_NEW");
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
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }
}
