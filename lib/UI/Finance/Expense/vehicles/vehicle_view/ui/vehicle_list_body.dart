part of 'vehicle_view_main_ui.dart';

class VehicleListBody extends StatelessWidget {
  const VehicleListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocBuilder<VehicleExpenseViewBloc, VehicleExpenseViewState>(
            builder: (context, state) {
              return SafeArea(
                minimum: 10.verticalPadding,
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          flex : 3,
                          child: DateRangePicker(
                            selectedDateRange: context.watch<VehicleExpenseViewBloc>().selectedDateRange,
                            onDateRangeSelected: (range) => context.read<VehicleExpenseViewBloc>().add(DateRangeEvent(selectedRange: range)),
                          ),
                        ),
                        CompactIconButton(
                          elevation: 2,
                          icon:Icons.add,
                          iconSize: 18.spMin,
                          backgroundColor: AppC.appColor,
                          onPressed: ()=> context.push(const VehicleAddEditMainUI()),
                          shape: WidgetStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                        ),
                        Skeletonizer(
                            ignorePointers: true,
                            ignoreContainers: true,
                            enabled: state is LoadingState,
                            child: Column(
                              spacing: 2,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomCheckboxListTile(
                                  padding: 0.padding,
                                  borderColor: AppC.appColor,
                                  radius: 14.spMin,
                                  useExpand: false,
                                  title: const CompactText('Approved', color: AppC.grey, fontWeight: FontWeight.bold),
                                  value: context.watch<VehicleExpenseViewBloc>().isApproved,
                                  onChanged:  (value)=>context.read<VehicleExpenseViewBloc>().add(ApprovedEvent(isApproved:value)),),
                                InkWell(
                                  onTap: () => ExpenseSummeryMainUI.show(context, expenseData: context.read<VehicleExpenseViewBloc>().isApproved ? context.read<VehicleExpenseViewBloc>().filterResponse : []),
                                  child: Row(
                                    spacing: 35,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CompactText(
                                          '\$ ${context.watch<VehicleExpenseViewBloc>().unApprovedAmount.toStringAsFixed(2)}',
                                          color: AppC.redAccent,
                                          fontWeight: FontWeight.bold
                                      ),
                                      CompactText(
                                          '\$ ${context.watch<VehicleExpenseViewBloc>().approvedAmount.toStringAsFixed(2)}',
                                          color: AppC.appColor,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                    Expanded(
                      child: Skeletonizer(
                          ignorePointers: true,
                          ignoreContainers: true,
                          enabled: state is LoadingState,
                          child: ListView.separated(
                            physics:const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => const Divider(height: 0.5),
                            itemCount: (state is LoadingState) ? 10 : context.watch<VehicleExpenseViewBloc>().filterResponse.length,
                            itemBuilder: (context, index) => VehicleListItem(
                              expense: (state is LoadingState) ? DummyData.vExpense : context.watch<VehicleExpenseViewBloc>().filterResponse[index],
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }
        );
      }
    );
  }
}
