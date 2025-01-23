import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class EditCategoryPage extends StatefulWidget {
  final Map<String, dynamic> category;

  const EditCategoryPage({required this.category, super.key});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late final TextEditingController categoryController;
  bool isTaskFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController(text: widget.category['name']);
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      isTaskFieldEmpty = categoryController.text.isEmpty;
    });
    if (categoryController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }
    final updatedcategory = {
      'id': widget.category['id'],
      'name': categoryController.text,
    };

    Navigator.pop(context, updatedcategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
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
                Utils.getText('Edit Category',
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
                    categoryController,
                    label: Utils.getText('Category', color: AppC.grey),
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
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(_controller.text);
            //   },
            //   child: Text('Save'),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
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
