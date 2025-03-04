import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class SimplePopUpMenu<T extends Object> {
  SimplePopUpMenu._();

  static final SimplePopUpMenu instance = SimplePopUpMenu._();

  void show<T extends Object>(BuildContext context,
      {required List<T> items,
      required Offset position,
      ItemAsString<T>? itemAsString,
      void Function(T item)? onTap}) async => await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          position.dx,
          position.dy,
          MediaQuery.of(context).size.width - position.dx,
          MediaQuery.of(context).size.height - position.dy,
        ),
        constraints: const BoxConstraints(),
        menuPadding: EdgeInsets.zero,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)
        ),
        elevation: 5,
        items: items
            .map((item) => PopupMenuItem(
                padding: 10.padding,
                textStyle: context.textTheme.labelMedium,
                value: item,
                onTap: () {
                  onTap?.call(item);
                },
                child: Text(
                  itemAsString?.call(item) ?? item.toString(),
                )))
            .toList());
}
