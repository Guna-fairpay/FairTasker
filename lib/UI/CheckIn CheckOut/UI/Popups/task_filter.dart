import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Utilities/Utils.dart';
import '../../Bloc/workHoursBloc.dart';
import '../../Event/workingHoursEvent.dart';

class FilterDialog extends StatefulWidget {
  final WorkingHoursBloc workingHoursBloc;
  final List<Map<String, dynamic>> filterOptions;
  final Set<int> selectedFilters;
  final Function(Set<int>) onSelectionChanged;
  final String to;
  final String from;
  final int userId;

  const FilterDialog({
    super.key,
    required this.workingHoursBloc,
    required this.filterOptions,
    required this.selectedFilters,
    required this.onSelectionChanged,
    required this.to,
    required this.from,
    required this.userId,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late Set<int> tempSelectedFilters;
  bool isAllSelected = false;

  final Map<String, dynamic> otherFilter = {
    'id': -1, // Assuming -1 is unused and safe for "Other"
    'cohort': 'Other',
  };

  @override
  void initState() {
    super.initState();
    tempSelectedFilters = {...widget.selectedFilters};

    // Add 'Other' to options if not already present
    if (!widget.filterOptions.any((e) => e['id'] == -1)) {
      widget.filterOptions.add(otherFilter);
    }

    isAllSelected = tempSelectedFilters.length == widget.filterOptions.length;
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
    _applyFilters();
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
    _applyFilters();
  }

  void _applyFilters() {
    log("Selected Filters: $tempSelectedFilters");
    widget.workingHoursBloc.add(TaskInitialEvent(
      to: widget.to,
      from: widget.from,
      userId: widget.userId,
      cohortIds: tempSelectedFilters.toList(),
    ));
    widget.onSelectionChanged(tempSelectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          children: [
            // Red close icon
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            // "All" Checkbox Row (checkbox on right)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Utils.getText("All"),
                ),
                Checkbox(
                  value: isAllSelected,
                  onChanged: _toggleAllSelection,
                ),
              ],
            ),

            const Divider(height: 0),

            // Filter List
            Expanded(
              child: ListView.builder(
                itemCount: widget.filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = widget.filterOptions[index];
                  final int filterId = filter['id'];
                  final String filterName = filter['cohort'];

                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(filterName),
                    value: tempSelectedFilters.contains(filterId),
                    onChanged: (val) => _toggleSingleSelection(filterId, val),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

