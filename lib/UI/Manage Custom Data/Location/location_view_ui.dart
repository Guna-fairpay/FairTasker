
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/location_data_bloc.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'location_add_ui.dart';
import 'location_edit_ui.dart';

class LocationViewUI extends StatefulWidget {
  const LocationViewUI({super.key});

  @override
  State<LocationViewUI> createState() => _LocationViewUIState();
}

class _LocationViewUIState extends State<LocationViewUI> {
  late LocationDataBloc locationDataBloc;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> location = [];
  List<Map<String, dynamic>> filteredLocation = [];

  @override
  void initState() {
    super.initState();
    locationDataBloc = LocationDataBloc();
    locationDataBloc.add(const GetAddedLocationListData());
  }

  @override
  void dispose() {
    locationDataBloc.close();
    searchController.dispose();
    super.dispose();
  }

  void _filterLocation(String query) {
    setState(() {
      filteredLocation = location.where((locations) {
        final location = locations['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return location.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToLocationAddUI() async {
    final newLocation = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const LocationAddUI()),
    );
    if (newLocation != null) {
      setState(() {
        locationDataBloc.add(AddLocationData(
          id: null,
          name: newLocation['name'],
          address: newLocation['addresses']
              ?.where((e) => e['id'] == null)
              .map((e) => e['address']!)
              .toList(),
        ));
      });
      locationDataBloc.add(const GetAddedLocationListData());
      Utils.showMobileToast('Added successfully');
    }
  }

  Future<void> _navigateToEditLocationUI(int index) async {
    final updatedLocation = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationEditUI(location: filteredLocation[index]),
      ),
    );
    if (updatedLocation != null) {
      locationDataBloc.add(AddLocationData(
        name: updatedLocation['name'],
        address: (updatedLocation['addresses'] as List?)
            ?.where((e) => e['id'] == null)
            .map((e) => e['address'] as String)
            .toList(),
        id: updatedLocation['id'],
      ));
      Utils.showMobileToast('Updated successfully');
    }
  }

  Future<void> _deleteLocation(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context ,'Location?');
    if (confirmed == true) {
      final location = filteredLocation[index];
      locationDataBloc.add(DeleteLocation(id: location['id']));
      locationDataBloc.add(const GetAddedLocationListData());
      Utils.showMobileToast('deleted successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title: const Text('Location'),
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: const Icon(Icons.close))
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            locationDataBloc..add(const GetAddedLocationListData()),
        child: BlocConsumer<LocationDataBloc, LocationDataState>(
            listener: (context, state) async {
          if (state is LocationDataLoading) {
            EasyLoading.show();
          } else if (state is LocationListLoaded) {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            filteredLocation.clear();
            final List<Map<String, dynamic>> list = [];
            list.addAll(state.resource ?? []);
            list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
            location = list;
            filteredLocation = List.from(location);
          } else {
            locationDataBloc.add(const GetAddedLocationListData());
            EasyLoading.show();
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Utils.getSearchBarUI(

                        onChange: (value) {
                          _filterLocation(value);
                        },
                        searchController: searchController,
                      ),
                    ),
                    Utils.getAddElevatedButton(_navigateToLocationAddUI),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredLocation.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0.5),
                    itemBuilder: (context, index) {
                      final location = filteredLocation[index];
                      return InkWell(
                        onTap: () =>
                          _navigateToEditLocationUI(index),
                        child: SafeArea(
                          minimum: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Utils.getText(
                                  location['name'] ?? '',
                                ),
                              ),
                              InkWell(
                                onTap: () => _deleteLocation(index),
                                  child: const Icon(Icons.delete_outline,color: AppC.redAccent,))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
