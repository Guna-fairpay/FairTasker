import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class CustomWeekdaysGridview<T  extends Object> extends StatelessWidget {
  final List<T> items;
  final List<T>? selectedItems;
  final ItemAsString<T>? itemAsString;
  final ValueChanged<T>? onChanged;
  final ScrollPhysics? scrollPhysics;

  const CustomWeekdaysGridview(
      {super.key,
      required this.items,
      this.selectedItems,
      this.itemAsString,
      this.onChanged,
      this.scrollPhysics = const NeverScrollableScrollPhysics()});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          physics: scrollPhysics,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2),
          itemBuilder: (context, index) {
            var model = items[index];
            var isSelected = selectedItems?.contains(model) ?? false;
            var textValue = (itemAsString != null
                    ? itemAsString!(items[index])
                    : items[index])
                .toString();
            return ListTile(
              horizontalTitleGap: 0,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => onChanged?.call(model),
              leading: Checkbox(
                value: isSelected,
                onChanged: (value) => onChanged?.call(model),
                checkColor: AppC.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
                ),
                fillColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? AppC.appColor
                        : Colors.white),
              ),
              title: Text(textValue),
              minLeadingWidth: 0,
              minVerticalPadding: 0,
              style: ListTileStyle.list,
              titleTextStyle: context.textTheme.labelLarge
                  ?.copyWith(overflow: TextOverflow.ellipsis),
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          },
          shrinkWrap: true,
          itemCount: items.length,
        ),
        if (selectedItems?.isEmpty ?? false)
          Utils.getText("Please select at least one option",
              align: TextAlign.start,
              style: context.textTheme.labelSmall
                  ?.copyWith(color: context.theme.colorScheme.error))
      ],
    );
  }
}
