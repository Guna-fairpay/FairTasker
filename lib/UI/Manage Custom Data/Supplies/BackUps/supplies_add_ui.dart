
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';

class SuppliesAddUI extends StatefulWidget {
  const SuppliesAddUI({super.key});

  @override
  State<SuppliesAddUI> createState() => _SuppliesAddUIState();
}

class _SuppliesAddUIState extends State<SuppliesAddUI> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool goBack = false;
  TextEditingController suppliesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isSuppliesFieldEmpty = false;

  void _save() {
    _formKey.currentState!.validate();
    setState(() {});
    if (suppliesController.text.isEmpty) {
      return;
    }
    final newSupplies = {
      'name': suppliesController.text,
      'description': descriptionController.text,
    };
    Navigator.of(context).pop(newSupplies);
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
          'Add Supplies',
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Utils.getTextFormField(
                'Supplies Name',
                suppliesController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val) => val!.isEmpty ? 'Please enter supplies name' : null,
              ),
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
      ),
      drawer: const DrawerView(),
    );
  }
}
