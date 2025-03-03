
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class PermissionsAddUI extends StatefulWidget {
  const PermissionsAddUI({super.key});

  @override
  State<PermissionsAddUI> createState() => _PermissionsAddUIState();
}

class _PermissionsAddUIState extends State<PermissionsAddUI> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  void _save() {
    if (!formKey.currentState!.validate()) return;
    final newPermission = {
      'name': nameController.text,
    };
    Navigator.of(context).pop(newPermission);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Add Permission'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )
          ],
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
          minimum: 15.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Utils.getTextFormField(
                'Permission Name',
                nameController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val)=>val!.isEmpty?'Enter Permission Name':null,
              ),
              const SizedBox(height: 15),
              Utils.getElevatedButton( ()=>_save()),
            ],
          ),
        ),
      ),
    );
  }
}
