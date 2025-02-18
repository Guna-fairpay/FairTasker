
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class PermissionsEditUI extends StatefulWidget {
  final Map<String, dynamic> permissions;

  const PermissionsEditUI({super.key, required this.permissions});

  @override
  State<PermissionsEditUI> createState() => _PermissionsEditUIState();
}

class _PermissionsEditUIState extends State<PermissionsEditUI> {


  late final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.permissions['name'];
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (nameController.text.isEmpty) return;
    final updatedPermission = {
      'id': widget.permissions['id'],
      'name': nameController.text,
    };
    Navigator.of(context).pop(updatedPermission);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Edit Permission'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Form(
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
