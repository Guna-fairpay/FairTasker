import 'package:fairpytasker/UI/Finance/Finance/statement_filter_dropdown.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import '../../../Event/todo_view_event.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

import 'Component/custom_ExpansionTile.dart';
import 'Component/custom_ListTile.dart';

class StatementUI extends StatefulWidget {
  const StatementUI({super.key});

  @override
  State<StatementUI> createState() => _StatementUIState();
}

class _StatementUIState extends State<StatementUI> {
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController CohortController = TextEditingController();
  late TodoViewBloc cohortsBloc;
  List<Map<String, dynamic>> cohortsData = [];
  List<Map<String, dynamic>> expenseData = [];
  dynamic selectedCohortsData;
  DateTime? selectedDate;
  DateRange? selectedDateRange;
  bool loading = false;
  bool showInputFields = false;

  @override
  void initState() {
    super.initState();
    cohortsBloc = TodoViewBloc();
  }

  Widget datePickerBuilder(
      BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = false])
  {
      return SizedBox(
        height: 300,
        child: DateRangePickerWidget(
          doubleMonth: doubleMonth,
          initialDateRange: selectedDateRange,
          disabledDates: const [],
          initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
          onDateRangeChanged: onDateRangeChanged,
          displayMonthsSeparator: true,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(
        create: (context) => cohortsBloc..add(const GetEmployeeStatementData()),
        child: BlocConsumer<TodoViewBloc, TodoViewState>(
          listener: (context, state) async {
            if (state is TodoListLoading) {
              loading = true;
            } else if (state is FinanceStatementLoaded) {
              loading = false;
              cohortsData.clear();
              cohortsData.addAll(state.statementData ?? []);
            } else {
              cohortsBloc.add(const GetCohortsData());
              loading = true;
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Utils.getText(
                          'Income Statement',
                          size: 16,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child:
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppC.fieldBase,
                                      width: Num.borderWidthField,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(Num.subradiusButton)),
                                  ),
                                  child:
                                  const SearchableMultiSelectDropdown(items: [
                                    'Fair Returns LP LLC', 'Share Car',
                                    'Personal Car', 'FairPY',
                                    'Fair Returns Fall 2023', 'FairFund 2024',
                                    'Fair Returns Prime LP',
                                    'Abdullah khan 2024',
                                    'TESTER'
                                  ],),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: SizedBox(
                                height: 40,
                                child:
                                DateRangeField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppC.fieldBase,
                                          width: Num.borderWidthField),
                                      borderRadius: BorderRadius.circular(
                                          Num.subradiusButton),
                                    ),
                                    hintStyle:
                                    Utils.getTextStyle(color: AppC.grey),
                                    hintText: 'Select Date',
                                  ),
                                  onDateRangeSelected: (DateRange? value) {
                                    setState(() {
                                      selectedDateRange = value;
                                    });
                                  },
                                  selectedDateRange: selectedDateRange,
                                  pickerBuilder: datePickerBuilder,
                                ),
                              ),
                            ),
                          ],
                        ),
                        10.height,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CustomExpansionTile(title: 'Cash Flows from Operations',nameController: nameController,
                                valueController: valueController,
                                cohortController: CohortController,),
                              10.height,
                              CustomExpansionTile(title: 'Cash Flows from Investing',),
                              10.height,
                              CustomExpansionTile(title: 'Cash Flows from Financing',),
                              10.height,
                              RoundedBorderListTile(leadingText: "Net change in cash", trailingText: "\$0",),
                              10.height,
                              RoundedBorderListTile(leadingText: "Beginning cash balance", trailingText: "\$2000",),
                              10.height,
                              RoundedBorderListTile(leadingText: "Ending cash balance", trailingText: "\$2000",),
                              10.height,
                              CustomExpansionTile(title: 'Sales',totalCash: "40000",),
                              10.height,
                              RoundedBorderListTile(leadingText: "Gross Profit", trailingText: "\$40000",),
                              10.height,
                              CustomExpansionTile(title: 'Operating Expenses',),
                              10.height,
                              CustomExpansionTile(title: 'Assets',),
                              10.height,
                              CustomExpansionTile(title: 'Liabilities',),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
