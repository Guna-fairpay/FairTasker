import "package:date_time/date_time.dart";
import "package:fairpytasker/Component/expense_vehicle_list_item.dart";
import "package:fairpytasker/Utilities/Utils.dart";
import "package:fairpytasker/core/app/extension/sized_extension.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "../../../../../Utilities/appC.dart";
import "../../Bloc/expense_bloc.dart";
import "../../Event/expense_event.dart";
import "../../State/expense_state.dart";

class ExpenseVehicleViewUI extends StatelessWidget {
  const ExpenseVehicleViewUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseBloc>(
        create: (context) => ExpenseBloc()
          ..add(GetVehicleExpenseData(
              minDate: DateTime.now()
                  .subtract(const Duration(days: 7))
                  .format('yyyy-MM-dd')
                  .toString(),
              maxDate: DateTime.now().format('yyyy-MM-dd').toString())),
        child: BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          },
          child:
              BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
            return Column(
              children: [
                Row(
                  children: [
                    Utils.getText('Total:', weight: FontWeight.bold, size: 13),
                    const SizedBox(width: 10),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0.5),
                    itemCount: state.filteredResponse.length,
                    itemBuilder: (context, index) => ExpenseVehicleListItem(expense: state.apiResponse[index]),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}

/*class ExpenseViewUI extends StatefulWidget {
  const ExpenseViewUI({super.key});

  @override
  State<ExpenseViewUI> createState() => _ExpenseViewUIState();
}

class _ExpenseViewUIState extends State<ExpenseViewUI> {
  late TodoViewBloc expenseBloc;
  late EmployeeBloc employeeBloc;
  TextEditingController dateController = TextEditingController();
  DateRange? selectedDateRange;
  List<Map<String, dynamic>> expense = [];
  List<Map<String, dynamic>> filteredExpense = [];
  bool loading = false;
  List<Map<String, dynamic>> employee = [];
  List<Map<String, dynamic>> filteredEmployee = [];

  @override
  void initState() {
    expenseBloc = TodoViewBloc();
    employeeBloc = EmployeeBloc();
    filteredExpense = expense;
    DateTime now = DateTime.now();
    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 7)),
      now,
    );
    String minDate = selectedDateRange!.start.toString();
    String maxDate = selectedDateRange!.end.toString();
    expenseBloc.add(GetExpenseData(minDate, maxDate));
    employeeBloc.add(const GetEmployeeData());
    super.initState();
  }

  void _navigateToExpenseEditUI(int index) async {
    final updatedTask = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseEditUI(expense: expense[index]),
      ),
    );
    if (updatedTask != null) {
      expenseBloc.add(AddExpenseData(
          vehicleId: updatedTask['vehicle_id'],
          expenseAmount: updatedTask['expense_amount'],
          paymentMethodId: updatedTask['payment_method_id'],
          expenseDescription: updatedTask['expense_description'],
          categoryId: updatedTask['category_id'],
          subcategoryId: updatedTask['subcategory_id'],
          expenseTo: updatedTask['expense_to'],
          expenseDate: updatedTask['expense_date'],
          odometer: updatedTask['odometer'],
          id: updatedTask['id']));

      Utils.showMobileToast('Task updated successfully');
    }
  }

  void filterTasksByDateRange() {
    List<Map<String, dynamic>> result = expense;
    if (selectedDateRange != null) {
      result = result.where((item) {
        final dateParts = item['date']?.split(' to ');
        if (dateParts == null || dateParts.length != 2) return false;

        final startDate =
            DateTime.tryParse(dateParts[0].split('-').reversed.join('-'));
        final endDate =
            DateTime.tryParse(dateParts[1].split('-').reversed.join('-'));

        return startDate != null && endDate != null;
        // &&
        // startDate.isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
        // endDate.isBefore(selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
    setState(() {
      filteredExpense = result;
    });
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
                      Tab(text: 'Vehicle', height: 30),
                      Tab(text: 'Person', height: 30),
                      Tab(text: 'Other', height: 30),
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
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => expenseBloc
                  ..add(GetExpenseData(
                    selectedDateRange!.start.toString(),
                    selectedDateRange!.end.toString(),
                  ))),
            BlocProvider(
                create: (context) => employeeBloc..add(const GetEmployeeData()))
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<TodoViewBloc, TodoViewState>(
                listener: (context, state) {
                  if (state is TodoListLoading) {
                    loading = true;
                  } else if (state is ExpenseListLoaded) {
                    loading = false;
                    expense.clear();
                    expense.addAll(state.data);
                    filteredExpense = List.from(state.data);
                  } else {
                    loading = true;
                  }
                },
              ),
              BlocListener<EmployeeBloc, EmployeeState>(
                  listener: (context, state) {
                if (state is EmployeeListLoaded) {
                  employee.clear();
                  employee.addAll(state.data ?? []);
                  filteredEmployee = List.from(state.data ?? []);
                }
              })
            ],
            child: BlocBuilder<TodoViewBloc, TodoViewState>(
                builder: (context, state) {
              return Stack(
                children: [
                  TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 40,
                                    child: DateRangeField(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              Num.subradiusButton),
                                        ),
                                        label: Utils.getText('Date Range',
                                            color: AppC.grey),
                                      ),
                                      selectedDateRange: selectedDateRange,
                                      onDateRangeSelected: (DateRange? value) {
                                        setState(() {
                                          selectedDateRange = value;
                                          String startDate = selectedDateRange!
                                              .start
                                              .toString();
                                          String endDate =
                                              selectedDateRange!.end.toString();
                                          expenseBloc.add(GetExpenseData(
                                              startDate, endDate));

                                          filterTasksByDateRange();
                                        });
                                      },
                                      pickerBuilder: datePickerBuilder,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ExpenseAddUI()));
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: AppC.grey.shade300,
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                4)),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Utils.getText('Total:',
                                    weight: FontWeight.bold, size: 13),
                              ],
                            ),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: filteredExpense.length,
                                    itemBuilder: (_, index) {
                                      final expenseList =
                                          filteredExpense[index];
                                      final employeeId =
                                          expenseList['employee_id'];
                                      final Map<String, dynamic>
                                          matchedEmployee =
                                          filteredEmployee.isNotEmpty
                                              ? filteredEmployee.firstWhere(
                                                  (emp) =>
                                                      emp['id'] == employeeId,
                                                  orElse: () => {},
                                                )
                                              : {};

                                      final initials = matchedEmployee
                                              .isNotEmpty
                                          ? (matchedEmployee['id'] == 1
                                              ? 'PO'
                                              : "${matchedEmployee['first_name']?[0] ?? ''}${matchedEmployee['last_name']?[0] ?? ''}")
                                          : '';

                                      bool isChecked =
                                          (expenseList['approved'] == 1);

                                      return Slidable(
                                        endActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed:
                                                    (context) {}, //=> _delete(index),
                                                backgroundColor: AppC.white,
                                                foregroundColor: AppC.red,
                                                icon: Icons.delete_outline,
                                                label: 'Delete',
                                              ),
                                            ]),
                                        child: GestureDetector(
                                          onTap: () {
                                            _navigateToExpenseEditUI(index);
                                          },
                                          child: Card(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            color: AppC.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(children: [
                                                    Utils.getText(
                                                        expenseList['expense_date']
                                                                ?.substring(
                                                                    5) ??
                                                            '',
                                                        //weight: FontWeight.bold,
                                                        color: expenseList[
                                                                    'approved'] ==
                                                                0
                                                            ? AppC.redAccent
                                                            : AppC.black),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Utils.getText(
                                                        expenseList['vehicle']?[
                                                                'vehicle_name'] ??
                                                            '',
                                                        weight: FontWeight.bold,
                                                        color: expenseList[
                                                                    'approved'] ==
                                                                0
                                                            ? AppC.redAccent
                                                            : AppC.black,
                                                        overFlow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    //Icon(Icons.remove_red_eye_outlined,size: 15,),
                                                    Utils.getText(
                                                      initials,
                                                      weight: FontWeight.bold,
                                                      color: expenseList[
                                                                  'approved'] ==
                                                              0
                                                          ? AppC.redAccent
                                                          : AppC.black,
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Utils.getText(
                                                      expenseList['expense_amount'] !=
                                                                  null &&
                                                              expenseList[
                                                                      'expense_amount'] >=
                                                                  1
                                                          ? '\$${expenseList['expense_amount'].toStringAsFixed(2)}'
                                                          : '\$${expenseList['expense_amount']}',
                                                      weight: FontWeight.bold,
                                                      color: expenseList[
                                                                  'approved'] ==
                                                              0
                                                          ? AppC.redAccent
                                                          : AppC.black,
                                                    ),
                                                  ]),
                                                  //SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start, // Adjust main alignment
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center, // Adjust cross alignment
                                                    children: [
                                                      Container(
                                                        child: Utils.getText(
                                                          (expenseList['expense_to_data']
                                                                      ?[
                                                                      'expense_to'] !=
                                                                  'Cohort')
                                                              ? '${expenseList['expense_to_data']?['expense_to'] ?? ''}'
                                                              : '',
                                                          weight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Utils.getText(
                                                            '${expenseList['cohort']?['cohort'] ?? ''} ',
                                                            weight:
                                                                FontWeight.bold,
                                                            overFlow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Utils.getText("|",
                                                          size: 20),
                                                      Expanded(
                                                        child: Container(
                                                          child: Utils.getText(
                                                            '${expenseList['category']?['name'] ?? ''} ',
                                                            weight:
                                                                FontWeight.bold,
                                                            overFlow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Utils.getText("|",
                                                          size: 20),
                                                      Expanded(
                                                        child: Container(
                                                          child: Utils.getText(
                                                            '${expenseList['subcategory']?['name'] ?? ''}',
                                                            weight:
                                                                FontWeight.bold,
                                                            overFlow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                          width:
                                                              20), // Adjust width if needed
                                                      SizedBox(
                                                        width: 15,
                                                        child: Checkbox(
                                                          activeColor:
                                                              AppC.appColor,
                                                          value: isChecked,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked =
                                                                  value ??
                                                                      false;
                                                              expenseList[
                                                                      'approved'] =
                                                                  isChecked
                                                                      ? 1
                                                                      : 0;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),
                                                      Utils.getText(
                                                        '\$0.00',
                                                        // expenseList['expense_amount'] != null && expenseList['expense_amount'] >= 1
                                                        //     ? '\$${expenseList['expense_amount'].toStringAsFixed(2)}'
                                                        //     :'\$${expenseList['expense_amount']}0',
                                                        weight: FontWeight.bold,
                                                        color: AppC.appColor,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }))
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: PersonExpenseViewUI(),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: OtherExpenseViewUI(),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)),
                  ),
                ],
              );
            }),
          ),
        ),
        drawer: const DrawerView(),
      ),
    );
  }

  Widget datePickerBuilder(
      BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = false]) {
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      initialDateRange: selectedDateRange,
      initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: onDateRangeChanged,
      height: 340,
      displayMonthsSeparator: true,
    );
  }
}*/
