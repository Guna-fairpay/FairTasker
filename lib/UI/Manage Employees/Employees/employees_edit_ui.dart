import 'package:fairpytasker/Bloc/department_bloc.dart';
import 'package:fairpytasker/Bloc/roles_bloc.dart';
import 'package:fairpytasker/Event/department_event.dart';
import 'package:fairpytasker/Event/roles_event.dart';
import 'package:fairpytasker/State/department_state.dart';
import 'package:fairpytasker/State/roles_state.dart';
import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesEditUI extends StatefulWidget {
  final Map<String, dynamic> employees;

  const EmployeesEditUI({
    super.key,
    required this.employees,
  });

  @override
  State<EmployeesEditUI> createState() => _EmployeesEditUIState();
}

class _EmployeesEditUIState extends State<EmployeesEditUI> {
  late DepartmentBloc departmentBloc;
  late RolesBloc rolesBloc;
  List<Map<String, dynamic>> rolesDropdownList = [];
  List<Map<String, dynamic>> departmentDropdownList = [];
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  dynamic selectedRole;
  dynamic selectedDepartment;
  bool isFirstNameFieldEmpty = false;
  bool isLastNameFieldEmpty = false;
  bool isMobileFieldEmpty = false;
  bool isEmailFieldEmpty = false;
  bool isPasswordFieldEmpty = false;
  bool isSelectedRoleFieldEmpty = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    departmentBloc = DepartmentBloc();
    rolesBloc = RolesBloc();
    departmentBloc.add(const GetDepartmentData());
    rolesBloc.add(const GetRolesData());
    firstnameController.text = widget.employees['first_name'] ?? '';
    lastnameController.text = widget.employees['last_name'] ?? '';
    emailController.text = widget.employees['email'] ?? '';
    mobileController.text = widget.employees['phone'] ?? '';
  }

  void _save() {
    setState(() {
      isFirstNameFieldEmpty = firstnameController.text.isEmpty;
      isLastNameFieldEmpty = lastnameController.text.isEmpty;
      isMobileFieldEmpty = mobileController.text.isEmpty;
      isEmailFieldEmpty = emailController.text.isEmpty;
      isSelectedRoleFieldEmpty = selectedRole == null;
    });

    final updatedEmployees = {
      'id': widget.employees['id'],
      'first_name': firstnameController.text,
      'last_name': lastnameController.text,
      'email': emailController.text,
      'phone': mobileController.text,
      'role': selectedRole ?? '',
      'departments': selectedDepartment ?? '',
    };
    Navigator.pop(context, updatedEmployees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => rolesBloc..add(const GetRolesData())),
          BlocProvider(
            create: (context) => departmentBloc..add(const GetDepartmentData()),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<RolesBloc, RolesState>(
              listener: (context, state) async {
                if (state is RolesLoading) {
                  setState(() {
                    loading = true;
                  });
                } else if (state is RolesListLoaded) {
                  setState(() {
                    loading = false;
                    rolesDropdownList.clear();
                    rolesDropdownList.addAll(state.data ?? []);
                    selectedRole = rolesDropdownList.firstWhere(
                        (name) =>
                            name['name'] == widget.employees['role']['name'],
                        orElse: () => {});
                    print('---------------------------------------$selectedRole');
                  });
                }
              },
            ),
            BlocListener<DepartmentBloc, DepartmentState>(
              listener: (context, state) async {
                if (state is DepartmentLoading) {
                  setState(() {
                    loading = true;
                  });
                } else if (state is DepartmentListLoaded) {
                  setState(() {
                    loading = false;
                    departmentDropdownList.clear();
                    departmentDropdownList.addAll(state.data ?? []);
                    selectedDepartment = departmentDropdownList.firstWhere(
                        (item) =>
                            item['name'] ==
                            widget.employees['departments']['name'],
                        orElse: () => {});
                  });
                }
              },
            ),
          ],
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
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
                          Utils.getText('Edit Employee',
                              size: 16, weight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                            'First Name',
                            firstnameController,
                            borderColor: isFirstNameFieldEmpty
                                ? Colors.red
                                : AppC.fieldBase,
                          ),
                          if (isFirstNameFieldEmpty)
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child:
                                  Icon(Icons.error_outline, color: Colors.red),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                            'Last Name',
                            lastnameController,
                            borderColor: isLastNameFieldEmpty
                                ? Colors.red
                                : AppC.fieldBase,
                          ),
                          if (isLastNameFieldEmpty)
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child:
                                  Icon(Icons.error_outline, color: Colors.red),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                            'Mobile',
                            mobileController,
                            borderColor: isMobileFieldEmpty
                                ? Colors.red
                                : AppC.fieldBase,
                          ),
                          if (isMobileFieldEmpty)
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child:
                                  Icon(Icons.error_outline, color: Colors.red),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                            'Email',
                            emailController,
                            borderColor:
                                isEmailFieldEmpty ? Colors.red : AppC.fieldBase,
                          ),
                          if (isEmailFieldEmpty)
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child:
                                  Icon(Icons.error_outline, color: Colors.red),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Utils.dropdownBox('', rolesDropdownList, (selectedValue) {
                        setState(() {
                          selectedRole = selectedValue;
                        });
                      }, initialSelection: selectedRole, labelKey: 'name'),
                      const SizedBox(height: 10),
                      Utils.dropdownBox('', departmentDropdownList,
                          (selectedValue) {
                        setState(() {
                          selectedDepartment = selectedValue;
                        });
                      },
                          initialSelection: selectedDepartment,
                          labelKey: 'name'),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 30,
                            child: Utils.getAddFilledButton('Save', _save),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: loading,
                child: Center(child: Utils.getProgressIndicator(context)),
              ),
            ],
          ),
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
