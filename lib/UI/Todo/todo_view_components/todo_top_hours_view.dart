import 'package:date_time/date_time.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';

class TodoTopHoursView extends StatelessWidget {
  final Map<String, dynamic>? model;
  const TodoTopHoursView({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text.rich(TextSpan(
            text: (model?['checkIn'] ?? "00:00:00").toString().toDateTime(inputFormat: "HH:mm:ss").toFormat(format: "hh:mm a"),
            children: [
              WidgetSpan(child: 3.width),
              TextSpan(text: "Check in", style: context.textTheme.labelSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.normal))
            ]
        ), style: context.textTheme.labelMedium?.copyWith(fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Text.rich(TextSpan(
              text: model?['totalHours'] ?? "00:00",
              children: [
                WidgetSpan(child: 3.width),
                TextSpan(text: "Hours Active", style: context.textTheme.labelSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.normal))
              ]
          ), style: context.textTheme.labelMedium?.copyWith(fontSize: 13, color: AppC.red, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        Text.rich(TextSpan(
            text: ( (Time.fromStr(model?['checkIn'].toString()) ?? getIt<CommonService>().usNow.time).inMins - (Time.fromStr(model?['checkOut'].toString()) ?? getIt<CommonService>().usNow.time).inMins ).abs().minutesToHourMinute,
            children: [
              WidgetSpan(child: 3.width),
              TextSpan(text: "Hours Total", style: context.textTheme.labelSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.normal))
            ]
        ), style: context.textTheme.labelMedium?.copyWith(fontSize: 13, color: AppC.text, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
