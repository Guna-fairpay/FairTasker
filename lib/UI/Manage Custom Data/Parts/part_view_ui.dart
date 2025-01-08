import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/vehicle_data_bloc.dart';
import 'part_add_ui.dart';
import 'part_edit_ui.dart';

class PartViewUI extends StatefulWidget {
  const PartViewUI({super.key});

  @override
  State<PartViewUI> createState() => _PartViewUIState();
}

class _PartViewUIState extends State<PartViewUI> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late VehicleDataBloc partDataBloc;
  List<Map<String, dynamic>> parts = [];
  List<Map<String, dynamic>> filteredParts = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    partDataBloc = VehicleDataBloc();
    partDataBloc.add(const GetPartsListV());
  }

  @override
  void dispose() {
    partDataBloc.close();
    searchController.dispose();
    super.dispose();
  }

  void _filterParts(String query) {
    setState(() {
      filteredParts = parts.where((part) {
        final partsName = part['name']?.toLowerCase() ?? '';
        final description = part['note']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return partsName.contains(searchQuery) ||
            description.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToPartsAddUI() async {
    final newParts = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const PartAddUI()),
    );
    if (newParts != null) {
      setState(() {
        partDataBloc.add(AddPartsData(
          id: newParts['id'],
          name: newParts['name'],
          desc: newParts['note'],
        ));
        Utils.showMobileToast('Parts added successfully');
        partDataBloc.add(const GetPartsListV());
      });
    }
  }

  Future<void> _navigateToEditPartUI(int index) async {
    final updatedParts = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => PartEditUI(
          parts: parts[index],
        ),
      ),
    );

    if (updatedParts != null) {
      partDataBloc.add(AddPartsData(
        id: updatedParts['id'],
        name: updatedParts['name'],
        desc: updatedParts['note'],
      ));
      Utils.showMobileToast('Parts Updated successfully');
      partDataBloc.add(const GetPartsListV());
    }
  }

  Future<void> _deletePart(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context,
    'Do you want to delete this Vehicle Part?',);
    if (confirmed == true) {
      final parts = filteredParts[index];
      partDataBloc.add(DeletePartsEvent(id: parts['id']));
      partDataBloc.add(const GetPartsListV());
    }
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
        create: (context) => partDataBloc..add(const GetPartsListV()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) async {
          if (state is VehicleDataLoading) {
            loading = true;
          } else if (state is PartsListLoaded) {
            loading = false;
            filteredParts.clear();
            filteredParts.addAll(state.partsDataList ?? []);
            List<Map<String, dynamic>> list = [];
            list.addAll(state.partsDataList ?? []);
            list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
            parts = list;
            filteredParts = List.from(parts);
          } else {
            partDataBloc.add(const GetPartsListV());
            loading = true;
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        Utils.getText('Parts',
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
                            child: Utils.getSearchBarUI(() {}, (value) {
                              _filterParts(value);
                            }, searchController, searchFocusNode),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton('Add', () {
                            _navigateToPartsAddUI();
                          }),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredParts.length,
                        itemBuilder: (context, index) {
                          final part = filteredParts[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => _deletePart(index),
                                  backgroundColor: AppC.white,
                                  foregroundColor: AppC.red,
                                  icon: Icons.delete_outline,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _navigateToEditPartUI(index);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppC.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Utils.getText(
                                          part['name'] ?? '',
                                          weight: FontWeight.bold,
                                        ),
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
