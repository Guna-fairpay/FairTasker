import 'package:fairpytasker/UI/Finance/Expense/component/icon_and_text.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/verification_enum.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class AgreementStatusList extends StatelessWidget {
  final dynamic data;
  const AgreementStatusList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String bookingId = data?['booking_id'] ?? '';
    String status = data?['status_display_name'] ?? '';
    String statusName = data?['status_name'] ?? '';
    String user = data?['user']?['name'] ?? '';
    String email = data?['user']?['email'] ?? '';
    String bookingOn = data?['booked_on'].toString().toFormat(format: 'MM-dd-yyyy') ?? '';
    String fromDate = data?['booking_start_date'].toString().toFormat(format: 'MM-dd-yy') ?? '';
    String fromTime = data?['booking_start_time'].toString().toFormat(inputFormat: 'hh:mm:ss', format: 'HH:mm a') ?? '';
    String toDate = data?['booking_return_date'].toString().toFormat(format: 'MM-dd-yy') ?? '';
    String toTime = data?['booking_return_time'].toString().toFormat(inputFormat: 'hh:mm:ss', format: 'HH:mm a') ?? '';
    String total = data?['cost_summary']?['total'] ?? '';

    return Column(
      children: [
        ExpansionTile(
          childrenPadding: 5.padding,
          tilePadding: 5.horizontalPadding,
          expansionAnimationStyle: const AnimationStyle(
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 350),
          ),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '#$bookingId', style: context.textTheme.titleMedium?.copyWith()),
                WidgetSpan(child: 10.width),
                TextSpan(text: status, style: context.textTheme.titleMedium?.copyWith( color: statusName.type?.color, overflow: TextOverflow.visible)),
              ],
            )
          ),
          shape: ContinuousRectangleBorder(side: const BorderSide(color: AppC.grey), borderRadius: BorderRadius.circular(20)),
          collapsedShape: ContinuousRectangleBorder(side: const BorderSide(color: AppC.grey), borderRadius: BorderRadius.circular(20)),
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        IconAndText(icon: Remix.user_fill, label: "$user", iconColor: AppC.appColor, padding: 0.padding, isExpanded: true, overFlow: TextOverflow.visible,),
                        IconAndText(icon: Remix.mail_fill, label: '$email', iconColor: AppC.appColor, padding: 0.padding, isExpanded: true, overFlow: TextOverflow.visible),
                        Text.rich(
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.start,
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Booked On: ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: bookingOn),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          overflow: TextOverflow.visible,
                          TextSpan(
                            children: [
                              const TextSpan(text: 'From: ' , style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '$fromDate '),
                              TextSpan(text: fromTime,),
                            ],
                          ),
                        ),
                        Text.rich(
                          overflow: TextOverflow.visible,
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Till: ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '$toDate '),
                              TextSpan(text: toTime,),
                            ],
                          ),
                        ),
                        Text.rich(
                          overflow: TextOverflow.visible,
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '\$$total'),
                            ],
                          ),
                        ),
                      ],),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
