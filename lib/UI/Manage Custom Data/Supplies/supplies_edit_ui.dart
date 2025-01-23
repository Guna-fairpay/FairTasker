import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class SuppliesEditUI extends StatefulWidget {
  final Map<String, dynamic> supply;

  const SuppliesEditUI({super.key, required this.supply});

  @override
  _SuppliesEditUIState createState() => _SuppliesEditUIState();
}

class _SuppliesEditUIState extends State<SuppliesEditUI> {
  late final TextEditingController suppliesController;
  late final TextEditingController descriptionController;
  bool isSuppliesFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    suppliesController = TextEditingController(text: widget.supply['name']);
    descriptionController =
        TextEditingController(text: widget.supply['description']);
  }

  @override
  void dispose() {
    suppliesController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      isSuppliesFieldEmpty = suppliesController.text.isEmpty;
    });
    if (suppliesController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }

    final updatedSupplies = {
      'id': widget.supply['id'], // Keep the existing ID
      'name': suppliesController.text,
      'description': descriptionController.text,
    };

    Navigator.of(context).pop(updatedSupplies);
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                Utils.getText('Edit Supplies',
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
