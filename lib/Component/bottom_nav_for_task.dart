import 'package:fairpytasker/Component/compact_bottom_bar_item.dart';
import 'package:fairpytasker/Component/drawer_ui.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/expense_tap_ui.dart';
import 'package:fairpytasker/UI/Finance/Finance/profit&loss_ui.dart';
import 'package:fairpytasker/UI/Finance/Invoice/invoice_view_ui.dart';
import 'package:fairpytasker/UI/Finance/expense_main/expense_main_screen.dart';
import 'package:fairpytasker/UI/Finance/revenue/ui/revenue_main_ui.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/vehicle_status_list_ui.dart';
import 'package:fairpytasker/UI/notes/notes_main_ui.dart';
import 'package:fairpytasker/UI/tasker/tasker_main_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/bottom_menu.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/UI/Feedback/feedback_ui.dart';
import 'package:fairpytasker/Component/header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  void initState() {
    super.initState();
    index = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerView(),
      extendBody: false,
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(25.h),
        child: const HeaderView(),
      ),
      backgroundColor: AppC.white,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.sp,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: index,
        iconSize: 20.r,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: AppC().base,
        unselectedItemColor: AppC.grey,
        unselectedLabelStyle: context.textTheme.labelMedium,
          unselectedFontSize: 12.sp,
        selectedLabelStyle: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        selectedFontSize: 14.sp,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: BottomMenuHelper.pages.map((e) => CompactBottomBarItem(labelText: e['name'], selectedIcon: e['activeIcon'], inActiveIcon: e['icon'])).toList()
      ),
      body: switch(BottomMenuHelper.getPageIndex(index)){
      0 => const TaskerMainUi(),
      1 => const NotesMainUi(),
      2 => const VehicleStatusListUi(),
      3 => const FeedBackUI(),
      4 => const ExpenseMainUI(),
      5 => const InvoiceViewUI(),
      6 => const RevenueTab(),
      7 => const ProfitAndLossUI(),
      _ => const TaskerMainUi(),
      },
    );
  }
}
