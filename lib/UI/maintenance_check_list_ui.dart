
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
  List<Map<String, dynamic>> children=[];
  List<bool> checkboxStates = [];
  dynamic selectedChecks;
  bool isAllCheck=false;

  @override
  void initState() {
    maintenance=widget.maintenance;
    //children=widget.children;
    checkboxStates = List.generate(maintenance.length, (index) => false);

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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
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
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: maintenance.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final maintenanceCheckListData = maintenance[index];
              var  checkList = maintenanceCheckListData['children'];
              final dropDownValue = checkList.isNotEmpty ? checkList[0]['children'] : null;                return Padding(
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
                          if(checkList[i]['name'] !='Other')
                            Expanded(
                              child:Utils.dropdownBox(
                                  'Not Checked',
                                  dropDownValue,
                                      (selectedValue) {
                                    setState(() {
                                      selectedChecks = selectedValue;
                                    });
                                  }, labelKey: 'name'),
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
        ],
      ),
    );
  }
}