import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';

class ToDoProcessor {
  List<Map<String, dynamic>> _groupVehicle = [];
  List<Map<String, dynamic>> _activeVehicles = [];
  List<Map<String, dynamic>> _groupPersons = [];
  List<Map<String, dynamic>> _usersList = [];
  List<Map<String, dynamic>> _bouncieVehicles = [];
  List<Map<String, dynamic>> _taskExpenseDatas = [];

  final APiRepository _aPiRepository = APiRepository();
  String? get _userId => Session.of.getString(Str.userIdPrefText);

  Future<void> initialize() async {
    var response = await Future.wait([
      _fetchVehicleGroups(),
      _fetchActiveVehicles(),
      _fetchBouncieVehicles(),
      _fetchTaskExpenseData(),
      _fetchGroupPersons(),
      _fetchUsers(),
    ]);
    _groupVehicle = response[0] ?? [];
    _activeVehicles = response[1] ?? [];
    _bouncieVehicles = response[2] ?? [];
    _taskExpenseDatas = response[3] ?? [];
    _groupPersons = response[4] ?? [];
    _usersList = response[5] ?? [];
  }

  Future<List<Map<String, dynamic>>> _fetchVehicleGroups() async =>
      await getIt<CommonService>().groupVehicles();

  Future<List<Map<String, dynamic>>> _fetchActiveVehicles() async =>
      await getIt<CommonService>().getActiveVehicles();

  Future<List<Map<String, dynamic>>> _fetchBouncieVehicles() async =>
      await getIt<CommonService>().getBouncieVehicles();

  Future<List<Map<String, dynamic>>> _fetchGroupPersons() async =>
      await getIt<CommonService>().getGroupPersons();

  Future<List<Map<String, dynamic>>> _fetchUsers() async =>
      await getIt<CommonService>().getUsers();

  Future<List<Map<String, dynamic>>> _fetchTaskExpenseData() async =>
      await getIt<CommonService>().getTaskExpenseData();

  Future<List<Map<String, dynamic>>?> _fetchToDoList(DateTime selectedDate, bool isCompleted, {String? resourceId}) async {
    var response = await _aPiRepository.getToDoList(
        selectedDate: selectedDate.toFormat(),
        status: isCompleted,
        resourceId: resourceId);
    var data = List<Map<String, dynamic>>.from(response?['todos'] ?? []);
    var checkIO = ["Check In", "Check Out"];
    var checkInOut = data
        .where((element) => checkIO.contains(element['title']))
        .where((element) => element['user_id'] == _userId)
        .toList();
    data.removeWhere((element) => checkIO.contains(element['title']));
    data.addAll(checkInOut);
    data.sort((a, b) =>
    a['todo_time']
        .toString()
        .toDateTime(inputFormat: "HH:mm:ss")
        ?.compareTo(
        b['todo_time'].toString().toDateTime(inputFormat: "HH:mm:ss") ??
            DateTime.now()) ??
        0);
    return data;
  }

  Future<List<Map<String, dynamic>>?> getToDoList(DateTime selectedDate, bool isCompleted, {String? resourceId}) async {
    var response = await Future.wait([
      _fetchGroupPersons(),
      _fetchToDoList(selectedDate, isCompleted, resourceId: resourceId)
    ]);
    _groupPersons = response[0] ?? [];
    var todos = response[1] ?? [];
    return _processToDos(todos);
  }

  List<Map<String, dynamic>> _processToDos(List<Map<String, dynamic>> toDos) {
    return toDos
        .map((e) => e
          ..['vehicle_group_name'] = _getVehicleName(e)
          ..['distance'] = _getVehicleDistance(e)
          ..['image_path'] = _getVehicleImage(e)
          ..['plate_number'] = _getVehiclePlate(e)
          ..['display'] = {
            "task_title": _title(e),
            "task_time": _time(e),
            "completed_time": _completedTime(e),
            "hasCompletedTime": _hasCompletedTime(e),
            "hasTimeSensitive" : _hasTimeSensitive(e),
            "person_name": _personName(e),
            "vendor_location": _vendorLocation(e),
            "resource_name": _resourceName(e),
            "notes": _notes(e),
            "hasBouncie": _hasBouncie(e),
            "hasDistance": _hasDistance(e),
            "hasParts": _hasParts(e),
            "hasSupplies": _hasSupplies(e),
            "hasG": _hasG(e),
            "hasVehicleHistory": _hasVehicleHistory(e),
            "hasVendorInfo": _hasVendorInfo(e),
            "hasAttachments": _hasAttachments(e),
            "hasAddress": _hasAddress(e),
            "hasCustomLink": _hasCustomLink(e),
            "hasCompleted" : _hasCompleted(e),
            "hasVehiclePlate" : _hasVehiclePlate(e),
            "vins": _getVehicleVins(e),
            "vehicle_image" : _getVehicleImage(e),
            "vehicle_plate" : _getVehiclePlate(e),
            "vehicle_distance" : _getVehicleDistance(e),
            "vehicle_name" : _getVehicleName(e),
          }
          )
        .toList();
  }

  String? _getVehicleName(Map<String, dynamic> model) {
    if (model['vehicle_group_id'].toString().isNotNullOrEmpty) {
      // FIND VEHICLE GROUP NAME
      return _groupVehicle.firstWhereOrNull(
          (element) => element['id'] == model['vehicle_group_id'])?['name'];
    } else if (model['vehicle_name'].toString().isNotNullOrEmpty) {
      return model['vehicle_name'] ?? "";
    } else {
      var vlist = List<Map<String, dynamic>>.from(model['vehicles'] ?? []);
      if (vlist.length > 1) {
        return "MV";
      } else {
        return vlist.firstOrNull?['vehicle_name'];
      }
    }
  }

  String? _getVehicleImage(Map<String, dynamic> model) {
    if (model['vehicle_group_id'].toString().isNotNullOrEmpty) {
      return null;
    } else if (model['vin'].toString().isNotNullOrEmpty) {
      var activeVehicle = _activeVehicles
          .firstWhereOrNull((element) => element['vin'] == model['vin']);
      Map<String, dynamic>? images = List<Map<String, dynamic>>.from(
              activeVehicle?['images'] ?? [])
          .firstWhereOrNull((element) => element['vehicle_image_type'] == 1);
      return images?['path'].toString().toStorageURL;
    } else {
      var vlist = List<Map<String, dynamic>>.from(model['vehicles'] ?? []);
      if (vlist.length > 1) {
        return null;
      } else {
        var activeVehicle = _activeVehicles.firstWhereOrNull(
            (element) => element['vin'] == vlist.firstOrNull?['vin']);
        Map<String, dynamic>? images = List<Map<String, dynamic>>.from(
                activeVehicle?['images'] ?? [])
            .firstWhereOrNull((element) => element['vehicle_image_type'] == 1);
        return images?['path'].toString().toStorageURL;
      }
    }
  }

  String? _getVehiclePlate(Map<String, dynamic> model) {
    if (model['vehicle_group_id'].toString().isNotNullOrEmpty) {
      return null;
    } else if (model['vin'].toString().isNotNullOrEmpty) {
      var activeVehicle = _activeVehicles
          .firstWhereOrNull((element) => element['vin'] == model['vin']);
      return activeVehicle?['vehicle_number'];
    } else {
      var vlist = List<Map<String, dynamic>>.from(model['vehicles'] ?? []);
      if (vlist.length > 1) {
        return null;
      } else {
        var activeVehicle = _activeVehicles.firstWhereOrNull(
            (element) => element['vin'] == vlist.firstOrNull?['vin']);
        return activeVehicle?['vehicle_number'];
      }
    }
  }

  String? _getVehicleDistance(Map<String, dynamic> model) {
    if (model['vehicle_group_id'].toString().isNotNullOrEmpty) {
      return null;
    } else {
      var vins = _getVehicleVins(model);
      if (vins.length == 1) {
        var bouncieVehicle = _bouncieVehicles
            .firstWhereOrNull((element) => element['vin'] == vins.first);
        return bouncieVehicle?['distance'];
      } else {
        return null;
      }
    }
  }

  bool _hasBouncie(Map<String, dynamic> model) {
    if (model['vehicle_group_id'].toString().isNotNullOrEmpty) {
      return false;
    } else if (model['vin'].toString().isNotNullOrEmpty) {
      return true;
    } else {
      var vlist = List<Map<String, dynamic>>.from(model['vehicles'] ?? []);
      return vlist.isNotEmpty;
    }
  }

  bool _hasDistance(Map<String, dynamic> model) {
    if (model['vehicle_group_id'].toString().isNotNullOrEmpty) {
      return false;
    } else if (model['vin'].toString().isNotNullOrEmpty) {
      return true;
    } else {
      var vlist = List<Map<String, dynamic>>.from(model['vehicles'] ?? []);
      return (vlist.isNotEmpty) && (vlist.length == 1);
    }
  }

  bool _hasParts(Map<String, dynamic> model) {
    var parts = List<Map<String, dynamic>>.from(model['parts'] ?? []);
    return parts.isNotEmpty;
  }

  bool _hasSupplies(Map<String, dynamic> model) {
    var supplies = List<Map<String, dynamic>>.from(model['supplies'] ?? []);
    return supplies.isNotEmpty;
  }

  bool _hasG(Map<String, dynamic> model) =>
      model['vehicle_group_id'].toString().isNotNullOrEmpty;

  bool _hasCompletedTime(Map<String, dynamic> model) {
    var checkIO = ["Check In", "Check Out"];
    return !checkIO.contains(model['title']);
  }

  bool _hasVehicleHistory(Map<String, dynamic> model) {
    if (model['vehicle_group_id'].toString().isNotNullOrEmpty) {
      return false;
    } else if (model['vin'].toString().isNotNullOrEmpty) {
      return true;
    } else {
      var vlist = List<Map<String, dynamic>>.from(model['vehicles'] ?? []);
      return (vlist.length == 1);
    }
  }

  bool _hasVendorInfo(Map<String, dynamic> model) =>
      model['vendor_name'].toString().isNotNullOrEmpty;

  bool _hasAttachments(Map<String, dynamic> model) =>
      List<Map<String, dynamic>>.from(model['todoimages'] ?? []).isNotEmpty;

  bool _hasAddress(Map<String, dynamic> model) =>
      model['addresses'].toString().isNotNullOrEmpty;

  bool _hasCustomLink(Map<String, dynamic> model) =>
      model['custom_link_id'].toString().isNotNullOrEmpty &&
      model['reference_id'].toString().isNotNullOrEmpty &&
      model['custom_link_id'] != 1;

  bool _hasTimeSensitive(Map<String, dynamic> model) => model['time_sensitive'] == 1;

  bool _hasCompleted(Map<String, dynamic> model) => model['status'] == "Completed";

  bool _hasVehiclePlate(Map<String, dynamic> model) {
    if (model['vehicle_group_id'].toString().isNotNullOrEmpty) {
      return false;
    } else if (model['vin'].toString().isNotNullOrEmpty) {
      return true;
    } else {
      var vlist = List<Map<String, dynamic>>.from(model['vehicles'] ?? []);
      return (vlist.length == 1);
    }
  }

  String _title(Map<String, dynamic> model) => model['title'] ?? "";

  String? _notes(Map<String, dynamic> model) => model['notes'];

  String _time(Map<String, dynamic> model) => model['todo_time'] ?? "";

  String _completedTime(Map<String, dynamic> model) {
    var identifierId = model['identifier_id'];
    var completedTimeTaken = model['complete_time_taken'];
    if (completedTimeTaken.toString().isNotNullOrEmpty) {
      return completedTimeTaken;
    } else if (identifierId.toString().isNotNullOrEmpty) {
      var taken = _taskExpenseDatas.firstWhereOrNull((element) => element['id'] == identifierId)?['time_taken'] ?? "";
      if (taken.toString().isNotNullOrEmpty) {
        return "00:$taken";
      } else {
        return "00:15";
      }
    } else {
      return "00:15";
    }
  }

  String? _personName(Map<String, dynamic> model) => model['person'];

  String? _vendorLocation(Map<String, dynamic> model) =>
      model['location'] ?? model['vendor_name'];

  String? _resourceName(Map<String, dynamic> model) {
    Map<String, dynamic> users = model['users'] ?? {};
    if (users.isNotEmpty) {
      return <String>[
        (users['first_name'] ?? ""),
        (users['last_name'] ?? "")
      ].toInitial;
    } else if (model['user_group_id'].toString().isNotNullOrEmpty) {
      var userId = (_groupPersons.firstWhereOrNull(
              (element) =>
          element['id'] == model['user_group_id'])?['userId'] ??
          "");
      List<int> userIds = List.from(jsonDecode(userId));
      var user = _usersList
          .firstWhereOrNull((element) => userIds.contains(element['id']));
      var initial = <String>[
        (user?['first_name'] ?? ""),
        (user?['last_name'] ?? "")
      ].toInitial;
      if (userIds.length > 1) {
        return "$initial...";
      } else {
        return initial;
      }
    } else {
      return null;
    }
  }

  List<String> _getVehicleVins(Map<String, dynamic> model) {
    var vin = model['vin'] ?? "";
    var vList = List<Map<String, dynamic>>.from(model['vehicles'] ?? []);
    List<String> vins = vList.map((e) => (e['vin'] ?? "").toString()).toList();
    vins.add(vin);
    vins.removeWhere((element) => element.isNullOrEmpty);
    return vins.distinct((element) => element);
  }
}
