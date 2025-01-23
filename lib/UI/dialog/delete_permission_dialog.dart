
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

class DeletePermissionDialog {
  DeletePermissionDialog._();

  static final DeletePermissionDialog of = DeletePermissionDialog._();

  void show(BuildContext context, Function(String val)? onSubmit) async {
    await showDialog(context: context, builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: _DeleteDialogView(controller: TextEditingController(), onSubmit: (val) {
       onSubmit?.call(val);
       Navigator.pop(context);
      }, onCancel: () => Navigator.pop(context)),
    ));
  }
}

class _DeleteDialogView extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onCancel;
  final Function(String val)? onSubmit;

  const _DeleteDialogView(
      {required this.controller, this.onSubmit, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.help_outline_sharp,
            size: 30,
            color: Colors.blue,
          ),
          // const SizedBox(height: ),
          Utils.getText('Are you sure?',
              size: 20, weight: FontWeight.w700, align: TextAlign.center),
          const SizedBox(height: 8),
          Utils.getText(
            'FairPy Inc, are you sure you want to delete this task? Kindly enter a valid reason to confirm the deletion',
            size: 12,
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Utils.getTextFormField('Enter a reason', controller),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, child) => Utils.getAddFilledButton(
                        'Yes, delete it!',
                        () {
                          if (controller.text.isNotEmpty) {
                            onSubmit?.call(controller.text);
                          }
                        },
                        bgColor: (value.text.isNotEmpty)
                            ? AppC.blue
                            : AppC.blue.withOpacity(0.5),
                      )),
              Utils.getAddFilledButton(
                'Cancel',
                () => onCancel?.call(),
                bgColor: AppC.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
