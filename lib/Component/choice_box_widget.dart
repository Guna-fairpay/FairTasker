import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class ChoiceBoxWidget<T extends Object> extends StatelessWidget {
  final List<T>? items;
  final ItemAsString<T>? itemAsString;
  final Color? bgColor;

  const ChoiceBoxWidget({super.key, this.items, this.itemAsString, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: 10.padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Num.borderRadius),
          border: Border.all(
              width: Num.borderWidthThinField, color: AppC.borderColor)),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        alignment: WrapAlignment.start,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        runAlignment: WrapAlignment.center,
        direction: Axis.horizontal,
        spacing: 5,
        runSpacing: 5,
        children: ((items != null) || (items?.isNotEmpty ?? false))
            ? List.generate(
                (items?.length ?? 0),
                (index) => Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(30),
                              right: Radius.circular(30)),
                          color: bgColor ?? AppC.blue50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Text((itemAsString != null)
                          ? (itemAsString!(items![index])).toString()
                          : "${items?[index] ?? ""}"),
                    ))
            : [],
      ),
    );
  }
}
