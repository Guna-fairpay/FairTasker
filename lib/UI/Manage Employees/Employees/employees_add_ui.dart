import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../Bloc/department_bloc.dart';
import '../../../Bloc/roles_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Event/department_event.dart';
import '../../../Event/roles_event.dart';
import '../../../State/department_state.dart';
import '../../../State/roles_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class EmployeesAddUI extends StatefulWidget {
  const EmployeesAddUI({super.key});

  @override
  State<EmployeesAddUI> createState() => _EmployeesAddUIState();
}

class _EmployeesAddUIState extends State<EmployeesAddUI> {
  late DepartmentBloc departmentBloc;
  late RolesBloc rolesBloc;
  bool showPassword = true;
  List<Map<String, dynamic>> rolesDropdownList = [];
  List<Map<String, dynamic>> departmentDropdownList = [];
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  String? selectedDepartment;
  bool isFirstNameFieldEmpty = false;
  bool isLastNameFieldEmpty = false;
  bool isMobileFieldEmpty = false;
  bool isEmailFieldEmpty = false;
  bool isPasswordFieldEmpty = false;
  bool isSelectedRoleFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    departmentBloc = DepartmentBloc();
    rolesBloc = RolesBloc();
    departmentBloc.add(const GetDepartmentData());
    rolesBloc.add(const GetRolesData());
  }

  void _save() {
    if (firstnameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedDepartment == null ||
        selectedRole == null) {
      return Utils.showMobileToast('Please fill in all required fields');
    }

    final newEmployee = {
      'first_name': firstnameController.text,
      'last_name': lastnameController.text,
      'email': emailController.text,
      'phone': mobileController.text,
      'password': passwordController.text,
      'role': selectedRole ?? '',
      'departments': selectedDepartment ?? '',
    };
    Navigator.pop(context, newEmployee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Add Employee'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: ()=>Navigator.pop(context))
        ],
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
                if (state is RolesListLoaded) {
                  setState(() {
                    rolesDropdownList.clear();
                    rolesDropdownList.addAll(state.data ?? []);
                  });
                }
              },
            ),
            BlocListener<DepartmentBloc, DepartmentState>(
              listener: (context, state) async {
                if (state is DepartmentListLoaded) {
                  setState(() {
                    departmentDropdownList.clear();
                    departmentDropdownList.addAll(state.data ?? []);
                  });
                }
              },
            ),
          ],
          child: ListView(
            children: [
              SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Utils.getTextFormField(
                        '', firstnameController,
                        label: Utils.getText('First Name', color: AppC.grey)),
                    const SizedBox(height: 10),
                    Utils.getTextFormField(
                        '', lastnameController,
                        label: Utils.getText('Last Name', color: AppC.grey)),
                    const SizedBox(height: 10),
                    Utils.getTextFormField(
                        '', mobileController,
                        label: Utils.getText('Mobile No', color: AppC.grey),
                        textType: TextInputType.phone),
                    const SizedBox(height: 10),
                    Utils.getTextFormField(
                        '', emailController,
                        label: Utils.getText('Email', color: AppC.grey),
                        textType: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    Utils.getTextFormField(
                      'Password',
                      passwordController,
                      hintTextColor: AppC.fieldBase,
                      obscure: showPassword,
                      suffixIcon: InkWell(
                          child: Icon(
                            showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.remove_red_eye_outlined,
                          ),
                          onTap: () {
                            showPassword = !showPassword;
                            setState(() {});
                          }),
                    ),
                    const SizedBox(height: 10),
                    Utils.dropdownBox('Select Role', rolesDropdownList,
                        (selectedValue) {
                      setState(() {
                        selectedRole = selectedValue;
                      });
                    }, labelKey: 'name'),
                    const SizedBox(height: 10),
                    Utils.dropdownBox(
                        'Select Department', departmentDropdownList,
                        (selectedValue) {
                      setState(() {
                        selectedDepartment = selectedValue;
                      });
                    }, labelKey: 'name'),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Utils.getAddFilledButton(
                            'Save',
                            () {
                              _save();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
