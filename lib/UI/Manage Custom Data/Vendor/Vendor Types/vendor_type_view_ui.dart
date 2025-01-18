import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../Bloc/vendor_data_bloc.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import 'vendor_type_edit_ui.dart';
import 'vendor_type_add_ui.dart';

class VendorTypeUI extends StatefulWidget {
  const VendorTypeUI({super.key});

  @override
  State<VendorTypeUI> createState() => _VendorTypeUIState();
}

class _VendorTypeUIState extends State<VendorTypeUI> {
  late VendorDataBloc vendorDataBloc;
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> vendorsType = [];
  List<Map<String, dynamic>> filteredVendorsType = [];
  bool loading = false;
  bool reverse = false;

  @override
  void initState() {
    super.initState();
    vendorDataBloc = VendorDataBloc();
  }

  void _filterVendorType(String query) {
    setState(() {
      filteredVendorsType = vendorsType.where((vendor) {
        final name = vendor['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToVendorTypeAddUI() async {
    final newVendor = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const VendorTypeAddUI()),
    );
    if (newVendor != null) {
      vendorDataBloc.add(AddVendorType(
        id: newVendor['id'],
        name: newVendor['name'],
      ));

      vendorDataBloc.add(const GetVendorTypeList());
    }
  }

  Future<void> _navigateToEditVendorUI(int index) async {
    final updatedVendor = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VendorTypeEditUI(vendor: filteredVendorsType[index]),
      ),
    );
    print("Updated Vendor ==$updatedVendor");
    if (updatedVendor != null) {
      vendorDataBloc.add(AddVendorType(
        id: updatedVendor['id'],
        name: updatedVendor['name'],
      ));
      vendorDataBloc.add(const GetVendorTypeList());
    }
  }

  Future<void> _deleteVendorType(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final vendor = filteredVendorsType[index];
      vendorDataBloc.add(DeleteVendorType(id: vendor['id']));
      Utils.showMobileToast('Vendor deleted');
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure?'),
        content: Utils.getText('Are you sure you want to delete this vendor?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
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
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) => vendorDataBloc..add(const GetVendorTypeList()),
        child: BlocConsumer<VendorDataBloc, VendorDataState>(
          listener: (context, state) async {
            if (state is VendorDataLoading) {
              loading = true;
            } else if (state is VendorTypeListLoaded) {
              // print('Vendors loaded: ${state.resource?.map((e) => e.id).toList()}');
              // print('Vendors Type: ${state.resource?.map((e) => e.id.runtimeType).toList()}');
              loading = false;
              filteredVendorsType.clear();
              filteredVendorsType.addAll(state.resource ?? []);
              List<Map<String, dynamic>> list = [];
              list.addAll(state.resource ?? []);
              vendorsType = list;
              filteredVendorsType = List.from(vendorsType);
            }
            // else if(state is VendorListLoaded)
            //   {
            //     vendorDataBloc.add(const GetVendorList());
            //     loading = true;
            //   }
            else {
              vendorDataBloc.add(const GetVendorTypeList());
              loading = true;
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          Utils.getText(
                            'Vendor Type',
                            size: 20,
                            weight: FontWeight.bold,
                          ),
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
                              child: Utils.getSearchBarUI(() {}, (value) {
                                _filterVendorType(value);
                              }, searchController,),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton('Add', () {
                              _navigateToVendorTypeAddUI();
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          reverse: false,
                          itemCount: filteredVendorsType.length,
                          itemBuilder: (context, index) {
                            final vendorType = filteredVendorsType[index];
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) =>
                                        _deleteVendorType(index),
                                    backgroundColor: AppC.white,
                                    foregroundColor: AppC.red,
                                    icon: Icons.delete_outline,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _navigateToEditVendorUI(index);
                                },
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  color: AppC.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Utils.getText(
                                            vendorType['name'] ?? '',
                                            weight: FontWeight.bold,
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
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
          },
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
