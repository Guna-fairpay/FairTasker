
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class AddVehicleUI extends StatelessWidget {
  const AddVehicleUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        automaticallyImplyLeading: false,
        foregroundColor: AppC.white,
        backgroundColor: AppC.appColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ]
      ),
      body: SafeArea(
        minimum: 10.padding,
        child: ListView(
          children: [
            Text('Add Vehicle Screen')
          ],
        ),
      ),
    );
  }
}

