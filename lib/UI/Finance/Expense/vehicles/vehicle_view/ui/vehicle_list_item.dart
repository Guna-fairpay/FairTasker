part of 'vehicle_view_main_ui.dart';

class VehicleListItem extends StatelessWidget {
  final dynamic expense;
  const VehicleListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleExpenseViewBloc, VehicleExpenseViewState>(
      builder: (context, state) {

        Color approveColor = expense['approved'] == 1 ? AppC.black : AppC.redAccent;
        final cohort = expense['expense_to'] == 1
            ? "${expense['expense_to_data']?['expense_to'] ?? ''}"
            : expense['expense_to'] == 4
            ? '${expense['cohort']?['cohort'] ?? ''}'
            : "";

        Color categoryColor = (expense['payment_method_id']).toString() == '4' ? const Color(0xFF13b3b3) : AppC.grey;
        List<dynamic> expenseImages = List.from(expense['attachments'] ?? []).map((e) => e['path'].toString().toStorageURL).toList();
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            decoration: BoxDecoration(
                color: AppC.redAccent,
                borderRadius: BorderRadius.circular(6)
            ),

            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete_outline, color: AppC.white),
                  CompactText( 'Delete', color: AppC.white),
                ],
              ),
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            AskPermissionDialog.show(context,
                title: "Are you sure?",
                description: "Do you want to delete this Expense?",
                positiveText: "Yes, delete it!",
                negativeText: "Cancel",
                isReasonRequired: false,
                onPositivePressed: ()=> context.read<VehicleExpenseViewBloc>().add(DeleteExpenseEvent(id: expense['id'])));
            return false;
          },
          child: SafeArea(
            minimum: 5.spMin.padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          flex: 5,
                          child: Row(
                            spacing: 10,
                            children: [
                              CompactText(
                                expense['expense_date'].toString().toDateTime()?.toFormat(format: 'MM-dd') ?? '',
                                color: approveColor,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap:()=> context.push(VehicleAddEditMainUI(editModel: expense)),
                                  child: CompactText(
                                      expense['vehicle']?['vehicle_name'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      color: approveColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if(expense['rental_booking_id'] != null)
                                InkWell(
                                    onTap: ()=>context.read<VehicleExpenseViewBloc>().add(FairRentalEvent(id: expense?['rental_booking_id'])),
                                    child: const CompactText('F', fontWeight: FontWeight.bold, color: AppC.blue,)),
                            ],
                          ),
                        ),
                      ]),
                      Row(children: [
                        if (cohort.isNotNullOrEmpty)
                          Expanded(
                            child: InkWell(
                              onTap: ()=> context.read<VehicleExpenseViewBloc>().add(CohortEvent(cohort: expense)),
                              child: CompactText(
                                cohort,
                                overflow: TextOverflow.ellipsis,
                                color: (expense['expense_to']).toString() == '4'
                                    ?context.watch<VehicleExpenseViewBloc>().getCategoryColor(cohort)
                                    : AppC.appColor,
                              ),
                            ),
                          ),
                        const CompactText(" | ", fontWeight: FontWeight.w900),
                        Expanded(
                          child: InkWell(
                            onTap: ()=> context.read<VehicleExpenseViewBloc>().add(CategoryEvent(category: expense)),
                            child: CompactText(
                              '${expense['category']?['name'] ?? ''} ',
                              overflow: TextOverflow.ellipsis,
                              color: categoryColor,
                            ),
                          ),
                        ),
                        const CompactText(" | ", fontWeight: FontWeight.w900),
                        Expanded(
                          child: InkWell(
                            onTap: ()=> context.read<VehicleExpenseViewBloc>().add(CategoryEvent(category: expense)),
                            child: CompactText(
                              '${expense['subcategory']?['name'] ?? ''}',
                              overflow: TextOverflow.ellipsis,
                              color: categoryColor,
                            ),
                          ),
                        ),
                      ],)
                    ],
                  ),
                ),
                ((expense['attachments'] ?? []).isNotEmpty)
                    ? InkWell(
                    onTap: () => ShowAttachmentsDialog.of.show(context,
                        attachments: expenseImages, title: 'Expense Image'),
                    child: const Icon(
                      size: 20,
                      Icons.remove_red_eye,
                      color: AppC.appColor,
                    ))
                    : const Icon(
                  Icons.remove_red_eye,
                  color: AppC.trans,
                ),
                Expanded(
                  child: Column(
                    spacing: 10,
                    children: [
                      CompactText(
                        "${expense['employee_name'] ?? ''}",
                        color: approveColor,
                        fontWeight: FontWeight.bold,
                      ),
                      FittedBox(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(14.spMin),
                          child: Checkbox(
                            activeColor: AppC.appColor,
                            value: (expense['approved'] == 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: const BorderSide(width: 0.8, color: AppC.appColor),
                            onChanged: (v)=> context.read<VehicleExpenseViewBloc>().add(ApproveCheckEvent(model: expense, approved: v)),
                          ),
                        ),
                      ),
                    ],),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 10,
                    children: [
                      CompactText(
                        "\$${expense['expense_amount'].toString().toDoubleDigit}",
                        color: approveColor,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                        onTap: () => context.push(VehicleExpenseHistoryUI(
                          vin: expense['vehicle']['vin'] ?? '',
                          vehicleName: expense['vehicle']['vehicle_name'] ?? '',
                          currentExpenseAmount: expense['approved']==0? double.tryParse(expense['expense_amount'].toString()):0.0,
                          showTotalAmount: true,
                        )),
                        child: CompactText(
                          "\$${expense['approveAmount'].toString().toDoubleDigit}",
                          fontWeight: FontWeight.bold,
                          color: AppC.grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
