import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceCheckConfirmDialog {
  MaintenanceCheckConfirmDialog._();

  static void show(BuildContext context, {Map<dynamic, dynamic>? model, VoidCallback? onDelete, VoidCallback? onComplete, ValueChanged<Map<dynamic, dynamic>?>? onUpdate}) async {
    Console.of.log(model);
    await showDialog(context: context, builder: (context) => _MaintenanceCheckConfirmDialog(model: model, onComplete: onComplete, onDelete: onDelete, onUpdate: onUpdate));
  }
}

class _MaintenanceCheckConfirmDialog extends StatelessWidget {
  final Map<dynamic, dynamic>? model;
  final VoidCallback? onDelete, onComplete;
  final ValueChanged<Map<dynamic, dynamic>?>? onUpdate;
  late ValueNotifier<Map<String, dynamic>?> _selectedDropDown;
  _MaintenanceCheckConfirmDialog({super.key, this.model, this.onDelete, this.onComplete, this.onUpdate}) {
    _selectedDropDown = ValueNotifier(model?['selectedValue']);
  }
  final ValueNotifier<bool> _showDropDown = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      alignment: Alignment.topCenter,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      insetPadding: 10.sp.padding,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10.sp,
          children: [
            ValueListenableBuilder(valueListenable: _showDropDown, builder: (context, value, child) => Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10.sp,
              children: [
               if (!value)
                 ...[
                   Text("Task already exits, please complete or delete the task", style: context.textTheme.labelLarge?.copyWith(
                       fontSize: 12.sp
                   ),),
                   Row(
                     spacing: 10.sp,
                     mainAxisAlignment: MainAxisAlignment.end,
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       SuccessButton(
                         text: "Complete",
                         onPressed: () {
                           var identifierId = (model?['fix_task']?['identifier_id'] ?? 0);
                           Console.of.log("ID: $identifierId");
                           if (identifierId == 126) {
                             // OIL CHANGE
                             onComplete?.call();
                             context.popDialog();
                           } else {
                             _showDropDown.value = true;
                           }
                         },
                       ),
                       SuccessButton(
                         text: "Delete",
                         onPressed: () {
                           onDelete?.call();
                           context.popDialog();
                         },
                         backgroundColor: AppC.redAccent,
                       )
                     ],
                   ),
                 ]
                else
                  ...[
                    ValueListenableBuilder(valueListenable: _selectedDropDown, builder: (context, selectedValue, child) => Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10.sp,
                      children: [
                        CustomDropdown<Map<String, dynamic>>(
                            items: List.from(model?['children'] ?? [])..sort((a, b) => a['order'].compareTo(b['order'])),
                            itemAsString: (item) => item['name'].toString(),
                            value: selectedValue,
                            onChanged: (val) => _selectedDropDown.value = val,
                            contentPadding: 1.sp.padding.copyWith(left: 5.sp, right: 5.sp),
                            hintText: "Not Checked",
                            labelText: null,
                            isExpanded: true),
                        if (!(["good"].contains(selectedValue?['name'].toString().toLowerCase())))
                        Row(
                          spacing: 10.sp,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SuccessButton(
                              text: "Update Task",
                              onPressed: () {
                                onUpdate?.call(selectedValue);
                                context.popDialog();
                              },
                            )
                          ],
                        ),
                      ],
                    )),
                  ]
              ],
            )),
          ],
        ),
      ),
    );
  }
}
