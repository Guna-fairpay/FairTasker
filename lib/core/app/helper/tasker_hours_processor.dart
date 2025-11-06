
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';

class TaskerHoursProcessor {
  Map<String, dynamic>? _response;
  final APiRepository _aPiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  Future<Map<String, dynamic>?> _findCheckInHours() async => await _aPiRepository.findCheckInHours();

  Future<void> initialize() async {
    _listenBroadcast();
    await refresh();
  }

  Future<Map<String, dynamic>> refresh() async {
    _response = await _findCheckInHours();
    final currentHrmIds = getIt<CommonService>().currentBranchHrmIds;
    List<Map<String, dynamic>> punchList = List.from(_response?['userPunchList'] ?? []);
    var users = punchList.where((element) => currentHrmIds.contains(element['employee']?['id']));
    final checkInCount = users.where((element) => element['end_time'].toString().trim().isNullOrEmpty).length;
    final checkOutCount = users.where((element) => element['end_time'].toString().trim().isNotNullOrEmpty).length;
    // var checkInOutCount = "${_response?['checkInCount'] ?? 0}/${_response?['checkOutCount'] ?? 0}";
    var checkInOutCount = "$checkInCount/$checkOutCount";
    _broadcast.broadcast("check_in_out_count", value: checkInOutCount);
    return processWorkingHours();
  }

  void _listenBroadcast() {
    _broadcast.register("header_timer", (value, callback) => refresh());
  }

  Map<String, dynamic> processWorkingHours() {
    return {
      "checkIn" : _response?['startTime'].toString().toFormat(inputFormat: "dd-MM-yyyy HH:mm:ss", format: "HH:mm:ss"),
      "totalHours" : _response?['activeHours'],
      "checkOut" : _response?['endTime'].toString().toFormat(inputFormat: "dd-MM-yyyy HH:mm:ss", format: "HH:mm:ss"),
    };
  }
}