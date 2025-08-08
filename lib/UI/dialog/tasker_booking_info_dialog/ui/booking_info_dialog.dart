import 'package:fairpytasker/UI/dialog/tasker_booking_info_dialog/bloc/booking_info_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingInfoDialog {
  BookingInfoDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model) async {
    await showDialog(
        context: context,
        builder: (context) => _BookingInfoDialogView(model: model),
        barrierDismissible: true,
        useSafeArea: true);
  }
}

class _BookingInfoDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;

  const _BookingInfoDialogView({this.model});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      contentPadding: 10.spMin.padding,
      titlePadding: 10.spMin.padding,
      insetPadding: 10.spMin.padding,
      title: ListTile(
        dense: true,
        minTileHeight: 0,
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        title:
        Utils.getText("Booking Info", size: 17.spMin, weight: FontWeight.bold),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: Icon(Icons.close_rounded, size: 18.spMin),
        ),
      ),
      content: BlocProvider(
        create: (context) => BookingInfoBloc()..add(InitialEvent(model)),
        child: BlocListener<BookingInfoBloc, BookingInfoState>(
          listener: (context, state) {
            if(state is LoadingState){
              EasyLoading.show();
            }else{
              EasyLoading.dismiss();
              if(state is ErrorState){
                Toaster.showError(state.message.toString());
              }
            }
          },
          child: BlocBuilder<BookingInfoBloc, BookingInfoState>(
              builder: (context, state) {
                var model = context.read<BookingInfoBloc>().model;
                var name = model?['user']?['name'] ?? "";
                var email = model?['user']?['email'] ?? "";
                var bookedOn = model?['booked_on'].toString().toFormat(format: "MM-dd-yyyy") ?? "";
                var from = "${model?['booking_start_date'].toString().toFormat(format: "MM-dd-yy") ?? ""} ${model?['booking_start_time'].toString().toFormat(inputFormat: 'HH:mm:ss', format: "hh:mm a") ?? ""}";
                var till = "${model?['booking_return_date'].toString().toFormat(format: "MM-dd-yy") ?? ""} ${model?['booking_return_time'].toString().toFormat(inputFormat: 'HH:mm:ss', format: "hh:mm a") ?? ""}";
                var total = model?['cost_summary']?['finalEstimate'] ?? "";
                return Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  padding: 10.spMin.padding,
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(2),
                    },
                    border: TableBorder.all(
                        borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
                        width: Num.borderWidthThinField,
                        color: AppC.borderColor),
                    children: [
                      TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: Utils.getText("Name",
                                      size: 12.spMin,
                                      weight: FontWeight.bold,
                                      overFlow: TextOverflow.ellipsis),
                                )),
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: Utils.getText(
                                      name,
                                      size: 12.spMin,
                                      weight: FontWeight.normal,
                                      overFlow: TextOverflow.ellipsis),
                                )),
                          ]),
                      TableRow(children: [
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText("Email",
                                  size: 12.spMin,
                                  weight: FontWeight.bold,
                                  overFlow: TextOverflow.ellipsis),
                            )),
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText(
                                  email,
                                  size: 12.spMin,
                                  weight: FontWeight.normal,
                                  overFlow: TextOverflow.ellipsis),
                            )),
                      ]),
                      TableRow(children: [
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText("Booked On",
                                  size: 12.spMin,
                                  weight: FontWeight.bold,
                                  overFlow: TextOverflow.ellipsis),
                            )),
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText(
                                  bookedOn,
                                  size: 12.spMin,
                                  weight: FontWeight.normal,
                                  overFlow: TextOverflow.ellipsis),
                            )),
                      ]),
                      TableRow(children: [
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText("From",
                                  size: 12.spMin,
                                  weight: FontWeight.bold,
                                  overFlow: TextOverflow.ellipsis),
                            )),
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText(
                                  from,
                                  size: 12.spMin,
                                  weight: FontWeight.normal,
                                  overFlow: TextOverflow.ellipsis),
                            )),
                      ]),
                      TableRow(children: [
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText("Till",
                                  size: 12.spMin,
                                  weight: FontWeight.bold,
                                  overFlow: TextOverflow.ellipsis),
                            )),
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText(
                                  till,
                                  size: 12.spMin,
                                  weight: FontWeight.normal,
                                  overFlow: TextOverflow.visible),
                            )),
                      ]),
                      TableRow(children: [
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText("Total",
                                  size: 12.spMin,
                                  weight: FontWeight.bold,
                                  overFlow: TextOverflow.visible),
                            )),
                        TableCell(
                            child: Padding(
                              padding: 10.padding,
                              child: Utils.getText(
                                  "\$$total",
                                  size: 12.spMin,
                                  weight: FontWeight.normal,
                                  overFlow: TextOverflow.visible),
                            )),
                      ]),
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}
