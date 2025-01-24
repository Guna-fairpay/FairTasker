import 'package:flutter/material.dart';

import '../../../../Component/custom_checkbox.dart';

class CheckboxPopup extends StatefulWidget {
  const CheckboxPopup({Key? key}) : super(key: key);

  @override
  _CheckboxPopupState createState() => _CheckboxPopupState();
}

class _CheckboxPopupState extends State<CheckboxPopup> {
  final List<String> items = [
    'All',
    'Fair Returns LP LLC',
    'Share Car',
    'Personal Car',
    'FairPY',
    'Fair Returns Fall 2023',
    'Unassigned',
    'FairFund 2024',
    'Fair Returns Prime LP',
    'Abdullah Khan 2024',
    'Test Cohort',
    'FairPAY Tech Works 2025',
    'TEST 2025',
    'TEST JAN',
    'Final Test',
    'Final test 1',
    'FP',
    'TEST FP',
    'Other',
  ];

  final Map<String, bool> checkboxState = {};

  @override
  void initState() {
    super.initState();
    // Initialize all checkboxes to true
    for (var item in items) {
      checkboxState[item] = true;
    }
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      for (var key in checkboxState.keys) {
        checkboxState[key] = value ?? false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:32),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          //height: 19 * 60.0 > 400 ? 400 : 19 * 60.0,
          height: 19 * 60.0 > 700 ? 700 : 2,
          child: Column(
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 48), // Spacer to align with close button
                  ],
                ),
              ),
              // List of checkboxes using CustomCheckboxListTile
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return
                      CustomCheckboxListTile(
                        title: Text(item),
                      value: checkboxState[item],
                      onChanged: (value) {
                        setState(() {
                          checkboxState[item] = value ?? false;
                          if (item == 'All') {
                            toggleSelectAll(value);
                          }
                        });
                      },
                      isCheckboxOnRight: item=="All"?true:false,
                    );
                  },
                ),
              ),
              // Footer buttons (optional)
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Perform action with selected options
              //       final selectedItems = checkboxState.entries
              //           .where((entry) => entry.value)
              //           .map((entry) => entry.key)
              //           .toList();
              //       print('Selected Items: $selectedItems');
              //       Navigator.pop(context);
              //     },
              //     child: const Text('Done'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
