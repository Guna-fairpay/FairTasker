part of 'expense_summery_main_ui.dart';

class  CohortBaseVehicleMainUI {
  CohortBaseVehicleMainUI._();
  static void show(BuildContext context, {List<dynamic>? expenseData,}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<ExpenseSummeryBloc>(context),
          child: _CohortBaseVehicleMainUI(
            expenseData: expenseData,
          ),
        );
      });
  }
}

class _CohortBaseVehicleMainUI extends StatelessWidget {
  final List<dynamic>? expenseData;
  const _CohortBaseVehicleMainUI({
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
                  context.watch<ExpenseSummeryBloc>().title ?? '',
                  color: AppC.appColor,
                  weight: FontWeight.bold,
                  size: 16.spMin,
                ),
                trailing: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: Utils.getText(
                          "Total: \$ ${context.read<ExpenseSummeryBloc>().total.toString().toDoubleDigit}",
                          color: AppC.appColor,
                          weight: FontWeight.bold,
                          size: 16.spMin,
                          align: TextAlign.right,),
                    ),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: 10.verticalPadding,
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: context.watch<ExpenseSummeryBloc>().vehicleList.length,
                        itemBuilder: (context, index) {
                          var item = context.watch<ExpenseSummeryBloc>().vehicleList[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: ()=> context.read<ExpenseSummeryBloc>().add(ExpenseEditEvent(item)),
                                      child: Utils.getText(
                                        item?['vehicle']?['vehicle_name'] ?? '',
                                        color: AppC.appColor,
                                        weight: FontWeight.bold,
                                        overFlow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: ()=> context.read<ExpenseSummeryBloc>().add(CohortAndCategoryEvent(item)),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(text: "${item['category']?['name'] ?? ''}"),
                                            const TextSpan(text: ' | '),
                                            TextSpan(text: "${item['subcategory']?['name'] ?? ''}"),
                                          ],
                                          style: const TextStyle(color: AppC.text,overflow: TextOverflow.ellipsis),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Utils.getText("${item['employee_name'] ?? ''}", weight: FontWeight.bold),
                                    Visibility(
                                      visible: item['attachments'].isNotEmpty,
                                      child: InkWell(
                                          onTap: () => ShowAttachmentsDialog.of.show(context,
                                              attachments: item['attachments_paths'], title: 'Expense Image'),
                                          child: const Icon(
                                            size: 20,
                                            Icons.remove_red_eye,
                                            color: AppC.appColor,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex : 2,
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Utils.getText("\$${item['expense_amount'].toString().toDoubleDigit}", weight: FontWeight.bold),
                                    Utils.getText(item['expense_date'].toString().toDateTime()?.toFormat(format: 'MM-dd') ?? '', weight: FontWeight.bold),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ));
        }
    );
  }
}

