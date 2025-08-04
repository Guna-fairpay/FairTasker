
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Components/popup_with_icons.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_bloc.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_state.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/ui/leave_list_view_item.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveViewListingPage extends StatelessWidget {
  const LeaveViewListingPage({super.key});

  @override
  Widget build(BuildContext contextie) {
    return BlocBuilder<LeaveViewBloc,LeaveViewState>(
      builder: (context,state) {
        return SafeArea(
          minimum: 10.padding,
          child: Column(
            // physics: const NeverScrollableScrollPhysics(),
            children: [
              Row(
                spacing: 10,
                children: [
                  Expanded(child: Utils.dropdownBox(
                    'Select Employee',
                    context.read<LeaveViewBloc>().employeeList,
                        (value) => context.read<LeaveViewBloc>().add(EmployeeSelectedEvent(value)),
                    labelKey: 'first_name',
                    labelKey2: 'last_name',
                    initialSelection: context.read<LeaveViewBloc>().selectedEmployee,
                    height: 28.spMin,
                    borderColor: AppC.blue,
                    borderWidth: 1,
                  )),
                  Expanded(
                    flex: 3,
                    child: CompactSearchView(
                      controller: context.read<LeaveViewBloc>().searchController,
                      onChanged: (value) => context.read<LeaveViewBloc>().add(SearchEvent(value)),
                    ),
                  ),
                  SuccessButton(
                    icon: Icons.add,
                    onPressed: ()=>context.read<LeaveViewBloc>().add(AddEditPageEvent()),
                    text: 'Apply',
                    backgroundColor: AppC.appColor,
                  ),
                ],
              ),
              10.spMin.height,
              Table(
                columnWidths:const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(3),
                  3: FlexColumnWidth(3),
                  4: IntrinsicColumnWidth(),
                  5: FlexColumnWidth(),
                  6: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border:  const TableBorder(
                    horizontalInside: BorderSide(
                        color: AppC.borderColor,
                        width: Num.borderWidthThinField)),
                children: [
                  TableRow(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Num.borderRadius)),
                          color: AppC.appbgColor),
                      children: [
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 5.spMin, right: 5.spMin),
                            child: Text("Name",
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.spMin))),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 5.spMin, right: 5.spMin),
                            child: Text("Type",
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.spMin))),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 5.spMin, right: 5.spMin),
                            child: Text("Reason",
                                textAlign: TextAlign.start,
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.spMin))),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 5.spMin, right: 5.spMin),
                            child: Text("Date",
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.spMin))),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 5.spMin, right: 5.spMin),
                            child: Text("#",
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.spMin))),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 5.spMin, right: 5.spMin),
                            child: Text("#",
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppC.trans,
                                    fontSize: 12.spMin))),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 5.spMin, right: 5.spMin),
                            child: Icon(Icons.edit_outlined,size: 16.spMin,)),
                      ]),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths:const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(3),
                      3: FlexColumnWidth(3),
                      4: IntrinsicColumnWidth(),
                      5: FlexColumnWidth(),
                      6: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border:  const TableBorder(
                        horizontalInside: BorderSide(
                            color: AppC.borderColor,
                            width: Num.borderWidthThinField)),
                    children: context.watch<LeaveViewBloc>().filteredResponse.map((e) => LeaveListViewItem(
                      model: e,
                      onTapDown: (details) => PopupWithIcons.show(contextie, details,
                          icon2: Icons.verified_outlined,
                          color2: AppC.green,
                          onIcon1Tap: ()=>context.read<LeaveViewBloc>().add(AddEditPageEvent(leaveData: e)),
                          onIcon2Tap: () => context.read<LeaveViewBloc>().add(VerificationPageEvent(leaveData: e))
                      ),
                    )).toList(),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
