import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerViewOnly extends StatefulWidget {
  final TodoListRepo? todoListRepo;
  final VoidCallback? voidCallback;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  const TimePickerViewOnly({super.key, this.todoListRepo, this.voidCallback, this.textStyle, this.padding});

  @override
  State<TimePickerViewOnly> createState() => _TimePickerViewOnlyState();
}

class _TimePickerViewOnlyState extends State<TimePickerViewOnly> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Num.subradiusButton),
          border: Border.all(
            color: AppC.fieldBase,
            width: Num.borderWidthField,
          )),
      child: Padding(
        padding:  widget.padding ?? const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          onTap: () {
            _selectTime(context, TextEditingController());
          },
          child: Text(
            widget.todoListRepo?.chosenDateTimeString ?? '',
            style: widget.textStyle ?? Utils.getTextStyle(
                color: AppC.subText, weight: FontWeight.bold, size: 12),
          ),
        ),
      ),
    );
  }

  void _selectTime(BuildContext context, TextEditingController controller) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: DateTime.now().hour,
        minute: DateTime.now().minute,
      ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,
                dialBackgroundColor: Colors.grey[100],
                dialHandColor: Colors.blue[900],
                dayPeriodTextColor: Colors.black,
                helpTextStyle: const TextStyle(color: Colors.black),
                dialTextStyle:
                    const TextStyle(color: AppC.appColor, fontSize: 20),
              ),
            ),
            child: child!,
          ),
        );
      },
    ).then((selectedTime) {
      if (selectedTime != null) {
        final now = DateTime.now();
        final selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        controller.text = Utils.convertDateTimeToTimeString(selectedDateTime);

        setState(() {
          widget.todoListRepo?.chosenDateTime = selectedDateTime;
          widget.todoListRepo?.chosenDateTimeString =
              DateFormat("HH:mm").format(selectedDateTime);
          widget.todoListRepo?.startTimeTFString =
              DateFormat("HH:mm:ss").format(selectedDateTime);
        });

        widget.voidCallback?.call();
      }
    });
  }
}
