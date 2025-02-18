

import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _save() {
    setState(() {});
    _formKey.currentState!.validate();
    if (categoryController.text.isEmpty ) { return ;}
    final newCategory = {
      'name': categoryController.text,
    };
    Navigator.pop(context, newCategory);
  }


  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppC.appColor,
        foregroundColor: Colors.white,
        title: const Text('Add Category'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
            color: AppC.white,),
          ),
        ]
      ),
      body: SafeArea(
        minimum: 15.padding,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.getTextFormField(
                'Category', categoryController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val) => val!.isEmpty ? 'Please enter category' : null,
              ),
              Utils.getElevatedButton( () => _save()),
            ],
          ),
        ),
      ),
    );
  }
}
