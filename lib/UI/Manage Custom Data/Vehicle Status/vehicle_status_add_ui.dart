import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: const Text(
          'Add Vehicle Status',),
        actions: [
          IconButton(
              onPressed: ()=> Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: AppC.white,),)
        ],
      ),
      body: SafeArea(
        minimum: 15.padding,
        child: ListView(
          children: [
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
                  'Checklist Name', checklistController,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: Utils.getTextFormField(
                  'Task Name', taskNameController,
              ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Utils.getElevatedButton((){},bgColor: AppC.green,text: 'Save')
              ],
            ),
            // Add more widgets here if needed
          ],
        ),
      ),
    );
  }
}
