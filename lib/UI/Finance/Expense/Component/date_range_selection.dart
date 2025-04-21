import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:intl/intl.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';

class DateRangePicker extends StatelessWidget {
  final DateRange? selectedDateRange;
  final Function(DateRange) onDateRangeSelected;

  const DateRangePicker({
    super.key,
    this.selectedDateRange,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DateRangeField(
      decoration:
      InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Num.subradiusButton),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Num.subradiusButton),
          borderSide: const BorderSide(color: AppC.grey),
        ),
        filled: true,
        constraints: const BoxConstraints(maxHeight: 40),
        isDense: true,
      ),
      childBuilder: (context, value) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Utils.getText(
                  ((selectedDateRange?.start) == (selectedDateRange?.end)) ? "${selectedDateRange?.start.toFormat()}" : "${DateFormat("yyyy-MM-dd").format(selectedDateRange!.start)} - ${DateFormat("yyyy-MM-dd").format(selectedDateRange!.end)}",
                overFlow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      onDateRangeSelected: (DateRange? value) {
        if (value != null) {
          onDateRangeSelected(value);
        }
      },
      pickerBuilder: (context, onDateRangeChanged) {
        return DateRangePickerWidget(
           doubleMonth: false,
          initialDateRange: selectedDateRange,
          initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
          onDateRangeChanged: onDateRangeChanged,
          allowSingleTapDaySelection: true,
          height: MediaQuery.of(context).size.height * 0.40,
          displayMonthsSeparator: true,
        );
      },
    );
  }
}
