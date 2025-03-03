
import 'package:flutter/material.dart';

class VehicleExpenseUI extends StatelessWidget {
  const VehicleExpenseUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => const Divider(height: 0.5,),
      itemBuilder: (context, index) {
        return SafeArea(child: Text(''));
      },

    ));
  }
}
