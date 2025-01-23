import 'package:fairpytasker/Component/drawer_ui.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';

class RevenueViewUI extends StatefulWidget {
  const RevenueViewUI({super.key});

  @override
  State<RevenueViewUI> createState() => _RevenueViewUIState();
}

class _RevenueViewUIState extends State<RevenueViewUI> {
  DateTime? selectedDate;
  DateRange? selectedDateRange;
  TextEditingController dateController = TextEditingController();
  List<String> userType = [
    'select',
    'Support Task',
  ];
  String? selectedUserType;
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  Widget datePickerBuilder(
      BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = false]) {
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      initialDateRange: selectedDateRange,
      disabledDates: const [],
      initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: onDateRangeChanged,
      height: 338,
      displayMonthsSeparator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText("Revenue", size: 18, weight: FontWeight.bold),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: DateRangeField(
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppC.fieldBase, width: Num.borderWidthField),
                        borderRadius:
                            BorderRadius.circular(Num.subradiusButton),
                      ),
                      hintStyle: Utils.getTextStyle(color: AppC.grey),
                      hintText: 'Select Date',
                    ),
                    onDateRangeSelected: (DateRange? value) {
                      setState(() {
                        selectedDateRange = value;
                      });
                    },
                    selectedDateRange: selectedDateRange,
                    pickerBuilder: datePickerBuilder,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppC.fieldBase,
                        width: Num.borderWidthField,
                      ),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Num.subradiusButton)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Utils.getText('Status', color: AppC.grey),
                        ),
                        value: selectedUserType,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 3,
                        dropdownColor: AppC.white,
                        onChanged: (String? value) {
                          setState(() {
                            selectedUserType = value;
                          });
                        },
                        items: userType
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            alignment:
                                Alignment.centerLeft, // Change alignment here
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Utils.getText(value),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: Utils.getSearchBarUI(
                    () {},
                    (value) {
                      //  _filtercategory(value);
                    },
                    searchController,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const DrawerView(),
    );
  }
}
