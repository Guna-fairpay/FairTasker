import 'package:date_time/date_time.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bloc/person_expense_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/person_expense_list_item.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/person_expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/State/persion_expense_state.dart';
import 'package:fairpytasker/UI/Finance/Expense/UI/Person/person_expense_add_ui.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PersonExpenseViewUI extends StatelessWidget {
  const PersonExpenseViewUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonExpenseBloc>(
        create: (context) => PersonExpenseBloc()
          ..add(GetPersonExpenseData(
              minDate: DateTime.now()
                  .subtract(const Duration(days: 7))
                  .format('yyyy-MM-dd')
                  .toString(),
              maxDate: DateTime.now().format('yyyy-MM-dd').toString())),
        child: BlocListener<PersonExpenseBloc, PersonExpenseState>(
          listener: (context, state) {
            state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          },
          child: BlocBuilder<PersonExpenseBloc, PersonExpenseState>(
              builder: (context, state) {
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
                            context.read<PersonExpenseBloc>().add(
                                ChangeDateRangeEvent(selectedRange: range));
                            String startDate = range.start.toString();
                            String endDate = range.end.toString();
                            context.read<PersonExpenseBloc>().add(
                                GetPersonExpenseData(
                                    minDate: startDate, maxDate: endDate));
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonExpenseAddUI(),
                            )),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: AppC.appColor,
                              borderRadius:
                                  BorderRadiusDirectional.circular(8)),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      30.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Utils.getText(
                            'Total: \$${state.approvedAmount.toStringAsFixed(2)}',
                            color: AppC.appColor,
                            weight: FontWeight.bold,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                (state.apiResponse.isEmpty && !state.isLoading)
                    ? const EmptyWidget()
                    : Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0.5),
                    itemCount: state.apiResponse.length,
                    itemBuilder: (context, index) =>
                        ExpensePersonListItem(
                                expense: state.apiResponse[index],
                                onChanged: (value) => context
                                    .read<PersonExpenseBloc>()
                                    .add(ApproveEvent(
                                      model: state.apiResponse[index],
                                      approved: "${value == true ? 1 : 0}",
                                    )),
                                onDelete: (id) => context
                                    .read<PersonExpenseBloc>()
                                    .add(DeletePersonExpenseEvent(
                                        id: id, isEditPage: false)),
                                employeeList: state.persons,
                                /*onCohort: (value) =>
                                context.read<ExpenseBloc>().add(
                                      CohortListEvent(selectedCohort: value),
                                    ),*/
                              ),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
