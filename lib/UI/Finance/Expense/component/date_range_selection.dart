import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';

class DateRangePicker extends StatelessWidget {
  final DateRange? selectedDateRange;
  final String? splitter;
  final Function(DateRange) onDateRangeSelected;
  final EdgeInsets? padding;

  const DateRangePicker({
    super.key,
    this.splitter = "-",
    this.selectedDateRange,
    required this.onDateRangeSelected,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final List<DateTime?>? picked = await DateRagePicker.showDatePicker(
            context: context,
            initialFirstDate: selectedDateRange?.start ?? DateTime.now(),
            initialLastDate: selectedDateRange?.end ?? DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 2000)),
            lastDate: DateTime(DateTime.now().year + 5)
        );
        if (picked != null) {
          onDateRangeSelected(DateRange(picked.firstOrNull ?? DateTime.now(), picked.lastOrNull ?? DateTime.now()));
        }
      },
      child: Container(
        width: double.maxFinite,
        padding: padding ?? 8.spMin.padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Num.subradiusButton),
          border: Border.all(color: AppC.borderColor)
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
               ((selectedDateRange?.start == null) && (selectedDateRange?.end == null))
                   ? "Select Date Range"
                   : ((selectedDateRange?.start) == (selectedDateRange?.end))
                   ? selectedDateRange?.start.toFormat() ?? ""
                   : "${selectedDateRange?.start.toFormat() ?? ""} $splitter ${selectedDateRange?.end.toFormat() ?? ""}",
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelLarge?.copyWith(color: ((selectedDateRange?.start == null) && (selectedDateRange?.end == null))? AppC.grey : AppC.text),

              ),
            ),
            Icon(Icons.calendar_month_rounded, size: 13.spMin, color: AppC.subText,)
          ],
        ),
      ),
    );
    /*return DateRangeField(
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
    );*/
  }
}
