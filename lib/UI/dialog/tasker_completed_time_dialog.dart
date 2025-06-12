import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter, LengthLimitingTextInputFormatter;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerCompletedTimeDialog {
  TaskerCompletedTimeDialog._();

  static void show(BuildContext context, Map<String, dynamic>? data, {void Function(String timeTaken, String? reason)? onChanged}) async {
    await showDialog(
      context: context,
      builder: (context) => _TaskerCompletedTimeDialogView(model: data, onChanged: onChanged),
    );
  }
}

class _TaskerCompletedTimeDialogView extends StatelessWidget {
  final TextEditingController timeTakenController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final ValueNotifier<String> _selectedTimeTaken = ValueNotifier("");
  final Map<String, dynamic>? model;
  String _selectedCompletedTime = "";
  final void Function(String timeTaken, String? reason)? onChanged;
  _TaskerCompletedTimeDialogView({this.onChanged, required this.model}) {
    _selectedCompletedTime = model?['display']?['completed_time'] ?? "";
    _selectedTimeTaken.value = _selectedCompletedTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      insetPadding: 10.padding,
      title: ListTile(
        dense: true,
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        minTileHeight: 0,
        contentPadding: 16.padding,
        title: Utils.getText("Task Completed - Time", size: 16.spMin, weight: FontWeight.bold, color: AppC.appColor, overFlow: TextOverflow.ellipsis),
        trailing: IconButton(onPressed: context.popDialog, icon: const Icon(Icons.close_rounded)),
      ),
      content: SizedBox(
        width: context.width,
        child: ListView(
          shrinkWrap: true,
          children: [
            Utils.getText(
              'How long this task taken to complete?',
              weight: FontWeight.bold,
            ),
            ValueListenableBuilder(valueListenable: _selectedTimeTaken, builder: (context, value, child) {
             return Column(
               mainAxisSize: MainAxisSize.min,
               spacing: 10,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Wrap(
                   spacing: 10,
                   runSpacing: 5,
                   crossAxisAlignment: WrapCrossAlignment.center,
                   clipBehavior: Clip.antiAliasWithSaveLayer,
                   alignment: WrapAlignment.spaceAround,
                   runAlignment: WrapAlignment.spaceAround,
                   children: [
                     ...[
                       '00:15', '00:30', '00:45', '01:00', '01:15',
                       '01:30', '01:45', '02:00', '02:15', '02:30',
                       '02:45', '03:00', '03:15', '03:30', '03:45',
                       '04:00', '> 4 hours'
                     ].map((e) => ChoiceChip(
                       label: Utils.getText(
                         e,
                         color: (e == value) ? AppC.white : (e == "> 4 hours") ? AppC.red : AppC.appColor,
                         weight: FontWeight.bold,
                       ),
                       selected: (e == value) ,
                       labelPadding: EdgeInsets.zero,
                       selectedColor: AppC.appColor,
                       disabledColor: Colors.blue[50],
                       showCheckmark: false,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(4.0),
                         side: const BorderSide(
                           color: AppC.appColor,
                           width: 0.5,
                         ),
                       ),
                       backgroundColor: Colors.blue[50],
                       onSelected: (bool selected) {
                         _selectedCompletedTime = e;
                         _selectedTimeTaken.value = e;
                       },
                     )).toList(),
                   ],
                 ),
                 if (value.contains(">"))
                   ...[
                     Row(
                       children: [
                         Expanded(
                           child: Utils.getText(
                             'Enter the time taken:',
                             weight: FontWeight.bold,
                           ),
                         ),
                         Expanded(
                           child: Utils.getTextFormField(
                             'eg: 05:00',
                             timeTakenController,
                             hintText: "00:00",
                             textInputFormatter: [
                               LengthLimitingTextInputFormatter(5),
                               FilteringTextInputFormatter.allow(RegExp(r'[0-9:]'))
                             ],
                           ),
                         ),
                       ],
                     ),
                     ValueListenableBuilder(valueListenable: timeTakenController, builder: (context, value, child) => Visibility(
                       visible: (value.text.isValidCompletedTime == false),
                       child: Utils.getText(
                         value.text.notValidCompletedTimeMessage,
                         color: AppC.red,
                       ),
                     )),
                     const SizedBox(height: 10),
                   ],
                 if (value != (model?['display']?['completed_time'] ?? ""))
                   ...[
                     Utils.getBorderedMultilineTextField('Reason',
                       reasonController,
                       minLines: 2,
                       autoValidate: AutovalidateMode.always,
                       validator: (val) => (val?.trim().isNullOrEmpty ?? false) ? 'Please enter reason for extra time' : null,
                     ),
                   ]
               ],
             );
            }),
            Utils.getFilledButton('Submit', () {
              if (timeTakenController.text.isNotNullOrEmpty && (timeTakenController.text.isValidCompletedTime == false)) return;
              if (_selectedCompletedTime.contains(">") && timeTakenController.text.isEmpty && reasonController.text.trim().isEmpty && !(timeTakenController.text.isValidCompletedTime)) return;
              if ((_selectedCompletedTime != (model?['display']?['completed_time'] ?? "")) && reasonController.text.trim().isNullOrEmpty) return;
              var reason = (_selectedCompletedTime != (model?['display']?['completed_time'] ?? "")) ? reasonController.text : null;
              var completedTime = (_selectedCompletedTime.contains(">")) ? timeTakenController.text : _selectedCompletedTime;
              if (onChanged != null) {
                onChanged?.call(completedTime, reason);
                context.popDialog();
              }
            }, bgColor: AppC.green),
          ],
        ),
      ),
    );
  }
}
