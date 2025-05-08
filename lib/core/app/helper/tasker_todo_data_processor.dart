import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/core/initializer/todo_supporter.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart' show Color, Colors, Durations;

class ToDoProcessor {
  List<Map<String, dynamic>> get _groupVehicle => getIt<CommonService>().groupVehicleList;
  List<Map<String, dynamic>> get _activeVehicles => getIt<CommonService>().activeVehicleList;
  List<Map<String, dynamic>> get _activeVehiclesCount => getIt<CommonService>().activeVehicleCountList;
  List<Map<String, dynamic>> get _usersList => getIt<CommonService>().usersList;
  List<Map<String, dynamic>> get _vendorsList => getIt<CommonService>().vendorsList;
  List<Map<String, dynamic>> get _locationList => getIt<CommonService>().locationsList;
  List<Map<String, dynamic>> get _taskExpenseDatas => getIt<CommonService>().taskExpenseDataList;
  List<Map<String, dynamic>> get _groupPersons => getIt<CommonService>().groupPersonList;
  List<Map<String, dynamic>> get _bouncieVehicles => getIt<CommonService>().bouncieVehicles;
  List<Map<String, dynamic>> _relatedToDos = [];

  final APiRepository _aPiRepository = APiRepository();

  String? get userId => Session.of.getString(Str.userIdPrefText);
  int? get hrmId => Session.of.getInt(Str.hrmIdPrefText);
  int? branchId = Session.of.getInt(Str.branchIdPrefText);

  Future<void> initialize() async {
    await Future.wait([
      _fetchVehicleGroups(),
      _fetchActiveVehicles(),
      _fetchBouncieVehicles(),
      _fetchTaskExpenseData(),
      _fetchGroupPersons(),
      _fetchUsers(),
      _fetchVendors(),
      _fetchLocations(),
      _fetchActiveVehiclesCount(),
      _fetchCurrentToDos(),
    ]);
    return;
  }

  Future<List<List<Map<String, dynamic>>>> refresh() async {
    return await Future.wait([
      _fetchVehicleGroups(reset: true),
      _fetchActiveVehicles(reset: true),
      _fetchBouncieVehicles(reset: true),
      _fetchTaskExpenseData(reset: true),
      _fetchUsers(reset: true),
      _fetchVendors(reset: true),
      _fetchLocations(reset: true),
      _fetchActiveVehiclesCount(reset: true),
      _fetchCurrentToDos(reset: true),
    ]);
  }

  Future<List<Map<String, dynamic>>?> _fetchRelatedToDos({required List<dynamic> todoIds}) async =>
      await _aPiRepository.relatedToDos(todoIds: todoIds);

  Future<List<Map<String, dynamic>>> _fetchVehicleGroups({bool reset = false}) async =>
      await getIt<CommonService>().groupVehicles(reset: reset);

  Future<List<Map<String, dynamic>>> _fetchActiveVehicles({bool reset = false}) async =>
      await getIt<CommonService>().getActiveVehicles(reset: reset);

  Future<List<Map<String, dynamic>>> _fetchActiveVehiclesCount({bool reset = false}) async =>
      await getIt<CommonService>().getActiveVehiclesCount(reset: reset);

  Future<List<Map<String, dynamic>>> _fetchBouncieVehicles({bool reset = false}) async =>
      await getIt<CommonService>().getBouncieVehicles(reset: reset);

  Future<List<Map<String, dynamic>>> _fetchGroupPersons() async =>
      await getIt<CommonService>().getGroupPersons();

  Future<List<Map<String, dynamic>>> _fetchUsers({bool reset = false}) async =>
      await getIt<CommonService>().getUsers(reset: reset);

  Future<List<Map<String, dynamic>>> _fetchVendors({bool reset = false}) async =>
      await getIt<CommonService>().getVendorsList(reset: reset);

  Future<List<Map<String, dynamic>>> _fetchLocations({bool reset = false}) async =>
      await getIt<CommonService>().getLocationsList(reset: reset);

  Future<List<Map<String, dynamic>>> _fetchTaskExpenseData({bool reset = false}) async =>
      await getIt<CommonService>().getTaskExpenseData(reset: reset);

  Future<List<Map<String, dynamic>>> _fetchCurrentToDos({bool reset = false}) async =>
      await getIt<CommonService>().getToDos(reset: reset);

  Future<List<Map<String, dynamic>>?> _fetchToDoList(
      DateTime selectedDate, bool isCompleted,
      {String? resourceId}) async {
    var response = await _aPiRepository.getToDoList(
        selectedDate: selectedDate.toFormat(),
        status: isCompleted,
        resourceId: resourceId);
    var data = List<Map<String, dynamic>>.from(response?['todos'] ?? []);
    var checkIO = ["Check In", "Check Out"];
    var checkInOut = data
        .where((element) => checkIO.contains(element['title']))
        .where((element) => element['user_id'] == userId)
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

  Future<List<Map<String, dynamic>>?> getToDoList(
      DateTime selectedDate, bool isCompleted,
      {String? resourceId}) async {
    var response = await Future.wait([
      _fetchBouncieVehicles(reset: true),
      _fetchGroupPersons(),
      _fetchToDoList(selectedDate, isCompleted, resourceId: resourceId)
    ]);
    // _groupPersons = response[0] ?? [];
    var todos = response[2] ?? [];
    if (selectedDate.toFormat() == DateTime.now().toFormat()) getIt<ToDoSupport>().resetting(todos: todos);
    var relatedTaskIds = todos.map((e) => e['related_task_id'] ?? 0).toList();
    relatedTaskIds.removeWhere((element) => element <= 0);
    if (relatedTaskIds.isNotEmpty) {
      _relatedToDos = await _fetchRelatedToDos(todoIds: relatedTaskIds) ?? [];
    }

    return await _processToDos(todos);
  }

  Future<List<Map<String, dynamic>>>? _processToDos(List<Map<String, dynamic>> toDos) async {
    final Completer<List<Map<String, dynamic>>> completer = Completer();
    var result = toDos
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
        "hasTimeSensitive": _hasTimeSensitive(e),
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
        "hasCompleted": _hasCompleted(e),
        "hasRelatedTask": _hasRelatedTask(e),
        "hasVehiclePlate": _hasVehiclePlate(e),
        "hasReason": _hasReason(e),
        "hasReasonAttachments": _hasReasonAttachments(e),
        "vins": _getVehicleVins(e),
        "vehicle_image": _getVehicleImage(e),
        "vehicle_plate": _getVehiclePlate(e),
        "vehicle_distance": _getVehicleDistance(e),
        "vehicle_name": _getVehicleName(e),
        "vehicle_or_person_name": _getVehicleName(e) ?? _personName(e),
        "vendor": _vendor(e),
        "addresses" : _getAddresses(e),
        "selectedAddress" : _getSelectedAddress(e),
        "resources": _resources(e),
        "vehicles": _getVehicles(e),
        "vehicleStatus" : _getVehicleStatus(e),
        "vehicleStatusCategoryName": _getVehicleStatusCategoryName(e),
        "vehicleHistoryIconColorCode" : _getVehicleHistoryIconColorCode(e),
        "relatedTaskName" : _getRelatedTaskName(e),
        "personId" : e['person_id'],
        "vehicleGroupId" : e['vehicle_group_id'],
        "reason" : _reason(e),
        "hasTimeChangeReason" : _hasTimeChangeReason(e),
        "timeChangeReason" : _timeChangeReason(e),
      })
        .toList();
    completer.complete(result);
    await Future.delayed(Durations.medium1);
    return completer.future;
  }

  String? _getVehicleName(Map<String, dynamic> model) {
    if (model['vehicle_group_id'].toString().isNotNullOrEmpty) {
      // FIND VEHICLE GROUP NAME
      return _groupVehicle.firstWhereOrNull(
          (element) => element['id'] == model['vehicle_group_id'])?['name'];
    } else if ((model['vehicle_name'].toString().isNotNullOrEmpty) && (model['vin'].toString().isNotNullOrEmpty)) {
      return _getVinVehicleName(model) ??  (model['vehicle_name'] ?? "");
    } else if (List.from(model['vehicles'] ?? []).isNotEmpty) {
      var vlist = List<Map<String, dynamic>>.from(model['vehicles'] ?? []).distinct((element) => element['vin']);
      if (vlist.length > 1) {
        return "MV";
      } else {
        return (_getVinVehicleName(model)) ?? (vlist.firstOrNull?['vehicle_name'] ?? "");
      }
    } else if (model['vin'].toString().isNotNullOrEmpty) {
      var activeVehicle = _activeVehicles
          .firstWhereOrNull((element) => element['vin'] == model['vin']);
      return activeVehicle?['vehicle_name'] ?? "";
    } else {
      return null;
    }
  }

  String? _getVinVehicleName(Map<String, dynamic> model) {
    var vins = _getVehicleVins(model);
    if (vins.length == 1) {
      var activeVehicle = _activeVehicles
          .firstWhereOrNull((element) => element['vin'] == vins.first);
      return activeVehicle?['vehicle_name'];
    } else {
      return null;
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
    if (model['todo_date'] != DateTime.now().toFormat()) return false;
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
    } else {
      return (_getVehicleVins(model).length == 1);
    }
  }

  bool _hasVendorInfo(Map<String, dynamic> model) =>
      model['vendor_name'].toString().isNotNullOrEmpty;

  bool _hasReason(Map<String, dynamic> model) =>
      model['reason'].toString().isNotNullOrEmpty;

  bool _hasReasonAttachments(Map<String, dynamic> model) =>
      model['reason_images'].toString().isNotNullOrEmpty && (List.from(model['reason_images']).isNotEmpty);

  bool _hasAttachments(Map<String, dynamic> model) =>
      List<Map<String, dynamic>>.from(model['todoimages'] ?? []).isNotEmpty;

  bool _hasAddress(Map<String, dynamic> model) {
    var address = model['address'].toString().replaceAll("null", "");
    var decoded = (address.isNotNullOrEmpty) ? jsonDecode(address) : null;
    return (address.isNotNullOrEmpty) && (decoded != null) && (decoded is List) && List<int>.from(decoded).isNotEmpty;
  }

  bool _hasCustomLink(Map<String, dynamic> model) => (model['reference_id'].toString().isNotNullOrEmpty);

  bool _hasTimeSensitive(Map<String, dynamic> model) =>
      model['time_sensitive'] == 1;

  bool _hasCompleted(Map<String, dynamic> model) =>
      model['status'] == "Completed";

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
    var title = model['title'].toString();
    title = (title.contains("-") ? (title.split("-").firstOrNull ?? "").toLowerCase() : title.toLowerCase());
    var completedTimeTaken = model['complete_time_taken'];
    if (completedTimeTaken.toString().isNotNullOrEmpty) {
      return completedTimeTaken;
    } else if (identifierId.toString().isNotNullOrEmpty) {
      var taken = _taskExpenseDatas.firstWhereOrNull(
              (element) => (element['id'] == identifierId) || (element['task'].toString().toLowerCase() == title) )?['time_taken'] ??
          "";
      if (taken.toString().isNotNullOrEmpty) {
        return "00:$taken";
      } else {
        return "00:15";
      }
    } else {
      var taken = _taskExpenseDatas.firstWhereOrNull((element) => element['task'].toString().toLowerCase() == title)?['time_taken'];
      if (taken.toString().isNotNullOrEmpty) {
        return "00:$taken";
      } else {
        return "00:15";
      }
    }
  }

  String? _personName(Map<String, dynamic> model) => model['person'];

  String? _vendorLocation(Map<String, dynamic> model) =>
      model['location'] ?? model['vendor_name'];

  String? _resourceName(Map<String, dynamic> model) {
    Map<String, dynamic> users = model['users'] ?? {};
    if (users.isNotEmpty) {
      return <String>[(users['first_name'] ?? ""), (users['last_name'] ?? "")]
          .toInitial;
    } else if (model['user_group_id'].toString().isNotNullOrEmpty) {
      var userId = (_groupPersons.firstWhereOrNull((element) =>
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

  List<Map<String, dynamic>> _resources(Map<String, dynamic> model) {
    Map<String, dynamic> users = model['users'] ?? {};
    if (users.isNotEmpty) {
      return [users];
    } else if (model['user_group_id'].toString().isNotNullOrEmpty) {
      var userId = (_groupPersons.firstWhereOrNull((element) =>
              element['id'] == model['user_group_id'])?['userId'] ??
          "");
      List<int> userIds = List.from(jsonDecode(userId));
      return _usersList
          .where((element) => userIds.contains(element['id']))
          .toList();
    } else {
      return [];
    }
  }

  List<Map<String, dynamic>> _getAddresses(Map<String, dynamic> model) {
    var hasLocationId = model['location_id'].toString().isNotNullOrEmpty;
    if (hasLocationId) {
      var location = _locationList.firstWhereOrNull((element) => element['id'].toString() == model['location_id'].toString());
      var addresses = List<Map<String, dynamic>>.from(location?['addresses'] ?? []);
      return addresses;
    }
    return [];
  }

  Map<String, dynamic>? _getSelectedAddress(Map<String, dynamic> model) {
    if (_hasAddress(model)) {
      var addresses = _getAddresses(model);
      var addressIds = List.from(jsonDecode(model['address'].toString().replaceAll("null", "")) ?? []).map((e) => int.tryParse("${e ?? ""}"));
      var result = addresses.firstWhereOrNull((element) => addressIds.contains(element['id']));
      return result;
    }
    return null;
  }

  String? _vendorId(Map<String, dynamic> model) =>
      model['vendor_id'].toString();

  Map<String, dynamic>? _vendor(Map<String, dynamic> model) {
    var vendorId = _vendorId(model);
    if (vendorId.isNotNullOrEmpty) {
      return _vendorsList
          .firstWhereOrNull((element) => element['id'].toString() == vendorId);
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

  List<Map<String, dynamic>> _getVehicles(Map<String, dynamic> model) {
    var vins = _getVehicleVins(model);
    return _activeVehicles
        .where((element) => vins.contains(element['vin']))
        .toList();
  }

  int? _getVehicleStatus(Map<String, dynamic> model) {
    var vins = _getVehicleVins(model);
    if (vins.length == 1) {
      return _activeVehicles.firstWhereOrNull((element) => element['vin'] == vins.first)?['vehicle_status'];
    } else {
      return null;
    }
  }

  String? _getVehicleStatusCategoryName(Map<String, dynamic> model) {
    var statusId = _getVehicleStatus(model);
    if (statusId != null) {
      var cate = _activeVehiclesCount.firstWhereOrNull((element) => element['id'] == statusId)?['category_name'];
      return cate;
    } else {
      return null;
    }
  }

  Color? _getVehicleHistoryIconColorCode(Map<String, dynamic> model) {
    var statusId = _getVehicleStatus(model);
    if (statusId != null) {
      return switch(statusId) {
        2 => Colors.black87,
        3 => AppC.green,
        4 => AppC.red,
        _ => AppC.bouncieButtonColor
      };
    } else {
      return AppC.appColor;
    }
  }

  bool _hasRelatedTask(Map<String, dynamic> model) => (model['related_task_id'].toString().isNullOrEmpty) ? false : ((model['related_task_id'] ?? 0) > 0);

  String? _getRelatedTaskName(Map<String, dynamic> model) {
    if (!_hasRelatedTask(model)) return null;
    var relatedTask = _relatedToDos.firstWhereOrNull((element) => element['id'] == model['related_task_id']);
    return relatedTask?['title'] ?? "";
  }

  String _reason(Map<String, dynamic> model) =>
      model['reason'] ?? "";

  bool _hasTimeChangeReason(Map<String, dynamic> model) => model['time_change_reason'].toString().isNotNullOrEmpty;

  String _timeChangeReason(Map<String, dynamic> model) => model['time_change_reason'] ?? "";
}
