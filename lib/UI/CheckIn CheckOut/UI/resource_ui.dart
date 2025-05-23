

// working_hours_view_ui.dart
import 'dart:developer';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/task_components_settings_ui_rework.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/working_hours_task.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import '../../Finance/Expense/Component/date_range_selection.dart';
import '../Bloc/workHoursBloc.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';
import 'Popups/hours_top_notification_popup.dart';
import 'Popups/reason_top_notification_popup.dart';
import 'Popups/resource_listing_dropdown.dart';


class WorkHoursViewUI extends StatelessWidget {
  WorkHoursViewUI({super.key});
  List<Map<String, dynamic>> filteredData=[];
  Map<String, String> dates={};
  DateRange? selectedDateRange;
  String startDate='';
  String endDate='';

  Map<String, String> generateDateList(String startDate, String endDate) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd");
      DateTime start = format.parse(startDate);
      DateTime end = format.parse(endDate);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      String formattedStart = outputFormat.format(start);
      String formattedEnd = outputFormat.format(end);
      return {
        'from': formattedStart,
        'to':formattedEnd
      };
    } catch (e) {
      print("Error generating date list: $e");
      return {};
    }
  }


  String getFirstWord(String fullName) {
    return fullName.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
        appBar: AppBar(
        leadingWidth: 0,
        title: const Text("Check In/Out"),
    automaticallyImplyLeading: false,
    actions: [
    IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
    ],
    foregroundColor: Colors.white,
    backgroundColor: AppC.appColor,
        ),
      body:
      BlocProvider(
        create: (context) => WorkingHoursBloc()..add(WorkingHoursInitialEvent(
            minDate: selectedDateRange?.start.toString() ?? DateTime.now().subtract(const Duration(days: 7)).toString(),
            maxDate: selectedDateRange?.end.toString() ?? DateTime.now().toString()
        )),
        child: BlocListener<WorkingHoursBloc, WorkingHoursState>(
          listener: (context, state) {
            if (state.isLoading) {
              EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              filteredData = state.combinedData ?? [];
              startDate = DateFormat('yyyy-MM-dd').format(state.selectedDateRange!.start);
              endDate = DateFormat('yyyy-MM-dd').format(state.selectedDateRange!.end);
              dates = generateDateList(startDate, endDate);
            }
          },
          child:
          BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 5),
                child:
                Column(
                  children: [
                    const SizedBox(height: 7),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // Header Container (Fixed)
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(3),
                                3: FlexColumnWidth(2),
                                4: FlexColumnWidth(2),
                              },
                              children: [
                                  const TableRow(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 0.2,
                                          blurRadius: 0.5,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                      color: Color.fromRGBO(240, 240, 240, 1),
                                    ),
                                    children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "User",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "CheckIn",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "CheckOut",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "Active",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "Total",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                ...state.punchListData.map((item) => TableRow(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppC.black,
                                          width: 0.2,
                                        ),
                                      )
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "${item['User'] ?? ''}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "${item['CheckIn'] ?? ''}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "${item['CheckOut'] ?? ''}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "${item['Active'] ?? ''}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "${item['Total'] ?? ''}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )).toList(),
                              ],
                            ),
                          ),
                          // Scrollable Body Container
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: const Color.fromRGBO(189, 201, 232, 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.2,
                            blurRadius: 0.5,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Utils.getText("Working Hours History",size: 14.sp, weight: FontWeight.bold),
                        trailing: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TaskComponentsSettingsUI()));
                          },
                          child: const Icon(Icons.settings_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child:
                          DateRangePicker(
                            selectedDateRange: state.selectedDateRange,
                            onDateRangeSelected: (range)
                            {
                              // context.read<WorkingHoursBloc>().add(
                              //     UpdateDateRangeEvent(selectedRange: range));
                              startDate = DateFormat('yyyy-MM-dd').format(range.start);
                              endDate = DateFormat('yyyy-MM-dd').format(range.end);
                              log("${startDate} - ${endDate} ${state.selectedDateRange}",name: "datet");
                              context.read<WorkingHoursBloc>().add(WorkingHoursInitialEvent(minDate: startDate, maxDate: endDate));
                              dates.clear();
                              dates = generateDateList(startDate, endDate);
                              log("${dates}", name: "dates");
                            },
                          ),
                        ),
                        if(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getStringList(Str.rolePrefText)!.contains("Admin") || Session.of.getString(Str.userIdPrefText) == '2')
                        Expanded(child:
                        ResourceListingDropdown<Map<String, dynamic>>(
                          items: context.watch<WorkingHoursBloc>().dropDownResource,
                          value: context.watch<WorkingHoursBloc>().initialDropDown,
                          contentPadding: 5.padding,
                          onChanged: (val) => context.read<WorkingHoursBloc>().add(ResourceDropDownEvent(val)),
                          itemAsString: (item) => item['full_name'].toString(),
                        )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.2,
                            blurRadius: 0.5,
                            offset: Offset(0, 1),
                          ),
                        ],
                        color: const Color.fromRGBO(240, 240, 240, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: 
                        Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: Utils.getText('Employee', weight: FontWeight.bold)),
                            Expanded(
                                flex: 3,
                                child: Utils.getText('Active', weight: FontWeight.bold)),
                            Expanded(
                                flex: 3,
                                child: Utils.getText('Hours', weight: FontWeight.bold)),
                            Expanded(
                                flex: 2,
                                child: Utils.getText('Task', weight: FontWeight.bold)),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Utils.getText('#', weight: FontWeight.bold))),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                      Builder(
                        builder: (context) {
                          log("${context.watch<WorkingHoursBloc>().initialDropDown}");
                          var selectedName = context.watch<WorkingHoursBloc>().initialDropDown;
                          final dataList = (context.read<WorkingHoursBloc>().approveId.contains(Session.of.getString(Str.userIdPrefText))
                          ) ?
                          (selectedName['full_name'] == 'All')
                              ? state.combinedData
                              :  state.combinedData?.where((item) {
                                return item['user_id'] == selectedName['id'];
                              }).toList() ?? []
                              : state.combinedData?.where((item) {
                                return
                                  item['user_id'].toString().trim() == Session.of.getString(Str.userIdPrefText).toString().trim();
                              }).toList() ?? [];
                          if ((dataList ?? []).isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                              itemCount: dataList?.length ?? 0,
                              itemBuilder: (context, index) {
                              final employee = dataList?[index];
                              //final taskCount = employee?['#']?.toString() ?? '0';
                              if (employee?['#'] != '0' && employee?['#'] != null)
                              {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Container(
                                    key: ValueKey(employee?['id']),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppC.black,
                                          width: 0.2,
                                        ),
                                      )
                                    ),
                                    child:
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Utils.getText(employee?['Employee'] ?? ''), // Resource Name
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Utils.getText(employee?['Active'] ?? ''), // Active Hours
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: GestureDetector(
                                            onTap: () {
                                              HoursPopup.show(
                                                context,
                                                dataList: employee?['list'],
                                                userName: "${employee?['first_name']} ${employee?['last_name']}",
                                                selectedDateRange: state.selectedDateRange.toString(),
                                                empID: employee?['user_id'],
                                                hrmID: employee?['hrm_id'],
                                                fromDate: startDate,
                                                toDate: endDate,
                                              );
                                            },
                                            child: Utils.getText(employee?['Hours'] ?? ''),// Hours
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => WorkingHoursTaskUI(
                                                    workingHoursData: dataList![index],
                                                    dateRange: dates,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Utils.getText(employee?['Task'].toString() ?? ''),// Task
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: () {
                                                ReasonTopNotificationPopup.show(
                                                  context,
                                                  dataList: employee?['list'],
                                                  userName: "${employee?['first_name']} ${employee?['last_name']}",
                                                  taskComments: state.comments,
                                                  selectedDateRange: state.selectedDateRange.toString(),
                                                  hrmId: employee?['hrm_id'],
                                                  startDate: startDate,
                                                  endDate: endDate,
                                                );
                                              },
                                              child: Utils.getText(employee?['#'].toString() ?? ''),//#
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                              },
                            );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          )

        ),
      ),
    );
  }
}

