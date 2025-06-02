import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

class OtherListingPage extends StatelessWidget {

  final Map<String, dynamic> expense;
  final void Function(String? value) onDelete;
  final void Function(bool? value)? onChanged;

  const OtherListingPage({super.key, required this.expense, required this.onDelete, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: AppC.redAccent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.delete_outline, color: AppC.white),
                Utils.getText('Delete', color: AppC.white),
              ],
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          AskPermissionDialog.show(context,
              title: "Are you sure?",
              description: "Do you want to delete this Expense?",
              positiveText: "Yes, delete it!",
              negativeText: "Cancel",
              isReasonRequired: false,
              onPositivePressed: () => onDelete(expense['id'].toString()));
          return false;
        },
        child: Column(),
    );
  }
}
