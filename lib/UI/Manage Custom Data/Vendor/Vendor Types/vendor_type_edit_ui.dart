import 'package:flutter/material.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Utilities/utils.dart';
import '../../../../Utilities/appC.dart';

class VendorTypeEditUI extends StatefulWidget {
  final Map<String, dynamic> vendor;

  const VendorTypeEditUI({super.key, required this.vendor});

  @override
  _VendorTypeEditUIState createState() => _VendorTypeEditUIState();
}

class _VendorTypeEditUIState extends State<VendorTypeEditUI> {
  late final TextEditingController nameController;

  bool isVendorFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.vendor['name']);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      isVendorFieldEmpty = nameController.text.isEmpty;
    });
    if (nameController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }
    final updatedVendor = {
      'id': widget.vendor['id'],
      'name': nameController.text,
    };
    Navigator.pop(context, updatedVendor);
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                Utils.getText('Edit Vendor Type',
                    size: 20, weight: FontWeight.bold)
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
                    nameController,
                    label: Utils.getText('Vendor Type', color: AppC.grey),
                    borderColor:
                        isVendorFieldEmpty ? Colors.red : AppC.fieldBase,
                  ),
                  if (isVendorFieldEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.error_outline, color: Colors.red),
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
