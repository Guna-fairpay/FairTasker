

import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State <AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  TextEditingController categoryController = TextEditingController();
  bool isTaskFieldEmpty = false;

  void _save() {
    setState(() {
      isTaskFieldEmpty = categoryController.text.isEmpty;
    });
    // Validate the form fields
    if (categoryController.text.isEmpty ) {
      return
        Utils.showMobileToast('Please fill the required field');
    }
    final newCategory = {
      'name': categoryController.text,
    };

    // Return the new rental data to the previous screen
    Navigator.pop(context, newCategory);
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
        padding: const EdgeInsets.symmetric(horizontal:  20.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width:10 ,),
                Utils.getText('Add Category',size: 20,weight: FontWeight.bold),
              ],
            ),
            const SizedBox(height: 10,),
            SizedBox(height: 40,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                      '', categoryController,
                    label: Utils.getText('Category',color: AppC.grey),
                    borderColor: isTaskFieldEmpty ? Colors.red : AppC.fieldBase,

                  ),
                  if (isTaskFieldEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.error_outline, color: Colors.red),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 40,
                  child: Utils.getAddFilledButton('Save', () {
                   _save();
                  }),
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
