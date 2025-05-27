import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fbroadcast/fbroadcast.dart';

class TaskerHelper {
  TaskerHelper._();
  static final TaskerHelper instance = TaskerHelper._();
  final FBroadcast _broadcast = FBroadcast.instance();

  void withoutLoadingRefresh() => _broadcast.broadcast("todo_view", value: {"showLoading" : false, "refresh": false});
  void withoutLoading() => _broadcast.broadcast("todo_view", value: {"showLoading" : false, "refresh": true});
  void withoutRefresh() => _broadcast.broadcast("todo_view", value: {"showLoading" : true, "refresh": false});
  void refresh() => _broadcast.broadcast("todo_view", value: true);
  void scrollToIndex(dynamic value) {
    if ((value.toString().isNullOrEmpty) || (value.toString().toNumeric <= 0)) return;
    _broadcast.stickyBroadcast("scrollToIndex", value: value);
    Session.of.set("scrollToIndex", int.tryParse(value.toString()) ?? 0);
  }

}