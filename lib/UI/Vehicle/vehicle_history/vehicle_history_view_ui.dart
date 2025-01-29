
import 'dart:convert';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:fairpytasker/Component/readmore.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_pop.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../Utilities/appC.dart';
import '../../../../../Utilities/utils.dart';

class VehicleHistoryViewUI extends StatefulWidget {
  final String? vin;
  final String? vehicleName;
  final bool showHeader;
  final bool showSameTask;
  final String? title;
  final List<Map<String, dynamic>> resourceList;
  final List<Map<String, dynamic>> userGroupList;

  const VehicleHistoryViewUI(
      {super.key,
      required this.vin,
      required this.vehicleName,
      this.showHeader = true,
      this.title,
      this.showSameTask = false,
      required this.resourceList,
      required this.userGroupList});

  @override
  State<VehicleHistoryViewUI> createState() => _VehicleHistoryViewUIState();
}

class _VehicleHistoryViewUIState extends State<VehicleHistoryViewUI> {
  late VehicleDataBloc vehicleDataBloc;
  List<Map<String, dynamic>> vehicleHistoryList = [];
  List<Map<String, dynamic>> vehicleDataList = [];
  List<Map<String, dynamic>> filterVehicleDataList = [];
  List<Map<String, dynamic>> resourceList = [];
  List<Map<String, dynamic>> userGroupList = [];
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool sameTask = false;

  bool loading = false;
  int currentPage = 1;
  late final String? vin;
  String? vehicleName;
  String? title;

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    vin = widget.vin;
    vehicleName = widget.vehicleName;
    title = widget.title;
    vehicleDataBloc.add(GetVehicleHistoryListData(currentPage.toString(), vin));
    _scrollController.addListener(_onScroll);
    userGroupList = widget.userGroupList;
    resourceList = widget.resourceList;
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
      if (!sameTask) {
        // Reset the filtered list to the original data
        filterVehicleDataList = vehicleDataList;
      } else {
        // Apply filtering logic
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
      }
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
                vehicleDataBloc.add(GetVehicleHistoryListData(currentPage.toString(), vin));
                loading = false;
              });
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
                               // inputAction: TextInputAction.search
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.showSameTask)
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.6,
                              child: Switch(
                                value: sameTask,
                                onChanged: (value) {
                                  setState(() {
                                    sameTask = value;
                                    _filterVehicleDataList(title!);
                                    //searchController.text=title!;
                                  });
                                },
                                activeTrackColor: AppC.appColor,
                                activeColor: AppC.white,
                                inactiveTrackColor: AppC.white,
                                inactiveThumbColor: AppC.appColor,
                              ),
                            ),
                            Utils.getText(
                              'Same Task',
                              weight: FontWeight.bold,
                            ),
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
                            : ListView.separated(
                                controller: _scrollController,
                                itemCount: filterVehicleDataList.length,
                                itemBuilder: (context, index) {
                                  final data = filterVehicleDataList[index];
                                  var d = data['todo_time'] ?? '';
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 6.0),
                                          child: Utils.getText(
                                              Utils.convertDateFormats(
                                                data['todo_date'] ?? '',
                                              ),
                                              weight: FontWeight.bold,
                                              color: AppC.green,
                                              size: 12),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: ClipRRect(
                                          child: Dismissible(
                                            background: Container(),
                                            secondaryBackground: Container(
                                              alignment: Alignment.centerRight,
                                              color: AppC.green.withValues(alpha: 0.8),
                                              child: TextButton.icon(onPressed: (){}, label: Utils.getText("Complete", color: AppC.white, weight: FontWeight.w600), icon: Icon(Icons.check_circle_outline,color: AppC.white,)),
                                            ),
                                              direction:
                                                  DismissDirection.endToStart,
                                              confirmDismiss:
                                                  (direction) async {
                                                if (direction ==
                                                    DismissDirection
                                                        .endToStart) {
                                                  print("OKAY");
                                                }
                                                return false;
                                              },
                                              key: UniqueKey(),
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 4,
                                                  horizontal: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: const BorderSide(
                                                        color: AppC.white,
                                                        width: 1),
                                                    left: const BorderSide(
                                                        color: AppC.white,
                                                        width: 1),
                                                    right: const BorderSide(
                                                        color: AppC.white,
                                                        width: 1),
                                                    bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.4),
                                                        width: 1.2),
                                                  ),
                                                  color: AppC.white,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      spacing: 10,
                                                      children: [
                                                        Utils.getText(
                                                          data['title'] ?? '',
                                                          weight:
                                                              FontWeight.bold,
                                                          color: AppC.green,
                                                        ),
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              final String
                                                                  link =
                                                                  data['custom_link_id'] ==
                                                                          3
                                                                      ? 'https://getaround.com/dashboard/rentals/${data['reference_id'] ?? data['reference_id']}'
                                                                      : 'https://turo.com/us/en/reservation/${data['reference_id'] ?? data['reference_id']}';
                                                              if (await canLaunch(
                                                                  link)) {
                                                                await launch(
                                                                    link,
                                                                    forceSafariVC:
                                                                        false,
                                                                    forceWebView:
                                                                        false);
                                                              } else {
                                                                throw 'Could not launch $link';
                                                              }
                                                            },
                                                            child:
                                                                Utils.getText(
                                                              data['custom_link_id'] !=
                                                                          null &&
                                                                      data['reference_id'] !=
                                                                          null
                                                                  ? (data['custom_link_id'] ==
                                                                          3
                                                                      ? 'G'
                                                                      : 'T')
                                                                  : data['reference_id'] !=
                                                                          null
                                                                      ? 'T'
                                                                      : '',
                                                              color: data['custom_link_id'] ==
                                                                      3
                                                                  ? const Color(
                                                                      0xFFA608C0)
                                                                  : Colors
                                                                      .black,
                                                              weight: FontWeight
                                                                  .w900,
                                                              size: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        Utils.getText(
                                                          Utils.convertString24HTo12H(
                                                              data['todo_time'] ??
                                                                  ''),
                                                          color: AppC.green,
                                                        ),
                                                        const Icon(
                                                          Icons.delete_outline,
                                                          color: AppC.redAccent,
                                                          size: 14,
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      spacing: 10,
                                                      children: [
                                                        if (data[
                                                                'clean_required'] !=
                                                            null)
                                                          Utils.getText(
                                                            '(${data['clean_required']})',
                                                            weight:
                                                                FontWeight.bold,
                                                            color: AppC.orange,
                                                          ),
                                                        if (data[
                                                                'parts']
                                                            .isNotEmpty)
                                                          InkWell(
                                                              onTapDown: (details) => VehicleHistoryPop
                                                                  .instance
                                                                  .show(context,
                                                                      data:
                                                                          data,
                                                                      details:
                                                                          details,
                                                                      compare:
                                                                          "parts",
                                                                      display:
                                                                          "parts_name"),
                                                              child: Utils.getText(
                                                                  "P",
                                                                  weight:
                                                                      FontWeight
                                                                          .bold,
                                                                  size: 13)),
                                                        if (data['supplies']
                                                            .isNotEmpty)
                                                          InkWell(
                                                              onTapDown: (details) => VehicleHistoryPop
                                                                  .instance
                                                                  .show(context,
                                                                      data:
                                                                          data,
                                                                      details:
                                                                          details,
                                                                      compare:
                                                                          "supplies",
                                                                      display:
                                                                          "supplies_name"),
                                                              child: Utils.getText(
                                                                  'S',
                                                                  weight:
                                                                      FontWeight
                                                                          .bold)),
                                                      ],
                                                    ),
                                                    Row(
                                                      spacing: 10,
                                                      children: [
                                                        Expanded(
                                                            child: (data['notes'] !=
                                                                        null &&
                                                                    data['notes']
                                                                        .toString()
                                                                        .isNotEmpty)
                                                                ? ReadMoreText(
                                                                    '(${data['notes']})',
                                                                    trimLines:
                                                                        1,
                                                                    titleText: data[
                                                                            'location'] ??
                                                                        data[
                                                                            'vendor_name'] ??
                                                                        '',
                                                                    titleTextStyle: context
                                                                        .textTheme
                                                                        .labelLarge
                                                                        ?.copyWith(
                                                                            color:
                                                                                AppC.green,
                                                                            fontWeight: FontWeight.w500),
                                                                    trimMode:
                                                                        TrimMode
                                                                            .Line,
                                                                    trimCollapsedText:
                                                                        ' more',
                                                                    trimExpandedText:
                                                                        ' less',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                    moreStyle: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .pink),
                                                                    lessStyle: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .pink),
                                                                  )
                                                                : Container()),
                                                        getUserGroupDataById(
                                                          data,
                                                          onPressed: Utils
                                                              .showMobileToast,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => 1.height,
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

  Widget getUserGroupDataById(Map<String, dynamic> todos,
      {Function(String val)? onPressed}) {
    //log("$todos", name: "TODO_S");
    String getInitials(String? firstName, String? lastName) {
      return '${firstName?[0].toUpperCase() ?? ''}${lastName?[0].toUpperCase() ?? ''}';
    }

    if (todos['users'] != null) {
      String userShortName = getInitials(
        todos['users']?['first_name'],
        todos['users']?['last_name'],
      );

      return Utils.getText(
        userShortName,
        color: AppC().base,
        weight: FontWeight.bold,
      );
    } else {
      String userGroupConcatenationName = '';
      List<String> userInitials = [];

      for (Map<String, dynamic> group in userGroupList) {
        if (group['id'] == todos['user_group_id']) {
          List<dynamic> userList = [];
          try {
            userList = json.decode(group['userId'] ?? '[]');
          } catch (_) {
            continue;
          }

          for (Map<String, dynamic> res in resourceList) {
            if (userList.contains(res['id'])) {
              String initials = getInitials(
                res['first_name'],
                res['last_name'],
              );
              userInitials.add(initials);
            }
          }
          break;
        }
      }
      if (userInitials.isNotEmpty) {
        userGroupConcatenationName = (userInitials.length > 1)
            ? "${userInitials.first}..."
            : userInitials.join(',');
      }
      return GestureDetector(
        onTap: () => onPressed?.call(userInitials.join(',')),
        child: Utils.getText(
            align: TextAlign.end,
            userGroupConcatenationName,
            color: AppC().base,
            weight: FontWeight.bold,
            overFlow: TextOverflow.ellipsis),
      );
    }
  }
}
