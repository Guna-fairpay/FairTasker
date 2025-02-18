import 'dart:developer';

import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class ShowChipDialog<T> {
  ShowChipDialog._();

  static void show<T>(BuildContext context, {required String title, List<dynamic>? data, ItemAsString<T>? itemAsString, Widget? avatarIcon}) async {
    log("$data", name: "ShowChipDialog");
    await showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (context) => _ShowViewUsersDialog(title: title, data: data, itemAsString: itemAsString, avatarIcon: avatarIcon));
  }
}

class _ShowViewUsersDialog<T> extends StatelessWidget {
  final List<dynamic>? data;
  final String title;
  final ItemAsString<T>? itemAsString;
  final Widget? avatarIcon;
  const _ShowViewUsersDialog({super.key, required this.title, this.data, this.itemAsString, this.avatarIcon});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      backgroundColor: Colors.white,
      title: ListTile(
        title: Text(title),
        trailing: GestureDetector(
          onTap: () => context.popDialog(),
          child: const Icon(Icons.close_rounded),
        ),
        titleTextStyle: context.textTheme.titleLarge,
      ),
      titlePadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      insetPadding: 10.horizontalPadding,
      contentPadding: 10.padding,
      content: Container(
        width: context.width,
        padding: const EdgeInsets.only(bottom: 10),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          runAlignment: WrapAlignment.center,
          direction: Axis.horizontal,
          runSpacing: 5,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: data?.map((e) => ChoiceChip(
            label: Text(itemAsString?.call(e) ?? '$e'),
            labelStyle: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            selected: false,
            elevation: 5,
            color: WidgetStatePropertyAll(AppC.blue50),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            avatar: avatarIcon,
            side: BorderSide.none,
            onSelected: (value) {

            },
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(Num.borderRadiusXLarge + 4)),
          )).toList() ?? [],
        ),
      ),
    );
  }
}
