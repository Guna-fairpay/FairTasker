import 'package:flutter/material.dart';

import '../../Component/custom_checkbox.dart';
import '../../../dialog/tasker_check_in_out_completed_dialog.dart'; // Import your custom checkbox

class CheckboxPopup extends StatefulWidget {
  final List<Map<String, dynamic>> cohortsData;

  const CheckboxPopup(this.cohortsData, {Key? key}) : super(key: key);

  @override
  State<CheckboxPopup> createState() => _CheckboxPopupState();
}
class _CheckboxPopupState extends State<CheckboxPopup> {
  late List<Map<String, dynamic>> cohort;
  late Map<dynamic, bool> checkboxState;
  @override
  void initState()
  {
    super.initState();
    setState(() {
      cohort = List.from(widget.cohortsData);
      checkboxState = {};
      cohort.insert(0, {'cohort': 'All'});

      for (var item in cohort) {
        dynamic checkboxKey;
        if (item.containsKey('id')) {
          checkboxKey = item['id'];
        } else if (item.containsKey('cohort')) {
          checkboxKey = item['cohort'].toString();
        } else {
          print("Warning: Cohort data missing 'cohort' or 'id': $item");
          continue;
        }
        checkboxState[checkboxKey] = true;
      }
    });
  }

  void toggleSelectAll(bool? value)
  {
    setState(() {
      for (var key in checkboxState.keys) {
        checkboxState[key] = value ?? false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child:
      Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height > 700 ? 700 : MediaQuery.of(context).size.height * 0.8, // Dynamic height
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder
                  (
                  itemCount: cohort.length,
                  itemBuilder: (context, index) {
                    final item = cohort[index];
                    dynamic checkboxKey;
                    if (item.containsKey('id')) {
                      checkboxKey = item['id'];
                    } else if (item.containsKey('cohort')) {
                      checkboxKey = item['cohort'].toString();
                    } else {
                      return const SizedBox.shrink();
                    }
                    String displayName = item['cohort'] ?? item['id']?.toString() ?? 'Unknown';
                    return CustomCheckboxListTile(
                      title: Text(displayName),
                      value: checkboxState[checkboxKey] ?? false,
                      onChanged: (value) {
                        setState(() {
                          checkboxState[checkboxKey] = value!;
                          if (displayName == "All") {
                            toggleSelectAll(value);
                          }
                        });
                      },
                      isCheckboxOnRight: displayName == "All",
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    final selectedItems = checkboxState.entries
                        .where((entry) => entry.value && entry.key != "All")
                        .map((entry) => entry.key)
                        .toList();
                    print('Selected Items: $selectedItems');
                    Navigator.pop(context,selectedItems);
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}