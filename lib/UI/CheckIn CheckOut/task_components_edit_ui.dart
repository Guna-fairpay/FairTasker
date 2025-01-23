import 'package:flutter/material.dart';

import '../../Component/drawer_ui.dart'; // Correct import
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';

class TaskComponentsEditUI extends StatefulWidget {
  final String initialBase;
  final Map<String, String> task;
  final Map<String, String> hours;
  const TaskComponentsEditUI(
      {super.key,
      required this.initialBase,
      required this.task,
      required this.hours});

  @override
  State<TaskComponentsEditUI> createState() => _TaskComponentsEditUIState();
}

class _TaskComponentsEditUIState extends State<TaskComponentsEditUI> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  List<String> base = ['Task based', 'Hourly based'];
  String? selectBase;
  List<String> names = [
    'Product Owner',
    'Hasnath Mohammed',
    'Inshaf Nazir',
    'Abdullah Khan',
    'Zohaib Ahmed',
    'Mudassir Iqbal',
    'Lingeshwaran T',
    'Mukesh N',
    'Dinesh K',
    'Imthiyaas Ahamed',
    'Hidayath Suleiman'
  ];
  String? selectname;

  @override
  void initState() {
    super.initState();
    selectBase = widget.initialBase;
    taskNameController.text = widget.task['task'] ?? '';

    // Conditionally set the amount based on the initialBase
    if (selectBase == 'Task based') {
      amountController.text = widget.task['amount'] ?? '';
    } else if (selectBase == 'Hourly based') {
      amountController.text = widget.hours['amount'] ?? '';
      selectname = widget.hours['name'];
    }
  }

  void _onSelectBaseChanged(String? value) {
    setState(() {
      selectBase = value;

      // Clear fields and set values based on selection
      if (selectBase == 'Task based') {
        taskNameController.text = widget.task['task'] ?? '';
        amountController.text = widget.task['amount'] ?? '';
        selectname = null; // Clear selectname if switching to Task based
      } else if (selectBase == 'Hourly based') {
        amountController.text = widget.hours['amount'] ?? '';
        selectname = widget.hours['name'];
        taskNameController.clear(); // Clear task name when switching to Hourly
      }
    });
  }

  void _onNameChanged(String? value) {
    setState(() {
      selectname = value;
    });
  }

  void _save() {
    if (selectBase == 'Task based') {
      final Map<String, String> updateData = {
        'task': taskNameController.text,
        'amount': amountController.text,
        'base': 'Task based',
      };
      Navigator.pop(context, updateData);
    } else if (selectBase == 'Hourly based') {
      if (selectname == null) {
        Utils.showMobileToast('Please select a user');
        return;
      }
      final Map<String, String> newData = {
        'name': selectname!,
        'amount': amountController.text,
        'base': 'Hourly based',
      };
      Navigator.pop(context, newData);
    } else {
      Utils.showMobileToast('Please select a base type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(
                  width: 10,
                ),
                Utils.getText('Edit Task', size: 20, weight: FontWeight.bold),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Utils.buildDropdownButton(
              'Select Base',
              base,
              selectBase,
              _onSelectBaseChanged,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: selectBase == 'Task based'
                  ? Utils.getTextFormField(
                      '',
                      taskNameController,
                      label: Utils.getText('Task Name', color: AppC.grey),
                    )
                  : Utils.buildDropdownButton(
                      'Select User', names, selectname, _onNameChanged),
            ),
            const SizedBox(height: 20),
            // Input field for amount
            SizedBox(
              height: 40,
              child: Utils.getTextFormField(
                '',
                textType: TextInputType.number,
                amountController,
                label: Utils.getText('Amount (\$)', color: AppC.grey),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  child: Utils.getAddFilledButton(
                    'Save',
                    _save,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
