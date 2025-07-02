import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Dialog/expense_summery/bloc/expense_summery_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_add_edit/ui/vehicle_add_edit_main_ui.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'cohort_and_category_main_ui.dart';
part 'cohort_base_vehicle_main_ui.dart';

class  ExpenseSummeryMainUI {
  ExpenseSummeryMainUI._();
  static void show(BuildContext context, {List<dynamic>? expenseData,}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ExpenseSummeryMainUI(
        expenseData: expenseData,
      ),
    );
  }
}

class _ExpenseSummeryMainUI extends StatelessWidget {
  final List<dynamic>? expenseData;
  const _ExpenseSummeryMainUI({
    Key? key,
    this.expenseData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseSummeryBloc()
        ..add(InitialEvent(expenseData)),
      child: BlocListener<ExpenseSummeryBloc, ExpenseSummeryState>(
        listener: (context, state) {
         if(state is LoadingState){
           EasyLoading.show();
         }else{
           if(EasyLoading.isShow) EasyLoading.dismiss();
           switch(state){
             case VehicleListingState(): CohortBaseVehicleMainUI.show(context, expenseData: state.data); break;
             case CohortAndCategoryState(): CohortAndCategoryMainUI.show(context); break;
             case ErrorState(): Toaster.showError(state.message); break;
             case SuccessState(): Toaster.showSuccess(state.message); break;
             case ExpenseEditState(): context.push(VehicleAddEditMainUI(editModel: state.model)); break;
             default: break;
           }
         }
        },
        child: BlocBuilder<ExpenseSummeryBloc, ExpenseSummeryState>(
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
                      "Expense Summary",
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
                        Flexible(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(),
                                2: IntrinsicColumnWidth(),
                              },
                              children: [
                                TableHeaderRow(
                                  tableDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.spMin),
                                        topRight: Radius.circular(4.spMin)),
                                    border: Border(bottom: BorderSide(color: AppC.borderColor, width: 1.spMin),),
                                    color: AppC.white,),
                                  backgroundColor: AppC.appbgColor,
                                  labels: const ["Cohort List", "FairPY", "Cohort"],
                                ),
                                ...context.read<ExpenseSummeryBloc>().cohortData.map((e) => TableRow(
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: AppC.borderColor, width: 1.spMin),),
                                  ),
                                  children: [
                                    TableCell(
                                        child: Padding(
                                          padding: 10.spMin.padding,
                                          child: Utils.getText(e?['cohort_name'] ?? ''),
                                        )),
                                    TableRowInkWell(
                                      onTap: ()=> context.read<ExpenseSummeryBloc>().add(VehicleListingEvent(model: e, isFairPY: true)),
                                        child: Padding(
                                          padding: 10.spMin.padding,
                                          child: Text("\$ ${e?['fairPY_amount'].toString().toDoubleDigit ?? '0'}"),
                                        )),
                                    TableRowInkWell(
                                        onTap: ()=> context.read<ExpenseSummeryBloc>().add(VehicleListingEvent(model: e, isCohort: true)),
                                        child: Padding(
                                          padding: 10.spMin.padding,
                                          child: Text("\$ ${e?['cohort_amount'].toString().toDoubleDigit ?? '10'}"),
                                        )),
                                  ],
                                ),
                                ),
                                TableRow(
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: AppC.borderColor, width: 1.spMin),),
                                  ),
                                  children: [
                                    TableCell(
                                        child: Padding(
                                          padding: 10.spMin.padding,
                                          child: Utils.getText('Total', weight: FontWeight.bold),
                                        )),
                                    TableCell(
                                        child: Padding(
                                          padding: 10.spMin.padding,
                                          child: Utils.getText("\$${context.read<ExpenseSummeryBloc>().fairPYTotal.toString().toDoubleDigit}",  weight: FontWeight.bold),
                                        )),
                                    TableCell(
                                        child: Padding(
                                          padding: 10.spMin.padding,
                                          child: Utils.getText("\$${context.read<ExpenseSummeryBloc>().cohortTotal.toString().toDoubleDigit}", weight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              );
            }
        ),
      ),
    );
  }
}

