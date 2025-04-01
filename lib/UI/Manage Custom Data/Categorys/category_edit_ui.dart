
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class EditCategoryPage extends StatefulWidget {
  final Map<String, dynamic> category;

  const EditCategoryPage({required this.category, super.key});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
   final TextEditingController categoryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    categoryController.text = widget.category['name'];
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  void _save() {
    _formKey.currentState!.validate();
    setState(() {
    });
    if (categoryController.text.isEmpty) {
      return ;
    }
    final updatedCategory = {
      'id': widget.category['id'],
      'name': categoryController.text,
    };
    Navigator.pop(context, updatedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppC.appColor,
        foregroundColor: Colors.white,
        title: const Text('Edit Category'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: 15.padding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.getTextFormField(
                'Category',
                categoryController,
                autoValidate: AutovalidateMode.always,
                validator: (val) => val!.isEmpty ? 'Please enter category' : null,
              ),
              const SizedBox(height: 10),
              Utils.getElevatedButton(()=>_save(),bgColor: AppC.green,text: 'Save')
            ],
          ),
        ),
      ),
    );
  }
}
