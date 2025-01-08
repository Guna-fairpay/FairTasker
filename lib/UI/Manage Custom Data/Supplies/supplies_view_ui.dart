import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Import the Slidable package

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import '../../../Bloc/vehicle_data_bloc.dart';
import 'supplies_edit_ui.dart';
import 'supplies_add_ui.dart';

class SuppliesViewUI extends StatefulWidget {
  const SuppliesViewUI({super.key});

  @override
  State<SuppliesViewUI> createState() => _SuppliesViewUIState();
}

class _SuppliesViewUIState extends State<SuppliesViewUI> {
  late VehicleDataBloc suppliesDataBloc;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> supplies = []; // Sample data list
  List<Map<String, dynamic>> filteredSupplies = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    suppliesDataBloc = VehicleDataBloc();
    suppliesDataBloc.add(const GetSuppliesListV());
    filteredSupplies = List.from(supplies);
  }

  @override
  void dispose() {
    suppliesDataBloc.close();
    searchController.dispose();
    super.dispose();
  }

  void _filterSupplies(String query) {
    setState(() {
      filteredSupplies = supplies.where((supply) {
        final name = supply['name']?.toLowerCase() ?? '';
        final description = supply['description']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || description.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToSuppliesAddUI() async {
    final newSupply = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const SuppliesAddUI()),
    );

    if (newSupply != null) {
      setState(() {
        suppliesDataBloc.add(AddSupplyData(
            name: newSupply['name'],
            desc: newSupply['description'],
            id: newSupply['id']));
        _filterSupplies(searchController.text); // Update filtered list
      });
      suppliesDataBloc.add(const GetSuppliesListV());
      Utils.showMobileToast('Supplies added successfully');
    }
  }

  Future<void> _navigateToEditSuppliesUI(int index) async {
    final updatedSupplies = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => SuppliesEditUI(supply: filteredSupplies[index]),
      ),
    );

    if (updatedSupplies != null) {
      suppliesDataBloc.add(AddSupplyData(
          name: updatedSupplies['name'],
          desc: updatedSupplies['description'],
          id: updatedSupplies['id']));
      suppliesDataBloc.add(const GetSuppliesListV());
      Utils.showMobileToast('Supplies updated successfully');
    }
  }

  Future<void> _deleteSupply(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final supplies = filteredSupplies[index];
      suppliesDataBloc.add(DeleteSupplyEvent(id: supplies['id']));
      suppliesDataBloc.add(const GetSuppliesListV());
      Utils.showMobileToast('Supplies deleted successfully');
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content: Utils.getText('Are you sure you want to delete this supply?'),
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (_) => suppliesDataBloc,
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) async {
          if (state is VehicleDataLoading) {
            loading = true;
          } else if (state is SupplyListLoaded) {
            loading = false;
            filteredSupplies.clear();
            filteredSupplies.addAll(state.supplyDataList ?? []);
            List<Map<String, dynamic>> list = [];
            list.addAll(state.supplyDataList ?? []);
            list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
            supplies = list;
            filteredSupplies = List.from(supplies);
          } else {
            loading = true;
            suppliesDataBloc.add(const GetSuppliesListV());
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
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
                        Utils.getText('Supplies',
                            size: 20, weight: FontWeight.bold),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(() {
                              // onTap action for search bar if needed
                            }, (value) {
                              _filterSupplies(value);
                            }, searchController, searchFocusNode),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton('Add', () {
                            _navigateToSuppliesAddUI();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredSupplies.length,
                        itemBuilder: (context, index) {
                          final supply = filteredSupplies[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => _deleteSupply(index),
                                  backgroundColor: AppC.white,
                                  foregroundColor: AppC.red,
                                  icon: Icons.delete_outline,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _navigateToEditSuppliesUI(index);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppC.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Utils.getText(
                                                supply['name'] ?? '',
                                                weight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
      drawer: const DrawerView(),
    );
  }
}
