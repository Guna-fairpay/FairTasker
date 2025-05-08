
import 'dart:developer';

import 'package:fairpytasker/Bloc/leave_management_bloc.dart';
import 'package:fairpytasker/Event/leave_management_event.dart';
import 'package:fairpytasker/State/leave_management_state.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/str.dart';
import '../../../Utilities/utils.dart';
import 'leave_management_add_ui.dart';
import 'leave_management_edit_ui.dart';
import 'leave_verification_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LeaveManagementViewUI extends StatefulWidget {
  const LeaveManagementViewUI({super.key});

  @override
  State<LeaveManagementViewUI> createState() => _LeaveManagementViewUIState();
}

class _LeaveManagementViewUIState extends State<LeaveManagementViewUI> {

  late LeaveManagementBloc leaveManagementBloc;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> employeesList = [];
  List<Map<String, dynamic>> filteredLeaveList = [];
  List<Map<String, dynamic>> leaveManagementList = [];

  List<Map<String, dynamic>> filter = [];
  dynamic selectedName;
  String? userRole;
  String? userId;
  int? hrmId;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    leaveManagementBloc = LeaveManagementBloc();
    filteredLeaveList = List.from(leaveManagementList);
    leaveManagementBloc.add(const GetLeaveManagementEmployeeListData());
    Utils.getStringListPreference(Str.rolePrefText).then((role) {
      setState(() {
        userRole = role.first;
      });
    });
    Utils.getStringPreference(Str.userIdPrefText).then((id) {
      setState(() {
        userId = id;
      });
    });
    Utils.getIntPreference(Str.hrmIdPrefText).then((id) {
      setState(() {
        print('hrmId1 $id');
        hrmId = id;
      });
    });

    employeesList.insert(0, {'id': -1, 'first_name': 'All', 'last_name': ''});
    selectedName = employeesList[0];
  }

  void _filterEmployees(String query) {
    setState(() {
      filteredLeaveList = leaveManagementList.where((leave) {
        final employee = employeesList.firstWhere(
          (emp) => emp['id'] == leave['user']['employee_id'],
          orElse: () => {},
        );
        final firstName = employee['first_name'] ?? '';
        final lastName = employee['last_name'] ?? '';
        final fullName = '$firstName $lastName'.trim().toLowerCase();
        final selectedFirstName = selectedName?['first_name'] ?? '';
        final selectedLastName = selectedName?['last_name'] ?? '';
        final selectedFullName =
            '$selectedFirstName $selectedLastName'.trim().toLowerCase();

        final matchesFilter = selectedName == null ||
            selectedName['id'] == -1 ||
            fullName == selectedFullName;
        final matchesQuery = query.isEmpty ||
            fullName.contains(query.toLowerCase()) ||
            (leave['leave_type']?['code']?.toLowerCase() ?? '')
                .contains(query.toLowerCase()) ||
            (leave['reason']?.toLowerCase() ?? '')
                .contains(query.toLowerCase());
        return matchesFilter && matchesQuery;
      }).toList();
    });
  }

  void _onFilterChanged(dynamic value) {
    setState(() {
      selectedName = value;
      _filterEmployees(searchController.text);
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _navigateToLeaveManagementAddUI() async {
    final newLeave = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const LeaveManagementAddUI()),
    );
    if (newLeave != null) {
      leaveManagementBloc.add(AddLeaveManagementData(
          leaveTypeId:newLeave['leave_type_id'],
          leaveDuration: newLeave['leave_duration'],
          startDate: newLeave['start_date'],
          endDate: newLeave['end_date'],
          reason: newLeave['reason'],
          startTime: newLeave['start_time'],
          endTime: newLeave['end_time'],
          status: newLeave['status']??'',
          userId: hrmId,
          id: newLeave['id']));
      leaveManagementBloc.add(const GetLeaveManagementEmployeeListData());
    }
  }

  void _navigateToLeaveManagementEditUI(int index) async {
    final updatedLeave = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LeaveManagementEditUI(leave: filteredLeaveList[index]),
      ),
    );

    if (updatedLeave != null) {
     // print(updatedLeave);
      leaveManagementBloc.add(AddLeaveManagementData(
          leaveTypeId:updatedLeave['leave_type_id'],
          leaveDuration: updatedLeave['leave_duration'],
          startDate: updatedLeave['start_date'],
          endDate: updatedLeave['end_date'],
          reason: updatedLeave['reason'],
          startTime: updatedLeave['start_time'],
          endTime: updatedLeave['end_time'],
          status: updatedLeave['status']??'',
          userId: hrmId,
          id: int.tryParse(updatedLeave['id'])
      )
      );
      leaveManagementBloc.add(const GetLeaveManagementEmployeeListData());
    }
  }

  void _navigateToLeaveVerificationUI(int index) async {
    final verifiedLeaves = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LeaveVerificationUI(leave: filteredLeaveList[index])),
    );
    if (verifiedLeaves != null) {
      leaveManagementBloc.add(ApplyLeaveEvent(
        id: verifiedLeaves['id'],
        status: verifiedLeaves['status'],
        reason: verifiedLeaves['reason'],
      ));
      leaveManagementBloc.add(const GetLeaveManagementEmployeeListData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title: const Text('Leave Management'),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp),
        foregroundColor: Colors.white,
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: ()=> Navigator.pop(context),
              icon: const Icon(Icons.close))
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            leaveManagementBloc..add(const GetLeaveManagementData()),
        child: BlocConsumer<LeaveManagementBloc, LeaveManagementState>(
            listener: (context, state) async {
          if (state is LeaveManagementLoading) {
            EasyLoading.show();
          } else {
            if(EasyLoading.isShow)EasyLoading.dismiss();
            if (state is LeaveManagementListLoaded) {
              leaveManagementList.clear();
              leaveManagementList.addAll(state.data ?? []);
              filteredLeaveList.addAll(state.data ?? []);
              filteredLeaveList = List.from(state.data ?? []);
            } else if (state is LeaveManagementEmployeeListLoaded) {
              employeesList.clear();
              employeesList.addAll(state.data ?? []);
              employeesList.insert(0, {'id': -1, 'first_name': 'All'});
              selectedName = employeesList[0];
            }
            else if(state is LeaveManagementLoaded){
              Utils.showMobileToast(state.message??'');
              leaveManagementBloc.add(const GetLeaveManagementData());
            }
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userRole == 'Admin' || userId == '3')
                  const SizedBox(
                    height: 5,
                  ),
                if (userRole == 'Admin' || userId == '3')
                  Utils.dropdownBox('Select Employee',
                      employeesList, (value){
                        setState(() {
                          _onFilterChanged(value);
                        });
                      }, labelKey: 'first_name',
                    labelKey2: 'last_name',
                    initialSelection: selectedName,
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Utils.getSearchBarUI(
                        onChange: (value) {
                          _filterEmployees(value);
                        },
                        searchController: searchController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Utils.getAddElevatedButton(
                          ()=>_navigateToLeaveManagementAddUI(),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(height: 0.5),
                    itemCount: filteredLeaveList.length,
                    itemBuilder: (context, index) {
                      final leave = filteredLeaveList[index];
                      final matchingEmployee = employeesList.firstWhere(
                            (employee) => employee['id'] == leave['user']['employee_id'],
                        orElse: () => {},
                      );
                      final firstName = matchingEmployee['first_name'] ?? '';
                      final lastName = matchingEmployee['last_name'] ?? '';
                      final name = '$firstName $lastName';

                      DateTime startDate = DateTime.parse(leave['start_date']);
                      DateTime endDate = DateTime.parse(leave['end_date']);
                      Duration difference = endDate.difference(startDate);
                      Duration extendedDuration = difference + const Duration(days: 1);
                      String formattedStartDate = DateFormat('MMM-dd-yy').format(startDate);
                      String formattedEndDate = DateFormat('MMM-dd-yy').format(endDate);
                      bool canDismiss = (userRole == 'Admin' || userId == '3');

                      Widget listItem = InkWell(
                        onTap: () => _navigateToLeaveManagementEditUI(index),
                        child: SafeArea(
                          minimum: 5.padding,
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Utils.getText(
                                      name,
                                      overFlow: TextOverflow.ellipsis,
                                      weight: FontWeight.bold,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 5,
                                      children: [
                                        Column(
                                          children: [
                                            OutlinedDotIndicator(
                                              size: 6,
                                              color: Colors.grey.shade300,
                                            ),
                                            SizedBox(
                                              height: 20,
                                              width: 1,
                                              child: DecoratedLineConnector(
                                                space: 5,
                                                direction: Axis.vertical,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                            ),
                                            DotIndicator(
                                              size: 6,
                                              position: 0.2,
                                              color: Colors.grey.shade300,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          spacing: 5,
                                          children: [
                                            Row(spacing: 10, children: [
                                              Icon(Icons.calendar_month, size: 15, color: Colors.grey.shade500),
                                              Utils.getText(formattedStartDate),
                                            ]),
                                            Row(spacing: 10, children: [
                                              Icon(Icons.calendar_month, size: 15, color: Colors.grey.shade500),
                                              Utils.getText(formattedEndDate),
                                            ]),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Utils.getText(
                                        '${extendedDuration.inDays} ${extendedDuration.inDays == 1 ? "Day" : "Days"}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Utils.getText(
                                      leave['leave_type']['name'] ?? '',
                                      color: AppC.subText,
                                      overFlow: TextOverflow.ellipsis,
                                    ),
                                    Utils.getText(
                                      leave['reason'] ?? 'No Reason Provided',
                                      color: AppC.subText,
                                      overFlow: TextOverflow.ellipsis,
                                    ),
                                    if (leave['status'] == 'Pending')
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                        decoration: BoxDecoration(
                                          color:AppC.blue,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Utils.getText(
                                          'Pending',
                                          color: AppC.white,
                                          weight: FontWeight.bold,
                                        ),
                                      )
                                    // const Icon(Icons.hourglass_bottom, size: 12, color: Colors.blue)
                                    else if (leave['status'] == 'Approved')
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                        decoration: BoxDecoration(
                                          color:AppC.green,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Utils.getText(
                                          'Approved',
                                          color: AppC.white,
                                          weight: FontWeight.bold,
                                        ),
                                      )
                                    //const Icon(Icons.thumb_up_off_alt_rounded, size: 12, color: Colors.green)
                                    else if (leave['status'] == 'Rejected')
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                          decoration: BoxDecoration(
                                            color:AppC.redAccent,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Utils.getText(
                                            'Rejected',
                                            color: AppC.white,
                                            weight: FontWeight.bold,
                                          ),
                                        )
                                    // const Icon(Icons.thumb_down, size: 12, color: Colors.redAccent),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      return canDismiss
                          ? Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.green.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.verified_outlined, color: AppC.white),
                                Utils.getText('Verification', color: AppC.white),
                              ],
                            ),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          Future.microtask(() => _navigateToLeaveVerificationUI(index));
                          return false;
                        },
                        child: listItem,
                      ) : listItem;
                    },
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
