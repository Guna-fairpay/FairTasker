part of 'expense_summery_main_ui.dart';

class  CohortAndCategoryMainUI {
  CohortAndCategoryMainUI._();
  static void show(BuildContext context, {List<dynamic>? expenseData,}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: BlocProvider.of<ExpenseSummeryBloc>(context),
            child: _CohortAndCategoryMainUI(
              expenseData: expenseData,
            ),
          );
        });
  }
}

class _CohortAndCategoryMainUI extends StatelessWidget {
  final List<dynamic>? expenseData;
  const _CohortAndCategoryMainUI({
    Key? key,
    this.expenseData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseSummeryBloc, ExpenseSummeryState>(
        builder: (context, state) {
          return AlertDialog(
              alignment: Alignment.topCenter,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
              backgroundColor: AppC.white,
              insetPadding: 10.spMin.padding,
              titlePadding: EdgeInsets.zero,
              contentPadding: 5.spMin.padding.copyWith(left: 15.spMin, right: 20.spMin, bottom: 15.spMin),
              title: ListTile(
                title: Utils.getText(
                  "FairFund 2024",
                  color: AppC.appColor,
                  weight: FontWeight.bold,
                  size: 16.spMin,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => context.read<ExpenseSummeryBloc>().add(SaveEvent()),
                      icon: const Icon(Icons.check, color: AppC.green,),
                    ), IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: AppC.redAccent,),
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Utils.dropdownBox(
                    'select category',
                    context.watch<ExpenseSummeryBloc>().categoryList,
                            (v)=> context.read<ExpenseSummeryBloc>().add(CategoryEvent(v)),
                        labelKey: 'name',
                      initialSelection: context.watch<ExpenseSummeryBloc>().selectedCategory,
                    ),
                    Utils.dropdownBox(
                        'select sub category',
                        context.watch<ExpenseSummeryBloc>().subCategoryList,
                            (v)=> context.read<ExpenseSummeryBloc>().add(SubCategoryEvent(v)),
                        labelKey: 'name',
                        initialSelection: context.watch<ExpenseSummeryBloc>().selectedSubCategory,
                        selectedKey: context.watch<ExpenseSummeryBloc>().selectedSubCategory
                    ),
                    Utils.dropdownBox(
                        'select expense to',
                        context.watch<ExpenseSummeryBloc>().expenseTo,
                            (v)=> context.read<ExpenseSummeryBloc>().add(ExpenseToEvent(v)),
                        labelKey: 'name',
                        initialSelection: context.watch<ExpenseSummeryBloc>().selectedExpenseTo,
                        selectedKey: context.watch<ExpenseSummeryBloc>().selectedExpenseTo),
                  ],
                ),
              ));
        }
    );
  }
}

