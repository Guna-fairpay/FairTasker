import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class CustomWrapChoice<T extends Object> extends StatefulWidget {
  final List<T> items;
  final int? showMaxItems;
  final List<T>? selectedItems;
  final ItemAsString<T>? itemAsString;
  final ItemAsString<T>? selectionItemAsString;
  final void Function(bool isChecked, T value)? onChanged;

  const CustomWrapChoice(
      {super.key,
      required this.items,
      this.showMaxItems,
      this.itemAsString,
      this.selectedItems,
      this.onChanged,
      this.selectionItemAsString});

  @override
  State<CustomWrapChoice<T>> createState() => _CustomWrapChoiceState<T>();
}

class _CustomWrapChoiceState<T extends Object> extends State<CustomWrapChoice<T>> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final visibleItems = isExpanded
        ? widget.items
        : (widget.showMaxItems != null && widget.showMaxItems != 0) ? widget.items.take(widget.showMaxItems ?? 0).toList() : widget.items;
    // Add the "More / Less" button at the end of the Wrap
    final showToggle = (widget.showMaxItems != null && widget.showMaxItems != 0) ? (widget.items.length > (widget.showMaxItems ?? 0)) : false;
    List<Widget> children = [...(visibleItems.map((e) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
      child: ChoiceChip(
        color: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? AppC.appColor : AppC.chipBackgroundUnselected),
        side: const BorderSide(color: AppC.chipBackgroundUnselectedBorder),
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
        showCheckmark: false,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        label: CompactText(
          widget.itemAsString?.call(e) ?? "$e",
          color: ((widget.selectionItemAsString != null)
              ? ((widget.selectedItems
              ?.map((e) => widget.selectionItemAsString?.call(e)))
              ?.contains(widget.selectionItemAsString?.call(e)) ??
              false)
              : widget.selectedItems?.contains(e) ?? false)
              ? AppC.white
              : AppC.text,
          fontWeight: ((widget.selectionItemAsString != null)
              ? ((widget.selectedItems
              ?.map((e) => widget.selectionItemAsString?.call(e)))
              ?.contains(widget.selectionItemAsString?.call(e)) ??
              false)
              : widget.selectedItems?.contains(e) ?? false)
              ? FontWeight.bold
              : FontWeight.normal
        ),
        selected: ((widget.selectionItemAsString != null)
            ? ((widget.selectedItems
            ?.map((e) => widget.selectionItemAsString?.call(e)))
            ?.contains(widget.selectionItemAsString?.call(e)) ??
            false)
            : widget.selectedItems?.contains(e) ?? false),
        onSelected: (bool selected) {
          widget.onChanged?.call(selected, e);
        },
      ),
    )).toList())];
    if (showToggle) {
      children.add(
        TextButton(
          onPressed: () => setState(() => isExpanded = !isExpanded),
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(context.textTheme.labelLarge?.copyWith(decoration: TextDecoration.underline))
          ),
          child: Text(isExpanded ? 'Less' : 'More'),
        ),
      );
    }
    return Wrap(
      spacing: 3.sp,
      runSpacing: 3.sp,
      children: children,
    );
  }
}
