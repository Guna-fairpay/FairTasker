import 'package:fairpytasker/UI/Finance/Finance/statement_filter_dropdown.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:intl/intl.dart';
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
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    DateTime now = DateTime.now();
    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 365)),
      now,
    );
    super.initState();
    cohortsBloc = TodoViewBloc();
  }

  void _showDatePickerDialog(BuildContext context) {
    DateRange? tempDateRange = selectedDateRange;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 1,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: DateRangePickerWidget(
                            doubleMonth: false,
                            initialDateRange: selectedDateRange,
                            disabledDates: const [],
                            initialDisplayedDate:
                                selectedDateRange?.start ?? DateTime.now(),
                            onDateRangeChanged: (DateRange? value) {
                              tempDateRange =
                                  value; // Store temporary selection
                            },
                            height: 340,
                            displayMonthsSeparator: true,
                          ),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Cancel Button - Closes the dialog without saving
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // Close dialog
                              },
                              child:
                                  Utils.getText("Cancel", color: AppC.appColor),
                            ),
                            SizedBox(width: 10),

                            // Confirm Button - Saves the selected date range
                            GestureDetector(
                              onTap: () {
                                if (tempDateRange != null) {
                                  setState(() {
                                    selectedDateRange =
                                        tempDateRange; // Save selection
                                  });
                                }
                                Navigator.pop(context); // Close dialog
                              },
                              child: Utils.getText("Confirm",
                                  color: AppC.appColor),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
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
              print("cohortsData ${cohortsData[0]['name']}");
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
                      child: Column(
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
                          SizedBox(
                            height: 40,
                            width: 140,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppC.fieldBase,
                                  width: Num.borderWidthField,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(Num.subradiusButton)),
                              ),
                              child: const SearchableMultiSelectDropdown(
                                items: [
                                  'Fair Returns LP LLC',
                                  'Share Car',
                                  'Personal Car',
                                  'FairPY',
                                  'Fair Returns Fall 2023',
                                  'FairFund 2024',
                                  'Fair Returns Prime LP',
                                  'Abdullah khan 2024',
                                  'TESTER'
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: GestureDetector(
                                onTap: () => _showDatePickerDialog(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppC.fieldBase,
                                      width: Num.borderWidthField,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        Num.subradiusButton),
                                  ),
                                  child: Text(
                                    selectedDateRange == null
                                        ? 'Select Date'
                                        : "${dateFormat.format(selectedDateRange!.start)} - ${dateFormat.format(selectedDateRange!.end)}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
                            for (var item in cohortsData)
                              Column(
                                children: [
                                  // Check if 'total_name' is empty or null
                                  if (item['total_name'] == "")
                                    RoundedBorderListTile(
                                      leadingText: item['name'],
                                      trailingText: item['value'] != null
                                          ? '\$${item['value']}'
                                          : '\$0',
                                    )
                                  else
                                    CustomExpansionTile(
                                      title: item['name'],
                                      nameController: nameController,
                                      valueController: valueController,
                                      cohortController: CohortController,
                                      totalCash: item['value'] != null
                                          ? item['value'].toString()
                                          : null,
                                    ),
                                  10.height,
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
