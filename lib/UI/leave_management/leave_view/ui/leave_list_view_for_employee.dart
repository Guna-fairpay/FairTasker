
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_bloc.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_state.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveListViewForEmployee extends StatelessWidget {
  const LeaveListViewForEmployee({super.key});

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                     itemCount: context.read<LeaveViewBloc>().filteredResponse.length,
                    itemBuilder: (context ,index) {
                      final item = context.read<LeaveViewBloc>().filteredResponse[index];
                      return  Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Num.borderRadius),
                            shape: BoxShape.rectangle,
                            border: Border.all(color: AppC.borderColor,
                                width: Num.borderWidthThinField)
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        padding: 10.spMin.padding,
                        margin: 10.spMin.padding,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Utils.getText(item['leave_type']?['name'],weight: FontWeight.bold),
                                trailing: Utils.getText(
                                    "${(item['start_date'] ?? '').toString().toDateTime().toFormat(format: 'MM-dd-yy')} to "
                                        "${(item['end_date'] ?? '').toString().toDateTime().toFormat(format: 'MM-dd-yy')}",
                                  size: 12.spMin,
                                ),
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                minVerticalPadding: 0,
                              ),
                              ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  minVerticalPadding: 0,
                                  title: Text.rich(TextSpan(
                                      text: "Reason: ",
                                      children: [TextSpan(text: item['reason'],
                                          style: const TextStyle(color: AppC.grey,))
                                      ],
                                  ), style: TextStyle(fontSize: 12.spMin),),
                                  trailing:(item['start_time'] != null)? Utils.getText(
                                    "${(item['start_time']).toString().toDateTime(inputFormat: "HH:mm:ss").toFormat(format: 'hh:mm a') ?? ''} to "
                                        "${(item['end_time']).toString().toDateTime(inputFormat: "HH:mm:ss").toFormat(format: 'hh:mm a') ?? ''}",
                                    size: 12.spMin,):null,
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                minVerticalPadding: 0,
                                title: (item['admin_reason'] != null) ? Text.rich(
                                   TextSpan(
                                    text: "Admin Reason: ",
                                    children: [TextSpan(text: item['admin_reason'], style: const TextStyle(color: AppC.grey),)]) ,
                                  style: TextStyle(fontSize: 12.spMin),
                                ) : const SizedBox.shrink(),
                                  trailing: IconButton( onPressed: ()=> context.read<LeaveViewBloc>().add(AddEditPageEvent(leaveData: item)),icon: Icon(Icons.mode_edit_outlined,size: 18.spMin,color: AppC.appColor) )
                              ),
                              Container(
                                padding: 1.spMin.padding,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Num.borderRadius),
                                  shape: BoxShape.rectangle,
                                  color: item['status'] == 'Approved' ? const Color(0xffe1f3eb)
                                      : item['status'] == 'Rejected' ? const Color(0xfffde8e4)
                                      : item['status'] == 'Pending' ? const Color(0xfffde8e4)
                                      : AppC.text,
                                ),
                                child: Utils.getText(item['status'],
                                  color: item['status'] == 'Approved' ? AppC.green
                                      : item['status'] == 'Rejected' ? AppC.red
                                      : item['status'] == 'Pending' ? const Color(0xffff4500)
                                      : AppC.text,
                                  size: 9.spMin,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            ]
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
