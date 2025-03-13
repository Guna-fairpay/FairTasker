import 'dart:convert' show json;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class TodoTaskCardItem extends StatelessWidget {
  final Map<String, dynamic> todos;
  final List<Map<String, dynamic>> vehicleGroupList;
  final List<Map<String, dynamic>> vehicleList;
  final List<Map<String, dynamic>> vehicleStatus;
  final bool statusFilter;
  final bool isNotesNotEmpty;
  final bool isNotesEdit;
  final List<Map<String, dynamic>> userGroupList;
  final List<Map<String, dynamic>> resourceList;
  final List<Map<String, dynamic>> multipleLocationAddressList;

  TodoTaskCardItem(
      {super.key,
      required this.todos,
      required this.vehicleGroupList,
      required this.vehicleList,
      required this.vehicleStatus,
      this.statusFilter = false,
      this.isNotesNotEmpty = false,
      this.isNotesEdit = false,
      required this.userGroupList,
      required this.multipleLocationAddressList,
      required this.resourceList});

  List<dynamic> todoImages = [];
  bool? isSelected = false;
  String? vehicleGroupName;
  String? userGroupConcatenationName;
  List<Map<String, dynamic>>? addresses;

  @override
  Widget build(BuildContext context) {
    final isValid = isValidTask(todos['todo_date'], todos['vin'], vehicleList);
    //final vehicle=vehicleList[index];
    String? vinToFind;
    Map<String, dynamic>? vehicle;
    if (todos['vin'] == null) {
      if (todos['vehicles'] is List && todos['vehicles'].isNotEmpty) {
        vinToFind = todos['vehicles'][0]['vin'];
      }
    } else {
      vinToFind = todos['vin'];
    }

    String? selectedTime = todos['complete_time_taken'] ??
        '00:15'; // Set your initial selected time

    vehicle = vinToFind != null
        ? vehicleList.firstWhere(
            (emp) => emp['vin'] == vinToFind,
            orElse: () => {}, // Return null if no match is found
          )
        : null;

    final Map<String, dynamic>? status = vehicle != null
        ? vehicleStatus.firstWhere(
            (data) => data['id'] == vehicle?['vehicle_status'],
            orElse: () => {}, // Return null if no match is found
          )
        : null;

    if (todos['vehicles'] is List && todos['vehicles'].isNotEmpty) {
      vinToFind = todos['vehicles'][0]['vin'];
    }

    final Map<String, dynamic>? image = vinToFind != null
        ? vehicleList.firstWhere(
            (emp) => emp['vin'] == vinToFind,
            orElse: () => {},
          )
        : null;

    if (todos['todoimages'] != null && todos['todoimages'] is List) {
      todoImages.clear();
      todoImages.addAll(todos['todoimages']); // Use addAll to avoid nesting
    }
    return Row(
      children: [
        Column(
          children: [
            CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.only(top: 0, bottom: 2),
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: todos['status'] == "Completed"
                            ? AppC.green
                            : AppC.appColor,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(27),
                    color: AppC.red,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  )),
              imageUrl: (getVehicleText(todos) != 'MV')
                  ? todos['vehicle_image'] != null
                      ? Str.STORAGE_BASE_URL + todos['vehicle_image']
                      : (image?['images'] != null &&
                              image?['images']?.isNotEmpty
                          ? Str.STORAGE_BASE_URL + image!['images'][0]['path']
                          : '')
                  : '',
              placeholder: (context, url) => SizedBox(
                  height: 50,
                  width: 50,
                  child: Utils.getProgressIndicator(context)),
              errorWidget: (context, url, error) {
                return Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: todos['status'] == "Completed"
                            ? AppC.green
                            : AppC.appColor,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(27),
                  ),
                  alignment: Alignment.center,
                  child: Utils.getText(
                    getVehicleText(todos) == 'MV' ? 'MV' : "CT",
                    size: 14,
                    color: todos['status'] == "Completed"
                        ? AppC.green
                        : AppC.appColor,
                  ),
                );
              },
            ),
            if (todos['vehicle_number'] != null)
              Utils.getText(
                "${todos['vehicle_number'] ?? "No plate"}",
                size: 10,
                weight: FontWeight.w900,
                color: todos['vehicle_number'] != null ? AppC().base : AppC.red,
              ),
            if (todos['vehicles'].isNotEmpty &&
                todos['vehicles'].length == 1 &&
                todos['vehicle_number'] == null)
              Utils.getText(
                vehicle?['vehicle_number'] ?? 'No plate',
                size: 10,
                weight: FontWeight.w900,
                color:
                    vehicle?['vehicle_number'] != null ? AppC().base : AppC.red,
              ),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Dismissible(
            key: ValueKey(todos['id']),
            background: Container(
              color: AppC.white,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Utils.getText('Tomorrow',
                  color: AppC.red, weight: FontWeight.bold),
            ),
            secondaryBackground: Container(
              color: AppC.white,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                statusFilter ? 'In Progress' : 'Complete',
                style: const TextStyle(color: Colors.green),
              ),
            ),
            confirmDismiss: (direction) async {
              return null;
            },
            onDismissed: (direction) {},
            child: Container(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
              decoration: BoxDecoration(
                border: Border(
                  top: const BorderSide(color: AppC.white, width: 1),
                  left: const BorderSide(color: AppC.white, width: 1),
                  right: const BorderSide(color: AppC.white, width: 1),
                  bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.4), width: 1.2),
                ),
                color: AppC.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () async {},
                                child: Utils.getText('${todos['title']}',
                                    color: todos['time_sensitive'] == 1
                                        ? AppC.red
                                        : AppC().base,
                                    weight: FontWeight.w800,
                                    overFlow: TextOverflow.ellipsis,
                                    size: 13),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final String link = todos['custom_link_id'] ==
                                          3
                                      ? 'https://getaround.com/dashboard/rentals/${todos['reference_id'] ?? todos['reference_id']}'
                                      : 'https://turo.com/us/en/reservation/${todos['reference_id'] ?? todos['reference_id']}';
                                  Utils.openURL(link);
                                },
                                child: Utils.getText(
                                  todos['custom_link_id'] != null
                                      ? (todos['custom_link_id'] == 3
                                          ? 'G'
                                          : 'T')
                                      : '',
                                  color: todos['custom_link_id'] == 3
                                      ? const Color(0xFFA608C0)
                                      : Colors.black,
                                  weight: FontWeight.w900,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Visibility(
                                  visible: todos['todoimages'].isNotEmpty,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.remove_red_eye_sharp,
                                      size: 12,
                                      color: AppC.appColor,
                                    ),
                                  )),
                            ],
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          size: 13,
                          color: Colors.black,
                        ),
                      ),
                      Visibility(
                        visible: todos['title'] != 'Check In' &&
                            todos['title'] != 'Check Out',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Utils.getText(
                              todos['complete_time_taken'] != null
                                  ? "(${todos['complete_time_taken'].toString()})"
                                  : '00:15',
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Utils.getText(Utils.convertString24HTo12H(
                            todos['todo_time'] ?? '05:30:00')),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: (todos['vehicles'] != null &&
                                          todos['vehicles']!.isNotEmpty) ||
                                      (todos['vehicle_name'] != null &&
                                          todos['vehicle_name'] != 'null') ||
                                      (todos['person'] != null &&
                                          todos['person'] != 'null') ||
                                      (todos['vehicle_group_id'] != null &&
                                          todos['vehicle_group_id'] != 0),
                                  child: InkWell(
                                    onTapDown:
                                        (TapDownDetails? details) async {},
                                    child: Utils.getText(
                                      (getVehicleText(todos)) ??
                                          (vehicleGroupName ?? ''),
                                      size: 12,
                                      overFlow: TextOverflow.ellipsis,
                                      weight: getVehicleText(todos) == 'MV'
                                          ? FontWeight.w900
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Visibility(
                            visible: (((todos['vehicle_name'] != null ||
                                    vehicle != null) &&
                                getVehicleText(todos) != 'MV')),
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: (status?['category_name']) == 'Recon'
                                      ? AppC.black
                                      : (status?['category_name']) == 'Rental'
                                          ? AppC.green
                                          : (status?['category_name']) ==
                                                  'Repair'
                                              ? AppC.red
                                              : AppC.blue,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: todos['parts'].isNotEmpty &&
                                    todos['parts'] != null,
                                child: InkWell(
                                    onTapDown: (TapDownDetails? details) {},
                                    child: Utils.getText("P",
                                        weight: FontWeight.bold, size: 13)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: todos['supplies'].isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: GestureDetector(
                                      onTapDown: (TapDownDetails? details) {},
                                      child: Utils.getText("S",
                                          weight: FontWeight.bold, size: 13)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Visibility(
                        visible: getAddressFromLocations(todos) != null,
                        child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                if (isValid)
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            InkWell(
                                onTapDown: (TapDownDetails? details) async {},
                                child: Utils.getText(
                                    todos['vendor_name'] != null &&
                                            todos['vendor_name'] != 'null'
                                        ? '${todos['vendor_name']}'
                                        : todos['location'] != null &&
                                                todos['location'] != 'null'
                                            ? '${todos['location']}'
                                            : '')),
                            if (todos['vendor_name'] != null)
                              const SizedBox(
                                width: 10,
                              ),
                            Visibility(
                              visible: todos['vendor_name'] != null,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  Icons.info,
                                  size: 14,
                                  color: Colors
                                      .blue, // Replace with AppC.appColor if defined
                                ),
                              ),
                            ),
                            if (todos['vendor_name'] != null)
                              const SizedBox(
                                width: 5,
                              ),
                            Expanded(
                              child: Visibility(
                                visible: isNotesNotEmpty ||
                                    (todos['notes'] != null &&
                                        todos['notes']!.isNotEmpty &&
                                        todos['notes'] != 'null'),
                                child: InkWell(
                                  onTapDown: (TapDownDetails? details) {},
                                  child: Utils.getText(
                                    todos['notes'] != null &&
                                            todos['notes'] != 'null'
                                        ? ' (${stripHtmlTags(todos['notes'] ?? '')}) '
                                        : '',
                                    overFlow: TextOverflow.ellipsis,
                                    size: 12,
                                    color: AppC().base,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Visibility(
                            visible: isNotesEdit,
                            child: Row(
                              children: [
                                Visibility(
                                  visible: isNotesNotEmpty,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(0)),
                                          border: Border.all(
                                              color: AppC
                                                  .fieldBase /*, width: 0.2*/)),
                                      child: Icon(
                                        Icons.check,
                                        color: AppC().base,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(0)),
                                        border: Border.all(
                                            color: AppC
                                                .fieldBase /*, width: 0.2*/)),
                                    child: const Icon(
                                      Icons.clear_rounded,
                                      color: AppC.red,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTapDown: (TapDownDetails? details) async {},
                        child: Visibility(
                          visible: todos['users'] != null ||
                              todos['user_group_id'] != null,
                          child: getUserGroupDataById(todos),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getUserGroupDataById(Map<String, dynamic> todos) {
    if (todos['users'] != null) {
      for (Map<String, dynamic> res in resourceList) {
        if (todos['users']!['id']!.toString() == res['id'].toString()) {
          isSelected = true;
        } else {
          isSelected = false;
        }
      }
      var userShortName = '${todos['users']?['first_name']?[0].toUpperCase()}'
          '${todos['users']?['last_name']?[0].toUpperCase()}';
      return Utils.getText(userShortName ?? '',
          color: AppC().base, weight: FontWeight.w900);
    } else {
      userGroupConcatenationName = '';
      for (Map<String, dynamic> u in userGroupList) {
        if (u['id'] == todos['user_group_id']) {
          List<dynamic> jsonList = json.decode(u['userId'] ?? '');
          List<dynamic> resultList = jsonList.cast<dynamic>();
          // todos.selectedUserGroupOrUser = [];
          for (Map<String, dynamic> res in resourceList) {
            for (dynamic userId in resultList) {
              if (userId.toString() == res['id'].toString()) {
                isSelected = true;

                if (resultList.length > 1) {
                  final displayNames =
                      '${userGroupConcatenationName ?? ''}${res['first_name']?[0].toUpperCase()}${res['last_name']?[0].toUpperCase()}, ';

                  return Utils.getText('$displayNames...',
                      color: AppC().base, weight: FontWeight.bold);
                } else {
                  userGroupConcatenationName =
                      '${userGroupConcatenationName ?? ''}${res['first_name']?[0].toUpperCase()}${res['last_name']?[0].toUpperCase()}, ';
                }
              } else {}
            }
            // todos.selectedUserGroupOrUser!.add(res);
          }
        }
      }
      return Utils.getText((userGroupConcatenationName ?? ''),
          color: AppC().base, weight: FontWeight.bold);
    }
  }

  bool isValidTask(String taskStart, String? vin, List<dynamic>? vehicles) {
    final now = DateTime.now();
    return isTaskDateValid(taskStart, now) &&
        (vin != null || (vehicles != null && vehicles.isNotEmpty));
  }

  bool isTaskDateValid(String taskStart, DateTime now) {
    final taskDate = DateFormat('yyyy-MM-dd').parse(taskStart);
    return taskDate.isAtSameMomentAs(now) || taskDate.isAfter(now);
  }

  String? getVehicleText(Map<String, dynamic> todos) {
    if (todos['vehicles'] is List && todos['vehicles']!.isNotEmpty) {
      if (todos['vehicles'].length > 1) {
        // If there are two or more vehicles in the list, return 'MV'
        return 'MV';
      } else if (todos['vehicles'].length == 1) {
        // If there is only one vehicle in the list, return its name
        return '${todos['vehicles'][0]['vehicle_name']}';
      }
    } else if (todos['vehicle_name'] != null &&
        todos['vehicle_name'] != 'null') {
      return '${todos['vehicle_name']}';
    } else if (todos['person'] != null && todos['person'] != 'null') {
      return '${todos['person']}  ';
    } else if (todos['vehicle_group_id'] != null &&
        todos['vehicle_group_id'] != 0) {
      if (vehicleGroupList.isNotEmpty) {
        for (Map<String, dynamic> v in vehicleGroupList) {
          if (v['id'] == todos['vehicle_group_id']) {
            return '${v['name']}  ';
          }
        }
        return '';
      } else {
        return null;
      }
    } else {
      return null;
    }
    return null;
  }

  String stripHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  List<Map<String, dynamic>>? getAddressFromLocations(
      Map<String, dynamic> todos) {
    for (int i = 0; i < multipleLocationAddressList.length; i++) {
      if (todos['location_id'] != null &&
          multipleLocationAddressList[i]['id'] ==
              int.parse(todos['location_id']!)) {
        addresses = [];
        List<Map<String, dynamic>> parsedAddresses =
            (multipleLocationAddressList[i]['addresses'] as List<dynamic>)
                .cast<Map<String, dynamic>>();
        addresses!.addAll(parsedAddresses);
        return addresses;
      }
    }
    return null;
  }
}
