import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/workHoursBloc.dart';
import '../../Event/workingHoursEvent.dart';

class FilterDialog extends StatefulWidget {
  final WorkingHoursBloc workingHoursBloc; // Add this
  final List<Map<String, dynamic>> filterOptions;
  final Set<int> selectedFilters;
  final Function(Set<int>) onSelectionChanged;
  final String to;
  final String from;
  final int userId;

  const FilterDialog({
    super.key,
    required this.workingHoursBloc, // Add this
    required this.filterOptions,
    required this.selectedFilters,
    required this.onSelectionChanged,
    required this.to,
    required this.from,
    required this.userId,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late Set<int> tempSelectedFilters;
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    tempSelectedFilters = {...widget.selectedFilters}; // Copy existing selections
    isAllSelected = tempSelectedFilters.length == widget.filterOptions.length; // Check if all are selected
  }

  void _toggleAllSelection(bool? value) {
    setState(() {
      if (value == true) {
        tempSelectedFilters = widget.filterOptions.map((e) => e['id'] as int).toSet();
      } else {
        tempSelectedFilters.clear();
      }
      isAllSelected = value ?? false;
    });
  }

  void _toggleSingleSelection(int id, bool? value) {
    setState(() {
      if (value == true) {
        tempSelectedFilters.add(id);
      } else {
        tempSelectedFilters.remove(id);
      }
      isAllSelected = tempSelectedFilters.length == widget.filterOptions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Filters",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // "All" Checkbox
            CheckboxListTile(
              title: const Text("All"),
              value: isAllSelected,
              onChanged: _toggleAllSelection,
            ),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = widget.filterOptions[index];
                  final int filterId = filter['id'];
                  final String filterName = filter['cohort'];

                  return CheckboxListTile(
                    title: Text(filterName),
                    value: tempSelectedFilters.contains(filterId),
                    onChanged: (value) => _toggleSingleSelection(filterId, value),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Buttons: Cancel & Apply
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    log("Selected Filters: $tempSelectedFilters");
                    widget.workingHoursBloc.add(TaskInitialEvent(
                      to: widget.to,
                      from: widget.from,
                      userId: widget.userId,
                      cohortIds: tempSelectedFilters.toList(), // Convert Set to List
                    ));
                    widget.onSelectionChanged(tempSelectedFilters);
                    Navigator.pop(context);
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
