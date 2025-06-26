import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/expense_tap_ui.dart';
import 'package:fairpytasker/UI/Finance/revenue/ui/revenue_main_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseMainUI extends StatefulWidget {
  const ExpenseMainUI({super.key});

  @override
  State<ExpenseMainUI> createState() => _ExpenseMainUIState();
}

class _ExpenseMainUIState extends State<ExpenseMainUI> {
  int currentIndex = 0;

  void get _setState {
    if (mounted) setState(() { });
  }

  void _updateIndex(int index) {
    currentIndex = index;
    _setState;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 10.spMin.padding,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppC.borderColor, width: Num.borderWidthButton))
            ),
            child: Row(
              children: [
                CustomTabButton(buttonText: "Expense", value: 0, selectedValue: currentIndex, onPressed: _updateIndex,),
                CustomTabButton(buttonText: "Revenue", value: 1, selectedValue: currentIndex, onPressed: _updateIndex,),
                CustomTabButton(buttonText: "Finance", value: 2, selectedValue: currentIndex, onPressed: _updateIndex,),
                const Spacer(),
              ],
            ),
          ),
          Expanded(child: switch(currentIndex) {
            0 => const ExpenseTab(),
            1 => const RevenueTab(),
            2 => Container(),
            _ => Container(),
          })
        ],
      ),
    );
  }
}
