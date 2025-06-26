import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class TodoTaskItemCard extends StatelessWidget {
  final Map<String, dynamic> model;
  final bool? showCheckbox, value;
  final Future<bool?> Function()? onComplete, onPrevious, onInProgress;
  final ValueChanged<bool?>? onChecked;
  final void Function(String? value)? onMore; // SHOW MORE TEXT WITH THIS FUNCTION
  final VoidCallback? onTap, onPlateNumTap, onVendorInfo, onBouncie, onCustomLink, onViewAttachment, onDateChange, onCompletedTimeChange, onTimeChange, onVehicleHistory, onReasonAttachmentView;
  final GestureTapDownCallback? onVehicleOrPerson, onVehicleGroup, onParts, onSupplies, onVendorOrLocation, onAddress, onResource, onNotes;
  const TodoTaskItemCard({super.key, required this.model, this.onTap, this.onPlateNumTap, this.onVendorInfo, this.onBouncie, this.onCustomLink, this.onViewAttachment, this.onDateChange, this.onCompletedTimeChange, this.onTimeChange, this.onVehicleOrPerson, this.onVehicleHistory, this.onVehicleGroup, this.onParts, this.onSupplies, this.onVendorOrLocation, this.onAddress, this.onResource, this.onNotes, this.onComplete, this.onPrevious, this.showCheckbox = false, this.value = false, this.onChecked, this.onInProgress, this.onReasonAttachmentView, this.onMore});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      key: key,
      child: Row(
        children: [
          GestureDetector(
            onTap: (model['display']?['hasVehiclePlate'] ?? false) ? onPlateNumTap : null,
            child: Container(
              padding: 10.padding,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: (model['display']?['hasCompleted'] ?? false) ? AppC.green : AppC.appColor,
                    child: CircleAvatar(
                      radius: (model.isEmpty) ? 30 : 28,
                      backgroundColor: AppC.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: (model['display']?['vehicle_image'].toString().isNullOrEmpty ?? false)
                            ? Center(
                                child: Utils.getText(
                                    ((List.from(model['display']?['vins'] ?? [])).length > 1)
                                    ? "MV"
                                    : "CT",
                                    size: 14.sp,
                                    overFlow: TextOverflow.ellipsis,
                                    color: AppC.appColor,
                                    align: TextAlign.center,
                                    weight: FontWeight.bold),
                              )
                            : Image.network(
                                width: context.width,
                                height: context.height,
                                (model['display']?['vehicle_image'] ?? "").toString().removeStorageUrl.toStorageURL,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    (loadingProgress?.cumulativeBytesLoaded ==
                                            loadingProgress?.expectedTotalBytes)
                                        ? child
                                        : const CustomLoading(),
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  Assets.noImages,
                                  fit: BoxFit.cover,
                                  width: context.width,
                                  height: context.height,
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (model['display']?['hasVehiclePlate'] ?? false)
                    Utils.getText(
                      (model['display']?['vehicle_plate'] ?? "No Plate"),
                      size: 10.sp,
                      weight: FontWeight.w900,
                      color: (model['display']?['vehicle_plate'].toString().isNotNullOrEmpty ?? false) ? AppC.appColor : AppC.red,
                    )
                ],
              ),
            ),
          ),
          Expanded(
              child: Dismissible(
            key: Key(model['id'].toString()),
            direction: DismissDirection.horizontal,
            secondaryBackground: Container(
              decoration: BoxDecoration(
                  color: (model['display']?['hasCompleted'] ?? false)
                      ? AppC.orange
                      : AppC.green,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Num.borderRadius))),
              alignment: Alignment.centerRight,
              padding: 10.padding,
              child: Utils.getText(
                  (model['display']?['hasCompleted'] ?? false) ? "In Progress" : "Complete",
                  size: 12.sp,
                  color: AppC.white,
                  weight: FontWeight.bold),
            ),
            background: Container(
              decoration: const BoxDecoration(
                  color: AppC.red,
                  borderRadius:
                      BorderRadius.all(Radius.circular(Num.borderRadius))),
              alignment: Alignment.centerLeft,
              padding: 10.padding,
              child: Utils.getText("Tomorrow",
                  size: 12.sp, color: AppC.white, weight: FontWeight.bold),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
               return ((model['display']?['hasCompleted'] ?? false)) ? onInProgress?.call() : onComplete?.call();
              } else if (direction == DismissDirection.startToEnd) {
                return onPrevious?.call();
              } else {
                return false;
              }
            },
            child: GestureDetector(
              // onTap: onTap,
              onTap: (showCheckbox ?? false) ? ()=> (onChecked?.call(!(value ?? false))) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                decoration: BoxDecoration(
                  border: Border(
                    top: const BorderSide(color: AppC.white, width: 1),
                    left: const BorderSide(color: AppC.white, width: 1),
                    right: const BorderSide(color: AppC.white, width: 1),
                    bottom: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.4), width: 1.2),
                  ),
                  color: (model.isEmpty) ? AppC.trans : (model['id'] == Session.of.getInt("scrollToIndex")) ? AppC.lightBlue : AppC.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Hero(tag: model['id'].toString(), child: Text.rich(TextSpan(
                                    children: [
                                      TextSpan(
                                          recognizer: TapGestureRecognizer()..onTap = onTap,
                                          text: model['display']?['task_title'], style: context.textTheme.labelMedium?.copyWith(color: (model?['display']?['hasTimeSensitive'] ?? false)
                                          ? AppC.red
                                          : AppC.appColor, fontWeight: FontWeight.bold)),
                                      if ((model['display']?['hasReason'] ?? false) || (model['display']?['hasReasonAttachments'] ?? false))
                                        ...[
                                          TextSpan(text: "\t(\t", style: context.textTheme.labelMedium?.copyWith(color: Colors.red, fontSize: 12.sp)),
                                          TextSpan(text: model['display']?['reason'], style: context.textTheme.labelMedium?.copyWith(color: Colors.red, fontSize: 12.sp)),
                                          if (model['display']?['hasReasonAttachments'] ?? false)
                                            WidgetSpan(child: 10.width),
                                          if (model['display']?['hasReasonAttachments'] ?? false)
                                            WidgetSpan(child: GestureDetector(
                                              onTap: onReasonAttachmentView,
                                              child: Icon(Icons.remove_red_eye_rounded, color: Colors.red, size: 14.sp),
                                            )),
                                          TextSpan(text: "\t)\t", style: context.textTheme.labelMedium?.copyWith(color: Colors.red, fontSize: 12.sp)),
                                        ],
                                      if (model['display']?['hasRelatedTask'] ?? false)
                                        ...[
                                          TextSpan(text: "\t>>\t", style: context.textTheme.labelMedium?.copyWith(color: Colors.red)),
                                          TextSpan(text: model['display']?['relatedTaskName']),
                                        ]
                                    ]
                                ), maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textTheme.labelMedium?.copyWith(color: AppC.appColor, fontSize: 12.sp))),
                              ),
                              if (model['display']?['hasCustomLink'] ?? false)
                                GestureDetector(
                                  onTap: onCustomLink,
                                  child: Utils.getText(
                                    "${model['display']?['customLinkText'] ?? "T"}",
                                    color: model['display']?['customColor'] ?? Colors.black,
                                    weight: FontWeight.w900,
                                    size: 14.sp,
                                  ),
                                ),
                              if (model['display']?['hasAttachments'] ?? false)
                                GestureDetector(
                                  onTap: onViewAttachment,
                                  child: Icon(
                                    Icons.remove_red_eye_sharp,
                                    size: 14.sp,
                                    color: AppC.appColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          spacing: 5,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: onDateChange,
                              child: Icon(
                                Icons.calendar_month_outlined,
                                size: 13.sp,
                              ),
                            ),
                            if (model['display']?['hasCompletedTime'] ?? false)
                              GestureDetector(
                                onTap: onCompletedTimeChange,
                                child: Utils.getText((model['display']?['completed_time'] ?? ""),
                                    size: 12.sp),
                              ),
                            GestureDetector(
                              onTap: onTimeChange,
                              child: Utils.getText(
                                  Utils.convertString24HTo12H(
                                      model['display']?['task_time'] ?? '05:30:00'),
                                  size: 12.sp),
                            ),
                            const SizedBox.shrink(),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (model['display']?['vehicle_or_person_name'].toString().isNotNullOrEmpty ?? false)
                              Flexible(
                                child: GestureDetector(
                                  onTapDown: onVehicleOrPerson,
                                  child: Utils.getText(
                                    (model['display']?['vehicle_or_person_name'] ?? ""),
                                    size: ((model['display']?['vehicle_or_person_name'] ?? "") == "MV") ? 14.sp : 11.sp,
                                    overFlow: TextOverflow.ellipsis,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (model['display']?['hasVehicleHistory'] ?? false)
                              GestureDetector(
                                onTap: onVehicleHistory,
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: (((model['display']?['vehicleHistoryIconColorCode'].toString().isNotNullOrEmpty ?? false) ? Color(int.parse("0xff${model['display']?['vehicleHistoryIconColorCode'] ?? ""}")) : AppC.blue)),
                                  size: 16.sp,
                                ),
                              ),
                            if (model['display']?['hasG'] ?? false)
                              GestureDetector(
                                  onTapDown: onVehicleGroup,
                                  child: Utils.getText("G",
                                      weight: FontWeight.bold, size: 14.sp)),
                            if (model['display']?['hasParts'] ?? false)
                              GestureDetector(
                                  onTapDown: onParts,
                                  child: Utils.getText("P",
                                      weight: FontWeight.bold, size: 14.sp)),
                            if (model['display']?['hasSupplies'] ?? false)
                              GestureDetector(
                                  onTapDown: onSupplies,
                                  child: Utils.getText("S",
                                      weight: FontWeight.bold, size: 14.sp))
                          ],
                        )),
                        if ((model['display']?['hasBouncie'] ?? false) || (((model['todo_date'].toString().toFormat(format: "yyyy-MM-dd")) == (DateTime.now().toFormat()) && (model['display']?['hasDistance'] ?? false) && (List.from(model['display']['vins'] ?? []).length == 1))))
                        GestureDetector(
                          onTap: onBouncie,
                          child: Row(
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                ((model['display']?['hasDistance'] ?? false) && ((model['display']['vehicle_distance'].toString().isNotNullOrEmpty))) ? Icons.location_on : Icons.location_on_outlined,
                                color: (model['display']['vehicle_distance'].toString().isNullOrEmpty) ? AppC.redAccent : AppC.green,
                                size: 17.sp,
                              ),
                              if (model['display']?['hasDistance'] ?? false)
                              Utils.getText("${model['display']['vehicle_distance'] ?? ""}",
                                  weight: FontWeight.normal, size: 13.sp, color: (model['display']['vehicle_distance'].toString().isNullOrEmpty) ? AppC.redAccent : AppC.green),
                              const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if ((model['display']?['vendor_location'].toString().isNotNullOrEmpty ?? false) || (model['display']?['notes'].toString().isNotNullOrEmpty ?? false))
                        Expanded(
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (model['display']?['vendor_location'].toString().isNotNullOrEmpty ?? false)
                                Flexible(
                                  child: GestureDetector(
                                      onTapDown: onVendorOrLocation,
                                      child: Utils.getText((model['display']?['vendor_location'] ?? ""),
                                          size: 12.sp,
                                        overFlow: TextOverflow.ellipsis
                                      )),
                                ),
                              if (model['display']?['hasVendorInfo'] ?? false)
                                GestureDetector(
                                  onTap: onVendorInfo,
                                  child: Icon(
                                    Icons.info,
                                    size: 14.sp,
                                    color: Colors
                                        .blue, // Replace with AppC.appColor if defined
                                  ),
                                ),
                              if (model['display']?['notes'].toString().isNotNullOrEmpty ?? false)
                                Flexible(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(text: "(${parse((model['display']?['notes'] ?? "").toString().removeNextLines).body?.text})", recognizer: TapGestureRecognizer()..onTapDown = onNotes),
                                        if (model['display']?['hasTimeChangeReason'] ?? false)
                                        TextSpan(text: "\t${(model['display']?['timeChangeReason'] ?? "").toString().toTitleCase()}", style: context.textTheme.labelMedium?.copyWith(color: null),
                                          recognizer: ((model['display']?['timeChangeReason'] ?? "").toString().length > 10) ? (TapGestureRecognizer()..onTap = ()=> onMore?.call((model['display']?['timeChangeReason'] ?? ""))) : null,
                                        )
                                      ],
                                      style: context.textTheme.labelMedium?.copyWith(fontSize: 11.sp, overflow: TextOverflow.ellipsis, color: AppC.appColor)
                                    )),
                                ),
                              if (model['display']?['hasAddress'] ?? false)
                                Flexible(
                                  child: GestureDetector(
                                      onTapDown: onAddress,
                                      child: Utils.getText("A",
                                          weight: FontWeight.bold, size: 13.sp)),
                                ),
                              const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        if ((model['display']?['vendor_location'].toString().isNullOrEmpty ?? false) && (model['display']?['notes'].toString().isNullOrEmpty ?? false))
                          const Spacer(),
                        if ((model['display']?['resource_name'].toString().isNotNullOrEmpty ?? false) || (List.from(model['display']?['resources'] ?? []).isNotEmpty))
                        Row(
                          spacing: (showCheckbox ?? false) ? 10 : 5,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                                onTapDown: onResource,
                                child: Utils.getText(model['display']?['resource_name'] ?? (List.from(model['display']?['resources'] ?? []).length == 1) ? (List.from(model['display']?['resources'] ?? []).map((e) => <String>[(e['first_name'] ?? ""), (e['last_name'] ?? "")].toInitial).firstOrNull ?? "") : "${List.from(model['display']?['resources']).map((e) => <String>[(e['first_name'] ?? ""), (e['last_name'] ?? "")].toInitial).firstOrNull ?? ""}...",
                                    weight: FontWeight.w900,
                                    size: 13.sp,
                                    color: AppC().base)),
                            if(showCheckbox ?? false)
                              SizedBox.fromSize(
                                size: const Size.fromRadius(0.8),
                                child: Checkbox(value: value,
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  tristate: false,
                                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadius)),
                                  side: const BorderSide(color: AppC.borderColor, width: Num.borderWidthField),
                                  onChanged: onChecked)
                              ),
                            const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
