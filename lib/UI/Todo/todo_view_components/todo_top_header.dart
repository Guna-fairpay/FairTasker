import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

class TodoTopHeader extends StatelessWidget {
  final bool isFilterSelected, switchValue, isUserSelected;
  final String? selectedMonthYear;
  final VoidCallback? onNextPressed, onPreviousPressed, onCurrentYearPressed;
  final void Function(TapDownDetails details)? onUserTapDown, onFilterPressed, onVehicleSearchPressed;
  final void Function(bool val)? onSwitch;
  final Color? vehicleSearchColor;

  const TodoTopHeader(
      {super.key,
      this.switchValue = false,
      this.isUserSelected = false,
      this.selectedMonthYear,
      this.isFilterSelected = false,
      this.onFilterPressed,
      this.onNextPressed,
      this.onPreviousPressed,
      this.onCurrentYearPressed,
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
                      value: switchValue,
                      onChanged: onSwitch)),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTapDown: onVehicleSearchPressed,
              child: Image.asset(
                Assets.vehicleSearchIcon,
                height: 24,
                width: 24,
                color: vehicleSearchColor ?? AppC.appColor,
              ),
            ),
            const SizedBox(width: 20),
            InkWell(
                onTap: onPreviousPressed,
                child: Icon(
                  Icons.chevron_left,
                  color: AppC().base,
                  size: 24,
                )),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: onCurrentYearPressed,
              child: Utils.getText(selectedMonthYear ?? "",
                  size: 17, weight: FontWeight.w500),
            ),
            const SizedBox(
              width: 5,
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: onNextPressed,
                  child: Icon(
                    Icons.chevron_right,
                    color: AppC().base,
                    size: 24,
                  )),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTapDown: onUserTapDown,
                child: Row(
                  children: [
                    Icon(
                      isUserSelected
                          ? Icons.supervisor_account
                          : Icons.person_outline,
                      color: AppC().base,
                      size: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                  onTapDown: onFilterPressed,
                  child: Row(
                    children: [
                      Icon(
                        isFilterSelected
                            ? Icons.filter_alt_outlined
                            : Icons.filter_alt_sharp,
                        color: AppC.black,
                        size: 22,
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
