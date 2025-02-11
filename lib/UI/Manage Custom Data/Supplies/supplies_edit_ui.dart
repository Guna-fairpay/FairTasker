import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class SuppliesEditUI extends StatefulWidget {
  final Map<String, dynamic> supply;

  const SuppliesEditUI({super.key, required this.supply});

  @override
  State<SuppliesEditUI> createState() => SuppliesEditUIState();
}

class SuppliesEditUIState extends State<SuppliesEditUI> {
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
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: const Text(
          'Edit Supplies',
        ),
        actions: [
          IconButton(
              onPressed: ()=> Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: AppC.white,
              )),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
        child: ListView(
          children: [
            Stack(
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
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Utils.getTextFormField(
                  '',
                  descriptionController,
                  label: Utils.getText('Description', color: AppC.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Utils.getElevatedButton(
                 text:  'Save',
                  bgColor: AppC.green,
                  () {
                    _save();
                  },
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
