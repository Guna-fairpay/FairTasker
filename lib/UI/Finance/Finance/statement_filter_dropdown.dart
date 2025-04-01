import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SearchableMultiSelectDropdown extends StatefulWidget {
  final List<String> items;

  const SearchableMultiSelectDropdown({Key? key, required this.items}) : super(key: key);

  @override
  _SearchableMultiSelectDropdownState createState() => _SearchableMultiSelectDropdownState();
}

class _SearchableMultiSelectDropdownState extends State<SearchableMultiSelectDropdown> {
  final Map<String, bool> checkboxState = {};
  List<String> filteredItems = [];
  bool isSelectedAll = false;
  final TextEditingController searchController = TextEditingController();
  final _dropdownKey = GlobalKey<DropdownButton2State>();
  final ValueNotifier<String> hintTextNotifier = ValueNotifier<String>('Select Items');

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(widget.items);
    _initializeCheckboxState();
    _updateHintText();
  }

  void _initializeCheckboxState() {
    for (var item in widget.items) {
      checkboxState[item] = false;
    }
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
      // Update the checkbox state for the filtered items
      for (var item in filteredItems) {
        checkboxState[item] = checkboxState[item] ?? false;
      }
    });
  }

  void toggleSelectAll() {
    setState(() {
      isSelectedAll = !isSelectedAll;
      for (var item in widget.items) {
        checkboxState[item] = isSelectedAll;
      }
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
      _dropdownKey.currentState?.didChangeDependencies();
    });
    _updateHintText();
  }

  List<String> get selectedItems => checkboxState.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  void _updateHintText() {
    hintTextNotifier.value = selectedItems.isEmpty
        ? 'Select Items'
        : '${selectedItems.length} selected';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ValueListenableBuilder<String>(
        valueListenable: hintTextNotifier,
        builder: (context, hintText, _) {
          return DropdownButton2<String>(
            key: _dropdownKey,
            isExpanded: true,
            hint: Text(
              hintText,
              style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
            ),
            items: [
              DropdownMenuItem(
                value: "Select All",
                child: Text('Select All',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...filteredItems.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return CheckboxListTile(
                        value: checkboxState[item],
                        onChanged: (value) {
                          setState(() {
                            checkboxState[item] = value ?? false;
                          });
                          // Update the hint text in real-time
                          _updateHintText();
                          // Rebuild the dropdown menu
                          _dropdownKey.currentState?.setState(() {});
                        },
                        title: Text(item),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                );
              }).toList(),
            ],
            onChanged: (value) {
              log("$value", name: "ON_CHANGE");
              if (value == "Select All") toggleSelectAll();
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: 220,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 250,
              width: 270,
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color to white
                borderRadius: BorderRadius.circular(8), // Optional: Add border radius
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: searchController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    hintText: 'Search...',
                    hintStyle: const TextStyle(fontSize: 12),
                    suffixIcon: Icon(Icons.search_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: filterItems,
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                searchController.clear();
                filterItems('');
              }
            },
          );
        },
      ),
    );
  }
}