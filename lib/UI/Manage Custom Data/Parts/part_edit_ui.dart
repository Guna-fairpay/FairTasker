import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class PartEditUI extends StatefulWidget {
  final Map<String, dynamic> parts;

  const PartEditUI({super.key, required this.parts});

  @override
  _PartEditUIState createState() => _PartEditUIState();
}

class _PartEditUIState extends State<PartEditUI> {
  late final TextEditingController partsController;
  late final TextEditingController descriptionController;
  bool isPartsFieldEmpty = false;
  @override
  void initState() {
    super.initState();
    partsController = TextEditingController(text: widget.parts['name']);
    descriptionController = TextEditingController(text: widget.parts['note']);
  }

  @override
  void dispose() {
    partsController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      isPartsFieldEmpty = partsController.text.isEmpty;
    });
    if (partsController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }
    final updatedParts = {
      'id': widget.parts['id'],
      'name': partsController.text,
      'note': descriptionController.text,
    };
    Navigator.pop(context, updatedParts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar:AppBar(
        title: const Text("Edit Parts"),
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
                      _save();
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
