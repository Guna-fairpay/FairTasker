import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class SuppliesAddUI extends StatefulWidget {
  const SuppliesAddUI({super.key});

  @override
  State<SuppliesAddUI> createState() => _SuppliesAddUIState();
}

class _SuppliesAddUIState extends State<SuppliesAddUI> {
  bool goBack = false;
  TextEditingController suppliesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isSuppliesFieldEmpty = false;

  void _saveSupplies() {
    setState(() {
      isSuppliesFieldEmpty = suppliesController.text.isEmpty;
    });
    if (suppliesController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }

    final newSupplies = {
      'name': suppliesController.text,
      'description': descriptionController.text,
    };

    Navigator.of(context).pop(newSupplies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                const SizedBox(
                  width: 10,
                ),
                Utils.getText('Add Supplies',
                    size: 20, weight: FontWeight.bold),
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
                    '',
                    suppliesController,
                    label: Utils.getText('Supplies Name', color: AppC.grey),
                    borderColor:
                        isSuppliesFieldEmpty ? Colors.red : AppC.fieldBase,
                  ),
                  if (isSuppliesFieldEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.error_outline, color: Colors.red),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Utils.getTextFormField(
                    '',
                    descriptionController,
                    label: Utils.getText('Description', color: AppC.grey),
                  ),
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
                      _saveSupplies();
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
