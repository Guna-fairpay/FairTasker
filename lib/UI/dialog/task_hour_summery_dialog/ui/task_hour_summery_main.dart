
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/dialog/task_hour_summery_dialog/bloc/task_hour_summery_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class  TaskHourSummeryMain {
  TaskHourSummeryMain._();
  static void show(
      BuildContext context, {
        dynamic name,
        List<dynamic>? hourSummeryData,
      }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _HourSummeryPopView(
        hourSummeryData: hourSummeryData,
        name: name,
      ),
    );
  }
}

class _HourSummeryPopView extends StatelessWidget {
  final List<dynamic>? hourSummeryData;
  final dynamic name;
  const _HourSummeryPopView({
    Key? key,
    this.name,
    this.hourSummeryData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskHourSummeryBloc()
        ..add(TaskHourSummeryInitialEvent(hourSummeryData: hourSummeryData)),
      child: BlocListener<TaskHourSummeryBloc, TaskHourSummeryState>(
        listener: (context, state) {

        },
        child: BlocBuilder<TaskHourSummeryBloc, TaskHourSummeryState>(
            builder: (context, state) {
              return AlertDialog(
                alignment: Alignment.topCenter,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
                  backgroundColor: AppC.white,
                  insetPadding: 10.sp.padding,
                  titlePadding: EdgeInsets.zero,
                  contentPadding: 5.sp.padding.copyWith(left: 15.sp, right: 20.sp, bottom: 15.sp),
                  title: ListTile(
                      title: Utils.getText(
                          "${name ?? ""} - Hour Summary",
                          color: AppC.appColor,
                          weight: FontWeight.bold,
                          size: 16.sp,

                      ),
                      trailing: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(),
                            2: IntrinsicColumnWidth(),
                          },
                          children: [
                          TableHeaderRow(
                              tableDecoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.sp),
                                    topRight: Radius.circular(4.sp)),
                                border: Border(bottom: BorderSide(color: AppC.borderColor, width: 1.sp),),
                                color: AppC.white,),
                              backgroundColor: AppC.appbgColor,
                              labels: const ["Task Name", "Count/Time", "Amount"],
                          ),
                            ...?context.read<TaskHourSummeryBloc>().hourSummeryData?.map((e) => TableRow(
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppC.borderColor, width: 1.sp),),
                              ),
                              children: [
                                TableCell(
                                    child: Padding(
                                      padding: 10.sp.padding,
                                      child: Utils.getText(e['task_name'] ?? ''),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: 10.sp.padding,
                                      child: Text(" ${e['task_name'].toString().toLowerCase().contains("other") ? (e['total_time'] ?? "") : (e['task_count'] ?? "")}"),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: 10.sp.padding,
                                      child: Text("\$${e['task_name'].toString().toLowerCase().contains("other") ? (e['hour_amount'] ?? "") : (e['total'] ?? "")}"),
                                    )),
                              ],
                            ),
                            ),
                          ],
                        ),
                        10.sp.height,
                        Align(
                          alignment: Alignment.centerRight,
                            child: Utils.getText("Total:\t\t \$${context.read<TaskHourSummeryBloc>().total.toString().toDoubleDigit}", weight: FontWeight.bold)),
                      ],
                    ),
                  ));
            }
        ),
      ),
    );
  }
}

