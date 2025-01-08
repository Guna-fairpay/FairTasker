import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/todo_view_bloc.dart';
import '../../../Event/todo_view_event.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class CashFlowUI extends StatefulWidget {
  const CashFlowUI({super.key});

  @override
  State<CashFlowUI> createState() => _CashFlowUIState();
}

class _CashFlowUIState extends State<CashFlowUI> {
  late TodoViewBloc cohortsBloc;
  List<Map<String, dynamic>> cohortsData = [];
  dynamic selectedCohortsData;
  bool loading = false;
  int value = 50;

  @override
  void initState() {
    cohortsBloc = TodoViewBloc();
    super.initState();
  }

  Widget _colorBox(String label, Color color) {
    return Row(
      children: [
        Container(
          color: color,
          height: 10,
          width: 10,
        ),
        const SizedBox(width: 10),
        Utils.getText(label),
      ],
    );
  }

  Widget _textsInRow(String label, String label1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Utils.getText(label, color: AppC.grey),
        Utils.getText(label1, color: AppC.black),
      ],
    );
  }

  Widget? faProgressBar;

  Widget getFAProgressBar(int index) {
    faProgressBar = FAProgressBar(
      currentValue: double.parse((value ?? 0.0).toString()),
      displayText: '%',
      backgroundColor: AppC.lightGrey,
      progressColor: AppC().base,
      animatedDuration: const Duration(seconds: 1),
      size: 15,
      maxValue: 100,
    );
    return faProgressBar!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                      color: AppC.white,
                      border: Border.all(
                        color: AppC.grey, // Set the border color here
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // shadow color
                          spreadRadius: 3, // how far the shadow spreads
                          blurRadius: 5, // blur effect
                          offset:
                              const Offset(0, 3), // position of shadow (x, y)
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Utils.getText('Cash Flow',
                                size: 16, weight: FontWeight.bold),
                            const SizedBox(
                              width: 20,
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
                                  child: DropdownButton<Map<String, dynamic>>(
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
                                    onChanged: (Map<String, dynamic>? value) {
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Utils.getText(
                                              value['cohort'] ?? '',
                                              overFlow: TextOverflow.ellipsis),
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
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Utils.getText('LAST 6 MONTH', size: 12),
                            Utils.getText('vs past period', size: 12),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Utils.getText('%',
                                size: 20, weight: FontWeight.bold),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _textsInRow('Money Received', '0'),
                        getFAProgressBar(value),
                        const SizedBox(
                          height: 10,
                        ),
                        _textsInRow('Money Spent', '- 0'),
                        getFAProgressBar(value),
                        const SizedBox(
                          height: 20,
                        ),
                        _colorBox('Operation Revenue', AppC.green),
                        _colorBox('Other Cash Inflow', AppC.lightGreen),
                        _colorBox('Operational Expenses', AppC.red),
                        _colorBox('Other Cash Outflow', AppC.redOpac),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
