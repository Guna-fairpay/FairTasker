import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerPickupTaskDialog {
  TaskerPickupTaskDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model, {void Function(DateTime date, TimeOfDay time, String? notes)? onSelected}) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (context) => _TaskerPickupTaskDialogView(model: model, onSelected: onSelected));
  }
}

class _TaskerPickupTaskDialogView extends StatelessWidget {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final Map<String, dynamic>? model;
  final void Function(DateTime date, TimeOfDay time, String? notes)? onSelected;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  _TaskerPickupTaskDialogView({this.model, this.onSelected}) {
    if (model != null) {
      _selectedDate = model?['todo_date'].toString().toDateTime();
      _selectedTime = model?['todo_time'].toString().toTimeOfDay(inputFormat: "HH:mm:ss");
      _dateController.text = _selectedDate?.toFormat() ?? "";
      _timeController.text = _selectedTime?.toHMS() ?? "";
      _notesController.text = model?['notes'].toString() ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      contentPadding: 10.horizontalPadding,
      insetPadding: 10.padding,
      title: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: const Text(""),
        trailing:
            IconButton(onPressed: context.popDialog, icon: const Icon(Icons.close_rounded)),
      ),
      content: SizedBox(
        width: context.width,
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Utils.getText("Pickup Car Task", size: 17.sp, weight: FontWeight.normal),
            const SizedBox.shrink(),
            Row(
              spacing: 10,
              children: [
                Expanded(
                    child: CustomDateTimePicker<DateTime>(
                      format: "yyyy-MM-dd",
                        suffixIcon: const Icon(Icons.calendar_month_rounded),
                        value: _selectedDate, controller: _dateController)),
                Expanded(
                    child: CustomDateTimePicker<TimeOfDay>(
                      format: "HH:mm",
                        showAsExpanded: true,
                        textAlign: TextAlign.center,
                        suffixIcon: const Icon(Icons.access_time_rounded),
                        value: _selectedTime, controller: _timeController)),
              ],
            ),
            Utils.getTextFormField("Notes", _notesController,
                minLines: 3,
                maxLines: 6,
                inputAction: TextInputAction.done,
                textType: TextInputType.multiline),
            if (onSelected != null)
              Utils.getFilledButton("Save", () {
              if (onSelected != null) {
                onSelected?.call(_selectedDate ?? DateTime.now(), _selectedTime ?? TimeOfDay.now(), _notesController.text);
                context.popDialog();
              }
            },),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
