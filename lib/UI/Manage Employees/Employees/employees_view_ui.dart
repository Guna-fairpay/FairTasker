import 'package:fairpytasker/Bloc/employee_bloc.dart';
import 'package:fairpytasker/Event/employee_event.dart';
import 'package:fairpytasker/State/employee_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Component/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  String? userId;

  @override
  void initState() {
    super.initState();
    employeeBloc = EmployeeBloc();
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
    final newEmployees = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const EmployeesAddUI()),
    );

    if (newEmployees != null) {
      employeeBloc.add(
        AddEmployeeData(
            id: newEmployees['id'],
            firstname: newEmployees['first_name'],
            lastname: newEmployees['last_name'],
            email: newEmployees['email'],
            password: newEmployees['password'],
            phone: newEmployees['phone'],
            department: newEmployees['departments'],
            role: newEmployees['role']),
      );
      employeeBloc.add(const GetEmployeeData());
      Utils.showMobileToast('Employee Added Successfully!');
    }
  }

  void _navigateToEmployeeEditUI(int index) async {
    final updatedEmployee = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeesEditUI(
          employees: filteredEmployees[index],
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
    final confirmed = await Utils.showCustomDeleteDialog(context,'User?');
    if (confirmed == true) {
      final delete = employees[index];
      employeeBloc.add(DeleteEmployeeData(id: delete['id'].toString()));
      employeeBloc.add(const GetEmployeeData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Employees List'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: ()=>Navigator.pop(context))
        ],
      ),
      body: BlocProvider(
        create: (context) => employeeBloc..add(const GetEmployeeData()),
        child: BlocConsumer<EmployeeBloc, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeLoading) {
              EasyLoading.show();
            } else {
              if(EasyLoading.isShow)EasyLoading.dismiss();
              if (state is EmployeeListLoaded) {
                employees.clear();
                employees.addAll(state.data ?? []);
                filteredEmployees.addAll(state.data ?? []);
                filteredEmployees = List.from(state.data ?? []);
              } else if (state is EmployeeLoaded) {
                employees.clear();
                employeeBloc.add(const GetEmployeeData());
              } else {
                employeeBloc.add(const GetEmployeeData());
              }
            }
          },
          builder: (context, state) {
            return SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Utils.getSearchBarUI(onChange: _filterEmployees, searchController: searchController),
                      ),
                      const SizedBox(width: 8),
                      if (userRole == 'Admin' || userId == '3')
                        Utils.getAddElevatedButton(()=> _navigateToEmployeeAddUI(),),
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
                              if (userRole == 'Admin' || userId == '3')
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
                              if (userRole == 'Admin' || userId == '3') {
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
            );
          },
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
