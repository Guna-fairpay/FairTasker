import 'package:fairpytasker/core/app/extension/string_extension.dart';

class CustomSearchDataConverter {

  CustomSearchDataConverter._();

  static List<Map<String, dynamic>> convertVPerson({List<dynamic>? vehicles, List<dynamic>? persons}) {
    var personList = persons
        ?.map((element) => {
      "id": element['id'],
      "name": [element['first_name'], element['last_name']].join(" "),
      "type": "person",
      "partNumber": 2,
      "value": element
    })
        .toList() ?? [];
    var vehicleList = vehicles
        ?.map((element) => {
      "id": element['id'],
      "name": element['vehicle_name'],
      "type": "vehicles",
      "subname": element['vehicle_number'].toString().isNullOrEmpty ? "" : "\t(${element['vehicle_number']})",
      "partNumber": 2,
      "value": element
    })
        .toList() ?? [];
    return [...vehicleList, ...personList];
  }

  static List<Map<String, dynamic>> convertVLocation({List<dynamic>? vendors, List<dynamic>? locations}) {
    var locationList = locations
        ?.map((element) => {
      "id": element['id'],
      "name": element['name'],
      "type": "location",
      "partNumber": 3,
      "value": element
    })
        .toList() ?? [];
    var vendorList = vendors
        ?.map((element) => {
      "id": element['id'],
      "name": element['name'],
      "type": "vendor",
      "partNumber": 3,
      "value": element
    })
        .toList() ?? [];
    return [...vendorList, ...locationList];
  }

  static List<Map<String, dynamic>> convertTasks({List<dynamic>? tasks}) {
    var taskList = tasks
        ?.map((e) => {"id": e['id'], "name": e['task'], "type": "task", "partNumber" : 1, "value" : e})
        .toList() ?? [];
    return taskList;
  }

}