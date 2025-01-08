import 'package:flutter/material.dart';

import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class RoleAddUI extends StatefulWidget {
  const RoleAddUI({super.key});

  @override
  State<RoleAddUI> createState() => _RoleAddUIState();
}

class _RoleAddUIState extends State<RoleAddUI> {
  TextEditingController roleController = TextEditingController();
  // List of permissions with their checked state
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
    if (roleController.text.isEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }

    final newRole = {
      'role': roleController.text,
      // 'permissions': permissions,
    };
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
                Utils.getText('Add Role', size: 20, weight: FontWeight.bold),
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
                    roleController,
                    label: Utils.getText('Role', color: AppC.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Utils.getText('Permissions', size: 15, weight: FontWeight.bold),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ...permissions.entries.map((entry) {
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
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Utils.getText(entry.key),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
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
      drawer: const DrawerView(),
    );
  }
}
