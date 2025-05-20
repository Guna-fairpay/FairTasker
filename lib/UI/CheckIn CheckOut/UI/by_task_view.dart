
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../../../Utilities/Utils.dart';
import '../Bloc/workHoursBloc.dart';
import '../Component/task_expansion.dart';
import '../Component/task_expansion_list_tile.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';
import 'Popups/task_filter.dart';

class ByTaskView extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> byTaskData;
  final String? fromDate;
  final String? toDate;
  final String date;
  final int userId;
  const ByTaskView({
    super.key,
    required this.data,
    required this.byTaskData,
    required this.fromDate,
    required this.toDate,
    required this.userId,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    Set<int> selectedFilters = {};
    return BlocProvider(
      create: (context) => WorkingHoursBloc()..add(ByTaskInitialEvent(date: date, userId: userId, cohortIds: selectedFilters.toList())),
      child: BlocListener<WorkingHoursBloc, WorkingHoursState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            log("${state.checkInDetails?['date'] ?? ''}");
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child:
          BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
            builder: (context, state){
              return SafeArea(
                  minimum: const EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Utils.getText("${data['date'] ?? ''}",weight: FontWeight.bold,size: 16),
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
                                    to: date.toString(),
                                    userId: userId,
                                  ),
                            );
                          },
                          child: const Icon(Icons.filter_alt_sharp),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.65,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.byTaskData.length,
                          itemBuilder: (context, index) {
                            final category = state.byTaskData[index];
                            final subcategories =
                            category['subcategory'] as List<dynamic>;
                            final categoryCount = subcategories.fold<int>(
                                0, (sum, item) => sum + (item['count'] as int));
                            return TaskExpansion(
                              leadingText: "${category['title']}",
                              titleText: "$categoryCount",
                              isInitialExpand: category['count'] > 0 ? true : false,
                              children: subcategories.map<Widget>((subcategory) {
                                final subTitle = subcategory['sub_title'];
                                final vehicles =
                                subcategory['vehicles'] as List<dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: TaskExpansion(
                                    leadingText: subTitle,
                                    titleText: "${vehicles.length}",
                                    children: vehicles.map<Widget>((vehicle) {
                                      return
                                        TaskExpansionListTile(
                                          leadingText: vehicle['vehicle_name'] ?? vehicle['person'] ?? '',
                                          dateText: vehicle['todo_date'] != null
                                              ? formatDate(vehicle['todo_date'])
                                              : "",
                                          timeText: vehicle['complete_time_taken']
                                              ?.toString() ??
                                              '',
                                          id: vehicle?['id'] ?? 0,
                                        );
                                    }).toList(),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                          separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                        ),
                      ),
                    ],
                  )
              );
            }
          ),
      ),
    );
  }
}
String formatDate(String? date) {
  if (date == null || date.isEmpty) return "";
  return DateFormat('MM-dd-yy').format(DateTime.parse(date));
}