
import 'package:fairpytasker/core/app/enums/task_enum.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';

class CustomSearchDataConverter {
  CustomSearchDataConverter._();

  static List<Map<String, dynamic>> convertVPerson(
      {List<dynamic>? vehicles,
      List<dynamic>? persons,
      List<dynamic>? groupVehicles}) {
    var personList = persons
            ?.map((element) => {
                  "id": element['id'],
                  "name":
                      [element['first_name'], element['last_name']].join(" "),
                  "type": "person",
                  "searchBy": [
                    (element['first_name'] ?? ""),
                    (element['last_name'] ?? "")
                  ]..removeWhere((element) => element.toString().isNullOrEmpty),
                  "partNumber": 2,
                  "value": element
                })
            .toList() ??
        [];
    var vehicleList = vehicles
            ?.map((element) => {
                  "id": element['id'],
                  "name": element['vehicle_name'],
                  "type": "vehicles",
                  "subname": element['vehicle_number'].toString().isNullOrEmpty
                      ? ""
                      : "\t(${element['vehicle_number']})",
                  "searchBy": [
                    (element['vehicle_name'] ?? ""),
                    (element['make'] ?? ""),
                    (element['model'] ?? ""),
                    (element['vehicle_number'] ?? "")
                  ]..removeWhere((element) => element.toString().isNullOrEmpty),
                  "partNumber": 2,
                  "value": element
                })
            .toList() ??
        [];
    var gVehicles = groupVehicles
            ?.map((element) => {
                  "id": element['id'],
                  "name": element['name'],
                  "type": "g_vehicles",
                  "searchBy": [
                    (element['name'] ?? "")
                  ]..removeWhere((element) => element.toString().isNullOrEmpty),
                  "partNumber": 2,
                  "value": element
                })
            .toList() ??
        [];
    return [...vehicleList, ...personList, ...gVehicles];
  }

  static List<Map<String, dynamic>> convertVLocation(
      {List<dynamic>? vendors, List<dynamic>? locations}) {
    var locationList = locations
            ?.map((element) => {
                  "id": element['id'],
                  "name": element['name'],
                  "type": "location",
                  "searchBy": [
                    (element['name'] ?? "")
                  ]..removeWhere((element) => element.toString().isNullOrEmpty),
                  "partNumber": 3,
                  "value": element
                })
            .toList() ??
        [];
    var vendorList = vendors
            ?.map((element) => {
                  "id": element['id'],
                  "name": element['name'],
                  "type": "vendor",
                  "searchBy": [
                    (element['name'] ?? "")
                  ]..removeWhere((element) => element.toString().isNullOrEmpty),
                  "partNumber": 3,
                  "value": element
                })
            .toList() ??
        [];
    return [...vendorList, ...locationList];
  }

  static List<Map<String, dynamic>> convertTasks({List<dynamic>? tasks}) {
    var taskList = tasks
            ?.map((e) => {
                  "id": e['id'],
                  "name": e['task'],
                  "type": "task",
                  "searchBy": [
                    (e['task'] ?? "")
                  ]..removeWhere((element) => element.toString().isNullOrEmpty),
                  "partNumber": 1,
                  "value": e
                })
            .toList() ??
        [];
    return taskList;
  }

  static List<Map<String, dynamic>> convertLeadChannel({List<dynamic>? leads, List<dynamic>? channels}) {
    var lead = leads?.map((e) => {
      "id" : e['id'],
      "name" : e['customer_name'],
      "searchBy" : [e['customer_name']],
      "type" : "lead",
      "value" : e
    }).toList();
    var channel = channels?.map((e) => {
      "id" : e['id'],
      "name" : e['channel_name'],
      "searchBy" : [e['channel_name']],
      "type" : "channel",
      "value" : e
    }).toList();
    List<Map<String, dynamic>>? leadChannel = (leads == null) ? null : [];
    if (leads != null) {
      leadChannel = [
        ...(lead ?? []),
        ...(channel ?? [])
      ];
    }
    return leadChannel ?? [];
  }

  static List<List<Map<String, dynamic>>> convertTaskIdentifier({
    List<Map<String, dynamic>>? taskExpense,
    List<Map<String, dynamic>>? leads,
    List<Map<String, dynamic>>? channels,
    List<Map<String, dynamic>>? vehicles,
    List<Map<String, dynamic>>? resources,
    List<Map<String, dynamic>>? groupVehicles,
    List<Map<String, dynamic>>? vendors,
    List<Map<String, dynamic>>? locations}) {
    List<List<Map<String, dynamic>>> result = [];
    var tasks = taskExpense?.map((e) => {
      "id" : e['id'],
      "name" : e['task'],
      "user_type_id" : e['user_type'],
      "user_type" : e['user_type'].toString().toNumeric.toInt().taskType,
      "searchBy" : [e['task'], e['user_type'].toString().toNumeric.toInt().taskType],
      "type" : "task",
      "value" : e
    }).toList();
    var lead = leads?.map((e) => {
      "id" : e['id'],
      "name" : e['customer_name'],
      "searchBy" : [e['customer_name']],
      "type" : "lead",
      "value" : e
    }).toList();
    var channel = channels?.map((e) => {
      "id" : e['id'],
      "name" : e['channel_name'],
      "searchBy" : [e['channel_name']],
      "type" : "channel",
      "value" : e
    }).toList();
    var vehicle = vehicles?.map((e) => {
      "id" : e['id'],
      "name" : e['vehicle_name'],
      "subname" : (e['vehicle_number'] ?? ""),
      "searchBy" : [e['vehicle_name'], e['vin'], e['vehicle_number']],
      "type" : "vehicles",
      "value" : e
    }).toList();
    var resource = resources?.map((e) => {
      "id" : e['id'],
      "name" : "${(e['first_name'] ?? "")} ${(e['last_name'] ?? "")}",
      "searchBy" : [e['first_name'], e['last_name']],
      "type" : "person",
      "value" : e
    }).toList();
    var groupVehicle = groupVehicles?.map((e) => {
      "id" : e['id'],
      "name" : e['name'],
      "searchBy" : [e['name']],
      "type" : "g_vehicles",
      "value" : e
    }).toList();
    var vendor = vendors?.map((e) => {
      "id" : e['id'],
      "name" : e['name'],
      "searchBy" : [e['name']],
      "type" : "vendor",
      "value" : e
    }).toList();
    var location = locations?.map((e) => {
      "id" : e['id'],
      "name" : e['name'],
      "searchBy" : [e['name']],
      "type" : "location",
      "value" : e
    }).toList();
    List<Map<String, dynamic>>? vehiclePerson = (vehicles == null) ? null : [];
    List<Map<String, dynamic>>? vendorLocation = (vendors == null) ? null : [];
    if (vehicles != null) {
      vehiclePerson = [
        ...(vehicle ?? []),
        ...(resource ?? []),
        ...(groupVehicle ?? []),
      ];
    }
    if (vendors != null) {
      vendorLocation = [
        ...(vendor ?? []),
        ...(location ?? []),
      ];
    }
    List<Map<String, dynamic>>? leadChannel = (leads == null) ? null : [];
    if (leads != null) {
      leadChannel = [
        ...(lead ?? []),
        ...(channel ?? [])
      ];
    }
    result = [
      if (tasks != null) tasks,
      if (leadChannel != null) leadChannel,
      if (vehiclePerson != null) vehiclePerson,
      if (vendorLocation != null) vendorLocation,
    ];
    return result;
  }
}
