import 'package:flutter/material.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String? totalCash;
  final TextEditingController? nameController;
  final TextEditingController? valueController;
  final TextEditingController? cohortController;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    this.totalCash,
    this.nameController,
    this.valueController,
    this.cohortController,
  }) : super(key: key);

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  final ExpansionTileController _expansionTileController = ExpansionTileController();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: widget.totalCash!=null?Utils.getText("\$${widget.totalCash}",align: TextAlign.right,weight: FontWeight.w900):const SizedBox(),
      leading: Utils.getText(
        widget.title,
        weight: FontWeight.w900,
        align: TextAlign.end,
      ),
      trailing: const Icon(Icons.add),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppC.grey, width: 0.7),
      ),
      backgroundColor: const Color(0xFFeaeaea),
      collapsedBackgroundColor: const Color(0xFFeaeaea),
      collapsedShape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      controller: _expansionTileController, // Use local controller
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: AppC.white,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (widget.nameController != null) Utils.getTextFormField('Enter Name', widget.nameController!),
              if (widget.nameController != null) const SizedBox(height: 4),
              if (widget.valueController != null) Utils.getTextFormField('Enter Cohort', widget.valueController!),
              if (widget.valueController != null) const SizedBox(height: 4),
              if (widget.cohortController != null) Utils.getTextFormField('Cohort Dropdown', widget.cohortController!),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle adding new item logic
                    },
                    icon: const Icon(Icons.check, color: AppC.green),
                  ),
                  IconButton(
                    onPressed: () {
                      _expansionTileController.collapse();
                    },
                    icon: const Icon(Icons.close, color: AppC.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
