import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Bloc/location_data_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
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
  List<Map<String, dynamic>> location = []; // Sample data list
  List<Map<String, dynamic>> filteredLocation = [];
  final FocusNode searchFocusNode = FocusNode();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    locationDataBloc = LocationDataBloc();
    // locationDataBloc.add(const GetAddedLocationListData());
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
        // final address = locations['addresses']?.map((e) => e['address']?.toLowerCase()).join(', ') ?? '';
        final searchQuery = query.toLowerCase();
        return location
                .contains(searchQuery) // || address.contains(searchQuery)
            ;
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
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final location = filteredLocation[index];
      locationDataBloc.add(DeleteLocationEvent(id: location['id']));
      locationDataBloc.add(const GetAddedLocationListData());
      Utils.showMobileToast('deleted successfully');
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content:
            Utils.getText('Are you sure you want to delete this Location?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm the deletion
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel the deletion
            },
            child: Utils.getText('Cancel'),
          ),
        ],
      ),
    );
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
            loading = true;
          } else if (state is LocationListLoaded) {
            loading = false;
            filteredLocation.clear();
            final List<Map<String, dynamic>> list = [];
            list.addAll(state.resource ?? []);
            list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
            location = list;
            filteredLocation = List.from(location);
          } else {
            locationDataBloc.add(const GetAddedLocationListData());
            loading = true;
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(

                              onChange: (value) {
                                _filterLocation(value);
                              },
                              searchController: searchController,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Utils.getAddElevatedButton(_navigateToLocationAddUI),

                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredLocation.length,
                        itemBuilder: (context, index) {
                          final location = filteredLocation[index];
                          return GestureDetector(
                            onTap: () {
                              _navigateToEditLocationUI(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Utils.getText(
                                          location['name'] ?? '',
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                      const Icon(Icons.delete_outline,color: AppC.redAccent,)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, separatorBuilder: (context, index)  => const Divider(height: 0.5,),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: loading,
                  child: Center(child: Utils.getProgressIndicator(context)))
            ],
          );
        }),
      ),
    );
  }
}
