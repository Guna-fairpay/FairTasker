import 'package:fbroadcast/fbroadcast.dart';

class TaskerHelper {
  TaskerHelper._();
  static final TaskerHelper instance = TaskerHelper._();
  final FBroadcast _broadcast = FBroadcast.instance();

  void withoutLoadingRefresh() => _broadcast.broadcast("todo_view", value: {"showLoading" : false, "refresh": false});
  void withoutLoading() => _broadcast.broadcast("todo_view", value: {"showLoading" : false, "refresh": true});
  void withoutRefresh() => _broadcast.broadcast("todo_view", value: {"showLoading" : true, "refresh": false});
  void refresh() => _broadcast.broadcast("todo_view", value: true);

}