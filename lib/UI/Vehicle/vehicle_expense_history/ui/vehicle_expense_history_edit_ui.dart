
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class VehicleExpenseHistoryEditUI extends StatelessWidget {
  final String? id;
  const VehicleExpenseHistoryEditUI({super.key,required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Expense"),
        foregroundColor: Colors.white,
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
