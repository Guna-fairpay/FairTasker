
import 'package:fairpytasker/Bloc/location_data_bloc.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class LocationEditUI extends StatefulWidget {
  final Map<String, dynamic> location;

  const LocationEditUI({super.key, required this.location});

  @override
  State<LocationEditUI> createState() => _LocationEditUIState();
}

class _LocationEditUIState extends State<LocationEditUI> {

  LocationDataBloc locationDataBloc = LocationDataBloc();
  late final TextEditingController locationController;
  final TextEditingController addressController = TextEditingController();
  List<dynamic> addressesList = [];
  bool isTaskFieldEmpty = false;
  bool isSelected = false;
  bool isTap = false;


  @override
  void initState() {
    super.initState();
    locationController = TextEditingController(text: widget.location['name']);
    addressesList.addAll(widget.location['addresses']??[]);
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
          id: addressesList[index]['id']));
    }
    setState(() {
      addressesList.removeAt(index);
    });
  }

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
            Utils.getTextFormField(
              'Location Name',
              locationController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty ? 'Please enter location name' : null,
               ),
            const SizedBox(height: 10),
            Utils.getTextFormField(
              'Address',
              addressController,
              label: Utils.getText('', color: AppC.grey),
              readOnly: false,
              suffixIcon: InkWell(
                onTap: () {
                  if (addressController.text.isNotEmpty) {
                    setState(() {
                      addressesList.add({
                        'address': addressController.text,
                      });
                      addressController.clear();
                    });
                  }
                },
                child: Icon(isTap ? Icons.save : Icons.add),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: List.generate(addressesList.length, (index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      isTap = true;
                      addressController.text=addressesList[index]['address'] ?? '';
                    });
                  },
                  child: Chip(
                    label: Utils.getText(addressesList[index]['address'] ?? ''),
                    deleteIcon: const Icon(Icons.close),
                    deleteIconColor: Colors.redAccent,
                    backgroundColor: AppC.lowGreen,
                    onDeleted: () => _deleteAddress(index),
                  ),
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Utils.getElevatedButton((){
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
