import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class TaskerAddressChangeDialog {
  TaskerAddressChangeDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model,
      {void Function(Map<String, dynamic>)? onSelected}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) =>
          _TaskerAddressChangeDialog(model: model, onSelected: onSelected),
    );
  }
}

class _TaskerAddressChangeDialog extends StatelessWidget {
  final Map<String, dynamic>? model;
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _selectedAddress;
  final void Function(Map<String, dynamic>)? onSelected;

  _TaskerAddressChangeDialog({required this.model, this.onSelected}) {
    _controller.text = model?['display']?['selectedAddress']?['address'] ?? "";
    _selectedAddress = model?['display']?['selectedAddress'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      alignment: Alignment.topCenter,
      insetPadding: 10.padding,
      title: ListTile(
          dense: true,
          minTileHeight: 0,
          minVerticalPadding: 0,
          minLeadingWidth: 0,
          horizontalTitleGap: 0,
          contentPadding: EdgeInsets.zero,
          title: Text("${model?['display']?['task_title']}"),
          titleTextStyle: context.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          trailing: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )),
      content: Container(
          constraints: BoxConstraints(minWidth: context.width),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SearchViewField<Map<String, dynamic>>(
                controller: _controller,
                suggestions: model?['display']?['addresses'] ?? [],
                itemAsString: (item) => item['address'] ?? "",
                onSelected: (value) {
                  _selectedAddress = value;
                  _controller.text = value['address'] ?? "";
                },
                selectedItem: model?['display']?['selectedAddress'],
                showEmpty: false),
            Utils.getFilledButton("Save", () {
              if (model?['display']?['selectedAddress'] != _selectedAddress) {
                onSelected?.call(_selectedAddress ?? {});
                Navigator.pop(context);
              } else if (_controller.text.trim().isNullOrEmpty) {
                onSelected?.call({});
                Navigator.pop(context);
              }
            })
          ])),
    );
  }
}
