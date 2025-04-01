import 'package:fairpytasker/Bloc/employee_bloc.dart';
import 'package:fairpytasker/Event/employee_event.dart';
import 'package:fairpytasker/State/employee_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Component/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Utilities/str.dart';
import 'employees_add_ui.dart';
import 'employees_edit_ui.dart';
import 'package:fairpytasker/Component/drawer_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';

class EmployeesViewUI extends StatefulWidget {
  const EmployeesViewUI({super.key});

  @override
  State<EmployeesViewUI> createState() => _EmployeesViewUIState();
}

class _EmployeesViewUIState extends State<EmployeesViewUI> {
  late EmployeeBloc employeeBloc;
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> filteredEmployees = [];
  bool loading = false;
  String? userRole;

  @override
  void initState() {
    super.initState();
    employeeBloc = EmployeeBloc();
    Utils.getStringListPreference(Str.rolePrefText).then((role) {
      setState(() {
        userRole = role
            .first; // Assuming role is a List<String> and fetching the first value
      });
    });
  }

  void _filterEmployees(String query) {
    setState(() {
      filteredEmployees = employees.where((employee) {
        final firstname = employee['first_name']?.toLowerCase() ?? '';
        final lastname = employee['last_name']?.toLowerCase() ?? '';
        final email = employee['email']?.toLowerCase() ?? '';
        final mobile = employee['phone']?.toLowerCase() ?? '';
        final department = employee['departments']['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return firstname.contains(searchQuery) ||
            lastname.contains(searchQuery) ||
            email.contains(searchQuery) ||
            mobile.contains(searchQuery) ||
            department.contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToEmployeeAddUI() async {
    final newemployees = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const EmployeesAddUI()),
    );

    if (newemployees != null) {
      employeeBloc.add(
        AddEmployeeData(
            id: newemployees['id'],
            firstname: newemployees['first_name'],
            lastname: newemployees['last_name'],
            email: newemployees['email'],
            password: newemployees['password'],
            phone: newemployees['phone'],
            department: newemployees['departments'],
            role: newemployees['role']),
      );
      print('NEW Employee$newemployees');
      employeeBloc.add(const GetEmployeeData());
      Utils.showMobileToast('Employee Added Successfully!');
    }
  }

  void _navigateToEmployeeEditUI(int index) async {
    final updatedEmployee = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeesEditUI(
          employees: employees[index],
        ),
      ),
    );

    if (updatedEmployee != null) {
      employeeBloc.add(
        EditEmployeeData(
            id: updatedEmployee['id'],
            firstname: updatedEmployee['first_name'],
            lastname: updatedEmployee['last_name'],
            email: updatedEmployee['email'],
            phone: updatedEmployee['phone'],
            department: updatedEmployee['departments'],
            role: int.parse(updatedEmployee['role'])),
      );
      employeeBloc.add(const GetEmployeeData());
      Utils.showMobileToast('Employee Updated Successfully');
    }
  }

  Future<void> _deleteEmployee(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final delete = employees[index];
      employeeBloc.add(DeleteEmployeeData(id: delete['id'].toString()));
      employeeBloc.add(const GetEmployeeData());
      Utils.showMobileToast('Deleted');
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content:
            Utils.getText('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm the deletion
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel the deletion
            },
            child: Utils.getText('Cancel'),
          ),
        ],
      ),
    );
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
        create: (context) => employeeBloc..add(const GetEmployeeData()),
        child: BlocConsumer<EmployeeBloc, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeLoading) {
              loading = true;
            } else if (state is EmployeeListLoaded) {
              loading = false;
              employees.clear();
              employees.addAll(state.data ?? []);
              filteredEmployees.addAll(state.data ?? []);
              filteredEmployees = List.from(state.data ?? []);
            } else if (state is EmployeeLoaded) {
              loading = false;
              employees.clear();
              employeeBloc.add(const GetEmployeeData());
            } else {
              employeeBloc.add(const GetEmployeeData());
              loading = true;
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back, size: 16)),
                          const SizedBox(
                            width: 10,
                          ),
                          Utils.getText('Employees List',
                              size: 16, weight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Utils.getSearchBarUI(() {}, (value) {
                              _filterEmployees(value);
                            }, searchController, searchFocusNode),
                          ),
                          const SizedBox(width: 8),
                          if (userRole == 'Admin')
                            SizedBox(
                              height: 30,
                              child: Utils.getAddFilledButton('Add', () {
                                _navigateToEmployeeAddUI();
                              }),
                            ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredEmployees.length,
                          itemBuilder: (_, index) {
                            final employee = filteredEmployees[index];
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  if (userRole == 'Admin')
                                    SlidableAction(
                                      onPressed: (context) =>
                                          _deleteEmployee(index),
                                      backgroundColor: AppC.white,
                                      foregroundColor: AppC.red,
                                      icon: Icons.delete_outline,
                                      label: 'Delete',
                                    ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (userRole == 'Admin') {
                                    _navigateToEmployeeEditUI(index);
                                  }
                                },
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  color: AppC.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Utils.getText(
                                                  '${employee['first_name'] ?? ''}'
                                                  ' ${employee['last_name'] ?? ''}',
                                                  weight: FontWeight.bold,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Utils.getText(
                                                    '${employee['departments']['name'] ?? ''}',
                                                    weight: FontWeight.bold,
                                                    color: AppC.subText,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                        // SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Utils.getText(
                                                  '${employee['email'] ?? ''}',
                                                  weight: FontWeight.bold,
                                                  color: AppC.appColor),
                                            ),
                                            Utils.getText(
                                              '${employee['phone'] ?? ''}',
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            );
          },
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
