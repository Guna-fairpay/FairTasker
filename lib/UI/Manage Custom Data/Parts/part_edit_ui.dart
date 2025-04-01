
import 'package:flutter/material.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class PartEditUI extends StatefulWidget {
  final Map<String, dynamic> parts;

  const PartEditUI({super.key, required this.parts});

  @override
  State<PartEditUI> createState() => _PartEditUIState();
}

class _PartEditUIState extends State<PartEditUI> {
  late final TextEditingController partsController;
  late final TextEditingController descriptionController;
  bool isPartsFieldEmpty = false;
  @override
  void initState() {
    super.initState();
    partsController = TextEditingController(text: widget.parts['name']);
    descriptionController = TextEditingController(text: widget.parts['note']);
  }

  @override
  void dispose() {
    partsController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {});
    if (partsController.text.isEmpty) {
      return;
    }
    final updatedParts = {
      'id': widget.parts['id'],
      'name': partsController.text,
      'note': descriptionController.text,
    };
    Navigator.pop(context, updatedParts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar:AppBar(
        title: const Text("Edit Parts"),
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
                Utils.getElevatedButton(
                  () =>_save(),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
