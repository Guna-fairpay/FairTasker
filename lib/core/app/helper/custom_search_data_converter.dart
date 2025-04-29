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
}
