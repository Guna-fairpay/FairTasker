import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../Component/task_expansion.dart';
import '../Component/task_expansion_list_tile.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import 'Popups/task_filter.dart';

import 'package:fairpytasker/UI/CheckIn%20CheckOut/Event/workingHoursEvent.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/State/workingHoursState.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Bloc/workHoursBloc.dart';

class WorkingHoursTaskUI extends StatelessWidget {
  final Map<String, dynamic> workingHoursData;
  final Map<String, String> dateRange;

  const WorkingHoursTaskUI({
    super.key,
    required this.workingHoursData,
    required this.dateRange,
  });

  String convertDateToCustomFormat(Map<String, String> inputDate) {
    try {
      String startDate = inputDate['from'].toString();
      String endDate = inputDate['to'].toString();
      String formattedStartDate = DateFormat("dd MMM yyyy").format(
        DateFormat("yyyy-MM-dd").parse(startDate),
      ).toUpperCase();
      String formattedEndDate = DateFormat("dd MMM yyyy").format(
        DateFormat("yyyy-MM-dd").parse(endDate),
      ).toUpperCase();
      return "$formattedStartDate - $formattedEndDate";
    } catch (e) {
      return "Invalid date format";
    }
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    return DateFormat('MM-dd-yy').format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    Set<int> selectedFilters = {};
    int getTotalCategoryCount(List<dynamic> categoryGroupData) {
      return categoryGroupData.fold<int>(0, (sum, category) {
        final subcategories = category['subcategory'] as List<dynamic>;
        final categoryCount = subcategories.fold<int>(
          0,
              (subSum, subItem) => subSum + (subItem['count'] as int),
        );
        return sum + categoryCount;
      });
    }

    return
    BlocProvider(
      create: (context) => WorkingHoursBloc()
        ..add(TaskInitialEvent(
            to: dateRange['to'].toString(),
            from: dateRange['from'].toString(),
            userId: workingHoursData['empID'], cohortIds: selectedFilters?.toList() ?? [])),
      child: Scaffold(
          backgroundColor: AppC.white,
          appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Utils.getText(
              "${workingHoursData['first_name']}",
              color: Colors.white,
              size: 18,
              weight: FontWeight.bold,
            ),
            Row(
              children: [
                BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
                  builder: (context, state) {
                    int totalCount = getTotalCategoryCount(state.categoryGroupData);
                    log("Total Count: $totalCount");
                    return Container(
                      width: 40,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Center(
                        child: Utils.getText(
                          "$totalCount",
                          size: 14,
                          color: Colors.white,
                          weight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  '\$84',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
        body: BlocListener<WorkingHoursBloc, WorkingHoursState>(
            listener: (context, state) {
              if (state.isLoading) {
                EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
              }
            },
          child: BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
            builder: (context, state) {
              return
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Utils.getText(
                                convertDateToCustomFormat(dateRange),
                                size: 14,
                              ),
                              GestureDetector(
                                onTap: () {
                                  final workingHoursBloc = context.read<WorkingHoursBloc>();
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => FilterDialog(
                                      workingHoursBloc: workingHoursBloc,
                                      filterOptions: state.cohortsData,
                                      selectedFilters: selectedFilters,
                                      onSelectionChanged: (newSelection) {
                                        selectedFilters = newSelection;
                                        print("Selected Filters (IDs): $selectedFilters");
                                      },
                                      to: dateRange['to'].toString(),
                                      from: dateRange['from'].toString(),
                                      userId: workingHoursData['empID'],
                                    ),
                                  );
                                },
                                child: const Icon(Icons.filter_alt_sharp),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.categoryGroupData.length,
                            itemBuilder: (context, index) {
                              final category = state.categoryGroupData[index];
                              final subcategories =
                              category['subcategory'] as List<dynamic>;
                              final categoryCount = subcategories.fold<int>(
                                  0, (sum, item) => sum + (item['count'] as int));

                              return TaskExpansion(
                                leadingText: "${category['title']}",
                                titleText: "$categoryCount",
                                children: subcategories.map<Widget>((subcategory) {
                                  final subTitle = subcategory['sub_title'];
                                  final vehicles =
                                  subcategory['vehicles'] as List<dynamic>;
                                  return TaskExpansion(
                                    leadingText: subTitle,
                                    titleText: "${vehicles.length}",
                                    children: vehicles.map<Widget>((vehicle) {
                                      return TaskExpansionListTile(
                                        leadingText: vehicle['vehicle_name'] ?? '',
                                        dateText: vehicle['todo_date'] != null
                                            ? formatDate(vehicle['todo_date'])
                                            : "",
                                        timeText: subcategory['complete_time_taken']
                                            ?.toString() ??
                                            '',
                                        id: vehicle?['id'] ?? 0,
                                      );
                                    }).toList(),
                                  );
                                }).toList(),
                              );
                            },
                            separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            },
          ),
        )
      )
    );
  }
}
