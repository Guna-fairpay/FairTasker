import 'package:fairpytasker/Component/search_with_status_add_view.dart';
import 'package:flutter/material.dart';

class SharedNotesUi extends StatelessWidget {
  const SharedNotesUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWithStatusAddView(
          selectedDate: DateTime.now(),
          controller: TextEditingController(),
          onCurrentDay: () {},
        ),
      ],
    );
  }
}
