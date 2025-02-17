import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:flutter/material.dart';

class ListWidget<T> extends StatelessWidget {
  final T item;
  final IconData? leadingIcon;
  final ItemAsString<T>? itemAsString;
  const ListWidget({super.key, required this.item, this.leadingIcon, this.itemAsString});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 0,
      minVerticalPadding: 0,
      leading: (leadingIcon != null) ? Icon(leadingIcon) : null,
      title: Text(itemAsString?.call(item).toString() ?? item.toString()),
    );
  }
}
