import 'package:fairpytasker/Bloc/location_data_bloc.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class LocationEditUI extends StatefulWidget {
  final Map<String, dynamic> location;

  const LocationEditUI({super.key, required this.location});

  @override
  _LocationEditUIState createState() => _LocationEditUIState();
}

class _LocationEditUIState extends State<LocationEditUI> {
  late LocationDataBloc locationDataBloc;
  late final TextEditingController locationController;
  late final TextEditingController addressController;
  List<dynamic> addressesList = [];
  bool isTaskFieldEmpty = false;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    locationDataBloc = LocationDataBloc();
    locationController = TextEditingController(text: widget.location['name']);
    addressController = TextEditingController(
      text: widget.location['addresses']!.isNotEmpty
          ? widget.location['addresses']!.first['address']
          : '',
    );
    addressesList = widget.location['addresses'] ?? [];
  }

  @override
  void dispose() {
    locationController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      isTaskFieldEmpty = locationController.text.isEmpty;
    });

    if (locationController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }

    final updatedLocation = {
      'id': widget.location['id'],
      'name': locationController.text,
      'addresses': addressesList,
    };
    Navigator.pop(context, updatedLocation);
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

// Future<void> _deleteLocation(int index) async {
//   final confirmed = await _confirmDelete(context);
//   if (confirmed == true) {
//     final location =filteredLocation[index];
//     locationDataBloc.add(DeleteLocationEvent(id:location. id));
//   }
//   locationDataBloc.add(const GetAddedLocationListData());
//   Utils.showMobileToast('deleted successfully');
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title: const Text('Edit Location'),
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: const Icon(Icons.close))
        ],
      ),
      body: SafeArea(
        minimum: 15.padding,
        child: ListView(
          children: [
            Stack(
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
            const SizedBox(height: 10),
            Utils.getTextFormField(
              '',
              addressController,
              label: Utils.getText('Address', color: AppC.grey),
              readOnly: false,
              suffixIcon: InkWell(
                onTap: () {
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
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0, // space between addresses
              runSpacing: 4.0, // space between rows if wrapped
              children: List.generate(addressesList.length, (address) {
                return Chip(
                  label: Utils.getText(addressesList[address]['address'] ?? ''),
                  deleteIcon: const Icon(Icons.close),
                  deleteIconColor: Colors.redAccent,
                  backgroundColor: AppC.lowGreen,
                  onDeleted: () => _deleteAddress(address),
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Utils.getElevatedButton(
                  text: 'Save',
                      bgColor: AppC.green,
                      (){
                  if (addressController.text.isNotEmpty) {
                    setState(() {
                      addressesList.add({
                        'address': addressController.text,
                      });
                    });
                  }
                  _save();
                },),
              ],
            )
          ],
        ),
      ),
    );
  }
}
