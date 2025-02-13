
import 'package:flutter/material.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class PartAddUI extends StatefulWidget {
  const PartAddUI({super.key});

  @override
  State<PartAddUI> createState() => _PartAddUIState();
}

class _PartAddUIState extends State<PartAddUI> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController partsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _saveParts() {
    _formKey.currentState!.validate();
    setState(() {});
    if (partsController.text.isEmpty) {return ;}
    final newLocation = {
      'name': partsController.text,
      'note': descriptionController.text,
    };
    Navigator.pop(context, newLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar:AppBar(
        title: const Text("Add Parts"),
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: ()=>Navigator.pop(context))
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Utils.getTextFormField(
                'Parts Name',
                partsController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val) => val!.isEmpty ? 'Please enter parts name' : null,
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
                  Utils.getElevatedButton(() => _saveParts(),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
