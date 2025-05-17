import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart' show BottomNavigationBarItem, BoxFit, BuildContext, Column, FontWeight, GlobalKey, Icon, Icons, Image, MainAxisAlignment, Offset, PopupMenuItem, RelativeRect, RenderBox, Row, Size, SizedBox, Widget, showMenu;

class BottomMenuHelper {
  BottomMenuHelper._();
  /*items: [
          CompactBottomBarItem(
            selectedIcon: Icons.calendar_month_rounded,
            inActiveIcon: Icons.calendar_today_rounded,
            labelText: 'Tasker',
          ),
          *//*buildBottomNavItem(
            activeIcon: const Icon(
              Icons.calendar_month_rounded,
              color: AppC.appColor,
              // size: 28,
            ),
            inactiveIcon: const Icon(
              Icons.calendar_today_rounded,
              color: AppC.grey,
              // size: 28,
            ),
            label: 'Tasker',
            itemIndex: 0,
          ),*//*
          buildBottomNavItem(
            activeIcon: const Icon(
              Icons.note_rounded,
              color: AppC.appColor,
              // size: 28,
            ),
            inactiveIcon: const Icon(
              Icons.note_outlined,
              color: AppC.grey,
              // size: 28,
            ),
            label: 'Notes',
            itemIndex: 1,
          ),
          CompactBottomBarItem(
            selectedIcon: Icons.receipt_rounded,
            inActiveIcon: Icons.receipt_long_outlined,
            labelText: 'Log',
          ),
          buildBottomNavItem(
            activeIcon: const Icon(
              Icons.receipt_rounded,
              color: AppC.appColor,
              // size: 28,
            ),
            inactiveIcon: const Icon(
              Icons.receipt_long_rounded,
              color: AppC.grey,
              // size: 28,
            ),
            label: 'Log',
            itemIndex: 8,
          ),
          buildBottomNavItem(
            activeIcon: const Icon(
              Icons.verified_rounded,
              color: AppC.appColor,
              // size: 28,
            ),
            inactiveIcon: const Icon(
              Icons.verified_outlined,
              color: AppC.grey,
              // size: 28,
            ),
            label: 'Asset',
            itemIndex: 2,
          ),
          buildBottomNavItem(
            activeIcon: const Icon(
              Icons.sms_failed,
              // size: 28,
            ),
            inactiveIcon: const Icon(
              Icons.sms_failed,
              // size: 28,
            ),
            label: 'Feedback',
            itemIndex: 3,
          ),
          if (getIt<CommonService>().showExpense) // Show only after role is loaded
            BottomNavigationBarItem(
              icon: InkWell(
                key: _financeIconKey,
                onTap: () => setState(() => index = 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.monetization_on_rounded,
                      // size: 28,
                      color: (index == 4) ? AppC.red : AppC.grey,
                    ),
                    Utils.getText(
                      'Expense',
                      color: (index == 4) ? AppC.red : AppC.grey,
                      weight: FontWeight.bold,
                      size: 14,
                    ),
                  ],
                ),
              ),
              label: 'Finance',
            ),
        ],*/

  static int getPageIndex(int index) {
    var pageModel = pages[index];
    return switch(pageModel['name']) {
      "Tasker" => 0,
      "Notes" => 1,
      "Asset" => 2,
      "Feedback" => 3,
      "Expense" => 4,
      "Invoice" => 5,
      "Revenue" => 6,
      "Finance" => 7,
      _ => 0
    };
  }

  static List<Map<String, dynamic>> pages = [
    {
      "name" : "Tasker",
      "icon" : Icons.calendar_today_rounded,
      "activeIcon" : Icons.calendar_month_rounded,
    },
    {
      "name" : "Notes",
      "icon" : Icons.note_outlined,
      "activeIcon" : Icons.note_rounded,
    },
    {
      "name" : "Asset",
      "icon" : Icons.verified_outlined,
      "activeIcon" : Icons.verified_rounded,
    },
    {
      "name" : "Feedback",
      "icon" : Icons.feed_outlined,
      "activeIcon" : Icons.feed_rounded,
    },
    {
      "name" : "Expense",
      "icon" : Icons.monetization_on_outlined,
      "activeIcon" : Icons.monetization_on_rounded,
    },
  ];

  final GlobalKey _financeIconKey = GlobalKey();

  int index = 1;

  void showCustomMenu(BuildContext context) {
    if (_financeIconKey.currentContext == null) return;

    final RenderBox renderBox =
    _financeIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu<int>(
      color: AppC.white,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy - size.height - 70,
        position.dx + size.width,
        position.dy,
      ),
      items: [
        PopupMenuItem<int>(
          value: 4,
          child: Row(
            children: [
              Image.asset(
                Assets.coins,
                width: 20,
                height: 20,
                fit: BoxFit.fitHeight,
                color: AppC.black,
              ),
              const SizedBox(width: 10),
              Utils.getText(
                'Expense',
                color: index == 4 ? AppC().base : AppC.grey,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 5,
          child: Row(
            children: [
              const Icon(Icons.receipt_long_outlined, color: AppC.grey),
              const SizedBox(width: 10),
              Utils.getText(
                'Invoice',
                color: index == 5 ? AppC().base : AppC.grey,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 6,
          child: Row(
            children: [
              const Icon(Icons.attach_money, color: AppC.grey),
              const SizedBox(width: 10),
              Utils.getText(
                'Revenue',
                color: index == 6 ? AppC().base : AppC.grey,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 7,
          child: Row(
            children: [
              Image.asset(
                Assets.dollarBag,
                width: 20,
                height: 20,
                fit: BoxFit.fitHeight,
                color: AppC.black,
              ),
              const SizedBox(width: 10),
              Utils.getText(
                'Finance',
                color: index == 7 ? AppC().base : AppC.grey,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ],
    ).then((int? value) {
      if (value != null) {
        index = value; // Set index based on the selected menu item
        /*setState(() {

        });*/
      }
    });
  }

  BottomNavigationBarItem buildBottomNavItem({
    required Widget activeIcon,
    required Widget inactiveIcon,
    required String label,
    required int itemIndex,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          index == itemIndex ? activeIcon : inactiveIcon,
          Utils.getText(
            label,
            color: index == itemIndex ? AppC().base : AppC.grey,
            weight: FontWeight.bold,
            size: 14,
          ),
        ],
      ),
      label: label,
    );
  }
}