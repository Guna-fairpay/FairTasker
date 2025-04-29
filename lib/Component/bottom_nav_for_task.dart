import 'package:fairpytasker/Component/drawer_ui.dart';
import 'package:fairpytasker/UI/Finance/Revenue/revenue_view_ui.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/vehicle_status_list_ui.dart';
import 'package:fairpytasker/UI/notes/notes_main_ui.dart';
import 'package:fairpytasker/UI/tasker/tasker_main_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/UI/Feedback/feedback_ui.dart';
import 'package:fairpytasker/Component/header.dart';
import '../UI/Finance/Expense/Component/expense_tap_ui.dart';
import '../UI/Finance/Finance/profit&loss_ui.dart';
import '../UI/Finance/Invoice/invoice_view_ui.dart';

class BottomNavigationForTaskView extends StatefulWidget {
  final int selectedIndex;
  final String? message;

  const BottomNavigationForTaskView(
      {super.key, required this.selectedIndex, this.message});

  @override
  State<BottomNavigationForTaskView> createState() =>
      _BottomNavigationForTaskViewState();
}

class _BottomNavigationForTaskViewState
    extends State<BottomNavigationForTaskView> {
  int index = 1;
  final GlobalKey _financeIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    index = widget.selectedIndex;
  }

  // A Map for pages to avoid the switch case logic
  final Map<int, Widget> pages = {
    0: const TaskerMainUi(),
    1: const NotesMainUi(),
    2: const VehicleStatusListUi(),
    3: const FeedBackUI(),
    4: const ExpenseTab(),
    5: const InvoiceViewUI(),
    6: const RevenueViewUI(),
    7: const ProfitAndLossUI(),
  };

  Widget callPage(int current) {
    return pages[current] ?? const TaskerMainUi(); // Fallback
  }

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
        setState(() {
          index = value; // Set index based on the selected menu item
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerView(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: HeaderView(),
      ),
      backgroundColor: AppC.white,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppC.white,
        currentIndex: index < 4 ? index : 0, // Show main tabs as active if index < 4
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppC().base,
        unselectedItemColor: AppC.grey,
        onTap: (value) {
          if (value != 4) {
            setState(() {
              index = value;
            });
          }
        },
        items: [
          buildBottomNavItem(
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
          ),
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
        ],
      ),
      body: switch(index){
      0 => const TaskerMainUi(),
      1 => const NotesMainUi(),
      2 => const VehicleStatusListUi(),
      3 => const FeedBackUI(),
      4 => const ExpenseTab(),
      5 => const InvoiceViewUI(),
      6 => const RevenueViewUI(),
      7 => const ProfitAndLossUI(),
      _ => const TaskerMainUi(),
      },
    );
  }
}
