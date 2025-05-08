import 'dart:developer';

import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../Component/custom_tab_button.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../Bloc/workHoursBloc.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';
import 'Popups/task_filter.dart';

class ExtendedDetailsDay extends StatelessWidget {
  final String fromDate;
  final String toDate;
  final int userId;
  final Map<String, dynamic> data;
  const ExtendedDetailsDay(
      {
        super.key,
        required this.fromDate,
        required this.toDate,
        required this.userId,
        required this.data,
      }
);

  @override
  Widget build(BuildContext context) {
    Set<int> selectedFilters = {};
    return BlocProvider(
      create: (context) => WorkingHoursBloc()
        ..add(ExtendedDetailsDayEvent(startDate: fromDate, endDate: toDate, date: toDate, userId: userId, cohortIds: selectedFilters.toList() ?? [], data: data)),
      child: BlocListener<WorkingHoursBloc, WorkingHoursState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            log("${state.checkInDetails}", name: "hoursData1");
          }
        },
        child: BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leadingWidth: 0,
                title: const Text("Hasnath Mohammed"),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                      onPressed: context.pop, icon: const Icon(Icons.close_rounded))
                ],
                foregroundColor: Colors.white,
                backgroundColor: AppC.appColor,
              ),
              body: SafeArea(
                  minimum: EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      children: [
                        Table(columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                        }, children: [
                          TableRow(children: [
                            Utils.getText("CheckIn", weight: FontWeight.bold),
                            Utils.getText("CheckOut", weight: FontWeight.bold),
                            Utils.getText("Active Hours", weight: FontWeight.bold),
                            Utils.getText("Total Hours", weight: FontWeight.bold),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Utils.getText("${state.checkInDetails?['checkIn'] ?? ''}",),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 10),
                              child: Utils.getText("${state.checkInDetails?['checkOut'] ?? ''}",),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 20),
                              child: Utils.getText("${state.checkInDetails?['active_hours'] ?? ''}",),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 20),
                              child: Utils.getText("${state.checkInDetails?['total_hours'] ?? ''}",),
                            ),
                          ]),
                        ]),
                        Container(
                          decoration:const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(width: Num.borderWidthThinField)
                              )
                          ),
                          child:  Row(
                            children: [
                              CustomTabButton(
                                  buttonText: 'By Task',
                                  value: 0,
                                  selectedValue: context.watch<WorkingHoursBloc>().selectedTab,
                                  onPressed:(val)=> context.read<WorkingHoursBloc>().add(TabChangeEvent(tabIndex: val))),
                              CustomTabButton(
                                  buttonText: 'By Day',
                                  value: 1,
                                  selectedValue: context.watch<WorkingHoursBloc>().selectedTab,
                                  onPressed:(val)=> context.read<WorkingHoursBloc>().add(TabChangeEvent(tabIndex: val))),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: Utils.getText("${state.checkInDetails?['date'] ?? ''}",weight: FontWeight.bold,size: 16),
                          trailing: GestureDetector(
                          onTap: () {
                            final workingHoursBloc = context.read<WorkingHoursBloc>();
                            showDialog(
                              context: context,
                              builder: (dialogContext) =>
                                  FilterDialog(
                                    workingHoursBloc: workingHoursBloc,
                                    filterOptions: state.cohortsData,
                                    selectedFilters: selectedFilters,
                                    onSelectionChanged: (newSelection) {
                                      selectedFilters = newSelection;
                                      print("Selected Filters (IDs): $selectedFilters");
                                    },
                                    to: fromDate.toString(),
                                    from: toDate.toString(),
                                    userId: userId,
                                  ),
                            );
                          },
                          child: const Icon(Icons.filter_alt_sharp),
                        ),
                        ),
                      ],
                    ),
                  )
              ),
            );
          }
        ),
      ),
    );
  }
}
