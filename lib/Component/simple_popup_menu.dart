import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimplePopUpMenu<T extends Object> {
  SimplePopUpMenu._();

  static final SimplePopUpMenu instance = SimplePopUpMenu._();

  void show<T extends Object>(BuildContext context,
          {required List<T> items,
          required Offset position,
          double? height,
          ItemAsString<T>? itemAsString,
          void Function(T item)? onTap}) async =>
      await showMenu(
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
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
          elevation: 5,
          items: items
              .map((item) => PopupMenuItem(
                  padding: 10.spMin.padding,
                  height: height ?? kMinInteractiveDimension,
                  textStyle: context.textTheme.labelMedium,
                  value: item,
                  onTap: () {
                    onTap?.call(item);
                  },
                  child: ((item is Map) && (item.containsKey("showSort")))
                      ? ListTile(
                          dense: true,
                          minTileHeight: 0,
                          minVerticalPadding: 0,
                          minLeadingWidth: 0,
                          // horizontalTitleGap: 0,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                              ((item['asc'] as bool)
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward),
                              color: (item['asc'] as bool)
                                  ? Colors.green
                                  : Colors.red,
                            size: 16,
                          ),
                          title: Text(
                            itemAsString?.call(item) ?? item.toString(),
                          ),
                        )
                      : Text(
                          itemAsString?.call(item) ?? item.toString(),
                        )))
              .toList());
}
