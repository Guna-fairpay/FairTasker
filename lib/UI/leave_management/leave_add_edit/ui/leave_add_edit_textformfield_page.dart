
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Component/custom_radio_button.dart';
import 'package:fairpytasker/UI/leave_management/leave_add_edit/bloc/leave_add_edit_bloc.dart';
import 'package:fairpytasker/UI/leave_management/leave_add_edit/bloc/leave_add_edit_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_add_edit/bloc/leave_add_edit_state.dart';
import 'package:fairpytasker/UI/leave_management/leave_add_edit/component/date_time_pickers_in_row.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveAddEditTextFormFieldPage extends StatelessWidget {
  const LeaveAddEditTextFormFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveAddEditBloc,LeaveAddEditState>(
      builder: (context, state) {
        return SafeArea(
          minimum: 16.sp.padding,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Utils.getText('Leave Type',weight: FontWeight.bold),
              5.sp.height,
              Utils.dropdownBox(
                  'Select',
                  context.read<LeaveAddEditBloc>().leaveTypes,
                  (value)=>context.read<LeaveAddEditBloc>().add(LeaveTypeSelectionEvent(selectedLeaveType: value)),
                  labelKey: 'name',
                initialSelection: context.read<LeaveAddEditBloc>().selectedLeaveType,
              ),
              12.sp.height,
              DateTimePickersInRow<DateTime>(
                format: 'MM-dd-yyyy',
                icon: Icon(Icons.calendar_month_outlined,size: 14.sp),
                firstLabel: 'Start Date',
                startController: context.read<LeaveAddEditBloc>().startDateController,
                firstValue: context.read<LeaveAddEditBloc>().startDate,
                onFirstChanged: (value)=>context.read<LeaveAddEditBloc>().add(StartDateSelectionEvent(selectedStartDate: value)),
                secondLabel: 'End Date',
                secondValue: context.read<LeaveAddEditBloc>().endDate,
                endController: context.read<LeaveAddEditBloc>().endDateController,
                onSecondChanged: (value)=>context.read<LeaveAddEditBloc>().add(EndDateSelectionEvent(selectedEndDate: value)),
              ),
              if(context.read<LeaveAddEditBloc>().selectedLeaveType?['id'].toString() == '8')...[
                12.sp.height,
                Row(
                  children: [
                    CustomRadioButton<String>(
                        label: 'First half',
                        value: 'first',
                        groupValue:context.watch<LeaveAddEditBloc>().currentButton,
                        onChanged: (v)=>context.read<LeaveAddEditBloc>().add(RadioButtonSelectionEvent(value: v)),
                    ),
                    CustomRadioButton<String>(
                      label: 'Second half',
                      value: 'second',
                      groupValue:context.watch<LeaveAddEditBloc>().currentButton,
                      onChanged: (v)=>context.read<LeaveAddEditBloc>().add(RadioButtonSelectionEvent(value: v)),
                    ),
                  ],
                ),
              ],
              if(['8','9'].contains(context.read<LeaveAddEditBloc>().selectedLeaveType?['id'].toString()))...[
                12.sp.height,
                DateTimePickersInRow<TimeOfDay>(
                  format: 'HH:mm',
                  icon: Icon(Icons.access_time_outlined,size: 14.sp),
                  firstLabel: 'Start Time',
                  startController: context.read<LeaveAddEditBloc>().startTimeController,
                  firstValue: context.read<LeaveAddEditBloc>().startTime,
                  onFirstChanged: (value)=>context.read<LeaveAddEditBloc>().add(StartTimeSelectionEvent(selectedStartTime: value)),
                  secondLabel: 'End Time',
                  secondValue: context.read<LeaveAddEditBloc>().endTime,
                  endController: context.read<LeaveAddEditBloc>().endTimeController,
                  onSecondChanged: (value)=>context.read<LeaveAddEditBloc>().add(EndTimeSelectionEvent(selectedEndTime: value)),
                ),
              ],
              12.sp.height,
              Utils.getText('Reason',weight: FontWeight.bold),
              5.sp.height,
              Utils.getTextFormField(
                  null,
                  context.read<LeaveAddEditBloc>().reasonController,
                  maxLines:2,
                  minLines: 2,
                hintText: 'Enter Reason',
              ),
              12.sp.height,
              SuccessButton(
                text: context.read<LeaveAddEditBloc>().model != null? 'Update' : 'Submit',
                onPressed: () => context.read<LeaveAddEditBloc>().add(SaveLeaveEvent()),
              ),
            ],
          ),
        );
      }
    );
  }
}
