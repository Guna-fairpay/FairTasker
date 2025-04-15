import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';

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
    setState(() {});
    if (suppliesController.text.isEmpty) {
      return;
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
        minimum: 15.padding,
        child: ListView(
          children: [
            Utils.getTextFormField(
              'Supplies Name',
              suppliesController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty ? 'Please enter supplies name' : null,),
            const SizedBox(height: 10),
            Utils.getTextFormField(
              'Description',
              descriptionController,
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
