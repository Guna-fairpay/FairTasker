import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import '../../../Bloc/cohorts_bloc.dart';
import '../../../Event/cohorts_event.dart';
import '../../../Event/todo_view_event.dart';
import '../../../State/cohorts_state.dart';
import '../../../State/todo_view_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

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
  late

  List<Map<String, dynamic>> Cash_Flows_from_Operations = [
    {'label': 'Customer payments', 'value': 200000},
    {'label': 'Material Purchase', 'value': 64000},
    {'label': 'Testing', 'value': 10000},
  ];

  List<Map<String, dynamic>> Statement_UI = [];
  List<Map<String, dynamic>> Cash_Flows_from_Investing = [
    {'label': 'Equipment purchase', 'value': 40000},
  ];

  List<Map<String, dynamic>> Loan_Payment = [
    {'label': 'loan payment', 'value': 60000},
  ];


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

  int calculateTotalCashFlows() {
    return Cash_Flows_from_Operations.fold(0, (sum, item) => sum + (item['value'] as int));
  }

  Widget datePickerBuilder(BuildContext context, dynamic Function(DateRange?) onDateRangeChanged, [bool doubleMonth = false]) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
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
    int totalCashFlows = calculateTotalCashFlows();

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

            (cohortsData as List).forEach((element) {
              (element['items'] as List).forEach((item) {
                if (element['id'] == item['statement_id']) {
                  Statement_UI.add({
                    'name': element['name'],
                    'total_name': element['total_name'],
                    'item_name': item['name'],
                    'item_value': item['value']
                  });
                }
              });
            });

          },
          builder: (context, state) {
            return Stack(
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
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppC.fieldBase,
                                    width: Num.borderWidthField,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(Num.subradiusButton)),
                                ),
                                child: DropdownButton<Map<String, dynamic>>(
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Utils.getText('Project Name', color: AppC.grey),
                                  ),
                                  value: selectedCohortsData,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down, color: AppC.appColor),
                                  elevation: 3,
                                  dropdownColor: AppC.white,
                                  underline: Container(height: 0, color: Colors.transparent),
                                  onChanged: (Map<String, dynamic>? value) {
                                    setState(() {
                                      selectedCohortsData = value;
                                    });
                                  },
                                  items: cohortsData.map<DropdownMenuItem<Map<String, dynamic>>>(
                                        (Map<String, dynamic> value) {
                                      return DropdownMenuItem<Map<String, dynamic>>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Utils.getText(value['cohort'] ?? '', overFlow: TextOverflow.ellipsis),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: SizedBox(
                              height: 40,
                              child: DateRangeField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppC.fieldBase, width: Num.borderWidthField),
                                    borderRadius: BorderRadius.circular(Num.subradiusButton),
                                  ),
                                  hintStyle: Utils.getTextStyle(color: AppC.grey),
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
                      ListView.builder(shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Statement_UI.length,itemBuilder: (context, index){
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 2),
                                        blurRadius: 1,
                                        spreadRadius: -1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Utils.getText("${Statement_UI[index]['name']}",weight: FontWeight.bold),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showInputFields = !showInputFields;
                                          });
                                        },
                                        icon: Icon(
                                          showInputFields ? Icons.remove : Icons.add,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start, // Aligns rows to the top
                                      crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures rows stretch to full width
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Utils.getText("${Statement_UI[index]['item_name']}",weight: FontWeight.bold),
                                            Utils.getText("${Statement_UI[index]['item_value']}",weight: FontWeight.bold),
                                          ],
                                        ),
                                        const SizedBox(height: 8), // Optional spacing between rows
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Label 2'),
                                            Text("\$Value 2"),
                                          ],
                                        ),
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Label 2'),
                                            Text("\$Value 2"),
                                          ],
                                        ),
                                        Visibility(
                                          visible: showInputFields,
                                          child: Column(
                                            children: [
                                              Utils.getTextFormField('Enter Name', nameController),
                                              const SizedBox(height: 4,),
                                              Utils.getTextFormField('Enter Cohort', valueController),
                                              const SizedBox(height: 4,),
                                              Utils.getTextFormField('Cohort Dropdown', CohortController),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      // Handle adding new item logic
                                                    },
                                                    icon: const Icon(Icons.check,color: AppC.green,),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        showInputFields = false;
                                                      });
                                                    },
                                                    icon: const Icon(Icons.close,color: AppC.red),
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Label 2'),
                                            Text("\$Value 2"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            );

                          }),
                      const Divider()
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
