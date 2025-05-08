
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_bloc.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_state.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/ui/table_view_details.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveVerificationListingPage extends StatelessWidget {
  const LeaveVerificationListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveVerificationBloc, LeaveVerificationState>(
      builder: (context, state) {
        return SafeArea(
          minimum: 16.sp.padding,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Utils.getText('Status', size: 12.sp, weight: FontWeight.w600),
              5.sp.height,
              Utils.dropdownBox(
                  'Select Status',
                  context.read<LeaveVerificationBloc>().statusName,
                  (selectedValue)=>context.read<LeaveVerificationBloc>().add(LeaveVerificationStatusChangeEvent(selectedData: selectedValue)),
                  labelKey: 'name',
                initialSelection: context.read<LeaveVerificationBloc>().selectedStatus,
              ),
              12.sp.height,
              Utils.getText('Reason', size: 12.sp, weight: FontWeight.w600),
              5.sp.height,
              Utils.getTextFormField(
                null,
                context.read<LeaveVerificationBloc>().reasonController,
                hintText: 'Enter a reason',
                maxLines: 2,
                minLines: 2,
              ),
              12.sp.height,
              SuccessButton(
                onPressed: () => context.read<LeaveVerificationBloc>().add(LeaveVerificationSubmitEvent()),
              ),
              20.sp.height,
              Table(
                border: TableBorder.all(width: Num.borderWidthThinField, color: AppC.borderColor),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableViewDetails(label: "Name", value: context.read<LeaveVerificationBloc>().model['user']['name']),
                  TableViewDetails(label: "Leave Type", value: context.read<LeaveVerificationBloc>().model['leave_type']['name']),
                  TableViewDetails(label: "Start Date", value: "${context.read<LeaveVerificationBloc>().model['start_date'].toString().toDateTime().toFormat(format: 'MM-dd-yyyy')}"),
                  TableViewDetails(label: "End Date", value: "${context.read<LeaveVerificationBloc>().model['end_date'].toString().toDateTime().toFormat(format: 'MM-dd-yyyy')}"),
                  TableViewDetails(label: "Reason", value: context.read<LeaveVerificationBloc>().model['reason']),
                  TableViewDetails(label: "Status", value: context.read<LeaveVerificationBloc>().model['status']),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
