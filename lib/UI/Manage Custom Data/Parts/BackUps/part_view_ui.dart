
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Bloc/vehicle_data_bloc.dart';
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
    final confirmed = await Utils.showCustomDeleteDialog(context,'Vehicle Part?');
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
            EasyLoading.show();
          } else if (state is PartsListLoaded) {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            filteredParts.clear();
            final List<Map<String, dynamic>> list = [];
            list.addAll(state.partsDataList ?? []);
            list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
            parts = list;
            filteredParts = List.from(parts);
          } else {
            partDataBloc.add(const GetPartsListV());
            EasyLoading.show();
          }
        },
            builder: (context, state) {
          return SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing:10,
                  children: [
                    Expanded(
                      child: Utils.getSearchBarUI(onChange:
                        _filterParts, searchController: searchController),
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
                      return InkWell(
                        onTap: ()=> _navigateToEditPartUI(index),
                        child: SafeArea(
                          minimum: 10.padding,
                          child: Row(
                            children: [
                              Expanded(
                                child: Utils.getText(
                                  part['name'] ?? '',
                                ),
                              ),
                              InkWell(
                                onTap: ()=>_deletePart(index),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: AppC.redAccent,)
                              ),
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
