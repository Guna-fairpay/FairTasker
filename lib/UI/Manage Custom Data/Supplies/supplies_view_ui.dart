
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      appBar: AppBar(
        title: const Text('Supplies'),
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: ()=>Navigator.pop(context))
        ],
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
                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(
                              () {
                                // onTap action for search bar if needed
                              },
                              (value) {
                                _filterSupplies(value);
                              },
                              searchController,
                            ),
                          ),
                        ),
                        Utils.getAddElevatedButton(()=>
                          _navigateToSuppliesAddUI(),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredSupplies.length,
                        separatorBuilder: (context,index) => const Divider(height: 0.5,),
                        itemBuilder: (context, index) {
                          final supply = filteredSupplies[index];
                          return GestureDetector(
                            onTap: () {
                              _navigateToEditSuppliesUI(index);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(10.0),
                                    child: Utils.getText(
                                      supply['name'] ?? '',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: AppC.redAccent,
                                    ),
                                ),
                              ],
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
    );
  }
}
