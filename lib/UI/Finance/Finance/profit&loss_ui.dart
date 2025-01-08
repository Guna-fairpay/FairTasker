import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/UI/Finance/Finance/statement_ui.dart';
import 'package:flutter/material.dart';
import '../../../Bloc/todo_view_bloc.dart';
import '../../../Event/todo_view_event.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import 'cash_flow_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfitAndLossUI extends StatefulWidget {
  const ProfitAndLossUI({super.key});

  @override
  State<ProfitAndLossUI> createState() => _ProfitAndLossUIState();
}

class _ProfitAndLossUIState extends State<ProfitAndLossUI> {
  late TodoViewBloc cohortsBloc;
  List<Map<String, dynamic>> cohortsData = [];
  dynamic selectedCohortsData;
  List<String> year = [];
  dynamic selectedYear;
  bool loading = false;
  DateTime? selectedDate;
  DateRange? selectedDateRange;
  int value = 100;

  @override
  void initState() {
    super.initState();
    cohortsBloc = TodoViewBloc();
    int currentYear = DateTime.now().year;
    int startYear = 2021; // Adjust this to your desired starting year
    year = List.generate(
        currentYear - startYear + 1, (index) => (startYear + index).toString());
  }

  Widget datePickerBuilder(
      BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = false]) {
    return Expanded(
      child: DateRangePickerWidget(
        doubleMonth: doubleMonth,
        initialDateRange: selectedDateRange,
        disabledDates: const [],
        initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
        onDateRangeChanged: onDateRangeChanged,
        height: 338,
        displayMonthsSeparator: true,
      ),
    );
  }

  Widget _colorBox(String label, Color? color, double height, double width) {
    return Row(
      children: [
        Container(
          color: color,
          height: height,
          width: width,
        ),
        const SizedBox(width: 5),
        Utils.getText(label, size: 12),
      ],
    );
  }

  Widget? faProgressBar;

  Widget getFAProgressBar(int index, Color color) {
    faProgressBar = FAProgressBar(
      currentValue: double.parse((value).toString()),
      displayText: '%',
      backgroundColor: AppC.white,
      progressColor: color,
      animatedDuration: const Duration(seconds: 1),
      size: 40,
      maxValue: 100,
    );
    return faProgressBar!;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0), // Change the height here
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    tabs: const [
                      Tab(text: 'Profile&Loss', height: 30),
                      Tab(text: 'Cash Flow', height: 30),
                      Tab(text: 'Statement', height: 30),
                    ],
                    dividerColor: AppC.trans,
                    labelStyle: const TextStyle(fontSize: 14),
                    labelColor: AppC.white,
                    unselectedLabelColor: AppC.appColor,
                    indicator: BoxDecoration(
                      color: AppC.appColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => cohortsBloc..add(const GetCohortsData()),
          child: BlocConsumer<TodoViewBloc, TodoViewState>(
              listener: (context, state) async {
            if (state is TodoListLoading) {
              loading = true;
            } else if (state is CohortsListLoaded) {
              loading = false;
              cohortsData.clear();
              cohortsData.addAll(state.cohortData ?? []);
            } else {
              cohortsBloc.add(const GetCohortsData());
              loading = true;
            }
          }, builder: (context, state) {
            return Stack(
              children: [
                TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Utils.getText(
                              'Profit & Loss',
                              size: 16,
                              weight: FontWeight.bold,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  Num.subradiusButton))),
                                      child:
                                          DropdownButton<Map<String, dynamic>>(
                                        hint: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Utils.getText('Project Name',
                                              color: AppC.grey),
                                        ),
                                        value: selectedCohortsData,
                                        isExpanded: true,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: AppC.appColor,
                                        ),
                                        elevation: 3,
                                        dropdownColor: AppC.white,
                                        underline: Container(
                                          height: 0,
                                          color: Colors.transparent,
                                        ),
                                        onChanged:
                                            (Map<String, dynamic>? value) {
                                          setState(() {
                                            selectedCohortsData = value;
                                          });
                                        },
                                        items: cohortsData.map<
                                                DropdownMenuItem<
                                                    Map<String, dynamic>>>(
                                            (Map<String, dynamic> value) {
                                          return DropdownMenuItem<
                                              Map<String, dynamic>>(
                                            value: value,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Utils.getText(
                                                  value['cohort'] ?? '',
                                                  overFlow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppC.fieldBase,
                                            width: Num.borderWidthField,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  Num.subradiusButton))),
                                      child: DropdownButton<String>(
                                        hint: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Utils.getText('Select Year',
                                              color: AppC.grey),
                                        ),
                                        value: selectedYear,
                                        isExpanded: true,
                                        // icon: const Icon(
                                        //   Icons.arrow_drop_down, color: AppC.appColor,),
                                        elevation: 3,
                                        dropdownColor: AppC.white,
                                        underline: Container(
                                          height: 0,
                                          color: Colors.transparent,
                                        ),
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedYear = value;
                                          });
                                        },
                                        items: year
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Utils.getText(value,
                                                  overFlow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 40,
                              child: DateRangeField(
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
                            const Divider(
                              height: 20,
                              thickness: 0.3,
                            ),
                            getFAProgressBar(value, AppC.green),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: getFAProgressBar(value, AppC.red)),
                                Column(
                                  children: [
                                    Utils.getText('NET INCOME', size: 12),
                                    Utils.getText('\$0',
                                        weight: FontWeight.bold, size: 16),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _colorBox('Income', AppC.green, 10, 30),
                                const SizedBox(
                                  width: 20,
                                ),
                                _colorBox('Expenses', AppC.redAccent, 10, 30),
                              ],
                            ),
                            SizedBox(
                              height: 400,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.start,
                                  maxY: 1.0, // Maximum value for Y-axis
                                  barGroups: [
                                    BarChartGroupData(
                                      x: 0,
                                      barRods: [
                                        BarChartRodData(
                                          toY:
                                              0.6, // Use toY for vertical height
                                          color: AppC.green,
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 1,
                                      barRods: [
                                        BarChartRodData(
                                          toY:
                                              0.8, // Use toY for vertical height
                                          color: AppC.redAccent,
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    // Continue adding bars for each month/data point
                                  ],
                                  titlesData: FlTitlesData(
                                    // leftTitles: const AxisTitles(
                                    //   sideTitles: SideTitles(
                                    //     showTitles: true,
                                    //     interval: 0.4,
                                    //   ),
                                    // ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          // Use getTitlesWidget for bottom axis labels
                                          switch (value.toInt()) {
                                            case 0:
                                              return const Text('JAN');
                                            case 1:
                                              return const Text('FEB');
                                            case 2:
                                              return const Text('MAR');
                                            // Add labels for other months
                                            default:
                                              return const Text('');
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: const FlGridData(show: true),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CashFlowUI(),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: StatementUI(),
                    ),
                  ],
                ),
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            );
          }),
        ),
      ),
    );
  }
}
