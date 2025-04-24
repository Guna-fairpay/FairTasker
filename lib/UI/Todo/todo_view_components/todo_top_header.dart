import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodoTopHeader extends StatelessWidget {
  final bool isFilterSelected, showCompleted, isUserSelected, isTimeSensitive;
  final DateTime? selectedDate;
  final VoidCallback? onNextPressed, onPreviousPressed, onDatePressed;
  final void Function(TapDownDetails details)? onUserTapDown,
      onFilterPressed,
      onVehicleSearchPressed;
  final void Function(bool val)? onSwitch;
  final ValueChanged<bool>? onChangeTimeSensitive;
  final Color? vehicleSearchColor;

  const TodoTopHeader(
      {super.key,
      this.showCompleted = false,
      this.isUserSelected = false,
      this.selectedDate,
      this.isFilterSelected = false,
      this.isTimeSensitive = false,
      this.onFilterPressed,
      this.onNextPressed,
      this.onPreviousPressed,
      this.onDatePressed,
      this.onVehicleSearchPressed,
      this.vehicleSearchColor,
      this.onSwitch,
      this.onUserTapDown,
      this.onChangeTimeSensitive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            SizedBox.fromSize(
              size: Size.fromRadius(16.sp),
              child: FittedBox(
                  child: Switch(
                      trackOutlineColor: WidgetStateColor.resolveWith(
                            (states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppC.green;
                          } else {
                            return AppC.grey;
                          }
                        },
                      ),
                      activeTrackColor: AppC.green,
                      activeColor: AppC.white,
                      inactiveThumbColor: AppC.white,
                      inactiveTrackColor: AppC.grey,
                      value: showCompleted,
                      onChanged: onSwitch)),
            ),
            GestureDetector(
              onTapDown: onVehicleSearchPressed,
              child: SizedBox.fromSize(
                size: Size(20.sp, 20.sp),
                child: FittedBox(
                  child: Image.asset(
                    Assets.vehicleSearchIcon,
                    color: vehicleSearchColor ?? AppC.appColor,
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(Num.borderRadius),
              onTap: () => onChangeTimeSensitive?.call(!isTimeSensitive),
              child: SizedBox.fromSize(
                size: Size(18.sp, 18.sp),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (isTimeSensitive) ? AppC.appColor : AppC.borderColor, width: Num.borderWidthThinField,
                    ),
                    borderRadius: BorderRadius.circular(Num.borderRadius),
                    color: (isTimeSensitive) ? AppC.appColor : AppC.trans
                  ),
                  child: Icon(Icons.check, size: 16.sp, color: (isTimeSensitive) ? AppC.white : AppC.trans,),
                ),
              ),
            ),
          ],),
          Expanded(
            flex: 3,
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: onPreviousPressed,
                  child: Icon(
                    Icons.chevron_left,
                    color: AppC().base,
                    size: 22.sp,
                  )),
              InkWell(
                onTap: onDatePressed,
                child: Utils.getText(
                    (selectedDate.toFormat(format: "MMM dd") ?? ""),
                    size: 12.sp,
                    weight: FontWeight.w500),
              ),
              GestureDetector(
                  onTap: onNextPressed,
                  child: Icon(
                    Icons.chevron_right,
                    color: AppC().base,
                    size: 22.sp,
                  )),
              if (getIt<CommonService>().departmentId != 9)
              GestureDetector(
                onTapDown: onUserTapDown,
                child: Row(
                  children: [
                    Icon(
                      isUserSelected
                          ? Icons.supervisor_account_rounded
                          : Icons.person_outline_rounded,
                      color: AppC().base,
                      size: 17.sp,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTapDown: onFilterPressed,
                  child: Row(
                    children: [
                      Icon(
                        !isFilterSelected
                            ? Icons.filter_alt_outlined
                            : Icons.filter_alt_sharp,
                        color: AppC.black,
                        size: 18.sp,
                      ),
                    ],
                  )),
            ],
          ))
        ],
      ),
    );
  }
}
