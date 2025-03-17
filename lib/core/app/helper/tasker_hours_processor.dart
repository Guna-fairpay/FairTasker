import 'package:fairpytasker/Repository/api_repository.dart';

class TaskerHoursProcessor {
  List<Map<String, dynamic>> workingHours = [];
  final APiRepository _aPiRepository = APiRepository();

  Future<List<Map<String, dynamic>>?> _fetchWorkingByHours() async => await _aPiRepository.getWorkingHoursByUser();

  Future<void> initialize() async {
    var response = await _fetchWorkingByHours();
    workingHours = (response ?? []);
  }

  Map<String, dynamic> processWorkingHours() {
    return {
      "checkIn" : workingHours.firstOrNull?['start_time'],
      "totalHours" : workingHours.firstOrNull?['total_hours'],
      "checkOut" : workingHours.firstOrNull?['end_time'],
    };
  }
}