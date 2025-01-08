import 'package:flutter/material.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';

class UserAddUI extends StatefulWidget {
  const UserAddUI({super.key});

  @override
  State<UserAddUI> createState() => _UserAddUIState();
}

class _UserAddUIState extends State<UserAddUI> {
  List<String> users = [
    'FairPy Inc',
    'Product Owner',
    'Hasnath Mohammed',
    'Inshaf Nazir',
    'Abdullah Khan',
    'Zohaib Ahmed',
    'Mudassir Iqbal',
    'Lingeshwaran T',
    'Mukesh N',
    'Suhaina Begum',
    'Imthiyaas Ahamed'
  ];
  String? selectedUsers;

  Map<String, bool> permissions = {
    'Create Users': false,
    'View Users': false,
    'Edit Users': false,
    'Delete Users': false,
    'Create Roles': false,
    'View Roles': false,
    'Edit Roles': false,
    'Delete Roles': false,
    'Create Permission': false,
    'View Permission': false,
    'Edit Permission': false,
    'Delete Permission': false,
    'Create Department': false,
    'View Department': false,
    'Edit Department': false,
    'Delete Department': false,
    'Task Scheduler': false,
    'Edit-expense': false,
    'import-task': false,
    'view-components-settings': false,
    'edit-components-settings': false,
    'working_hours_reason': false,
    'checkinout_reason': false,
    'private_rental': false,
  };

  void _save() {
    if (selectedUsers == null) {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final Map<String, String> stringPermissions = permissions.map((key, value) {
      return MapEntry(key, value.toString()); // Convert boolean to string
    });
    final newRole = {'user': selectedUsers ?? '', 'permissions': permissions};

    Navigator.of(context).pop(newRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back)),
                const SizedBox(
                  width: 10,
                ),
                Utils.getText('Add User', size: 20, weight: FontWeight.bold),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Utils.buildDropdownButton(
                    'Select a User',
                    users,
                    selectedUsers,
                    (value) {
                      setState(() {
                        selectedUsers = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Utils.getText('Permissions', size: 15, weight: FontWeight.bold),
            const SizedBox(height: 10),

            // Wrapping ListView in SingleChildScrollView
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: permissions.entries.map((entry) {
                    return Container(
                      height: 25,
                      margin: const EdgeInsets.only(
                          bottom: 8), // Adjust space between items
                      child: Row(
                        children: [
                          Checkbox(
                            value: entry.value,
                            onChanged: (bool? value) {
                              setState(() {
                                permissions[entry.key] = value ?? false;
                              });
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Utils.getText(entry.key),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 15), // Reduced space between list and button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  child: Utils.getAddFilledButton('Save', () {
                    //_save();
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
