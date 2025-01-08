import 'package:fairpytasker/Event/users_event.dart';
import 'package:fairpytasker/State/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../Bloc/department_bloc.dart';
import '../../../Bloc/users_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';

class DepartmentEditUI extends StatefulWidget {
  final Map<String, dynamic> heads;

  const DepartmentEditUI({super.key, required this.heads});

  @override
  State<DepartmentEditUI> createState() => _DepartmentEditUIState();
}

class _DepartmentEditUIState extends State<DepartmentEditUI> {
  TextEditingController departmentNameController = TextEditingController();
  List<Map<String, dynamic>> dropdownList = [];
  late UsersBloc userBloc;
  late DepartmentBloc departmentBloc;
  String? selectedHead;
  bool isDepartmentNameFieldEmpty = false;
  bool isSelectedHeadFieldEmpty = false;

  @override
  void initState() {
    super.initState();

    departmentBloc = DepartmentBloc();
    userBloc = UsersBloc();
    departmentNameController.text = widget.heads['name'] ?? '';
    if (widget.heads['users'] != null && widget.heads['users']['id'] != null) {
      selectedHead = widget.heads['users']['id'].toString();
    } else {
      selectedHead = null; // Default value if users data is not available
    }
  }

  void _save() {
    setState(() {
      isDepartmentNameFieldEmpty = departmentNameController.text.isEmpty;
      isSelectedHeadFieldEmpty = selectedHead == null;
    });

    if (isDepartmentNameFieldEmpty || isSelectedHeadFieldEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }

    final updateDepartment = {
      'id': widget.heads['id'],
      'name': departmentNameController.text,
      'head': selectedHead ?? '',
    };

    Navigator.of(context).pop(updateDepartment);
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
        create: (context) => userBloc..add(const GetUsersData()),
        child: BlocConsumer<UsersBloc, UsersState>(
          listener: (context, state) async {
            if (state is UsersListLoaded) {
              setState(() {
                dropdownList.clear();
                dropdownList.addAll(state.data ?? []);
              });
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          const SizedBox(width: 10),
                          Utils.getText('Edit Department',
                              size: 20, weight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                              '',
                              departmentNameController,
                              label: Utils.getText('name', color: AppC.grey),
                              borderColor: isDepartmentNameFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isDepartmentNameFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppC.fieldBase,
                              width: Num.borderWidthField),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(Num.subradiusButton)),
                        ),
                        child: DropdownButton<String>(
                          hint: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Utils.getText('Select Category',
                                color: AppC.grey),
                          ),
                          value: selectedHead,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 3,
                          dropdownColor: AppC.white,
                          underline: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedHead = value;
                            });
                          },
                          items: dropdownList.map<DropdownMenuItem<String>>(
                            (value) {
                              return DropdownMenuItem<String>(
                                value: value['id'].toString(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Utils.getText(
                                      '${value['first_name']} ${value['last_name']}'),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 40,
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
            );
          },
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
