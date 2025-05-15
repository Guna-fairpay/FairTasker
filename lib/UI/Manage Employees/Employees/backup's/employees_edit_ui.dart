// import 'package:fairpytasker/Bloc/department_bloc.dart';
// import 'package:fairpytasker/Bloc/roles_bloc.dart';
// import 'package:fairpytasker/Event/department_event.dart';
// import 'package:fairpytasker/Event/roles_event.dart';
// import 'package:fairpytasker/State/department_state.dart';
// import 'package:fairpytasker/State/roles_state.dart';
// import 'package:fairpytasker/core/app/extension/sized_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import '../../../Bloc/employee_bloc.dart';
// import '../../../Component/drawer_ui.dart';
// import '../../../Component/header.dart';
// import '../../../Event/employee_event.dart';
// import '../../../State/employee_state.dart';
// import '../../../Utilities/appC.dart';
// import '../../../Utilities/utils.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class EmployeesEditUI extends StatefulWidget {
//   final Map<String, dynamic> employees;
//
//   const EmployeesEditUI({
//     super.key,
//     required this.employees,
//   });
//
//   @override
//   State<EmployeesEditUI> createState() => _EmployeesEditUIState();
// }
//
// class _EmployeesEditUIState extends State<EmployeesEditUI> {
//
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final EmployeeBloc employeeBloc = EmployeeBloc();
//   List<Map<String, dynamic>> rolesDropdownList = [];
//   List<Map<String, dynamic>> departmentDropdownList = [];
//   Map<String, dynamic>? employeeDetails={};
//   TextEditingController firstnameController = TextEditingController();
//   TextEditingController lastnameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   dynamic selectedRole;
//   dynamic selectedDepartment;
//
//   @override
//   void initState() {
//     super.initState();
//     employeeBloc.add(const GetEmployeeDepartmentData());
//     employeeBloc.add(GetEditEmployeeData(id: widget.employees['id']));
//
//   }
//
//   void _save() {
//
//     if (!formKey.currentState!.validate()) {
//       return;
//     }
//     final updatedEmployees = {
//       'id': widget.employees['id'],
//       'first_name': firstnameController.text,
//       'last_name': lastnameController.text,
//       'email': emailController.text,
//       'phone': mobileController.text,
//       'role': selectedRole['id'],
//       'departments': selectedDepartment['id'].toString(),
//     };
//     Navigator.pop(context, updatedEmployees);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: AppC.appColor,
//         automaticallyImplyLeading: false,
//         title: const Text('Edit Employee'),
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//               icon: const Icon(Icons.close),
//               onPressed: () => Navigator.pop(context))
//         ],
//       ),
//       body: BlocProvider(
//         create: (context) => employeeBloc,
//         child: BlocConsumer<EmployeeBloc, EmployeeState>(
//             listener: (context, state) {
//           if (state is EmployeeLoading) {
//             EasyLoading.show();
//           } else {
//             if (EasyLoading.isShow) EasyLoading.dismiss();
//             if (state is EmployeeDepartmentLoaded) {
//               departmentDropdownList.clear();
//               departmentDropdownList.addAll(state.data ?? []);
//             } else if (state is EditEmployeeListLoaded) {
//               rolesDropdownList.clear();
//               employeeDetails?.clear();
//               rolesDropdownList.addAll(state.role??[]);
//               employeeDetails = state.user;
//               firstnameController.text =employeeDetails?['first_name'] ?? '';
//               lastnameController.text = employeeDetails?['last_name'] ?? '';
//               emailController.text = employeeDetails?['email'] ?? '';
//               mobileController.text = employeeDetails?['phone'] ?? '';
//               selectedRole = rolesDropdownList.firstWhere(
//                     (value)=>value['id']==employeeDetails!['role']['id'],
//                 orElse: () =>{},
//               );
//               selectedDepartment = departmentDropdownList.firstWhere(
//                     (value)=>value['id']==employeeDetails!['departments']['id'],);
//             } else {
//               employeeBloc.add(const GetEmployeeData());
//             }
//           }
//         }, builder: (context, state) {
//           return SafeArea(
//             minimum: 15.padding,
//             child: Form(
//               key: formKey,
//               child: ListView(
//                 children: [
//                   Utils.getTextFormField(
//                     'First Name',
//                     firstnameController,
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val) =>val!.isEmpty? 'Enter First Name':null,
//                   ),
//                   const SizedBox(height: 10,),
//                   Utils.getTextFormField(
//                     'Last Name',
//                     lastnameController,
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val)=>val!.isEmpty? 'Enter Last Name':null,
//                   ),
//                   const SizedBox(height: 10,),
//                   Utils.getTextFormField(
//                     'Mobile',
//                     mobileController,
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val)=>val!.isEmpty? 'Enter Mobile':null,
//                   ),
//                   const SizedBox(height: 10,),
//                   Utils.getTextFormField(
//                     'Email',
//                     emailController,
//                   autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val)=>val!.isEmpty? 'Enter Email':null,
//                     inputAction: TextInputAction.done,
//                   ),
//                   const SizedBox(height: 10,),
//                   Utils.dropdownBox('Select a role', rolesDropdownList,
//                           (selectedValue) {
//                     setState(() {
//                       selectedRole = selectedValue;
//                     });
//                   },
//                       initialSelection: selectedRole,
//                       labelKey: 'name'),
//                   const SizedBox(height: 10,),
//                   Utils.dropdownBox('Select a department', departmentDropdownList,
//                       (selectedValue) {
//                     setState(() {
//                       selectedDepartment = selectedValue;
//                     });
//                   },
//                       initialSelection: selectedDepartment,
//                       labelKey: 'name'),
//                   const SizedBox(height: 10,),
//                   Utils.getElevatedButton(_save,
//                       text: 'Update',),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
