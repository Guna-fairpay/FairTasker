
import "package:date_time/date_time.dart";
import "package:fairpytasker/Component/custom_checkbox.dart";
import "package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart";
import "package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Bloc/expense_bloc.dart";
import "package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Bloc/expense_event.dart";
import "package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Bloc/expense_state.dart";
import "package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Dialog/category_subcategory_dialog.dart";
import "package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Dialog/cohort_dialog.dart";
import "package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/UI/expense_vehicle_list_item.dart";
import "package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Add/UI/vehicle_expense_add_ui.dart";
import "package:fairpytasker/Utilities/Utils.dart";
import "package:fairpytasker/Utilities/appC.dart";
import "package:fairpytasker/core/app/extension/datetime_extension.dart";
import "package:fairpytasker/core/app/extension/sized_extension.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class ExpenseVehicleViewUI extends StatelessWidget {
  const ExpenseVehicleViewUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseBloc>(
        create: (context) => ExpenseBloc()
          ..add(const GetVehicleExpenseData()),
        child: BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          },
          child:
              BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: DateRangePicker(
                          selectedDateRange: state.selectedDateRange,
                          onDateRangeSelected: (range) {
                            context.read<ExpenseBloc>().add(
                                UpdateDateRangeEvent(selectedRange: range));
                            dynamic startDate = range.start.toFormat().toString();
                            dynamic endDate = range.end.toFormat().toString();
                            context.read<ExpenseBloc>().add(
                                GetVehicleExpenseData(
                                    minDate: startDate, maxDate: endDate));
                          },
                        ),
                      ),
                      InkWell(
                        onTap:()=> Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const ExpenseVehicleAddUI(),
                            fullscreenDialog: true)),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: AppC.appColor,
                              borderRadius: BorderRadiusDirectional.circular(8)),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomCheckboxListTile(
                            padding: 0.padding,
                            borderColor: AppC.appColor,
                            radius: 8,
                            useExpand: false,
                            title: Utils.getText('Approved',size: 12.sp,color: AppC.grey,weight: FontWeight.bold),
                            value: state.isExpenseApproved,
                            onChanged:  (value)=>context.read<ExpenseBloc>().add(ApprovedExpenseEvent(isApproved:value)),),
                          Row(
                            spacing: 35,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Utils.getText(
                                  '\$ ${state.unApprovedAmount.toStringAsFixed(2)}',
                                  color: AppC.redAccent,
                                  weight: FontWeight.bold),
                              Utils.getText('\$ ${state.approvedAmount.toStringAsFixed(2)}',
                                  color: AppC.appColor,
                                  weight: FontWeight.bold),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    physics:const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 0.5),
                      itemCount: state.filteredResponse.length,
                      itemBuilder: (context, index) => ExpenseVehicleListItem(
                            expense: state.filteredResponse[index],
                            onCategoryTapEvent: () {
                              CategorySubcategoryDialog.show(
                                context,
                                expense: state.filteredResponse[index],
                                onCompleted: () => context.read<ExpenseBloc>().add(RefreshEvent()),
                              );
                            },
                            onCohortTapEvent: () {
                              context.read<ExpenseBloc>().add(CohortDialogEvent(
                                  data: state.filteredResponse[index]));
                              CohortDialog.show(
                                context,
                                expense: state.filteredResponse[index],
                              );
                            },
                            onChanged: (value) => context.read<ExpenseBloc>()
                                .add(ApproveEvent(
                                    model: state.filteredResponse[index],
                                    approved: "${value == true ? 1 : 0}")),
                            onDelete: (id) => context.read<ExpenseBloc>()
                                .add(DeleteExpenseEvent(id: id)),
                          ),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
