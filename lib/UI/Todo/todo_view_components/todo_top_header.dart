import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodoTopHeader extends StatelessWidget {
  final bool isFilterSelected, showCompleted, isUserSelected;
  final DateTime? selectedDate;
  final VoidCallback? onNextPressed, onPreviousPressed, onDatePressed;
  final void Function(TapDownDetails details)? onUserTapDown, onFilterPressed, onVehicleSearchPressed;
  final void Function(bool val)? onSwitch;
  final Color? vehicleSearchColor;

  const TodoTopHeader(
      {super.key,
      this.showCompleted = false,
      this.isUserSelected = false,
      this.selectedDate,
      this.isFilterSelected = false,
      this.onFilterPressed,
      this.onNextPressed,
      this.onPreviousPressed,
      this.onDatePressed,
      this.onVehicleSearchPressed,
      this.vehicleSearchColor,
      this.onSwitch,
      this.onUserTapDown});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            SizedBox(
              width: 36,
              child: Transform.scale(
                  alignment: Alignment.centerLeft,
                  scale: .6,
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
            const SizedBox(width: 15),
            GestureDetector(
              onTapDown: onVehicleSearchPressed,
              child: Image.asset(
                Assets.vehicleSearchIcon,
                height: 20.sp,
                width: 20.sp,
                color: vehicleSearchColor ?? AppC.appColor,
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
                onTap: onPreviousPressed,
                child: Icon(
                  Icons.chevron_left,
                  color: AppC().base,
                  size: 22.sp,
                )),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: onDatePressed,
              child: Utils.getText((selectedDate.toFormat(format: "MMM dd") ?? ""),
                  size: 12.sp, weight: FontWeight.w500),
            ),
            const SizedBox(
              width: 5,
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: onNextPressed,
                  child: Icon(
                    Icons.chevron_right,
                    color: AppC().base,
                    size: 22.sp,
                  )),
              const SizedBox(
                width: 20,
              ),
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
              const SizedBox(
                width: 15,
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
          ),
        ],
      ),
    );
  }
}
