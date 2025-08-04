import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:html/parser.dart' show parse;
import 'package:remixicon/remixicon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

part 'tasker_todo_sub_items/vehicle_plate_view.dart';
part 'tasker_todo_sub_items/task_title_view.dart';
part 'tasker_todo_sub_items/custom_link_text.dart';
part 'tasker_todo_sub_items/attachment_view.dart';
part 'tasker_todo_sub_items/title_row.dart';
part 'tasker_todo_sub_items/vehicle_extras_view.dart';
part 'tasker_todo_sub_items/bouncie_distance_view.dart';
part 'tasker_todo_sub_items/vehicle_bouncie_row.dart';
part 'tasker_todo_sub_items/vendor_location_extras.dart';
part 'tasker_todo_sub_items/resource_extras.dart';
part 'tasker_todo_sub_items/vendor_notes_resource_view.dart';

class TodoTaskItemCard extends StatelessWidget {
  final Map<String, dynamic> model;
  final bool? showCheckbox, value;
  final Future<bool?> Function()? onComplete, onPrevious, onInProgress;
  final ValueChanged<bool?>? onChecked;
  final void Function(String? value)? onMore; // SHOW MORE TEXT WITH THIS FUNCTION
  final VoidCallback? onTap, onPlateNumTap, onVendorInfo, onBouncie, onCustomLink, onViewAttachment, onDateChange, onCompletedTimeChange, onTimeChange, onVehicleHistory, onReasonAttachmentView, onMeetingView;
  final GestureTapDownCallback? onVehicleOrPerson, onVehicleGroup, onParts, onSupplies, onVendorOrLocation, onAddress, onResource, onNotes, onLead, onMeeting;
  const TodoTaskItemCard({super.key, required this.model, this.onTap, this.onPlateNumTap, this.onVendorInfo, this.onBouncie, this.onCustomLink, this.onViewAttachment, this.onDateChange, this.onCompletedTimeChange, this.onTimeChange, this.onVehicleOrPerson, this.onVehicleHistory, this.onVehicleGroup, this.onParts, this.onSupplies, this.onVendorOrLocation, this.onAddress, this.onResource, this.onNotes, this.onComplete, this.onPrevious, this.showCheckbox = false, this.value = false, this.onChecked, this.onInProgress, this.onReasonAttachmentView, this.onMore, this.onMeetingView, this.onLead, this.onMeeting});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final hasCompleted = display['hasCompleted'] ?? false;
    final secondaryBackgroundColor = hasCompleted ? AppC.orange : AppC.green;
    final secondaryTitle = hasCompleted ? "In Progress" : "Complete";
    return RepaintBoundary(
      key: key,
      child: IntrinsicHeight(
        child: Row(
          children: [
            VehiclePlateView(model: model, onPlateNumTap: onPlateNumTap),
            Expanded(
                child: Dismissible(
              key: Key(model['id'].toString()),
              direction: DismissDirection.horizontal,
              secondaryBackground: Container(
                decoration: BoxDecoration(
                    color: secondaryBackgroundColor,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Num.borderRadius))),
                alignment: Alignment.centerRight,
                padding: 10.padding,
                child: Utils.getText(
                    secondaryTitle,
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
                 return (hasCompleted) ? onInProgress?.call() : onComplete?.call();
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
                      TitleRow(
                          model: model,
                          onTap: onTap,
                          onTimeChange: onTimeChange,
                          onCustomLink: onCustomLink,
                          onDateChange: onDateChange,
                          onMeetingView: onMeetingView,
                          onViewAttachment: onViewAttachment,
                          onCompletedTimeChange: onCompletedTimeChange,
                          onReasonAttachmentView: onReasonAttachmentView),
                      VehicleBouncieRow(
                        model: model,
                        onParts: onParts,
                        onBouncie: onBouncie,
                        onMeeting: onMeeting,
                        onSupplies: onSupplies,
                        onVehicleGroup: onVehicleGroup,
                        onVehicleHistory: onVehicleHistory,
                        onVehicleOrPerson: onVehicleOrPerson),
                      VendorNotesResourceView(
                        model: model,
                        onVendorOrLocation: onVendorOrLocation,
                        onVendorInfo: onVendorInfo,
                        onNotes: onNotes,
                        onMore: onMore,
                        onAddress: onAddress,
                        onResource: onResource,
                        showCheckbox: showCheckbox,
                        value: value,
                        onChecked: onChecked,
                        onLead: onLead,
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
