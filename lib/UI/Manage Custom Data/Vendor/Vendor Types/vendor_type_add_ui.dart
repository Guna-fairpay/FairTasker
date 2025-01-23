import 'package:flutter/material.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';

class VendorTypeAddUI extends StatefulWidget {
  const VendorTypeAddUI({super.key});

  @override
  State<VendorTypeAddUI> createState() => _VendorTypeAddUIState();
}

class _VendorTypeAddUIState extends State<VendorTypeAddUI> {
  final TextEditingController nameController = TextEditingController();
  bool isVendorFieldEmpty = false;

  void _saveVendor() {
    setState(() {
      isVendorFieldEmpty = nameController.text.isEmpty;
    });
    if (nameController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }

    final newVendor = {
      'name': nameController.text,
    };

    Navigator.pop(context, newVendor);
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
                const SizedBox(
                  width: 10,
                ),
                Utils.getText('Add Vendor Type',
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
                    label: Utils.getText('Vendor Name', color: AppC.grey),
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
                      _saveVendor();
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
