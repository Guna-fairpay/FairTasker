//
// import 'package:fairpytasker/State/employee_state.dart';
// import 'package:fairpytasker/core/app/extension/sized_extension.dart';
// import 'package:fairpytasker/core/app/helper/toaster.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import '../../../Bloc/employee_bloc.dart';
// import '../../../Event/employee_event.dart';
// import '../../../Utilities/appC.dart';
// import '../../../Utilities/utils.dart';
//
// class EmployeesAddUI extends StatefulWidget {
//   const EmployeesAddUI({super.key});
//
//   @override
//   State<EmployeesAddUI> createState() => _EmployeesAddUIState();
// }
//
// class _EmployeesAddUIState extends State<EmployeesAddUI> {
//
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final EmployeeBloc employeeBloc = EmployeeBloc();
//   bool showPassword = true;
//   List<Map<String, dynamic>> rolesDropdownList = [];
//   List<Map<String, dynamic>> departmentDropdownList = [];
//   TextEditingController firstnameController = TextEditingController();
//   TextEditingController lastnameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   dynamic selectedRole;
//   dynamic selectedDepartment;
//
//
//   @override
//   void initState() {
//     super.initState();
//     employeeBloc.add(const GetEmployeeDepartmentData());
//     employeeBloc.add(const GetEmployeeRoleData());
//   }
//
//   void _save() {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }
//     if (firstnameController.text.isEmpty ||
//         lastnameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         mobileController.text.isEmpty ||
//         passwordController.text.isEmpty ||
//         selectedRole == null) {
//       if(selectedRole == null){
//         Toaster.showError('Please select role');
//       }
//       return ;
//     }
//
//     final newEmployee = {
//       'first_name': firstnameController.text,
//       'last_name': lastnameController.text,
//       'email': emailController.text,
//       'phone': mobileController.text,
//       'password': passwordController.text,
//       'role': selectedRole['id'].toString(),
//       'departments': selectedDepartment['id'].toString(),
//     };
//     Navigator.pop(context, newEmployee);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: AppC.appColor,
//         automaticallyImplyLeading: false,
//         title: const Text('Add Employee'),
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
//               if (state is EmployeeLoading) {
//                 EasyLoading.show();
//               } else {
//                 if (EasyLoading.isShow) EasyLoading.dismiss();
//                 if (state is EmployeeDepartmentLoaded) {
//                   departmentDropdownList.clear();
//                   departmentDropdownList.addAll(state.data ?? []);
//                 } else if (state is EmployeeRoleLoaded) {
//                   rolesDropdownList.clear();
//                   rolesDropdownList.addAll(state.data??[]);
//                 }
//               }
//             }, builder: (context, state) {
//           return SafeArea(
//             minimum: 15.padding,
//             child: Form(
//               key: formKey,
//               child: ListView(
//                 children: [
//                   Utils.getTextFormField(
//                       'First Name', firstnameController,
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val)=>val!.isEmpty? 'Enter First Name':null,
//                      ),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                       'Last Name', lastnameController,
//                      autoValidate: AutovalidateMode.onUserInteraction,
//                   validator: (val)=>val!.isEmpty? 'Enter Last Name':null,),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                       'Mobile Number', mobileController,
//                       autoValidate: AutovalidateMode.onUserInteraction,
//                       validator: (val)=>val!.isEmpty? 'Enter Mobile':null,
//                       textType: TextInputType.phone),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                       'Email', emailController,
//                       autoValidate: AutovalidateMode.onUserInteraction,
//                       validator: (val)=>val!.isEmpty? 'Enter Email':null,
//                       textType: TextInputType.emailAddress),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                     'Password',
//                     passwordController,
//                     hintTextColor: AppC.fieldBase,
//                     obscure: showPassword,
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val)=>val!.isEmpty? 'Enter Password':null,
//                     inputAction: TextInputAction.done,
//                     suffixIcon: InkWell(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                           child: Icon(
//                             showPassword
//                                 ? Icons.visibility_off_outlined
//                                 : Icons.remove_red_eye_outlined,
//                           ),
//                         ),
//                         onTap: () {
//                           showPassword = !showPassword;
//                           setState(() {});
//                         }),
//                   ),
//                   const SizedBox(height: 10),
//                   Utils.dropdownBox('Select Role', rolesDropdownList,
//                           (selectedValue) {
//                         setState(() {
//                           selectedRole = selectedValue;
//                         });
//                       }, labelKey: 'name'),
//                   const SizedBox(height: 10),
//                   Utils.dropdownBox(
//                       'Select Department', departmentDropdownList,
//                           (selectedValue) {
//                         setState(() {
//                           selectedDepartment = selectedValue;
//                         });
//                       }, labelKey: 'name'),
//                   const SizedBox(height: 15),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       SizedBox(
//                         height: 30,
//                         child: Utils.getAddFilledButton(
//                           'Save',
//                               () {
//                             _save();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
//
