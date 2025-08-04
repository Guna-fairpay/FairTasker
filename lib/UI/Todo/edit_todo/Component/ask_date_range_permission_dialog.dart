
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utilities/Utils.dart';

class AskDateRangePermissionDialog {
  AskDateRangePermissionDialog._();

  static void show(BuildContext context,
      {
        String? startDate,
        String? endDate,
        DateTime? selectedStartDate,
        DateTime? selectedEndDate,
        required void Function(DateTime) onStartDate,
        required void Function(DateTime) onEndDate,
        void Function(String reason)? onReasonSubmitted,
        VoidCallback? onPositivePressed,
        bool? isReasonRequired,
        String? positiveText,
      }) async {
    final ValueNotifier<DateTime?> startDateNotifier = ValueNotifier(selectedStartDate);
    final ValueNotifier<DateTime?> endDateNotifier = ValueNotifier(selectedEndDate);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AskDateRangePermissionDialogView(
        startDate: startDate,
        endDate: endDate,
        onPositivePressed: onPositivePressed,
        selectedStartDate: selectedStartDate,
        selectedEndDate: selectedEndDate,
        onStartDate: onStartDate,
        isReasonRequired: isReasonRequired,
        onEndDate: onEndDate,
        endDateNotifier: endDateNotifier,
        startDateNotifier: startDateNotifier,
        positiveText: positiveText,
        onReasonSubmitted: onReasonSubmitted,
      ),
    );
  }
}

class _AskDateRangePermissionDialogView extends StatelessWidget {
  final String? startDate;
  final String? endDate;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final VoidCallback? onPositivePressed;
  final void Function(DateTime) onStartDate;
  final void Function(DateTime) onEndDate;
  final ValueNotifier<DateTime?> endDateNotifier;
  final ValueNotifier<DateTime?> startDateNotifier;
  final void Function(String reason)? onReasonSubmitted;
  final bool? isReasonRequired;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final String? positiveText;

  _AskDateRangePermissionDialogView(
      {super.key,
        this.startDate,
        this.endDate,
        this.selectedEndDate,
        this.selectedStartDate,
        this.onPositivePressed,
        required this.onStartDate,
        required this.endDateNotifier,
        required this.startDateNotifier,
        this.onReasonSubmitted,
        this.isReasonRequired,
        required this.onEndDate,
        this.positiveText,
      }){
    _startDateController.text = selectedStartDate?.toString() ?? '';
    _endDateController.text = selectedEndDate?.toString() ?? '';


  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: AppC.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: 16.padding,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: 10.spMin.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Utils.getText(
                  "Enter Date Range",
                  size: 18.spMin,
                  weight: FontWeight.bold,
                  align: TextAlign.center),
              8.height,
              Utils.getText("Recurring Start Date - $startDate", size: 14.spMin),
              8.height,
              Utils.getText("Recurring End Date - $endDate", size: 14.spMin),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                      child: Utils.getText("From", size: 14.spMin,align: TextAlign.center)),
                  Expanded(
                    flex: 2,
                    child: ValueListenableBuilder<DateTime?>(
                      valueListenable: startDateNotifier,
                      builder: (context, input, _) => CustomDateTimePicker<DateTime>(
                        controller: _startDateController,
                        format: "MM-dd-yyyy",
                        suffixIcon: Icon(Icons.calendar_month_rounded,
                            size: 15, color: context.theme.hintColor),
                        textAlign: TextAlign.center,
                        value: input,
                        onChanged: (value) {
                          startDateNotifier.value = value;
                          onStartDate(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Utils.getText("To", size: 14.spMin,align: TextAlign.center)),
                  Expanded(
                    flex: 2,
                    child: ValueListenableBuilder<DateTime?>(
                      valueListenable: endDateNotifier,
                      builder: (context, input, _) =>
                      CustomDateTimePicker<DateTime>(
                        controller: _endDateController,
                        format: "MM-dd-yyyy",
                        suffixIcon: Icon(Icons.calendar_month_rounded,
                            size: 15, color: context.theme.hintColor),
                        textAlign: TextAlign.center,
                        value: input,
                        onChanged: (input) {
                          endDateNotifier.value = input;
                          onEndDate(input);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              8.height,
              if(isReasonRequired ?? false)...[
                Utils.getTextFormField(
                'Enter a reason',
                _reasonController,
                validator: (value) => (value?.isEmpty ?? false) ? "Reason is required" : null,
              ), 8.height,
              ],
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                    ValueListenableBuilder(
                      valueListenable: _reasonController,
                      builder: (context, value, child) => SuccessButton(
                        text: positiveText ?? 'Update',
                        backgroundColor: (value.text.trim().isNullOrEmpty && (isReasonRequired ?? false)) ? Colors.blue.shade100 : AppC.blue,
                        foregroundColor: AppC.white,
                        onPressed: (value.text.trim().isNullOrEmpty && (isReasonRequired ?? false)) ? null : (){
                        if (isReasonRequired ?? false) {
                          if (_formKey.currentState?.validate() ?? false) {
                            onReasonSubmitted?.call(_reasonController.text);
                            Navigator.pop(context);
                          }
                        } else {
                          onPositivePressed?.call();
                          Navigator.pop(context);
                        }
                      },
                      ),
                    ),
                  SuccessButton(
                    text:  'Cancel',
                    backgroundColor: AppC.redAccent,
                    foregroundColor: AppC.white,
                    onPressed: () =>Navigator.pop(context),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
