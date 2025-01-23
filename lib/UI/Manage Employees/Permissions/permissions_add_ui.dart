import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class PermissionsAddUI extends StatefulWidget {
  const PermissionsAddUI({super.key});

  @override
  State<PermissionsAddUI> createState() => _PermissionsAddUIState();
}

class _PermissionsAddUIState extends State<PermissionsAddUI> {
  final TextEditingController nameController = TextEditingController();

  void _save() {
    // Validate the form fields
    if (nameController.text.isEmpty) {
      // Show an alert dialog if fields are empty
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final newPermission = {
      'name': nameController.text,
    };

    Navigator.of(context).pop(newPermission);
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
                Utils.getText('Add Permission',
                    weight: FontWeight.bold, size: 20),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Utils.getTextFormField(
                      '', nameController,
                      label:
                          Utils.getText('Permission Name', color: AppC.grey)),
                ],
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
      drawer: const DrawerView(),
    );
  }
}
