
import 'package:flutter/material.dart';
import '../Utilities/Utils.dart';
import '../Utilities/appC.dart';
import '../Utilities/num.dart';

class MaintenanceCheckListUI extends StatefulWidget {
  final List<Map<String, dynamic>> maintenance;

  const MaintenanceCheckListUI({super.key,required this.maintenance});

  @override
  State<MaintenanceCheckListUI> createState() => _MaintenanceCheckListUIState();
}

class _MaintenanceCheckListUIState extends State<MaintenanceCheckListUI> {

  bool loading = false;
  TextEditingController notesController = TextEditingController();
  List<Map<String, dynamic>> maintenance = [];
  Map<String, dynamic> children={};
  List<bool> checkboxStates = [];
  dynamic selectedChecks;
  bool isAllCheck=false;

  @override
  void initState() {
    maintenance=widget.maintenance;
    //children=widget.children;
    checkboxStates = List.generate(maintenance.length, (index) => false);

    children={};
    for (var map in maintenance) {
      children.addAll(map);
    }

    super.initState();
  }

  Widget checkBoxWithSingleTextAndTexBox({
    required bool checkboxValue,
    required ValueChanged<bool?> onCheckboxChanged,
    required String label,
  }) {
    return Row(
      children: [
        Checkbox(
          value: checkboxValue,
          onChanged: onCheckboxChanged,
        ),
        Utils.getText(label),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body:Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: isAllCheck,
                onChanged: (bool? newValue) {
                  setState(() {
                    isAllCheck = newValue!;
                  });
                  }, ),
              Utils.getText('Is all maintenance check done')
            ],
          ),
          Flexible(
            child: ListView.builder(
              itemCount: maintenance.length,
              itemBuilder: (context, index) {
                final maintenanceCheckListData = maintenance[index];
                var  checkList = (maintenanceCheckListData['children'] as List<dynamic>?) ?? [];
                //final childrenData= children[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Utils.getText(
                        maintenanceCheckListData['name']?.toString() ?? '',
                        weight: FontWeight.bold,
                      ),
                      for (var i = 0; i < checkList.length; i++)
                        Row(
                          children: [
                            checkBoxWithSingleTextAndTexBox(
                              checkboxValue: checkboxStates[index],
                              onCheckboxChanged: (bool? value) {
                                setState(() {
                                  checkboxStates[index] = value ?? false;
                                });
                                },
                              label: checkList[i]['name'].trim() ?? 'Default Label',
                            ),
                            //if(filteredMaintenance['children']['children'] != null)
                            Expanded(
                              child:Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppC.fieldBase,
                                    width: Num.borderWidthField,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(Num.subradiusButton)),
                                ),
                                child: DropdownButton<Map<String,dynamic>>(
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Utils.getText(
                                      'Select ExpenseTo',
                                      color: AppC.grey,
                                      overFlow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  value: selectedChecks,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 3,
                                  dropdownColor: AppC.white,
                                  underline: Container(height: 0, color: Colors.transparent),
                                  onChanged: (Map<String,dynamic>? value) {
                                    setState(() {
                                      selectedChecks = value;
                                    });
                                    },
                                  items: maintenance.map<DropdownMenuItem<Map<String,dynamic>>>((Map<String,dynamic> value) {
                                    return DropdownMenuItem<Map<String,dynamic>>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Utils.getText('${value['name']??''}'.trim()),
                                      ),
                                    );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (index == maintenance.length - 1)
                        Row(
                          children: [
                            Expanded(
                              child: Utils.getBorderedMultilineTextField(
                                'Notes',
                                notesController,
                                fillColor: AppC.white,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
                },
            ),
          ),
        ],
      ),
    );
  }
}