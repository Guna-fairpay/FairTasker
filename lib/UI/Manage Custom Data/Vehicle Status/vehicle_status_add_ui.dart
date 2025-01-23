import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';

class VehicleStatusAddUI extends StatefulWidget {
  const VehicleStatusAddUI({super.key});

  @override
  State<VehicleStatusAddUI> createState() => _VehicleStatusAddUIState();
}

class _VehicleStatusAddUIState extends State<VehicleStatusAddUI> {
  List<String> transactionTypeList = [
    'Buy',
    'PerSale',
    'Recon',
    'Rental',
    'Repair',
    'Sold'
  ];
  String? selectedTransactionType;
  List<String> vehicleStatusList = ['Active', 'InActive'];
  String? selectedVehicleStatus;
  TextEditingController checklistController = TextEditingController();
  TextEditingController taskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
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
                Utils.getText('Add Vehicle Status',
                    size: 20, weight: FontWeight.bold),
              ],
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
                child: DropdownButton<String>(
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Utils.getText('Transaction Type', color: AppC.grey),
                  ),
                  value: selectedTransactionType,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 3,
                  dropdownColor: AppC.white,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedTransactionType = value;
                    });
                  },
                  items: transactionTypeList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Utils.getText(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: Utils.getTextFormField(
                  '', checklistController,
                  label: Utils.getText('Checklist Name', color: AppC.grey)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: Utils.getTextFormField(
                  '', taskNameController,
                  label: Utils.getText('Task Name', color: AppC.grey)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppC.fieldBase,
                      width: Num.borderWidthField,
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Num.subradiusButton))),
                child: DropdownButton<String>(
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Utils.getText('Status', color: AppC.grey),
                  ),
                  value: selectedVehicleStatus,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 3,
                  dropdownColor: AppC.white,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    selectedVehicleStatus = value;
                    setState(() {});
                  },
                  items: vehicleStatusList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Utils.getText(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  child: Utils.getAddFilledButton('Save', () {
                    if (checklistController.text.isNotEmpty ||
                        taskNameController.text.isNotEmpty) {
                      taskNameController.clear();
                      checklistController.clear();
                      // selectedVehicleStatus.;
                      // selectedVehicleStatus?.clear();
                      return Utils.showMobileToast(
                          'Vehicle Status Added Successfully');
                      // Navigator.of(context).pop(categoryController.text);
                    } else {
                      return Utils.showMobileToast(
                          'Please fill in all required fields');
                    } // Add your save logic here
                  }),
                ),
              ],
            ),
            // Add more widgets here if needed
          ],
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
