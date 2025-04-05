
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';


class SwapIndexPopUp{
  SwapIndexPopUp._();
  static void show(BuildContext context,{
   required VoidCallback? onSwap,
    required dynamic data,
    required Function(List<dynamic>) onReorderUpdate,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SwapIndexPopUp(
        onReorderUpdate: onReorderUpdate,
        onSwap: onSwap,
        data: data,
      ),
    );
  }
}

class _SwapIndexPopUp extends StatelessWidget {
  final VoidCallback? onSwap;
  final dynamic data;
  final Function(List<dynamic>) onReorderUpdate;

  const _SwapIndexPopUp({
    required this.onSwap,
    required this.data,
    required this.onReorderUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
      backgroundColor: AppC.white,
      insetPadding: 10.padding,
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Utils.getText(data['category_name'],weight: FontWeight.bold),
                const Spacer(),
                IconButton(onPressed: context.popDialog, icon: const Icon(Icons.close,color: AppC.redAccent))
              ],
            ),
          ),
          Flexible(
            child: ReorderableListView(
              physics: const BouncingScrollPhysics(),
              padding: 0.padding,
              shrinkWrap: true,
              onReorder: (int oldIndex, int newIndex) {
                List<dynamic> updatedList = List.from(data['checklists']);
                if (newIndex > oldIndex) newIndex -= 1;
                final item = updatedList.removeAt(oldIndex);
                updatedList.insert(newIndex, item);
                onReorderUpdate(updatedList);
                Console.of.log(updatedList);
              },
              children: List.generate(data['checklists'].length, (index) {
                var checklist = data['checklists'][index];
                return ListTile(
                  key: ValueKey(checklist['checklist_order']),
                  title: Container(
                    color: AppC.blue50,
                      child: Utils.getText("${checklist['label']} - ${checklist['checklist_order']}")),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
