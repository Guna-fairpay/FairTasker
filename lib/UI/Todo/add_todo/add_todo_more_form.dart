import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/Response/todo_list_response.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/part_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/supplies_view_ui.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class AddTodoMoreForm extends StatelessWidget {
  const AddTodoMoreForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            Utils.getCircleCheckWidget(() {
            }, false, 'Parts/Services'),
            Utils.getCircleCheckWidget(() {
            }, false, 'Supplies'),
            IconButton(onPressed: () {

            }, icon: const Icon(Icons.local_car_wash_sharp),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide()
                ))
              ),
            ),
            Flexible(
              child: CustomDropdown<CleanCarTimeValues>(items: [],
              itemAsString: (item) => item.minutes.toString(),
              onChanged: (value) {

              },),
            )
          ],
        ),
        CustomMultiSelectionChipsField<Map<String, dynamic>>(selectedPartsList: [], suggestionsList: [],
            controller: TextEditingController(),
            labelText: "Parts",
            itemAsString: (item) => item['name'].toString(),
            onEmptyTap: () => context.push(const PartViewUI(), fullscreenDialog: true)
        ),
        CustomMultiSelectionChipsField<Map<String, dynamic>>(selectedPartsList: [], suggestionsList: [],
            controller: TextEditingController(),
            labelText: "Supplies",
            itemAsString: (item) => item['name'].toString(),
            onEmptyTap: () => context.push(const SuppliesViewUI(), fullscreenDialog: true)
        ),
        Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.getText('More...',
                color: Colors.lightGreen.shade800),
            Flexible(
              child: CustomDropdown<Map<String, dynamic>>(items: [],
              onChanged: (val){},
              itemAsString: (item) => item['label'].toString(),),
            )
          ],
        ),
        Utils.getTextFormField("Custom Link", TextEditingController()),
      ],
    );
  }
}
