import 'package:date_time/date_time.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodoTopHoursView extends StatelessWidget {
  final Map<String, dynamic>? model;

  const TodoTopHoursView({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5.spMin,
      children: [
        const SizedBox.shrink(),
        Expanded(child: Text.rich(
            TextSpan(
                text: (model?['checkIn'].toString().isNullOrEmpty ?? false)
                    ? "00:00"
                    : (model?['checkIn'])
                    .toString()
                    .toDateTime(inputFormat: "HH:mm:ss")
                    .toFormat(format: "hh:mm a"),
                children: [
                  TextSpan(
                      text: "\tCheck in",
                      style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 12.spMin, fontWeight: FontWeight.normal))
                ]),
            style: context.textTheme.labelMedium?.copyWith(fontSize: 13.spMin),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start)),
        Expanded(child: Text.rich(
            TextSpan(text: model?['totalHours'] ?? "00:00", children: [
              TextSpan(
                  text: "\tHours Active",
                  style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 12.spMin, fontWeight: FontWeight.normal))
            ]),
            style: context.textTheme.labelMedium?.copyWith(
                fontSize: 13.spMin,
                color: AppC.red,
                fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center)),
        Expanded(child: Text.rich(
            TextSpan(
                text: ((Time.fromStr(model?['checkIn'].toString()) ??
                    getIt<CommonService>().usNow.time)
                    .inMins -
                    (Time.fromStr(model?['checkOut'].toString()) ??
                        getIt<CommonService>().usNow.time)
                        .inMins)
                    .abs()
                    .minutesToHourMinute,
                children: [
                  TextSpan(
                      text: "\tHours Total",
                      style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 12.spMin, fontWeight: FontWeight.normal))
                ]),
            style: context.textTheme.labelMedium?.copyWith(
                fontSize: 13.spMin,
                color: AppC.text,
                fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end)),
        const SizedBox.shrink(),
      ],
    );
  }
}
