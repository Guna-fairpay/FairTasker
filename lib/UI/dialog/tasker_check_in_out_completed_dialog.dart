import 'package:fairpytasker/UI/dialog/tasker_check_in_out_dialog_bloc/tasker_check_in_out_dialog_bloc.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerCheckInOutCompleteDialog {
  TaskerCheckInOutCompleteDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model,
      {bool isCheckOut = false, ValueChanged<DateTime>? onYesterday}) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => _TaskerCompleteCheckInOutView(
            model: model, isCheckOut: isCheckOut, onYesterday: onYesterday));
  }
}

class _TaskerCompleteCheckInOutView extends StatelessWidget {
  final bool isCheckOut;
  final Map<String, dynamic>? model;
  final ValueChanged<DateTime>? onYesterday;
  const _TaskerCompleteCheckInOutView({this.isCheckOut = false, this.model, this.onYesterday});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: 10.padding,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
        backgroundColor: AppC.white,
        alignment: Alignment.topCenter,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          minTileHeight: 0,
          dense: true,
          horizontalTitleGap: 0,
          trailing: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded)),
        ),
        elevation: 5,
        content: BlocProvider(
          create: (context) => TCIODBloc()
            ..add(TCIODInitialEvent(isCheckout: isCheckOut, model: model)),
          child: BlocListener<TCIODBloc, TCIODStates>(
            listener: (context, state) {
              if (state is TCIODLoadingState) {
                if (!EasyLoading.isShow) EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
                switch (state) {
                  case TCIODSuccessState(): Toaster.showSuccess(state.message); break;
                  case TCIODErrorState(): Toaster.showError(state.message); break;
                  case NavigateYesterdayState(): {
                    onYesterday?.call(state.date);
                    context.pop();
                  } break;
                }
              }
            },
            child: const _TaskerCompleteCheckInOutContentView(),
          ),
        ));
  }
}

class _TaskerCompleteCheckInOutContentView extends StatelessWidget {
  const _TaskerCompleteCheckInOutContentView();

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<TCIODBloc, TCIODStates>(
      builder: (context, state) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.getText( "${context.watch<TCIODBloc>().isCheckOut ? "Check Out" : "Yesterday Hours"} summary", size: 17.sp),
            if (context.watch<TCIODBloc>().showPendingCounts)
            Text.rich(TextSpan(
              children: [
                TextSpan(text: "You have ${context.watch<TCIODBloc>().previousTaskCounts} pending tasks from yesterday."),
                const TextSpan(text: "\n"),
                TextSpan(text: "Do you want to go yesterday - ", children: [
                  TextSpan(text: "Click here",
                      recognizer: TapGestureRecognizer()..onTap = ()=> context.read<TCIODBloc>().add(NavigateYesterdayEvent()),
                      style: context.textTheme.labelLarge?.copyWith(color: AppC.bouncieButtonColor))
                ]),
              ]
            ), style: context.textTheme.labelLarge,),
            Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        Utils.getText("00:00",
                            weight: FontWeight.bold, size: 32.spMin, color: AppC.red),
                        Utils.getText(
                          "Idle Time",
                          size: 12.spMin,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: 'Checkin ',
                                  style: context.textTheme.labelMedium?.copyWith(
                                    fontSize: 12.spMin,
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextSpan(
                                  text: context.watch<TCIODBloc>().checkInTime.toHM(),
                                  style: context.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.spMin,
                                      color: AppC.green))
                            ])),
                          ],
                        ),
                      ],
                    )),
                Expanded(
                    child: Column(
                      children: [
                        Utils.getText(context.watch<TCIODBloc>().activeHours.toHM(),
                            weight: FontWeight.bold, size: 32.spMin, color: AppC.green),
                        Utils.getText("Total Active Hours",
                            weight: FontWeight.bold, size: 12.spMin),
                        10.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                    text: 'Checkout ',
                                    style: context.textTheme.labelMedium?.copyWith(
                                      fontSize: 12.spMin,
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(
                                    text: context.watch<TCIODBloc>().checkOutTime.toHM(),
                                    style: context.textTheme.labelMedium?.copyWith(
                                        fontSize: 12.spMin,
                                        fontWeight: FontWeight.bold,
                                        color: AppC.red))
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                var model = context.watch<TCIODBloc>().toDoList[index];
                return ListTile(
                  dense: true,
                  minLeadingWidth: 0,
                  minVerticalPadding: 0,
                  horizontalTitleGap: 0,
                  leading: Utils.getText(model['title'] ?? "",
                      color: AppC.appColor, size: 12.spMin, weight: FontWeight.bold),
                  trailing: Utils.getText(model['complete_time_taken'] ?? "00:15",
                      weight: FontWeight.normal, size: 12.spMin, color: model['complete_time_taken'].toString().isNullOrEmpty ? AppC.red : AppC.text),
                  contentPadding: 10.horizontalPadding,
                );
              },
                separatorBuilder: (context, index) => const Divider(height: 0.2,),
              itemCount: context.watch<TCIODBloc>().toDoList.length,),
            )
          ],
        ),
      ),
    );
  }
}
