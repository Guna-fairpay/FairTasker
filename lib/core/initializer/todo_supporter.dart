import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';

class ToDoSupport {
  final FBroadcast _broadcast = FBroadcast.instance();
  List<Map<String, dynamic>> _todos = [];
  final DateTime _currentDate = DateTime.now().toUtc();
  final APiRepository _aPiRepository = APiRepository();
  final CommonService _commonService = getIt<CommonService>();
  final int _cleanCarTaskId = 30;
  ToDoSupport() {
    _broadcast.register(Str.todayToDo, (value, _) => _fetchTodosForToday());
    _fetchTodosForToday();
    Console.of.log("ToDo Support has been initialized");
  }

  void _fetchTodosForToday() async {
    _todos = await _commonService.getToDos(reset: true);
  }

  bool isClearCarTaskExist({String? vin}) {
    var response = _todos.where((element) => (element['identifier_id'] == _cleanCarTaskId) && (List.from(element["vehicles"]).map((e) => e['vin']).contains(vin)));
    return response.isEmpty;
  }

  Map<String, dynamic>? lastCleanCarTask({String? vin}) {
    if (!isClearCarTaskExist(vin: vin)) return null;
    var response = _todos.firstWhereOrNull((element) => (element['identifier_id'] == _cleanCarTaskId) && (List.from(element["vehicles"]).map((e) => e['vin']).contains(vin)));
    return response;
  }
}