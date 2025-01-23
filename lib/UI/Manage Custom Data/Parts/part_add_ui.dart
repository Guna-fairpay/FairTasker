import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class PartAddUI extends StatefulWidget {
  const PartAddUI({super.key});

  @override
  State<PartAddUI> createState() => _PartAddUIState();
}

class _PartAddUIState extends State<PartAddUI> {
  bool goBack = false;
  TextEditingController partsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isPartsFieldEmpty = false;

  void _saveParts() {
    setState(() {
      isPartsFieldEmpty = partsController.text.isEmpty;
    });
    if (partsController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }

    final newLocation = {
      'name': partsController.text,
      'note': descriptionController.text,
    };
    print(descriptionController.text);
    // Return the new vendor data and pop the screen
    Navigator.pop(context, newLocation);
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
                Utils.getText('Add Parts', size: 20, weight: FontWeight.bold),
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
                    partsController,
                    label: Utils.getText('Parts Name', color: AppC.grey),
                    borderColor:
                        isPartsFieldEmpty ? Colors.red : AppC.fieldBase,
                  ),
                  if (isPartsFieldEmpty)
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
                      _saveParts();
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
