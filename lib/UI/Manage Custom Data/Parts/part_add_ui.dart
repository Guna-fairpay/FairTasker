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
      appBar:AppBar(
        title: const Text("Add Parts"),
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: ()=>Navigator.pop(context))
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: ListView(
          children: [
            SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Utils.getTextFormField(
                    'Parts Name',
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Utils.getElevatedButton(
                    text: 'Save',
                    bgColor: AppC.green,
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
    );
  }
}
