import 'package:fairpytasker/Component/outlined_button_icon.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_bloc.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_config.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusCard extends StatelessWidget {
  final Map<String, dynamic> model;
  final dynamic categoryId;
  final Future<bool> Function()? onPrevious, onComplete;
  final DismissDirection dismissDirection;
  final void Function(VehicleStatusOnPressed type)? onPressed;
  const VehicleStatusCard({super.key, required this.model, this.categoryId, this.onPrevious, this.onComplete, this.dismissDirection = DismissDirection.horizontal, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
        border: Border.all(width: Num.borderWidthThinField),
        color: Colors.white
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: 5.padding,
      child: Dismissible(
          key: UniqueKey(),
          direction: dismissDirection,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return onPrevious?.call();
            } else if (direction == DismissDirection.startToEnd) {
              return onComplete?.call();
            }
            return false;
          },
          background: Container(
            decoration: BoxDecoration(
              color: AppC.green,
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
            ),
            padding: 10.padding,
            alignment: Alignment.centerLeft,
            child: Text("Complete", style: context.textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontFamily: "Lato")),
          ),
          secondaryBackground: Container(
            decoration: BoxDecoration(
              color: AppC.red,
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
            ),
            padding: 10.padding,
            alignment: Alignment.centerRight,
            child: Text("Previous", style: context.textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontFamily: "Lato")),
          ),
          child: Container(
            padding: 10.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              spacing: 5,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  minLeadingWidth: 0,
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  title: GestureDetector(
                    onTap: () => onPressed?.call(VehicleStatusOnPressed.vehicle_page),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: "${model['vehicle_name']}"),
                      (!model['vehicle_number'].toString().isNullOrEmpty)?
                        TextSpan(
                            text: "\t/${model['vehicle_number']}",
                            style: context.textTheme.labelSmall
                                ?.copyWith(color: AppC.blue,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis))
                      :TextSpan(
                          text: "\t /No Plate",
                          style: context.textTheme.labelSmall
                              ?.copyWith(color: AppC.redAccent, fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis)),
                    ])),
                  ),
                  trailing: ([ 3].contains(categoryId))
                      ? null
                      : Text.rich(
                    TextSpan(children: [
                      WidgetSpan(
                          child: Icon(
                            Icons.closed_caption_off,
                            size: 18,
                            color: AppC().base,
                          )),
                      TextSpan(text: "\$${model['cumulative_cost']}", recognizer: TapGestureRecognizer()..onTap = ()=> onPressed?.call(VehicleStatusOnPressed.view_expense))
                    ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  minLeadingWidth: 0,
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  title: Text.rich(TextSpan(children: [
                    TextSpan(text: "${model['last_checklist'] ?? ""}", recognizer: TapGestureRecognizer()..onTap = () => onPressed?.call(VehicleStatusOnPressed.last_checklist)),
                    if (!model['followup_date'].toString().isNullOrEmpty)
                      TextSpan(
                          text: "\t ${model['followup_date'].toString().toDateTime().toFormat(format: "MM-dd-yy")}",
                          style: context.textTheme.labelMedium
                              ?.copyWith(color: AppC.red))
                  ])),
                  textColor: AppC.appColor,
                  trailing: ([ 3].contains(categoryId))
                      ? null
                      : Text.rich(
                    TextSpan(children: [
                      WidgetSpan(
                          child: Icon(
                            Icons.sports_basketball_rounded,
                            size: 14,
                            color: AppC().base,
                          )),
                      TextSpan(text: "\$${model['wholesale_amount'] ?? 0}")
                    ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                if ((!model['note'].toString().isNullOrEmpty ||
                    (!([1, 3, 7].contains(categoryId)))))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    minLeadingWidth: 0,
                    minTileHeight: 0,
                    minVerticalPadding: 0,
                    title: Text.rich(
                      TextSpan(
                        text: "${model['note'] ?? ""}",
                        recognizer: TapGestureRecognizer()..onTap = () => onPressed?.call(VehicleStatusOnPressed.view_notes)
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    textColor: AppC.green,
                    trailing: ([1, 3, 7].contains(categoryId))
                        ? null
                        : Text.rich(
                      TextSpan(children: [
                        TextSpan(text: "${model['count_days'] ?? ""}")
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if ((model['details'] != null) && ([3].contains(categoryId)))
                  Row(
                    spacing: 10,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(Num.borderRadiusLarge),
                            color: AppC.appColor),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 7),
                        child: Text(
                            "${model['details']?['reservationCount'] ?? 0}",
                            style: context.textTheme.labelMedium?.copyWith(
                                color: AppC.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      Text.rich(TextSpan(children: [
                        const WidgetSpan(
                            child: Icon(
                              Icons.monetization_on_outlined,
                              size: 18,
                              color: AppC.red,
                            )),
                        WidgetSpan(child: 2.width),
                        TextSpan(
                            text:
                            "${(model['details']?['totalExpenses'] ?? 0).toStringAsFixed(2)}"),
                        WidgetSpan(child: 10.width),
                        const WidgetSpan(
                            child: Icon(
                              Icons.monetization_on_outlined,
                              size: 18,
                              color: AppC.green,
                            )),
                        WidgetSpan(child: 2.width),
                        TextSpan(
                            text:
                            "${(model['details']?['totalEarnings'] ?? 0).toStringAsFixed(2)}")
                      ]))
                    ],
                  ),
                if (!([7, 3].contains(categoryId)))
                  FAProgressBar(
                    currentValue: double.parse(
                        (model['vehicle_status_value'] ?? 0.0).toString()),
                    displayText: '%',
                    backgroundColor: AppC.lightGrey,
                    progressColor: AppC().base,
                    animatedDuration: Durations.short1,
                    size: 15,
                    maxValue: 100,
                    displayTextStyle: context.textTheme.labelMedium!.copyWith(
                        color: AppC.white, fontWeight: FontWeight.bold),
                  ),
                if (context.read<VehicleStatusBloc>().selectedCategory?['id'] == 7)
                Text.rich(TextSpan(
                  children: [
                    WidgetSpan(child: Icon(CupertinoIcons.tag_fill, color: AppC().base, size: 18)),
                    TextSpan(text: "\t${(model['purchase_price'] ?? 0.0).toStringAsFixed(2)}"),
                    WidgetSpan(child: 10.width),
                    WidgetSpan(child: Icon(Icons.calendar_month_rounded, color: AppC().base, size: 18,)),
                    TextSpan(text: "\t${(model['details']?['soldDate'] ?? "")}"),
                    WidgetSpan(child: 10.width),
                    const WidgetSpan(child: Icon(Icons.adjust_rounded, color: AppC.red, size: 16,)),
                    TextSpan(text: "\t${(model['details']?['totalSoldAmount'] ?? 0.0).toStringAsFixed(2)}"),
                    WidgetSpan(child: 10.width),
                    const WidgetSpan(child: Icon(Icons.monetization_on_outlined, color: AppC.red, size: 16)),
                    TextSpan(text: "\t${(model['details']?['totalExpenses'] ?? 0.0).toStringAsFixed(2)}"),
                    WidgetSpan(child: 10.width),
                    const WidgetSpan(child: Icon(Icons.monetization_on_outlined, color: AppC.green, size: 16)),
                    TextSpan(text: "\t${(model['details']?['totalEarnings'] ?? 0.0).toStringAsFixed(2)}"),
                    WidgetSpan(child: 10.width),
                  ],
                ), textAlign: TextAlign.start,
                    style: context.textTheme.labelMedium
                ),
                Row(
                  spacing: 10,
                  children: [
                    if (model['last_checklist'].toString().isNullOrEmpty)
                      OutlinedButtonIcon(
                        onPressed: () => onPressed?.call(VehicleStatusOnPressed.last_checklist),
                          iconData: Icons.car_repair_rounded),
                    OutlinedButtonIcon(
                        onPressed: () => onPressed?.call(VehicleStatusOnPressed.vehicle_config),
                        iconData: Icons.settings_rounded),
                    OutlinedButtonIcon(
                        onPressed: () => onPressed?.call(VehicleStatusOnPressed.vehicle_edit),
                        iconData: Icons.edit_rounded),
                    OutlinedButtonIcon(
                        onPressed: () => onPressed?.call(VehicleStatusOnPressed.view_history),
                        iconData: Icons.remove_red_eye_rounded),
                    // if (model['followup_date'].toString().isNullOrEmpty)
                      OutlinedButtonIcon(
                          onPressed: () => onPressed?.call(VehicleStatusOnPressed.date_pickup),
                          iconData: Icons.calendar_month_rounded),
                    OutlinedButtonIcon(
                        onPressed: () => onPressed?.call(VehicleStatusOnPressed.add_vehicle),
                        iconData: Icons.add_rounded),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
