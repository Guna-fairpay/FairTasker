import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Bloc/location_data_bloc.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class LocationAddUI extends StatefulWidget {
  const LocationAddUI({super.key, location});

  @override
  State<LocationAddUI> createState() => _LocationAddUIState();
}

class _LocationAddUIState extends State<LocationAddUI> {
  late LocationDataBloc locationDataBloc;
  TextEditingController locationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<Map<String, dynamic>> addressesList = [];
  bool isTaskFieldEmpty = false;

  void _save() {
    setState(() {
      isTaskFieldEmpty = locationController.text.isEmpty;
    });

    if (locationController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }
    //addressesList.add(Addresses(address: addressController.text));
    final newLocation = {
      'name': locationController.text,
      'addresses': addressesList,
    };
    Navigator.pop(context, newLocation);
  }

  void _deleteAddress(int index) {
    if (addressesList[index]['id'] != null) {
      locationDataBloc.add(DeleteLocationEvent(
          id: addressesList[index]['id'], isLocationAddress: true));
    }
    setState(() {
      addressesList.removeAt(index);
    });
  }

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
                Utils.getText('Add Location',
                    size: 20, weight: FontWeight.bold),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Utils.getTextFormField(
                    '',
                    locationController,
                    label: Utils.getText('Location Name', color: AppC.grey),
                    borderColor: isTaskFieldEmpty ? Colors.red : AppC.fieldBase,
                  ),
                  if (isTaskFieldEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.error_outline, color: Colors.red),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: Utils.getTextFormField(
                '',
                addressController,
                label: Utils.getText('Address', color: AppC.grey),
                readOnly: false,
                suffixIcon: InkWell(
                  onTap: () {
                    addressController.clear();
                    if (addressController.text.isNotEmpty) {
                      setState(() {
                        addressesList.add({
                          'address': addressController.text,
                        });
                        addressController
                            .clear(); // Clear the text field after adding
                      });
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0, // space between addresses
              runSpacing: 4.0, // space between rows if wrapped

              children: List.generate(addressesList.length, (address) {
                return Chip(
                  label: Utils.getText(addressesList[address]['address'] ?? ''),
                  deleteIcon: const Icon(Icons.delete_outline),
                  deleteIconColor: Colors.redAccent,
                  backgroundColor: Colors.grey[100],
                  onDeleted: () => _deleteAddress(address),
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  child: Utils.getAddFilledButton(
                    'Save',
                    () {
                      if (addressController.text.isNotEmpty) {
                        setState(() {
                          addressesList.add({
                            'address': addressController.text,
                          });
                        });
                      }
                      _save();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
