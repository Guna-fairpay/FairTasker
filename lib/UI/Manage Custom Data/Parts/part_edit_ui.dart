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
                Utils.getText('Edit Parts', size: 20, weight: FontWeight.bold),
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
