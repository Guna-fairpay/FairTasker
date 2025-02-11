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
        final searchQuery = query.toLowerCase();
        return partsName.contains(searchQuery);
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
      partDataBloc.add(DeletePartEvent(id: parts['id']));
      partDataBloc.add(const GetPartsListV());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title: const Text("Parts"),
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
        create: (context) => partDataBloc..add(const GetPartsListV()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
              listener: (context, state) async {
          if (state is VehicleDataLoading) {
            loading = true;
          } else if (state is PartsListLoaded) {
            loading = false;
            filteredParts.clear();
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
        },
            builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      spacing:10,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(() {}, (value) {
                              _filterParts(value);
                            }, searchController),
                          ),
                        ),
                        Utils.getAddElevatedButton(()=>
                          _navigateToPartsAddUI()),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredParts.length,
                        separatorBuilder: (context, index) => const Divider(height: 0.5,),
                        itemBuilder: (context, index) {
                          final part = filteredParts[index];
                          return GestureDetector(
                            onTap: () {
                              _navigateToEditPartUI(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Utils.getText(
                                      part['name'] ?? '',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.delete_outline,color: AppC.redAccent,)
                                ],
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
