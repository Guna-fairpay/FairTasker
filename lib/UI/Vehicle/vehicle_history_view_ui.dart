import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';

class VehicleHistoryViewUI extends StatefulWidget {
  final String? vin;
  final String? vehicleName;
  final bool showHeader;

  const VehicleHistoryViewUI(
      {super.key,
      required this.vin,
      required this.vehicleName,
      this.showHeader = true});

  @override
  State<VehicleHistoryViewUI> createState() => _VehicleHistoryViewUIState();
}

class _VehicleHistoryViewUIState extends State<VehicleHistoryViewUI> {
  late VehicleDataBloc vehicleDataBloc;
  List<Map<String, dynamic>> vehicleHistoryList = [];
  List<Map<String, dynamic>> vehicleDataList = [];
  List<Map<String, dynamic>> filterVehicleDataList = [];
  final FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool loading = false;
  int currentPage = 1;
  late final String? vin;
  String? vehicleName;

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    vin = widget.vin;
    vehicleName = widget.vehicleName;

    vehicleDataBloc.add(GetVehicleHistoryListData(currentPage.toString(), vin));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0 &&
        !loading) {
      currentPage++;
      vehicleDataBloc
          .add(GetVehicleHistoryListData(currentPage.toString(), vin));
    }
  }

  void _filterVehicleDataList(String query) {
    setState(() {
      filterVehicleDataList = vehicleDataList.where((vehicleData) {
        final title = vehicleData['title']?.toLowerCase() ?? '';
        final lastName = vehicleData['last_name']?.toLowerCase() ?? '';
        final email = vehicleData['email']?.toLowerCase() ?? '';
        final mobile = vehicleData['phone']?.toLowerCase() ?? '';
        final department =
            vehicleData['departments']?['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery) ||
            lastName.contains(searchQuery) ||
            email.contains(searchQuery) ||
            mobile.contains(searchQuery) ||
            department.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppC.white,
      appBar: widget.showHeader
          ? AppBar(
              backgroundColor: AppC.appColor,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Utils.getText(vehicleName ?? '',
                  weight: FontWeight.bold, color: AppC.white, size: 16),
              titleSpacing: -8,
            )
          : null,
      body: BlocProvider(
        create: (context) => vehicleDataBloc,
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
          listener: (context, state) {
            if (state is VehicleDataLoading) {
              setState(() => loading = true);
            } else if (state is VehicleHistoryListLoaded) {
              setState(() {
                loading = false;
                vehicleHistoryList.addAll(state.todo ?? []);
                vehicleDataList.addAll(state.data ?? []);
                filterVehicleDataList.addAll(state.data ?? []);
              });
            } else {
              setState(() {
                vehicleDataBloc.add(
                    GetVehicleHistoryListData(currentPage.toString(), vin));
                loading = false;
              });
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: Utils.getSearchBarUI(
                                () {},
                                (value) => _filterVehicleDataList(value),
                                searchController,

                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      Expanded(
                        child: filterVehicleDataList.isEmpty &&
                                searchController.text.isNotEmpty
                            ? Center(
                                child: Utils.getText(
                                  'No Results Found',
                                  color: Colors.grey,
                                  weight: FontWeight.bold,
                                  size: 16,
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: filterVehicleDataList.length,
                                itemBuilder: (context, index) {
                                  final data = filterVehicleDataList[index];
                                  return Slidable(
                                    endActionPane: ActionPane(
                                      motion: const DrawerMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed:
                                              (context) {}, // Implement the completed action here
                                          backgroundColor: AppC.white,
                                          foregroundColor: AppC.green,
                                          label: 'Completed',
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      color: AppC.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Utils.getText(
                                                    data['todo_date'] ?? '',
                                                    weight: FontWeight.bold,
                                                    color: AppC.green),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Utils.getText(
                                                    data['title'] ?? '',
                                                    weight: FontWeight.bold,
                                                    color: AppC.green,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                if (data['clean_required'] !=
                                                    null)
                                                  Utils.getText(
                                                    '(${data['clean_required']})',
                                                    weight: FontWeight.bold,
                                                    color: AppC.orange,
                                                  ),
                                                Utils.getText(
                                                  Utils.convertString24HTo12H(
                                                      data['todo_time'] ?? ''),
                                                  weight: FontWeight.bold,
                                                  color: AppC.green,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Utils.getText(
                                                    data['location'] ?? '',
                                                    weight: FontWeight.bold,
                                                    color: AppC.green),
                                                if (data['notes'] != null)
                                                  Expanded(
                                                    child: Utils.getText(
                                                      '(${data['notes']})',
                                                      weight: FontWeight.bold,
                                                      color: AppC.appColor,
                                                    ),
                                                  ),
                                                if (data['users'] != null)
                                                  Utils.getText(
                                                      data['users']
                                                                  ['first_name']
                                                              [0] +
                                                          data['users']
                                                              ['last_name'][0],
                                                      color: AppC.green),
                                              ],
                                            ),
                                          ],
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
                if (loading) Center(child: Utils.getProgressIndicator(context)),
              ],
            );
          },
        ),
      ),
    );
  }
}
