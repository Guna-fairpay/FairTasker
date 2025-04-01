import 'package:fairpytasker/Bloc/leave_management_bloc.dart';
import 'package:fairpytasker/Event/leave_management_event.dart';
import 'package:fairpytasker/State/leave_management_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/num.dart';
import '../../Utilities/str.dart';
import '../../Utilities/utils.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.unfocus();
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

    if (newLeave != null) {}
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
      setState(() {
        employeesList[index] = updatedLeave;
        _filterEmployees(searchController.text);
      });
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
      setState(() {
        employeesList[index] = verifiedLeaves;
        _filterEmployees(searchController.text); // Update filtered list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) =>
            leaveManagementBloc..add(const GetLeaveManagementData()),
        child: BlocConsumer<LeaveManagementBloc, LeaveManagementState>(
            listener: (context, state) async {
          if (state is LeaveManagementLoading) {
            loading = true;
          } else if (state is LeaveManagementListLoaded) {
            loading = false;
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
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              size: 16,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Utils.getText('Leave Management',
                            size: 16, weight: FontWeight.bold),
                      ],
                    ),
                    if (userRole == 'Admin')
                      const SizedBox(
                        height: 5,
                      ),
                    if (userRole == 'Admin')
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppC.fieldBase,
                              width: Num.borderWidthField,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton))),
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: AppC.appColor,
                                  size: 14,
                                ),
                              ),
                            ),
                            DropdownMenu<Map<String, dynamic>>(
                              menuHeight: 250,
                              initialSelection: selectedName,
                              trailingIcon: const Icon(
                                Icons.add,
                                size: 12,
                                color: AppC.trans,
                              ),
                              selectedTrailingIcon: const Icon(
                                Icons.add,
                                size: 12,
                                color: AppC.trans,
                              ),
                              textStyle: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              inputDecorationTheme: const InputDecorationTheme(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                isDense: true,
                                iconColor: AppC.trans,
                              ),
                              menuStyle: MenuStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.white),
                                shadowColor:
                                    WidgetStateProperty.all<Color>(Colors.blue),
                                surfaceTintColor:
                                    WidgetStateProperty.all<Color>(Colors.blue),
                                visualDensity: const VisualDensity(
                                    vertical: VisualDensity.minimumDensity),
                              ),
                              expandedInsets:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              dropdownMenuEntries: employeesList
                                  .map<DropdownMenuEntry<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                                  final employeeName =
                                      '${value['first_name'] ?? ''} ${value['last_name'] ?? ''}';
                                  return DropdownMenuEntry<
                                      Map<String, dynamic>>(
                                    value: value,
                                    label:
                                        employeeName, // Replace with your widget
                                  );
                                },
                              ).toList(),
                              onSelected: (selectedValue) {
                                setState(() {
                                  _onFilterChanged(selectedValue);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Utils.getSearchBarUI(
                            () {},
                            (value) {
                              _filterEmployees(value);
                            },
                            searchController,
                            searchFocusNode,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 30,
                          child: Utils.getAddFilledButton(
                            '+ Apply',
                            () {
                              _navigateToLeaveManagementAddUI();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredLeaveList.length,
                        itemBuilder: (context, index) {
                          final leave = filteredLeaveList[index];

                          // Find the corresponding employee in employeesList
                          final matchingEmployee = employeesList.firstWhere(
                            (employee) =>
                                employee['id'] == leave['user']['employee_id'],
                            orElse: () => {}, // Default value
                          );

                          // Safely construct the employee name
                          final firstName =
                              matchingEmployee['first_name'] ?? '';
                          final lastName = matchingEmployee['last_name'] ?? '';
                          final name = '$firstName $lastName';

                          // Leave date and duration calculations
                          DateTime startDate =
                              DateTime.parse(leave['start_date']);
                          DateTime endDate = DateTime.parse(leave['end_date']);
                          Duration difference = endDate.difference(startDate);
                          Duration extendedDuration =
                              difference + const Duration(days: 1);

                          String formattedStartDate =
                              DateFormat('MM-dd-yy').format(startDate);
                          String formattedEndDate =
                              DateFormat('MM-dd-yy').format(endDate);
                          String leaveDuration =
                              "$formattedStartDate to $formattedEndDate";

                          return Stack(
                            children: [
                              if (userRole == 'Admin')
                                Slidable(
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) =>
                                            _navigateToLeaveVerificationUI(
                                                index),
                                        backgroundColor: AppC.white,
                                        foregroundColor: AppC.green,
                                        icon: Icons.check_circle_outline,
                                        label: 'Verification',
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _navigateToLeaveManagementEditUI(index);
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      color: AppC.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Row for Name and Type
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Utils.getText(
                                                    name,
                                                    weight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: AppC.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: Utils.getText(
                                                      '${extendedDuration.inDays} ${extendedDuration.inDays == 1 ? "Day" : "Days"}',
                                                      size: 12,
                                                      color: AppC.white,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Utils.getText(
                                                  leave['leave_type']['code'] ??
                                                      '',
                                                  color: AppC.subText,
                                                ),
                                                const SizedBox(width: 10),
                                                if (leave['status'] ==
                                                    'Pending') ...[
                                                  const Icon(
                                                      Icons.hourglass_bottom,
                                                      size: 12,
                                                      color: Colors.blue),
                                                ] else if (leave['status'] ==
                                                    'Approved') ...[
                                                  const Icon(
                                                      Icons
                                                          .thumb_up_off_alt_rounded,
                                                      size: 12,
                                                      color: Colors.green),
                                                ] else if (leave['status'] ==
                                                    'Rejected') ...[
                                                  const Icon(Icons.thumb_down,
                                                      size: 12,
                                                      color: Colors.redAccent),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Utils.getText(
                                                  leaveDuration,
                                                  color: AppC.appColor,
                                                ),
                                                const SizedBox(width: 30),
                                                Flexible(
                                                  child: Utils.getText(
                                                    leave['reason'] ??
                                                        'No Reason Provided',
                                                    color: AppC.subText,
                                                    overFlow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: loading,
                child: Center(child: Utils.getProgressIndicator(context)),
              ),
            ],
          );
        }),
      ),
      drawer: const DrawerView(),
    );
  }
}
