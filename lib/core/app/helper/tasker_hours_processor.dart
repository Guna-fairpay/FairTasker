import 'package:fairpytasker/Repository/api_repository.dart';
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
    var checkInOutCount = "${_response?['checkInCount'] ?? 0}/${_response?['checkOutCount'] ?? 0}";
    _broadcast.broadcast("check_in_out_count", value: checkInOutCount);
    return processWorkingHours();
  }

  void _listenBroadcast() {
    _broadcast.register("header_timer", (value, callback) => refresh());
  }

  Map<String, dynamic> processWorkingHours() {
    return {
      "checkIn" : _response?['startTime'],
      "totalHours" : _response?['activeHours'],
      "checkOut" : _response?['endTime'],
    };
  }
}